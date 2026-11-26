-- differential-equations implementation for DormandPrince
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("DifferentialEquations")
local RK45Integrator = require(DomainModules:WaitForChild("models"):WaitForChild("RK45Integrator"))

local Module = {}
function Module.AdaptiveStep(f,time,state,step,absoluteTolerance,relativeTolerance)
    Num.Positive(step,"trial step")
    local nextState,errorRatio=RK45Integrator.DormandPrinceStep(f,time,state,step,absoluteTolerance,relativeTolerance)
    local factor=if errorRatio==0 then 2 else math.max(0.2,math.min(5,0.9*errorRatio^(-0.2)))
    return nextState,{Accepted=errorRatio<=1,ErrorRatio=errorRatio,NextStep=step*factor}
end


-- Adaptive integration with a PI-like step controller using the embedded 5(4) error estimate.
function Module.IntegrateAdaptive(rhs,initialState,startTime,endTime,initialStep,absoluteTolerance,relativeTolerance)
    assert(endTime>=startTime,"end time must not precede start time")
    Num.Positive(initialStep,"initial step"); Num.Positive(absoluteTolerance,"absolute tolerance"); Num.Positive(relativeTolerance,"relative tolerance")
    local time=startTime; local state=table.clone(initialState); local step=initialStep
    local accepted,rejected=0,0; local history={{Time=time,State=table.clone(state)}}
    while time<endTime do
        step=math.min(step,endTime-time)
        local candidate,diagnostics=Module.AdaptiveStep(rhs,time,state,step,absoluteTolerance,relativeTolerance)
        if diagnostics.Accepted then
            time+=step; state=candidate; accepted+=1
            table.insert(history,{Time=time,State=table.clone(state)})
        else rejected+=1 end
        step=diagnostics.NextStep
        assert(step>1e-14,"adaptive integrator step underflow")
    end
    return state,history,{Accepted=accepted,Rejected=rejected}
end

return Module
