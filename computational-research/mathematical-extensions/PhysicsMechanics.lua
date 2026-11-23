local P = {}

local function vadd(a, b)
    return {a[1] + b[1], a[2] + b[2], a[3] + b[3]}
end

local function vsub(a, b)
    return {a[1] - b[1], a[2] - b[2], a[3] - b[3]}
end

local function vscale(a, s)
    return {a[1] * s, a[2] * s, a[3] * s}
end

local function dot(a, b)
    return a[1] * b[1] + a[2] * b[2] + a[3] * b[3]
end

local function cross(a, b)
    return {
        a[2] * b[3] - a[3] * b[2],
        a[3] * b[1] - a[1] * b[3],
        a[1] * b[2] - a[2] * b[1]
    }
end

local function norm(a)
    return math.sqrt(dot(a, a))
end

function P.gravitational_parameter(mass, gravitational_constant)
    assert(mass > 0 and gravitational_constant > 0, "mass and gravitational constant must be positive")
    return gravitational_constant * mass
end

function P.newtonian_acceleration(position, source_mass, gravitational_constant)
    local radius = norm(position)
    assert(radius > 0 and source_mass > 0 and gravitational_constant > 0, "invalid gravitational state")
    return vscale(position, -gravitational_constant * source_mass / radius ^ 3)
end

function P.two_body_derivative(state, mu)
    local r = {state[1], state[2], state[3]}
    local velocity = {state[4], state[5], state[6]}
    local radius = norm(r)
    assert(radius > 0 and mu > 0, "invalid two-body state")
    local acceleration = vscale(r, -mu / radius ^ 3)
    return {
        velocity[1], velocity[2], velocity[3],
        acceleration[1], acceleration[2], acceleration[3]
    }
end

function P.specific_energy(position, velocity, mu)
    local radius = norm(position)
    assert(radius > 0 and mu > 0, "invalid orbital state")
    return 0.5 * dot(velocity, velocity) - mu / radius
end

function P.specific_angular_momentum(position, velocity)
    return cross(position, velocity)
end

function P.vis_viva(mu, radius, semi_major_axis)
    assert(mu > 0 and radius > 0 and semi_major_axis > 0, "orbital parameters must be positive")
    local value = mu * (2 / radius - 1 / semi_major_axis)
    assert(value >= 0, "state is outside the real-speed region")
    return math.sqrt(value)
end

function P.orbital_elements(position, velocity, mu)
    local r, v = norm(position), norm(velocity)
    assert(r > 0 and mu > 0, "invalid orbital state")
    local h = cross(position, velocity)
    local hnorm = norm(h)
    local evec = vsub(vscale(cross(velocity, h), 1 / mu), vscale(position, 1 / r))
    local eccentricity = norm(evec)
    local energy = 0.5 * v * v - mu / r
    local semi_major_axis = math.abs(energy) > 1e-14 and -mu / (2 * energy) or math.huge
    local inclination = math.acos(math.max(-1, math.min(1, h[3] / hnorm)))
    return {
        semi_major_axis = semi_major_axis,
        eccentricity = eccentricity,
        inclination = inclination,
        angular_momentum = h,
        eccentricity_vector = evec,
        specific_energy = energy
    }
end

function P.drag_acceleration(velocity, density, drag_coefficient, area, mass)
    assert(density >= 0 and drag_coefficient >= 0 and area >= 0 and mass > 0, "invalid drag parameters")
    local speed = norm(velocity)
    if speed == 0 then return {0, 0, 0} end
    local factor = -0.5 * density * drag_coefficient * area * speed / mass
    return vscale(velocity, factor)
end

function P.kinetic_energy(mass, velocity)
    assert(mass >= 0, "mass cannot be negative")
    return 0.5 * mass * dot(velocity, velocity)
end

function P.potential_energy(mass, height, gravitational_acceleration)
    assert(mass >= 0, "mass cannot be negative")
    return mass * gravitational_acceleration * height
end

function P.rigid_body_angular_acceleration(inertia, angular_velocity, torque)
    assert(type(inertia) == "table" and #inertia == 3, "inertia must be a 3x3 matrix")
    local iw = {
        inertia[1][1] * angular_velocity[1] + inertia[1][2] * angular_velocity[2] + inertia[1][3] * angular_velocity[3],
        inertia[2][1] * angular_velocity[1] + inertia[2][2] * angular_velocity[2] + inertia[2][3] * angular_velocity[3],
        inertia[3][1] * angular_velocity[1] + inertia[3][2] * angular_velocity[2] + inertia[3][3] * angular_velocity[3]
    }
    local rhs = vsub(torque, cross(angular_velocity, iw))
    local a, b, c = inertia[1][1], inertia[1][2], inertia[1][3]
    local d, e, f = inertia[2][1], inertia[2][2], inertia[2][3]
    local g, h, i = inertia[3][1], inertia[3][2], inertia[3][3]
    local det = a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)
    assert(math.abs(det) > 1e-14, "inertia tensor is singular")
    local inv = {
        {(e*i-f*h)/det, (c*h-b*i)/det, (b*f-c*e)/det},
        {(f*g-d*i)/det, (a*i-c*g)/det, (c*d-a*f)/det},
        {(d*h-e*g)/det, (b*g-a*h)/det, (a*e-b*d)/det}
    }
    return {
        inv[1][1] * rhs[1] + inv[1][2] * rhs[2] + inv[1][3] * rhs[3],
        inv[2][1] * rhs[1] + inv[2][2] * rhs[2] + inv[2][3] * rhs[3],
        inv[3][1] * rhs[1] + inv[3][2] * rhs[2] + inv[3][3] * rhs[3]
    }
end

return P
