local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local BenchmarkUtils = require(script.Parent:WaitForChild("BenchmarkUtils"))
local TargetModule = require(VectorForge:WaitForChild("DifferentialPathGeometry"))

local CONFIGURATION = {
    WarmupRuns = 2,
    MeasuredRuns = 7,
    Iterations = 100,
}

local function workload()
    -- reuse the same curve definition across runs.
    -- add calls using the actual API exposed by DifferentialPathGeometry.lua.
    assert(TargetModule ~= nil, "DifferentialPathGeometry failed to load")
end

BenchmarkUtils.PrintEnvironment()
BenchmarkUtils.Measure("Geometry workload adapter", workload, CONFIGURATION)
