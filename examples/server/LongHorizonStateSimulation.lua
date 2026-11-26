-- long horizon state simulation
local state={1,-0.5,0.25,0.1}
local decay={0.01,0.03,0.05,0.08}
local dt=0.01
for _=1,5000 do
    for i=1,#state do state[i]*=math.exp(-decay[i]*dt) end
end
local normSquared=0
for _,value in ipairs(state) do normSquared+=value*value end
return {State=state,FinalNorm=math.sqrt(normSquared),Duration=50}
