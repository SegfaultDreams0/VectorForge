-- energy decay simulation
local x,v,dt=1,0,1/500
local mass,stiffness,damping=2,9,0.35
local energy={}
for step=1,1000 do
    local a=(-stiffness*x-damping*v)/mass
    v+=a*dt; x+=v*dt
    if step%50==0 then
        table.insert(energy,{time=step*dt,kinetic=0.5*mass*v*v,potential=0.5*stiffness*x*x})
    end
end
return energy
