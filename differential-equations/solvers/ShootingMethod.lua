-- differential-equations implementation for ShootingMethod
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.

local Module = {}
function Module.FindInitialSlope(integrate,slopeGuess,target,tolerance,maxIterations)
    local slope=slopeGuess; local tol=tolerance or 1e-8
    for iteration=1,(maxIterations or 30) do
        local value,derivative=integrate(slope); local residual=value-target
        if math.abs(residual)<=tol then return slope,{Converged=true,Iterations=iteration,Residual=residual} end
        assert(derivative~=0,"shooting sensitivity is zero"); slope-=residual/derivative
    end
    return slope,{Converged=false,Iterations=maxIterations or 30}
end

return Module
