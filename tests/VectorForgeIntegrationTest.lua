local RS = game:GetService("ReplicatedStorage")
local Modules = RS:WaitForChild("VectorForge")

local Lie = require(Modules:WaitForChild("LieGroupKinematics"))
local LA = require(Modules:WaitForChild("SpectralLinearAlgebra"))
local EKF = require(Modules:WaitForChild("BayesianStateEstimation"))
local Geometry = require(Modules:WaitForChild("DifferentialPathGeometry"))

local passed, failed = 0, 0
local failures = {}

local function near(a, b, tolerance)
    return math.abs(a - b) <= (tolerance or 1e-6)
end

local function vectorNear(a, b, tolerance)
    return (a - b).Magnitude <= (tolerance or 1e-5)
end

local function matrixNear(a, b, tolerance)
    if #a ~= #b then return false end
    for row = 1, #a do
        if #a[row] ~= #b[row] then return false end
        for column = 1, #a[row] do
            if not near(a[row][column], b[row][column], tolerance) then return false end
        end
    end
    return true
end

local function identity(size)
    local result = {}
    for row = 1, size do
        result[row] = {}
        for column = 1, size do
            result[row][column] = row == column and 1 or 0
        end
    end
    return result
end

local function test(name, callback)
    local ok, err = xpcall(callback, debug.traceback)
    if ok then
        passed += 1
        print("[VectorForge][PASS] " .. name)
    else
        failed += 1
        table.insert(failures, {name = name, error = tostring(err)})
        warn("[VectorForge][FAIL] " .. name .. " | " .. tostring(err))
    end
end


test("SO3 exponential/logarithmic maps", function()
    local v = Vector3.new(0.2, -0.4, 0.1)
    assert(vectorNear(v, Lie.Quaternion.Log(Lie.Quaternion.Exp(v)), 1e-5))
end)

test("Quaternion rotation preserves magnitude", function()
    local q = Lie.Quaternion.Exp(Vector3.new(0.7, 0.2, -0.3))
    local v = Vector3.new(3, -4, 2)
    assert(near(v.Magnitude, Lie.Quaternion.Rotate(q, v).Magnitude, 1e-5))
end)

test("Quaternion SLERP endpoints", function()
    local a = Lie.Quaternion.Exp(Vector3.new(0.1, 0.2, 0.3))
    local b = Lie.Quaternion.Exp(Vector3.new(-0.4, 0.3, 0.2))
    local input = Vector3.xAxis
    assert(vectorNear(Lie.Quaternion.Rotate(Lie.Quaternion.Slerp(a, b, 0), input), Lie.Quaternion.Rotate(a, input)))
    assert(vectorNear(Lie.Quaternion.Rotate(Lie.Quaternion.Slerp(a, b, 1), input), Lie.Quaternion.Rotate(b, input)))
end)

test("SE3 pose inverse", function()
    local pose = Lie.Pose.New(Lie.Quaternion.Exp(Vector3.new(0.3, -0.1, 0.5)), Vector3.new(7, -2, 4))
    local point = Vector3.new(2, 5, -1)
    local world = Lie.Pose.TransformPoint(pose, point)
    local localPoint = Lie.Pose.TransformPoint(Lie.Pose.Inverse(pose), world)
    assert(vectorNear(point, localPoint, 1e-5))
end)

test("SE3 exponential/logarithmic maps", function()
    local twist = {Angular = Vector3.new(0.15, -0.22, 0.31), Linear = Vector3.new(2, -3, 1.5)}
    local recovered = Lie.Pose.Log(Lie.Pose.Exp(twist))
    assert(vectorNear(twist.Angular, recovered.Angular, 1e-5))
    assert(vectorNear(twist.Linear, recovered.Linear, 1e-5))
end)

test("Matrix multiplication", function()
    local result = LA.Multiply({{1, 2}, {3, 4}}, {{5, 6}, {7, 8}})
    assert(matrixNear(result, {{19, 22}, {43, 50}}, 1e-8))
end)

test("LU solve and determinant", function()
    local a = {{4, 1}, {1, 3}}
    local x, err = LA.Solve(a, {1, 2})
    assert(x, err)
    assert(near(x[1], 1 / 11, 1e-8))
    assert(near(x[2], 7 / 11, 1e-8))
    assert(near(LA.Determinant(a), 11, 1e-8))
end)

test("Singular LU system returns failure", function()
    local x = LA.Solve({{1, 2}, {2, 4}}, {3, 6})
    assert(x == nil)
end)

test("Cholesky reconstruction", function()
    local a = {{4, 2}, {2, 3}}
    local l, err = LA.Cholesky(a)
    assert(l, err)
    assert(matrixNear(LA.Multiply(l, LA.Transpose(l)), a, 1e-8))
end)

test("Householder QR reconstruction and orthogonality", function()
    local a = {{12, -51, 4}, {6, 167, -68}, {-4, 24, -41}}
    local q, r = LA.QR(a)
    assert(matrixNear(LA.Multiply(q, r), a, 1e-7))
    assert(matrixNear(LA.Multiply(LA.Transpose(q), q), identity(3), 1e-7))
end)

test("Symmetric eigenpair residual", function()
    local a = {{4, 1}, {1, 3}}
    local values, vectors = LA.SymmetricEigen(a)
    for column = 1, 2 do
        local v = {vectors[1][column], vectors[2][column]}
        local av = LA.MatrixVector(a, v)
        for row = 1, 2 do
            assert(near(av[row], values[column] * v[row], 1e-7))
        end
    end
end)

