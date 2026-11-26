-- fluid-dynamics implementation for VorticityTransport
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Stretching(omega,velocityGradient)
    assert(#omega==3 and #velocityGradient==3,"3D vorticity and gradient required")
    return LA.MatrixVector(velocityGradient,omega)
end
function Module.BaroclinicTerm(gradRho,gradPressure,rho)
    Num.Positive(rho,"density"); return Num.Scale(Num.Cross3(gradRho,gradPressure),1/(rho*rho))
end

return Module
