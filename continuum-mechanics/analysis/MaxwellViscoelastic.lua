-- continuum-mechanics implementation for MaxwellViscoelastic
-- Units: SI; small-strain formulas assume infinitesimal deformation, while finite-strain and hyperelastic routines use their explicitly named constitutive models.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.ExactStressUpdate(stress, strainRate, dt, youngModulus, relaxationTime)
    Num.Positive(dt,"time step"); Num.Positive(youngModulus,"Young modulus"); Num.Positive(relaxationTime,"relaxation time")
    local decay=math.exp(-dt/relaxationTime)
    return stress*decay+youngModulus*relaxationTime*strainRate*(1-decay)
end

return Module
