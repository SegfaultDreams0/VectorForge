-- control-systems implementation for ExtendedKalmanObserver
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local AD = require(VectorForge:WaitForChild("AutomaticDifferentiation"))

local Module = {}
function Module.Correct(state,covariance,measurement,measurementFunction,measurementNoise)
    local H=AD.Jacobian(measurementFunction,state)
    local predicted=measurementFunction(state)
    local innovation=Num.Subtract(measurement,predicted)
    local S=Num.Add(LA.Multiply(LA.Multiply(H,covariance),LA.Transpose(H)),measurementNoise)
    local Sinv,reason=LA.Inverse(S); assert(Sinv,reason or "EKF innovation covariance singular")
    local gain=LA.Multiply(LA.Multiply(covariance,LA.Transpose(H)),Sinv)
    local corrected=Num.Add(state,LA.MatrixVector(gain,innovation))
    local IminusKH=Num.Subtract(LA.Identity(#state),LA.Multiply(gain,H))
    local correctedCov=LA.Symmetrize(LA.Multiply(IminusKH,covariance))
    return corrected,correctedCov,{Jacobian=H,Innovation=innovation,Gain=gain}
end

return Module
