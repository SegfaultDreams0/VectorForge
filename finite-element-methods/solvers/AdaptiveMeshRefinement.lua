-- finite-element-methods implementation for AdaptiveMeshRefinement
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Mark(indicators,threshold,relative)
    Num.Nonnegative(threshold,"refinement threshold"); local limit=threshold
    if relative then local maximum=0; for _,v in ipairs(indicators) do maximum=math.max(maximum,v) end; limit*=maximum end
    local marked={}; for i,value in ipairs(indicators) do if value>limit then table.insert(marked,i) end end
    return marked,limit
end

return Module
