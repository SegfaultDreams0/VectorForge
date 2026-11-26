-- optimization-methods implementation for RMSPropOptimizer
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.

local Module = {}
function Module.Step(parameters,gradient,meanSquare,learningRate,decay,epsilon)
    local nextParameters,nextMean=table.create(#parameters),table.create(#parameters)
    for i=1,#parameters do nextMean[i]=decay*meanSquare[i]+(1-decay)*gradient[i]^2; nextParameters[i]=parameters[i]-learningRate*gradient[i]/(math.sqrt(nextMean[i])+(epsilon or 1e-8)) end
    return nextParameters,nextMean
end

return Module
