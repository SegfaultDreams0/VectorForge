-- elastic material library
local M = {}
function M.FromYoungPoisson(young,poisson)
    assert(young > 0 and poisson > -1 and poisson < 0.5, "invalid elastic constants")
    return {Lambda=young*poisson/((1+poisson)*(1-2*poisson)),Mu=young/(2*(1+poisson))}
end
return M
