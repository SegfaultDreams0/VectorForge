-- optimization-methods implementation for TrustRegion
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.CauchyStep(gradient,hessian,radius)
    Num.Positive(radius,"trust-region radius"); local gg=LA.Dot(gradient,gradient); Num.Positive(gg,"gradient norm squared")
    local Bg=LA.MatrixVector(hessian,gradient); local curvature=LA.Dot(gradient,Bg)
    local alpha=if curvature<=0 then radius/math.sqrt(gg) else math.min(gg/curvature,radius/math.sqrt(gg))
    return Num.Scale(gradient,-alpha)
end
function Module.UpdateRadius(radius,actualReduction,predictedReduction)
    Num.Positive(radius,"trust-region radius"); assert(predictedReduction>0,"predicted reduction must be positive")
    local ratio=actualReduction/predictedReduction
    if ratio<0.25 then return 0.25*radius elseif ratio>0.75 then return math.min(2*radius,1e6) else return radius end
end


-- Actual/predicted reduction ratio for a trust-region trial point.
function Module.ReductionRatio(currentCost,trialCost,gradient,step,hessian)
    local predicted=-(LA.Dot(gradient,step)+0.5*LA.Dot(step,LA.MatrixVector(hessian,step)))
    assert(predicted>0,"trust-region model must predict positive reduction")
    local actual=currentCost-trialCost
    return actual/predicted,actual,predicted
end

-- Accept or reject a trial and update radius according to standard ratio thresholds.
function Module.AcceptTrial(ratio,radius,stepNorm,eta1,eta2,shrink,grow)
    Num = Num or require(game:GetService("ReplicatedStorage"):WaitForChild("VectorForgeShared"):WaitForChild("NumericalKernels"))
    Num.Positive(radius,"trust-region radius")
    local low,high=eta1 or 0.25,eta2 or 0.75
    assert(low>=0 and high>low,"invalid acceptance thresholds")
    local newRadius=radius
    if ratio<low then newRadius=radius*(shrink or 0.25)
    elseif ratio>high and stepNorm>=0.9*radius then newRadius=radius*(grow or 2) end
    return ratio>low,newRadius
end

return Module
