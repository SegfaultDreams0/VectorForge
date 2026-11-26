-- fixed step integration demo
local q,p,dt=1,0,1/1000
local samples={}
for step=1,2000 do
    p-=q*dt
    q+=p*dt
    if step%100==0 then table.insert(samples,{Time=step*dt,Position=q,Momentum=p}) end
end
return samples
