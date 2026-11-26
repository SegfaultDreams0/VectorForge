-- computational-geometry implementation for GeodesicDistance
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Dijkstra(vertexCount,edges,source)
    assert(source>=1 and source<=vertexCount,"source vertex out of range")
    local graph=table.create(vertexCount); for i=1,vertexCount do graph[i]={} end
    for _,edge in ipairs(edges) do Num.Nonnegative(edge.Weight,"edge length"); table.insert(graph[edge.A],{To=edge.B,Weight=edge.Weight}); table.insert(graph[edge.B],{To=edge.A,Weight=edge.Weight}) end
    local distance=table.create(vertexCount,math.huge); local visited=table.create(vertexCount,false); distance[source]=0
    for _=1,vertexCount do
        local current=nil; local best=math.huge
        for i=1,vertexCount do if not visited[i] and distance[i]<best then current=i; best=distance[i] end end
        if not current then break end; visited[current]=true
        for _,edge in ipairs(graph[current]) do local candidate=best+edge.Weight; if candidate<distance[edge.To] then distance[edge.To]=candidate end end
    end
    return distance
end

return Module
