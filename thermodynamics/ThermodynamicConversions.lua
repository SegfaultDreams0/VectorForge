-- thermodynamic conversions
local M = {}
function M.CelsiusToKelvin(c) return c+273.15 end
function M.KelvinToCelsius(k) assert(k >= 0, "temperature below absolute zero"); return k-273.15 end
function M.PascalToBar(p) return p/100000 end
function M.BarToPascal(p) return p*100000 end
return M
