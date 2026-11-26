-- numerical stability trial
local dt=0.01
local growth={}
for factor=0.5,3,0.25 do
    local y=1
    for _=1,200 do y*=1+factor*dt end
    table.insert(growth,{Rate=factor,Approximation=y,Reference=math.exp(factor*2)})
end
return growth
