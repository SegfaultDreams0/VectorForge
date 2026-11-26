-- rigid body parameters
local M = {}
function M.new(mass,inertia)
    assert(mass > 0 and #inertia == 3 and #inertia[1] == 3, "invalid rigid body properties")
    return {Mass=mass,Inertia=inertia}
end
return M
