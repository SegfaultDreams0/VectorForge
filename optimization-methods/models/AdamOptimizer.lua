-- optimization-methods implementation for AdamOptimizer
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.

local Module = {}
function Module.Step(parameters,gradient,firstMoment,secondMoment,iteration,learningRate,beta1,beta2,epsilon)
    beta1=beta1 or 0.9; beta2=beta2 or 0.999; epsilon=epsilon or 1e-8
    assert(#parameters==#gradient and #gradient==#firstMoment and #gradient==#secondMoment,"Adam dimensions mismatch")
    local p,m,v=table.create(#parameters),table.create(#parameters),table.create(#parameters)
    for i=1,#parameters do
        m[i]=beta1*firstMoment[i]+(1-beta1)*gradient[i]
        v[i]=beta2*secondMoment[i]+(1-beta2)*gradient[i]^2
        local mh=m[i]/(1-beta1^iteration); local vh=v[i]/(1-beta2^iteration)
        p[i]=parameters[i]-learningRate*mh/(math.sqrt(vh)+epsilon)
    end
    return p,m,v
end

return Module
