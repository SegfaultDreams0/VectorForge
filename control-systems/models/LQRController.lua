-- control-systems implementation for LQRController
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("ControlSystems")
local DiscreteRiccati = require(DomainModules:WaitForChild("analysis"):WaitForChild("DiscreteRiccati"))

local Module = {}
function Module.Design(A,B,Q,R)
    local P,Kgain,diagnostics=DiscreteRiccati.Solve(A,B,Q,R)
    assert(diagnostics.Converged,"discrete Riccati iteration did not converge")
    return Kgain,P
end
function Module.Control(gain,state)
    return Num.Scale(LA.MatrixVector(gain,state),-1)
end

return Module
