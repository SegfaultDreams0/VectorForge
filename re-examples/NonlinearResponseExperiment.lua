-- nonlinear response experiment
local values={}
for i=0,100 do
    local input=-2+4*i/100
    local response=0.7*input-0.12*input^3
    values[i+1]={Input=input,Response=response}
end
return values
