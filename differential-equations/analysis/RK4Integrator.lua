local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
-- differential-equations implementation for RK4Integrator
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Step(f,t,state,dt)
    Num.Positive(dt,"step size"); return Num.RK4(f,state,t,dt)
end
function Module.IntegrateFixedSteps(f,t0,state,dt,steps)
    local result=table.clone(state); local time=t0
    for i=1,steps do result=Num.RK4(f,result,time,dt); time+=dt end
    return result,time
end


-- Step doubling error estimate: compare one full RK4 step with two half steps.
function Module.StepDoubling(rhs,state,time,step)
    Num.Positive(step,"integration step")
    local full=Module.Step(rhs,time,state,step)
    local half=Module.Step(rhs,time,state,step/2)
    local refined=Module.Step(rhs,time+step/2,half,step/2)
    local error=LA.Norm(Num.Scale(Num.Subtract(refined,full),1/15))
    return refined,error
end

-- Fixed-step integration records states at a caller-selected output interval.
function Module.IntegrateWithHistory(rhs,initialState,startTime,step,stepCount,outputEvery)
    Num.Positive(step,"integration step")
    assert(stepCount>=0 and stepCount%1==0,"step count must be a nonnegative integer")
    local interval=outputEvery or 1
    assert(interval>=1 and interval%1==0,"output interval must be a positive integer")
    local state=table.clone(initialState); local time=startTime; local history={{Time=time,State=table.clone(state)}}
    for index=1,stepCount do
        state=Module.Step(rhs,time,state,step); time+=step
        if index%interval==0 then table.insert(history,{Time=time,State=table.clone(state)}) end
    end
    return state,history
end

return Module
