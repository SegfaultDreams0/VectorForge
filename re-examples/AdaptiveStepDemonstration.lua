-- adaptive step demonstration
local time,value,step=0,1,0.1
local samples={}
while time<2 do
    local derivative=-2*value
    local trial=value+step*derivative
    local error=math.abs((trial-value)-step*derivative*0.9)
    if error<0.01 then
        time+=step; value=trial
        table.insert(samples,{Time=time,Value=value,Step=step})
        step=math.min(0.15,step*1.1)
    else
        step*=0.5
    end
end
return samples
