-- control-systems implementation for KalmanObserver
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Update(state,covariance,measurement,H,Q,R)
    local innovation=Num.Subtract(measurement,LA.MatrixVector(H,state))
    local S=Num.Add(LA.Multiply(LA.Multiply(H,covariance),LA.Transpose(H)),R)
    local Sinv,reason=LA.Inverse(S); assert(Sinv,reason or "innovation covariance singular")
    local gain=LA.Multiply(LA.Multiply(covariance,LA.Transpose(H)),Sinv)
    local corrected=Num.Add(state,LA.MatrixVector(gain,innovation))
    local identity=LA.Identity(#state); local residual=Num.Subtract(identity,LA.Multiply(gain,H))
    local joseph=Num.Add(LA.Multiply(LA.Multiply(residual,covariance),LA.Transpose(residual)),LA.Multiply(LA.Multiply(gain,R),LA.Transpose(gain)))
    return corrected,LA.Symmetrize(joseph),{Innovation=innovation,Gain=gain}
end

return Module
