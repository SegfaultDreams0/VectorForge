-- computational-geometry implementation for ConvexHull2D
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.

local Module = {}
function Module.MonotoneChain(points)
    assert(#points>=3,"convex hull needs at least three points")
    local sorted={}; for i,p in ipairs(points) do sorted[i]=p end
    table.sort(sorted,function(a,b) return a[1]==b[1] and a[2]<b[2] or a[1]<b[1] end)
    local function cross(o,a,b) return (a[1]-o[1])*(b[2]-o[2])-(a[2]-o[2])*(b[1]-o[1]) end
    local lower={}; for _,p in ipairs(sorted) do while #lower>=2 and cross(lower[#lower-1],lower[#lower],p)<=0 do table.remove(lower) end; table.insert(lower,p) end
    local upper={}; for i=#sorted,1,-1 do local p=sorted[i]; while #upper>=2 and cross(upper[#upper-1],upper[#upper],p)<=0 do table.remove(upper) end; table.insert(upper,p) end
    table.remove(lower); table.remove(upper); for _,p in ipairs(upper) do table.insert(lower,p) end
    return lower
end

return Module
