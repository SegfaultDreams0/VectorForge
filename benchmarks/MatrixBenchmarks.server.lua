local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local BenchmarkUtils = require(script.Parent:WaitForChild("BenchmarkUtils"))
local TargetModule = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local CONFIGURATION = {
    WarmupRuns = 2,
    MeasuredRuns = 7,
    Iterations = 100,
}

local function workload()
    -- Connect a verified matrix operation; create inputs outside the timed callback if setup cost is not being measured.
    -- Add calls using the actual API exposed by SpectralLinearAlgebra.lua.
    assert(TargetModule ~= nil, "SpectralLinearAlgebra failed to load")
end

BenchmarkUtils.PrintEnvironment()
BenchmarkUtils.Measure("Matrix workload adapter", workload, CONFIGURATION)
