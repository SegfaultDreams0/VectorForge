-- control-systems implementation for NonlinearStateSpace
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.

local Module = {}
function Module.Evaluate(dynamics,state,input,time)
    local derivative=dynamics(state,input,time)
    assert(type(derivative)=="table" and #derivative==#state,"nonlinear dynamics returned wrong state dimension")
    return derivative
end

return Module
