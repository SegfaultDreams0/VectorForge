-- orbit state validation
local M = {}
function M.Validate(position,velocity)
    assert(#position == 3 and #velocity == 3, "orbit state must be three dimensional")
    for i=1,3 do
        assert(position[i] == position[i] and velocity[i] == velocity[i], "orbit state contains invalid values")
    end
    return true
end
return M
