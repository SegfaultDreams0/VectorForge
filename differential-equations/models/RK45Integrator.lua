-- differential-equations implementation for RK45Integrator
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.DormandPrinceStep(f,t,y,h,absoluteTolerance,relativeTolerance)
    local k1=f(y,t)
    local k2=f(Num.Add(y,Num.Scale(k1,h/5)),t+h/5)
    local k3=f(Num.Add(y,Num.Scale(Num.Add(Num.Scale(k1,3/40),Num.Scale(k2,9/40)),h)),t+3*h/10)
    local k4=f(Num.Add(y,Num.Scale(Num.Add(Num.Add(Num.Scale(k1,44/45),Num.Scale(k2,-56/15)),Num.Scale(k3,32/9)),h)),t+4*h/5)
    local k5=f(Num.Add(y,Num.Scale(Num.Add(Num.Add(Num.Add(Num.Scale(k1,19372/6561),Num.Scale(k2,-25360/2187)),Num.Scale(k3,64448/6561)),Num.Scale(k4,-212/729)),h)),t+8*h/9)
    local k6=f(Num.Add(y,Num.Scale(Num.Add(Num.Add(Num.Add(Num.Add(Num.Scale(k1,9017/3168),Num.Scale(k2,-355/33)),Num.Scale(k3,46732/5247)),Num.Scale(k4,49/176)),Num.Scale(k5,-5103/18656)),h)),t+h)
    local fifth=Num.Add(y,Num.Scale(Num.Add(Num.Add(Num.Add(Num.Add(Num.Scale(k1,35/384),Num.Scale(k3,500/1113)),Num.Scale(k4,125/192)),Num.Scale(k5,-2187/6784)),Num.Scale(k6,11/84)),h))
    local k7=f(fifth,t+h)
    local fourth=Num.Add(y,Num.Scale(Num.Add(Num.Add(Num.Add(Num.Add(Num.Add(Num.Scale(k1,5179/57600),Num.Scale(k3,7571/16695)),Num.Scale(k4,393/640)),Num.Scale(k5,-92097/339200)),Num.Scale(k6,187/2100)),Num.Scale(k7,1/40)),h))
    local error=LA.Norm(Num.Subtract(fifth,fourth)); local scale=(absoluteTolerance or 1e-9)+(relativeTolerance or 1e-6)*math.max(LA.Norm(y),LA.Norm(fifth))
    return fifth,error/scale
end

return Module
