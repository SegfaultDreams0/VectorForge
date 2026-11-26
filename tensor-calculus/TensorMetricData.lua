-- tensor-calculus implementation for TensorMetricData
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("TensorCalculus")
local MetricTensor = require(DomainModules:WaitForChild("models"):WaitForChild("MetricTensor"))

local Module = {}
function Module.VolumeElement(metric)
    MetricTensor.Validate(metric)
    return math.sqrt(LA.Determinant(metric))
end
function Module.Trace(metric) return LA.Trace(metric) end

return Module
