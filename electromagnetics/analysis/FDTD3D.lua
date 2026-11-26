-- electromagnetics implementation for FDTD3D
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.UpdateEx(ex,hy,hz,dt,dy,dz,epsilon)
    Num.Positive(dt,"time step"); Num.Positive(dy,"dy"); Num.Positive(dz,"dz"); Num.Positive(epsilon,"permittivity")
    local out=LA.Copy(ex)
    for i=1,#ex do for j=1,#ex[i]-1 do for k=1,#ex[i][j]-1 do
        out[i][j][k]+=dt/epsilon*((hz[i][j+1][k]-hz[i][j][k])/dy-(hy[i][j][k+1]-hy[i][j][k])/dz)
    end end end
    return out
end

return Module
