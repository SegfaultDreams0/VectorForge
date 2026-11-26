-- contact solver settings
local M = {}
function M.new(iterations,friction,restitution)
    assert(iterations >= 1 and friction >= 0 and restitution >= 0 and restitution <= 1, "invalid contact settings")
    return {Iterations=iterations,Friction=friction,Restitution=restitution}
end
return M
