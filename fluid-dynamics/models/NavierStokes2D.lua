-- fluid-dynamics implementation for NavierStokes2D
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.VorticityRHS(omega,u,v,dx,dy,nu)
    Num.Positive(dx,"dx"); Num.Positive(dy,"dy"); Num.Nonnegative(nu,"kinematic viscosity")
    local rows=#omega; local cols=#omega[1]; local rhs=LA.Zeros(rows,cols)
    for i=2,rows-1 do for j=2,cols-1 do
        local adv=u[i][j]*(omega[i][j+1]-omega[i][j-1])/(2*dx)+v[i][j]*(omega[i+1][j]-omega[i-1][j])/(2*dy)
        local lap=(omega[i][j+1]-2*omega[i][j]+omega[i][j-1])/(dx*dx)+(omega[i+1][j]-2*omega[i][j]+omega[i-1][j])/(dy*dy)
        rhs[i][j]=-adv+nu*lap
    end end
    return rhs
end


-- Conservative 2D vorticity transport on a uniform grid:
-- dω/dt + u dω/dx + v dω/dy = ν Laplacian(ω) + source.
function Module.VorticityTransportStep(vorticity, velocityX, velocityY, dx, dy, dt, viscosity, source)
    Num.Positive(dx,"x spacing"); Num.Positive(dy,"y spacing"); Num.Positive(dt,"time step")
    Num.Nonnegative(viscosity,"kinematic viscosity")
    local ny,nx=#vorticity,#vorticity[1]
    assert(nx>=3 and ny>=3 and #velocityX==ny and #velocityY==ny,"flow grid dimensions mismatch")
    local nextField=table.create(ny)
    for j=1,ny do
        assert(#vorticity[j]==nx and #velocityX[j]==nx and #velocityY[j]==nx,"flow grids must be rectangular")
        nextField[j]=table.clone(vorticity[j])
    end
    local idx2,idy2=1/(dx*dx),1/(dy*dy)
    for j=2,ny-1 do for i=2,nx-1 do
        local wx=(vorticity[j][i+1]-vorticity[j][i-1])/(2*dx)
        local wy=(vorticity[j+1][i]-vorticity[j-1][i])/(2*dy)
        local lap=(vorticity[j][i+1]-2*vorticity[j][i]+vorticity[j][i-1])*idx2+(vorticity[j+1][i]-2*vorticity[j][i]+vorticity[j-1][i])*idy2
        local forcing=source and source[j] and source[j][i] or 0
        nextField[j][i]=vorticity[j][i]+dt*(-velocityX[j][i]*wx-velocityY[j][i]*wy+viscosity*lap+forcing)
    end end
    return nextField
end

-- Central-difference divergence residual for a sampled velocity field.
function Module.MaximumDivergence(velocityX,velocityY,dx,dy)
    Num.Positive(dx,"x spacing"); Num.Positive(dy,"y spacing")
    local maximum=0
    for j=2,#velocityX-1 do for i=2,#velocityX[j]-1 do
        local divergence=(velocityX[j][i+1]-velocityX[j][i-1])/(2*dx)+(velocityY[j+1][i]-velocityY[j-1][i])/(2*dy)
        maximum=math.max(maximum,math.abs(divergence))
    end end
    return maximum
end

return Module
