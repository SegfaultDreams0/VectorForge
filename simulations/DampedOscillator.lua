local DampedOscillator = {}

local function acceleration(displacement, velocity, parameters)
    return (
        -parameters.stiffness * displacement
        - parameters.damping * velocity
    ) / parameters.mass
end

local function derivative(state, parameters)
    return {
        displacement = state.velocity,
        velocity = acceleration(state.displacement, state.velocity, parameters),
    }
end

local function addScaled(state, slope, scale)
    return {
        displacement = state.displacement + slope.displacement * scale,
        velocity = state.velocity + slope.velocity * scale,
    }
end

function DampedOscillator.step(state, parameters, timeStep)
    assert(typeof(state) == "table", "state must be a table")
    assert(typeof(parameters) == "table", "parameters must be a table")
    assert(type(state.displacement) == "number", "displacement must be a number")
    assert(type(state.velocity) == "number", "velocity must be a number")
    assert(type(parameters.mass) == "number" and parameters.mass > 0, "mass must be positive")
    assert(type(parameters.stiffness) == "number" and parameters.stiffness >= 0, "stiffness must be non-negative")
    assert(type(parameters.damping) == "number" and parameters.damping >= 0, "damping must be non-negative")
    assert(type(timeStep) == "number" and timeStep > 0, "timeStep must be positive")

    local k1 = derivative(state, parameters)
    local k2 = derivative(addScaled(state, k1, timeStep * 0.5), parameters)
    local k3 = derivative(addScaled(state, k2, timeStep * 0.5), parameters)
    local k4 = derivative(addScaled(state, k3, timeStep), parameters)

    return {
        displacement = state.displacement
            + (k1.displacement + 2 * k2.displacement + 2 * k3.displacement + k4.displacement) * (timeStep / 6),
        velocity = state.velocity
            + (k1.velocity + 2 * k2.velocity + 2 * k3.velocity + k4.velocity) * (timeStep / 6),
    }
end

function DampedOscillator.energy(state, parameters)
    assert(type(state.displacement) == "number" and type(state.velocity) == "number", "invalid state")
    assert(type(parameters.mass) == "number" and parameters.mass > 0, "mass must be positive")
    assert(type(parameters.stiffness) == "number" and parameters.stiffness >= 0, "stiffness must be non-negative")

    local kinetic = 0.5 * parameters.mass * state.velocity * state.velocity
    local potential = 0.5 * parameters.stiffness * state.displacement * state.displacement

    return kinetic + potential
end

return DampedOscillator
