-- random stream
local M = {}
M.__index=M
function M.new(seed)
    return setmetatable({State=math.floor(seed)%2147483647},M)
end
function M:Next()
    self.State=(16807*self.State)%2147483647
    return (self.State-1)/2147483646
end
function M:Range(minimum,maximum)
    return minimum+(maximum-minimum)*self:Next()
end
return M
