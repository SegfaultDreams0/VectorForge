-- computational-geometry implementation for DelaunayTriangulation
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Triangulate(points)
    assert(#points>=3,"Delaunay triangulation requires at least three points")
    local minX,maxX,minY,maxY=math.huge,-math.huge,math.huge,-math.huge
    for _,p in ipairs(points) do minX=math.min(minX,p[1]); maxX=math.max(maxX,p[1]); minY=math.min(minY,p[2]); maxY=math.max(maxY,p[2]) end
    local delta=math.max(maxX-minX,maxY-minY); Num.Positive(delta,"point cloud extent")
    local midX,midY=(minX+maxX)/2,(minY+maxY)/2; local work={}
    for i,p in ipairs(points) do work[i]=p end
    work[#points+1]={midX-20*delta,midY-10*delta}; work[#points+2]={midX+20*delta,midY-10*delta}; work[#points+3]={midX,midY+20*delta}
    local triangles={{#points+1,#points+2,#points+3}}
    local function inCircle(p,a,b,c)
        local ax,ay=a[1]-p[1],a[2]-p[2]; local bx,by=b[1]-p[1],b[2]-p[2]; local cx,cy=c[1]-p[1],c[2]-p[2]
        local det=(ax*ax+ay*ay)*(bx*cy-by*cx)-(bx*bx+by*by)*(ax*cy-ay*cx)+(cx*cx+cy*cy)*(ax*by-ay*bx)
        return det>1e-12
    end
    for index=1,#points do
        local bad={}; local edgeCount={}
        for ti,tri in ipairs(triangles) do if inCircle(work[index],work[tri[1]],work[tri[2]],work[tri[3]]) then bad[ti]=true
            for _,edge in ipairs({{tri[1],tri[2]},{tri[2],tri[3]},{tri[3],tri[1]}}) do table.sort(edge); local key=edge[1]..":"..edge[2]; edgeCount[key]=edgeCount[key] or {Count=0,Edge=edge}; edgeCount[key].Count+=1 end
        end end
        local kept={}; for ti,tri in ipairs(triangles) do if not bad[ti] then table.insert(kept,tri) end end
        for _,entry in pairs(edgeCount) do if entry.Count==1 then table.insert(kept,{entry.Edge[1],entry.Edge[2],index}) end end
        triangles=kept
    end
    local result={}; for _,tri in ipairs(triangles) do if tri[1]<=#points and tri[2]<=#points and tri[3]<=#points then table.insert(result,tri) end end
    return result
end

return Module
