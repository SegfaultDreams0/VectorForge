-- thermal material data
local M = {}
function M.new(conductivity,specificHeat,density)
    assert(conductivity > 0 and specificHeat > 0 and density > 0, "invalid thermal material")
    return {Conductivity=conductivity,SpecificHeat=specificHeat,Density=density,Diffusivity=conductivity/(density*specificHeat)}
end
return M
