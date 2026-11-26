-- integration tolerance
local M = {}
function M.new(absolute,relative)
    assert(absolute > 0 and relative > 0, "tolerances must be positive")
    return {Absolute=absolute,Relative=relative}
end
function M.ErrorScale(tolerance,reference)
    return tolerance.Absolute+tolerance.Relative*math.abs(reference)
end
return M
