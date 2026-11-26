-- riemann solver
local RiemannSolver = {}
RiemannSolver.__index = RiemannSolver
export type Vector = {number}
export type Matrix = {{number}}
local EPS = 1e-10
local function finite(x: number): boolean
    return x == x and x ~= math.huge and x ~= -math.huge
end
local function copyVector(v: Vector): Vector
    local out = table.create(#v)
    for i = 1, #v do out[i] = v[i] end
    return out
end
local function zeros(n: number): Vector
    local out = table.create(n, 0)
    return out
end
local function dot(a: Vector, b: Vector): number
    assert(#a == #b, "dimension mismatch")
    local s = 0
    for i = 1, #a do s += a[i] * b[i] end
    return s
end
local function norm(a: Vector): number
    return math.sqrt(math.max(0, dot(a, a)))
end
local function add(a: Vector, b: Vector): Vector
    assert(#a == #b, "dimension mismatch")
    local out = table.create(#a)
    for i = 1, #a do out[i] = a[i] + b[i] end
    return out
end
local function scale(a: Vector, k: number): Vector
    local out = table.create(#a)
    for i = 1, #a do out[i] = a[i] * k end
    return out
end
local function validateVector(v: Vector, expected: number?)
    assert(type(v) == "table", "expected numeric vector")
    if expected then assert(#v == expected, "unexpected vector dimension") end
    for i = 1, #v do assert(type(v[i]) == "number" and finite(v[i]), "vector contains invalid value") end
end
function RiemannSolver.new(configuration: {[string]: any}?)
    local self = setmetatable({}, RiemannSolver)
    self.Configuration = configuration or {}
    self.Time = 0
    self.Iterations = 0
    self.Diagnostics = { residual = math.huge, converged = false }
    return self
end
function RiemannSolver:Evaluate(state: Vector, input: Vector?, dt: number?): Vector
    validateVector(state)
    local u = input or {}
    validateVector(u)
    local step = dt or (self.Configuration.TimeStep or 1e-3)
    assert(step > 0 and finite(step), "time step must be finite and positive")
    local out = copyVector(state)
    local gain = self.Configuration.Gain or 1
    local damping = self.Configuration.Damping or 0
    for i = 1, #state do
        local forcing = u[i] or 0
        out[i] = state[i] + step * (gain * forcing - damping * state[i])
    end
    self.Time += step
    self.Iterations += 1
    return out
end
function RiemannSolver:Integrate(initial: Vector, derivative: (Vector, number) -> Vector, duration: number, step: number?): Vector
    validateVector(initial)
    assert(duration >= 0 and finite(duration), "duration must be nonnegative")
    local h = step or (self.Configuration.TimeStep or 1e-3)
    assert(h > 0, "step must be positive")
    local x = copyVector(initial)
    local elapsed = 0
    while elapsed < duration do
        local dt = math.min(h, duration - elapsed)
        local k1 = derivative(x, self.Time + elapsed)
        validateVector(k1, #x)
        local midpoint = add(x, scale(k1, 0.5 * dt))
        local k2 = derivative(midpoint, self.Time + elapsed + 0.5 * dt)
        validateVector(k2, #x)
        x = add(x, scale(k2, dt))
        elapsed += dt
    end
    self.Time += duration
    self.Iterations += 1
    return x
end
function RiemannSolver.Jacobian(f: (Vector) -> Vector, x: Vector, h: number?): Matrix
    validateVector(x)
    local delta = h or 1e-6
    assert(delta > 0, "finite-difference scale must be positive")
    local base = f(copyVector(x))
    validateVector(base)
    local J = table.create(#base)
    for i = 1, #base do J[i] = table.create(#x, 0) end
    for j = 1, #x do
        local xp, xm = copyVector(x), copyVector(x)
        xp[j] += delta
        xm[j] -= delta
        local fp, fm = f(xp), f(xm)
        validateVector(fp, #base)
        validateVector(fm, #base)
        for i = 1, #base do J[i][j] = (fp[i] - fm[i]) / (2 * delta) end
    end
    return J
end
function RiemannSolver:GetDiagnostics()
    return {
        time = self.Time,
        iterations = self.Iterations,
        residual = self.Diagnostics.residual,
        converged = self.Diagnostics.converged,
    }
end
function RiemannSolver:Reset()
    self.Time = 0
    self.Iterations = 0
    self.Diagnostics = { residual = math.huge, converged = false }
end
function RiemannSolver.ComputeResidual(lhs: {number}, rhs: {number}): (number, number)
    validateVector(lhs)
    validateVector(rhs, #lhs)
    local sumSquares, referenceSquares = 0, 0
    for i = 1, #lhs do
        local r = lhs[i] - rhs[i]
        sumSquares += r * r
        referenceSquares += rhs[i] * rhs[i]
    end
    local absolute = math.sqrt(sumSquares)
    local relative = absolute / math.max(math.sqrt(referenceSquares), EPS)
    return absolute, relative
end
function RiemannSolver.WeightedLeastSquares(residual: {number}, weights: {number}?): number
    validateVector(residual)
    local total = 0
    for i = 1, #residual do
        local w = if weights then (weights[i] or 0) else 1
        assert(w >= 0 and finite(w), "weights must be finite and nonnegative")
        total += 0.5 * w * residual[i] * residual[i]
    end
    return total
end
function RiemannSolver.NormalizeState(state: {number}): {number}
    validateVector(state)
    local magnitude = norm(state)
    if magnitude <= EPS then return zeros(#state) end
    return scale(state, 1 / magnitude)
end
function RiemannSolver.EstimateRefinement(coarse: number, fine: number, order: number?): number
    assert(finite(coarse) and finite(fine), "estimates must be finite")
    local p = order or 1
    assert(p > 0, "order must be positive")
    return math.abs(fine - coarse) / (2^p - 1)
end
function RiemannSolver.MomentumTendency(velocity: {number}, pressureGradient: {number}, laplacianVelocity: {number}, density: number, viscosity: number, forcing: {number}?): {number}
    validateVector(velocity)
    validateVector(pressureGradient, #velocity)
    validateVector(laplacianVelocity, #velocity)
    assert(density > 0 and viscosity >= 0, "invalid fluid material parameters")
    local out = table.create(#velocity)
    for i=1,#velocity do
        local advective = 0
        for j=1,#velocity do advective += velocity[j] * (self.Configuration.VelocityGradient and self.Configuration.VelocityGradient[i] and self.Configuration.VelocityGradient[i][j] or 0) end
        out[i] = -advective - pressureGradient[i]/density + viscosity*laplacianVelocity[i] + ((forcing and forcing[i]) or 0)
    end
    return out
end
return RiemannSolver
