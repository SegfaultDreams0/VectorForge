-- finite-element-methods implementation for GaussianQuadrature
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.

local Module = {}
function Module.Rule1D(order)
    local rules={
        [1]={Points={0},Weights={2}},
        [2]={Points={-1/math.sqrt(3),1/math.sqrt(3)},Weights={1,1}},
        [3]={Points={-math.sqrt(3/5),0,math.sqrt(3/5)},Weights={5/9,8/9,5/9}},
        [4]={Points={-0.861136311594053,-0.339981043584856,0.339981043584856,0.861136311594053},Weights={0.347854845137454,0.652145154862546,0.652145154862546,0.347854845137454}},
    }
    assert(rules[order],"Gauss order supported from 1 to 4")
    return rules[order]
end
function Module.Integrate1D(f,a,b,order)
    local rule=Module.Rule1D(order); local total=0; local midpoint=(a+b)/2; local half=(b-a)/2
    for i=1,#rule.Points do total+=rule.Weights[i]*f(midpoint+half*rule.Points[i]) end
    return half*total
end


-- Integrate a sampled callback over [a,b] using the stored Gauss-Legendre rule.
function Module.IntegrateInterval(callback, a, b, order)
    assert(type(callback)=="function" and b>a,"invalid integration interval")
    local rule=Module.Rule1D(order)
    local midpoint,half=0.5*(a+b),0.5*(b-a)
    local total=0
    for i=1,#rule.Points do total += rule.Weights[i]*callback(midpoint+half*rule.Points[i]) end
    return half*total
end

-- Estimate quadrature convergence by comparing two consecutive supported orders.
function Module.ConvergenceEstimate(callback,a,b,lowOrder,highOrder)
    local coarse=Module.IntegrateInterval(callback,a,b,lowOrder)
    local fine=Module.IntegrateInterval(callback,a,b,highOrder)
    return fine,math.abs(fine-coarse),coarse
end

return Module
