-- computational-geometry implementation for ConvexHull3D
-- Assumptions: coordinates use a consistent caller-defined length unit; predicates and parameter values require non-degenerate input geometry unless noted.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.BruteForceFaces(points,tolerance)
    assert(#points>=4,"3D hull requires at least four points"); local tol=tolerance or 1e-10; local faces={}; local seen={}
    for i=1,#points-2 do for j=i+1,#points-1 do for k=j+1,#points do
        local ab=Num.Subtract(points[j],points[i]); local ac=Num.Subtract(points[k],points[i]); local normal=Num.Cross3(ab,ac); local magnitude=LA.Norm(normal)
        if magnitude>tol then
            normal=Num.Scale(normal,1/magnitude); local positive,negative=false,false
            for p=1,#points do if p~=i and p~=j and p~=k then local side=LA.Dot(normal,Num.Subtract(points[p],points[i])); if side>tol then positive=true elseif side< -tol then negative=true end end end
            if not (positive and negative) then
                local face={i,j,k}; if positive then face={i,k,j} end
                local key=table.concat(face,":"); if not seen[key] then seen[key]=true; table.insert(faces,{Indices=face,Normal=normal}) end
            end
        end
    end end end
    return faces,{Assumption="general position without coplanar face ambiguity"}
end

return Module
