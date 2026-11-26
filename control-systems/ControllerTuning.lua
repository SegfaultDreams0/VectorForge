-- controller tuning
local M = {}
function M.PID(kp,ki,kd,limit)
    assert(limit > 0, "output limit must be positive")
    return {Kp=kp,Ki=ki,Kd=kd,OutputLimit=limit,IntegralLimit=limit}
end
function M.ClampOutput(value, limit)
    return math.max(-limit, math.min(limit,value))
end
return M
