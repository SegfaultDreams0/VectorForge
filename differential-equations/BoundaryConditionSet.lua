-- boundary condition set
local M = {}
function M.new()
    return {Dirichlet={},Neumann={},Robin={}}
end
function M.Add(target,kind,index,value)
    assert(target[kind] ~= nil and index >= 1, "invalid boundary condition")
    target[kind][index]=value
    return target
end
return M
