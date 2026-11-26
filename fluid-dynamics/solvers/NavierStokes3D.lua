-- fluid-dynamics implementation for NavierStokes3D
-- Units: SI for density, velocity, length, time, pressure, and viscosity; grid methods assume the stated dimensionality and require stable spacing and timestep choices.

local Module = {}
function Module.Divergence(velocity,spacing)
    assert(#velocity==3 and #spacing==3,"three velocity components and spacings required")
    local nx,ny,nz=#velocity[1],#velocity[1][1],#velocity[1][1][1]
    local out=table.create(nx)
    for i=1,nx do out[i]=table.create(ny); for j=1,ny do out[i][j]=table.create(nz,0) end end
    for i=2,nx-1 do for j=2,ny-1 do for k=2,nz-1 do
        out[i][j][k]=(velocity[1][i+1][j][k]-velocity[1][i-1][j][k])/(2*spacing[1])+(velocity[2][i][j+1][k]-velocity[2][i][j-1][k])/(2*spacing[2])+(velocity[3][i][j][k+1]-velocity[3][i][j][k-1])/(2*spacing[3])
    end end end
    return out
end

return Module
