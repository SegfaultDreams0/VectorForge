-- control-systems implementation for PIDController
-- Assumptions: vectors and matrices use numeric arrays; time and signal units follow the modeled plant; discrete-time methods require a positive sample interval.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.Step(errorValue,integral,previousError,dt,kp,ki,kd,limits)
    Num.Positive(dt,"sample interval")
    local nextIntegral=integral+errorValue*dt
    if limits and limits.Integral then nextIntegral=math.max(-limits.Integral,math.min(limits.Integral,nextIntegral)) end
    local derivative=(errorValue-previousError)/dt
    local output=kp*errorValue+ki*nextIntegral+kd*derivative
    if limits and limits.Output then output=math.max(-limits.Output,math.min(limits.Output,output)) end
    return output,nextIntegral,errorValue
end


-- Parallel PID with derivative filtering and conditional-integration anti-windup.
-- The derivative filter uses alpha=dt/(tau+dt), preventing measurement-noise amplification.
function Module.StepFiltered(setpoint,measurement,integral,previousMeasurement,previousFilteredDerivative,dt,kp,ki,kd,filterTimeConstant,limits)
    Num.Positive(dt,"controller time step")
    local errorValue=setpoint-measurement
    local rawDerivative=previousMeasurement and -(measurement-previousMeasurement)/dt or 0
    local tau=filterTimeConstant or 0
    Num.Nonnegative(tau,"derivative filter time constant")
    local alpha=tau==0 and 1 or dt/(tau+dt)
    local filteredDerivative=(previousFilteredDerivative or 0)+alpha*(rawDerivative-(previousFilteredDerivative or 0))
    local candidateIntegral=integral+errorValue*dt
    if limits and limits.Integral then candidateIntegral=math.clamp(candidateIntegral,-limits.Integral,limits.Integral) end
    local unsaturated=kp*errorValue+ki*candidateIntegral+kd*filteredDerivative
    local saturated=unsaturated
    if limits and limits.Output then saturated=math.clamp(unsaturated,-limits.Output,limits.Output) end
    local drivesFurther=(unsaturated>saturated and errorValue>0) or (unsaturated<saturated and errorValue<0)
    if drivesFurther then candidateIntegral=integral end
    local output=kp*errorValue+ki*candidateIntegral+kd*filteredDerivative
    if limits and limits.Output then output=math.clamp(output,-limits.Output,limits.Output) end
    return output,candidateIntegral,measurement,filteredDerivative,{Error=errorValue,Unsaturated=unsaturated,Saturated=output,Derivative=filteredDerivative}
end

return Module
