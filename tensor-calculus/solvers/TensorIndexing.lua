-- tensor-calculus implementation for TensorIndexing
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.ToLinear(indices,shape) return Num.TensorLinearIndex(indices,shape) end
function Module.ToMulti(linear,shape) return Num.TensorMultiIndex(linear,shape) end
function Module.Contractible(shapeA,axisA,shapeB,axisB)
    assert(axisA>=1 and axisA<=#shapeA and axisB>=1 and axisB<=#shapeB,"axis out of range")
    return shapeA[axisA]==shapeB[axisB]
end

return Module
