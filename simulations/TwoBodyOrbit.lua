local TwoBodyOrbit = {}

local function derivative(state, mu)
    local radius = state.position.Magnitude

    assert(radius > 0, "position magnitude must be greater than zero")

    local acceleration = state.position * (-mu / (radius * radius * radius))

    return {
        position = state.velocity,
        velocity = acceleration,
    }
end

local function addScaled(state, slope, scale)
    return {
        position = state.position + slope.position * scale,
        velocity = state.velocity + slope.velocity * scale,
    }
end

function TwoBodyOrbit.step(state, parameters)
    assert(typeof(state) == "table", "state must be a table")
    assert(typeof(state.position) == "Vector3", "state.position must be a Vector3")
    assert(typeof(state.velocity) == "Vector3", "state.velocity must be a Vector3")
    assert(typeof(parameters) == "table", "parameters must be a table")

    local mu = parameters.gravitationalParameter
    local dt = parameters.timeStep

    assert(type(mu) == "number" and mu > 0, "gravitationalParameter must be positive")
    assert(type(dt) == "number" and dt > 0, "timeStep must be positive")

    local k1 = derivative(state, mu)
    local k2 = derivative(addScaled(state, k1, dt * 0.5), mu)
    local k3 = derivative(addScaled(state, k2, dt * 0.5), mu)
    local k4 = derivative(addScaled(state, k3, dt), mu)

    local position = state.position
        + (k1.position + k2.position * 2 + k3.position * 2 + k4.position) * (dt / 6)

    local velocity = state.velocity
        + (k1.velocity + k2.velocity * 2 + k3.velocity * 2 + k4.velocity) * (dt / 6)

    return {
        position = position,
        velocity = velocity,
    }
end

return TwoBodyOrbit
