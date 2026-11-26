-- computational-geometry implementation for VoronoiDiagram
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.NearestSite(point,sites)
    assert(#sites>0,"Voronoi sites cannot be empty"); local best,bestDistance=nil,math.huge
    for i,site in ipairs(sites) do local d=LA.Norm(Num.Subtract(point,site)); if d<bestDistance then best=i; bestDistance=d end end
    return best,bestDistance
end
function Module.ClipCell(site,otherSites,bounds)
    local polygon={table.clone(bounds[1]),table.clone(bounds[2]),table.clone(bounds[3]),table.clone(bounds[4])}
    for _,other in ipairs(otherSites) do
        local normal=Num.Subtract(other,site); local offset=(LA.Dot(other,other)-LA.Dot(site,site))/2; local output={}
        for i=1,#polygon do
            local a=polygon[i]; local b=polygon[i%#polygon+1]; local fa=LA.Dot(normal,a)-offset; local fb=LA.Dot(normal,b)-offset
            if fa<=0 then table.insert(output,a) end
            if fa*fb<0 then local t=fa/(fa-fb); table.insert(output,Num.Add(a,Num.Scale(Num.Subtract(b,a),t))) end
        end
        polygon=output
    end
    return polygon
end

return Module
