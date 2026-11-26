-- optimization-methods implementation for ParticleSwarm
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.

local Module = {}
function Module.Update(position,velocity,pBest,gBest,inertia,cognitive,social,random)
    assert(#position==#velocity and #position==#pBest and #position==#gBest,"particle dimension mismatch")
    local nextVelocity=table.create(#position); local nextPosition=table.create(#position)
    for i=1,#position do
        nextVelocity[i]=inertia*velocity[i]+cognitive*random:Next()*(pBest[i]-position[i])+social*random:Next()*(gBest[i]-position[i])
        nextPosition[i]=position[i]+nextVelocity[i]
    end
    return nextPosition,nextVelocity
end

return Module
