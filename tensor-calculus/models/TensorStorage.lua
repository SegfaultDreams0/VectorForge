-- tensor-calculus implementation for TensorStorage
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.new(shape,initialValue)
    local count=1; for _,dimension in ipairs(shape) do Num.Positive(dimension,"tensor dimension"); assert(dimension%1==0,"integer shape required"); count*=dimension end
    local values=table.create(count,initialValue or 0)
    return {Shape=table.clone(shape),Values=values,Size=count}
end
function Module.Get(tensor,indices)
    return tensor.Values[Num.TensorLinearIndex(indices,tensor.Shape)]
end
function Module.Set(tensor,indices,value)
    assert(type(value)=="number" and value==value and math.abs(value)<math.huge,"finite scalar value required")
    tensor.Values[Num.TensorLinearIndex(indices,tensor.Shape)]=value
end

return Module
