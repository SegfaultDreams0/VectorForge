-- electromagnetic constants
local M = {}
M.SpeedOfLight = 299792458
M.VacuumPermeability = 1.25663706127e-6
M.VacuumPermittivity = 1/(M.VacuumPermeability*M.SpeedOfLight^2)
M.ElementaryCharge = 1.602176634e-19
return M
