-- continuum-mechanics implementation for StressInvariants
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Compute(stress)
    local I1=LA.Trace(stress); local tr2=LA.Trace(LA.Multiply(stress,stress)); local I2=0.5*(I1*I1-tr2); local I3=LA.Determinant(stress)
    local mean=I1/3; local dev=Num.Subtract(stress,Num.Scale(LA.Identity(3),mean)); local J2=0.5*LA.FrobeniusNorm(dev)^2
    return {I1=I1,I2=I2,I3=I3,J2=J2,MeanStress=mean}
end

return Module
