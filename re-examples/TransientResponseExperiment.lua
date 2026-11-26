-- transient response experiment
local y,dt=0,0.002
local tau=0.25
local samples={}
for step=1,750 do
    y+=(1-y)*dt/tau
    if step%25==0 then table.insert(samples,{Time=step*dt,Output=y}) end
end
return samples