test("Conjugate Gradient convergence", function()
    local x, diagnostics = LA.ConjugateGradient({{4, 1}, {1, 3}}, {1, 2}, nil, 1e-10, 20)
    assert(diagnostics.Converged)
    assert(near(x[1], 1 / 11, 1e-7))
    assert(near(x[2], 7 / 11, 1e-7))
end)

test("Least-squares quadratic fit", function()
    local a = {{1, 0, 0}, {1, 1, 1}, {1, 2, 4}, {1, 3, 9}, {1, 4, 16}}
    local x, err = LA.LeastSquares(a, {2, 6, 12, 20, 30})
    assert(x, err)
    assert(near(x[1], 2, 1e-7))
    assert(near(x[2], 3, 1e-7))
    assert(near(x[3], 1, 1e-7))
end)

test("Numerical Jacobian", function()
    local j = EKF.Jacobian(function(x) return {x[1]^2, x[1] + 3 * x[2]} end, {2, 5}, 2)
    assert(near(j[1][1], 4, 1e-4))
    assert(near(j[1][2], 0, 1e-4))
    assert(near(j[2][1], 1, 1e-4))
    assert(near(j[2][2], 3, 1e-4))
end)

test("EKF prediction and measurement update", function()
    local filter = EKF.new({
        InitialState = {0, 2},
        InitialCovariance = {{1, 0}, {0, 1}},
        ProcessNoise = {{0.001, 0}, {0, 0.01}},
        MeasurementNoise = {{0.1}},
        Transition = function(x, _, h) return {x[1] + x[2] * h, x[2]} end,
        Measurement = function(x) return {x[1]} end
    })
    local prediction = filter:Predict(nil, 0.1)
    assert(near(prediction.State[1], 0.2, 1e-8))
    local accepted = filter:Update({0.24})
    assert(accepted)
    assert(filter.AcceptedMeasurements == 1)
end)

test("EKF innovation gating", function()
    local filter = EKF.new({
        InitialState = {0},
        InitialCovariance = {{0.01}},
        ProcessNoise = {{0.001}},
        MeasurementNoise = {{0.1}},
        Transition = function(x) return {x[1]} end,
        Measurement = function(x) return {x[1]} end,
        GateThreshold = 0.001
    })
    local accepted = filter:Update({100})
    assert(not accepted)
    assert(filter.RejectedMeasurements == 1)
end)

local curve

test("Hermite curve endpoints", function()
    curve = Geometry.new({Vector3.new(0, 0, 0), Vector3.new(10, 5, 0), Vector3.new(20, 0, 10)})
    assert(vectorNear(curve:Evaluate(0), Vector3.new(0, 0, 0)))
    assert(vectorNear(curve:Evaluate(1), Vector3.new(20, 0, 10)))
end)

test("Curvature and torsion are finite", function()
    local curvature = curve:Curvature(0.45)
    local torsion = curve:Torsion(0.45)
    assert(curvature >= 0 and curvature < math.huge)
    assert(torsion == torsion and math.abs(torsion) < math.huge)
end)

test("Arc length inversion", function()
    local length = curve:ArcLength()
    assert(length > 0)
    local parameter = curve:ParameterAtArcLength(length * 0.4)
    assert(near(curve:ArcLengthAt(parameter), length * 0.4, 1e-3))
end)

test("Frenet frame orthonormality", function()
    local frame = curve:FrenetFrame(0.5)
    assert(frame ~= nil)
    assert(near(frame.Tangent.Magnitude, 1, 1e-5))
    assert(near(frame.Normal.Magnitude, 1, 1e-5))
    assert(near(frame.Binormal.Magnitude, 1, 1e-5))
    assert(math.abs(frame.Tangent:Dot(frame.Normal)) < 1e-5)
end)

test("Parallel transport frames", function()
    local frames = curve:ParallelTransportFrames(24)
    assert(#frames == 24)
    for _, frame in ipairs(frames) do
        assert(math.abs(frame.Tangent:Dot(frame.Normal)) < 1e-5)
        assert(math.abs(frame.Tangent:Dot(frame.Binormal)) < 1e-5)
    end
end)

test("Closest-point parameter is bounded", function()
    local target = curve:Evaluate(0.35) + Vector3.new(0, 1, 0)
    local parameter, point = curve:ClosestParameter(target, 64, 16)
    assert(parameter >= 0 and parameter <= 1)
    assert(typeof(point) == "Vector3")
end)

test("Minimum-jerk boundary conditions", function()
    local start = Vector3.new(1, 2, 3)
    local goal = Vector3.new(8, 9, 10)
    local p0, v0, a0 = Geometry.MinimumJerk(start, goal, 2, 0)
    local p1, v1, a1 = Geometry.MinimumJerk(start, goal, 2, 2)
    assert(vectorNear(p0, start, 1e-7))
    assert(vectorNear(p1, goal, 1e-7))
    assert(v0.Magnitude < 1e-7 and v1.Magnitude < 1e-7)
    assert(a0.Magnitude < 1e-7 and a1.Magnitude < 1e-7)
end)

print(string.format("[VectorForge] %d passed | %d failed", passed, failed))

if failed > 0 then
    for _, failure in ipairs(failures) do
        warn("[VectorForge] " .. failure.name .. "\n" .. failure.error)
    end
    error(string.format("VectorForge test suite failed: %d test(s)", failed))
else
    print("[VectorForge] All tests passed.")
end
