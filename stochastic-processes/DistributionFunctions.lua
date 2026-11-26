-- distribution functions
local M = {}
function M.NormalPDF(x,mean,standardDeviation)
    assert(standardDeviation > 0, "standard deviation must be positive")
    local z=(x-mean)/standardDeviation
    return math.exp(-0.5*z*z)/(standardDeviation*math.sqrt(2*math.pi))
end
function M.ExponentialPDF(x,rate)
    assert(rate > 0, "rate must be positive")
    if x < 0 then return 0 end
    return rate*math.exp(-rate*x)
end
return M
