-- three state dynamics study
local A={{0,1,0},{-2,-0.3,1},{0,-1,-0.5}}
local x={1,0.2,-0.1}
local dt=0.005
for _=1,600 do
    local nextState={0,0,0}
    for i=1,3 do for j=1,3 do nextState[i]+=A[i][j]*x[j]*dt end; nextState[i]+=x[i] end
    x=nextState
end
return {FinalState=x}
