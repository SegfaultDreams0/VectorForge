-- computational-geometry implementation for MeshSmoothing
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Laplacian(vertices,adjacency,lambda,iterations)
    assert(#vertices==#adjacency,"mesh vertex/adjacency mismatch"); assert(lambda>=0 and lambda<=1,"smoothing factor must be in [0,1]")
    local current={}; for i,v in ipairs(vertices) do current[i]=table.clone(v) end
    for _=1,(iterations or 1) do
        local nextVertices={}
        for i,v in ipairs(current) do
            if #adjacency[i]==0 then nextVertices[i]=table.clone(v)
            else
                local average=table.create(#v,0); for _,neighbor in ipairs(adjacency[i]) do average=Num.Add(average,current[neighbor]) end
                average=Num.Scale(average,1/#adjacency[i]); nextVertices[i]=Num.Add(Num.Scale(v,1-lambda),Num.Scale(average,lambda))
            end
        end
        current=nextVertices
    end
    return current
end

return Module
