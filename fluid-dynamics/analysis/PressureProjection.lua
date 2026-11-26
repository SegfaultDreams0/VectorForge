-- fluid-dynamics implementation for PressureProjection
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Divergence(u,v,dx,dy)
    Num.Positive(dx,"dx"); Num.Positive(dy,"dy"); local rows=#u; local cols=#u[1]; local div=LA.Zeros(rows,cols)
    for i=2,rows-1 do for j=2,cols-1 do div[i][j]=(u[i][j+1]-u[i][j-1])/(2*dx)+(v[i+1][j]-v[i-1][j])/(2*dy) end end
    return div
end
function Module.Project(u,v,p,dt,rho,dx,dy)
    Num.Positive(dt,"time step"); Num.Positive(rho,"density"); Num.Positive(dx,"dx"); Num.Positive(dy,"dy")
    local rows=#u; local cols=#u[1]; assert(#v==rows and #p==rows,"grid dimensions mismatch")
    local uc=LA.Copy(u); local vc=LA.Copy(v)
    for i=2,rows-1 do for j=2,cols-1 do uc[i][j]-=dt/rho*(p[i][j+1]-p[i][j-1])/(2*dx); vc[i][j]-=dt/rho*(p[i+1][j]-p[i-1][j])/(2*dy) end end
    return uc,vc
end


-- Jacobi pressure solve for div(grad(p)) = rho/dt * div(u*), with zero-mean gauge.
-- Grid is a uniform interior Cartesian array; homogeneous Neumann boundary closure is used.
function Module.SolvePressureJacobi(divergence, dx, dy, density, dt, iterations, tolerance)
    Num.Positive(dx, "x spacing"); Num.Positive(dy, "y spacing")
    Num.Positive(density, "density"); Num.Positive(dt, "time step")
    local ny = #divergence
    assert(ny >= 3 and #divergence[1] >= 3, "pressure grid must be at least 3 by 3")
    local nx = #divergence[1]
    for j = 1, ny do assert(#divergence[j] == nx, "divergence grid must be rectangular") end
    local pressure, nextPressure = table.create(ny), table.create(ny)
    local rhsMean = 0
    for j=1,ny do
        pressure[j]=table.create(nx,0); nextPressure[j]=table.create(nx,0)
        for i=1,nx do rhsMean += divergence[j][i] end
    end
    rhsMean /= nx*ny
    local ax, ay = 1/(dx*dx), 1/(dy*dy)
    local denominator = 2*(ax+ay)
    local rhsScale = density/dt
    local maxResidual = math.huge
    for iteration=1,(iterations or 500) do
        maxResidual=0
        for j=2,ny-1 do for i=2,nx-1 do
            local compatibleRhs = divergence[j][i] - rhsMean
            nextPressure[j][i] = ((pressure[j][i+1]+pressure[j][i-1])*ax + (pressure[j+1][i]+pressure[j-1][i])*ay - rhsScale*compatibleRhs)/denominator
            maxResidual=math.max(maxResidual,math.abs(nextPressure[j][i]-pressure[j][i]))
        end end
        for j=1,ny do nextPressure[j][1]=nextPressure[j][2]; nextPressure[j][nx]=nextPressure[j][nx-1] end
        for i=1,nx do nextPressure[1][i]=nextPressure[2][i]; nextPressure[ny][i]=nextPressure[ny-1][i] end
        local meanPressure = 0
        for j=1,ny do for i=1,nx do meanPressure += nextPressure[j][i] end end
        meanPressure /= nx*ny
        for j=1,ny do for i=1,nx do nextPressure[j][i] -= meanPressure end end
        pressure,nextPressure=nextPressure,pressure
        if maxResidual <= (tolerance or 1e-8) then return pressure,{Converged=true,Iterations=iteration,UpdateNorm=maxResidual,RHSMeanRemoved=rhsMean} end
    end
    return pressure,{Converged=false,Iterations=iterations or 500,UpdateNorm=maxResidual,RHSMeanRemoved=rhsMean}
end

return Module
