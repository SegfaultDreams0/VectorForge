-- electromagnetics implementation for FDTD2D
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.UpdateHz(hz,ex,ey,dt,dx,dy,mu)
    Num.Positive(dt,"dt"); Num.Positive(dx,"dx"); Num.Positive(dy,"dy"); Num.Positive(mu,"mu")
    local out=LA.Copy(hz)
    for i=1,#hz-1 do for j=1,#hz[i]-1 do out[i][j]+=dt/mu*((ex[i][j+1]-ex[i][j])/dy-(ey[i+1][j]-ey[i][j])/dx) end end
    return out
end

return Module
