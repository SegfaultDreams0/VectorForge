-- index convention
local M = {}
function M.ValidateIndex(index,dimension)
    assert(index >= 1 and index <= dimension and index % 1 == 0, "tensor index out of range")
    return index
end
function M.CanContract(shapeA,axisA,shapeB,axisB)
    return shapeA[axisA] == shapeB[axisB]
end
return M
