-- coupled state evolution
local x,y,z = 1.0,0.0,0.5
local dt=0.002
for _=1,1000 do
    local dx=-0.4*x+0.1*y
    local dy=0.3*x-0.2*y+0.05*z
    local dz=-0.1*y-0.15*z
    x+=dx*dt; y+=dy*dt; z+=dz*dt
end
return {State={x,y,z},Norm=math.sqrt(x*x+y*y+z*z)}
