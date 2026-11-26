-- electromagnetics implementation for WaveguideModes
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))

local Module = {}
function Module.RectangularCutoff(m,n,width,height)
    Num.Positive(width,"waveguide width"); Num.Positive(height,"waveguide height"); assert(m>=0 and n>=0 and m+n>0,"mode indices must be nonnegative and not both zero")
    return Constants.C/2*math.sqrt((m/width)^2+(n/height)^2)
end

return Module
