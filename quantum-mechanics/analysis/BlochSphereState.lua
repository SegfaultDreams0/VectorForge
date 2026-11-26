-- quantum-mechanics implementation for BlochSphereState
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.FromSpinor(alpha,beta)
    local norm2=Num.ComplexAbs2(alpha)+Num.ComplexAbs2(beta)
    assert(math.abs(norm2-1)<1e-8,"spinor must be normalized")
    local cross=Num.ComplexMul({Re=alpha.Re,Im=-alpha.Im},beta)
    return {X=2*cross.Re,Y=2*cross.Im,Z=Num.ComplexAbs2(alpha)-Num.ComplexAbs2(beta)}
end

return Module
