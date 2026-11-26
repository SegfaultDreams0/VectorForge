-- electromagnetics implementation for LorentzForce
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Compute(charge,electric,velocity,magnetic)
    assert(#electric==3 and #velocity==3 and #magnetic==3,"three-dimensional fields required")
    return Num.Scale(Num.Add(electric,Num.Cross3(velocity,magnetic)),charge)
end

return Module
