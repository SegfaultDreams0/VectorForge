local SolarSystem = {
    Mercury = {
        mass = 3.3011e23,
        semiMajorAxis = 5.7909e10,
        orbitalPeriod = 7.6005e6,
    },
    Venus = {
        mass = 4.8675e24,
        semiMajorAxis = 1.0821e11,
        orbitalPeriod = 1.9414e7,
    },
    Earth = {
        mass = 5.9722e24,
        semiMajorAxis = 1.4960e11,
        orbitalPeriod = 3.1558e7,
    },
    Mars = {
        mass = 6.4171e23,
        semiMajorAxis = 2.2794e11,
        orbitalPeriod = 5.9355e7,
    },
    Jupiter = {
        mass = 1.8982e27,
        semiMajorAxis = 7.7857e11,
        orbitalPeriod = 3.7434e8,
    },
    Saturn = {
        mass = 5.6834e26,
        semiMajorAxis = 1.4335e12,
        orbitalPeriod = 9.2929e8,
    },
}


for _, body in pairs(SolarSystem) do
    body.gravitationalParameter = 6.67430e-11 * body.mass
    table.freeze(body)
end

return table.freeze(SolarSystem)
