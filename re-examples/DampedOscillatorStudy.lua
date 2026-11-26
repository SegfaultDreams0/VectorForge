-- damped oscillator study
local mass, stiffness, damping = 1.0, 16.0, 0.8
local x, velocity, dt = 1.0, 0.0, 1/240
local history = {}
for step=1,480 do
    local acceleration = (-stiffness*x-damping*velocity)/mass
    velocity += acceleration*dt
    x += velocity*dt
    if step%24==0 then table.insert(history,{time=step*dt,position=x,velocity=velocity}) end
end
return {History=history,FinalPosition=x,FinalVelocity=velocity}
