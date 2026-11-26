-- electromagnetics implementation for BiotSavartField
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local Constants = require(Shared:WaitForChild("Constants"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}

function Module.StraightSegmentCurrent(current, pointA, pointB, observation)
    assert(type(current) == "number" and current == current and math.abs(current) < math.huge, "current must be finite")
    assert(#pointA == 3 and #pointB == 3 and #observation == 3, "points must be three-dimensional numeric arrays")
    local segment = Num.Subtract(pointB, pointA)
    local length = LA.Norm(segment)
    Num.Positive(length, "wire segment length")
    local direction = Num.Scale(segment, 1 / length)
    local fromStart = Num.Subtract(observation, pointA)
    local axialStart = LA.Dot(fromStart, direction)
    local perpendicular = Num.Subtract(fromStart, Num.Scale(direction, axialStart))
    local radius = LA.Norm(perpendicular)
    Num.Positive(radius, "perpendicular distance from wire")
    local axialEnd = axialStart - length
    local endFactor = axialEnd / math.sqrt(radius * radius + axialEnd * axialEnd)
    local startFactor = axialStart / math.sqrt(radius * radius + axialStart * axialStart)
    local angular = Num.Cross3(direction, perpendicular)
    local coefficient = Constants.MU_0 * current / (4 * math.pi * radius * radius) * (startFactor - endFactor)
    return Num.Scale(angular, coefficient)
end

return Module
