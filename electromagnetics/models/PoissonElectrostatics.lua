-- electromagnetics implementation for PoissonElectrostatics
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Solve1D(chargeDensity,length,epsilon,leftPotential,rightPotential)
    local n=#chargeDensity; assert(n>=2,"at least two interior points required"); Num.Positive(length,"domain length"); Num.Positive(epsilon,"permittivity")
    local dx=length/(n+1); local matrix=LA.Zeros(n,n); local rhs=table.create(n)
    for i=1,n do matrix[i][i]=2; if i>1 then matrix[i][i-1]=-1 end; if i<n then matrix[i][i+1]=-1 end; rhs[i]=chargeDensity[i]*dx*dx/epsilon end
    rhs[1]+=leftPotential; rhs[n]+=rightPotential
    local solution,reason=LA.Solve(matrix,rhs); assert(solution,reason or "Poisson solve failed")
    return solution
end


-- Electric field from potential: E_i = -(phi[i+1]-phi[i-1])/(2 dx).
function Module.ElectricField1D(potential, spacing)
    Num.Positive(spacing,"grid spacing"); assert(#potential>=3,"potential grid requires at least three samples")
    local field=table.create(#potential-2)
    for i=2,#potential-1 do field[i-1]=-(potential[i+1]-potential[i-1])/(2*spacing) end
    return field
end

-- Discrete Poisson residual r_i = (phi[i-1]-2phi[i]+phi[i+1])/dx^2 + rho/epsilon.
function Module.Residual1D(potential, chargeDensity, spacing, permittivity)
    Num.Positive(spacing,"grid spacing"); Num.Positive(permittivity,"permittivity")
    assert(#potential==#chargeDensity and #potential>=3,"Poisson arrays must have equal length >= 3")
    local residual=table.create(#potential-2); local maximum=0
    for i=2,#potential-1 do
        local value=(potential[i-1]-2*potential[i]+potential[i+1])/(spacing*spacing)+chargeDensity[i]/permittivity
        residual[i-1]=value; maximum=math.max(maximum,math.abs(value))
    end
    return residual,maximum
end

return Module
