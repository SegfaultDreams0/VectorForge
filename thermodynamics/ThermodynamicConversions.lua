-- thermodynamics implementation for ThermodynamicConversions
-- Units: temperature K, pressure Pa, volume m^3, amount mol, energy J, heat capacity J/(mol K); model assumptions are stated by each equation (ideal, real-gas, or cycle model).
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.CelsiusToKelvin(c) assert(c>=-273.15,"below absolute zero"); return c+273.15 end
function Module.PascalToBar(p) Num.Nonnegative(p,"pressure"); return p/1e5 end
function Module.BarToPascal(p) Num.Nonnegative(p,"pressure"); return p*1e5 end

return Module
