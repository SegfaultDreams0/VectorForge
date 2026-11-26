-- orbital-mechanics implementation for TwoBodyPropagator
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Acceleration(position,mu)
    Num.Positive(mu,"mu"); local r=LA.Norm(position); Num.Positive(r,"orbital radius")
    return Num.Scale(position,-mu/r^3)
end


-- Specific orbital energy epsilon=v^2/2-mu/r for an isolated two-body system.
function Module.SpecificEnergy(position, velocity, gravitationalParameter)
    Num.Positive(gravitationalParameter,"gravitational parameter")
    local radius=LA.Norm(position)
    Num.Positive(radius,"orbital radius")
    return 0.5*LA.Dot(velocity,velocity)-gravitationalParameter/radius
end

-- Specific angular momentum vector h=r x v and its magnitude.
function Module.SpecificAngularMomentum(position,velocity)
    local h=Num.Cross3(position,velocity)
    return h,LA.Norm(h)
end

-- Circular orbit period for radius a: T=2*pi*sqrt(a^3/mu).
function Module.CircularPeriod(radius,gravitationalParameter)
    Num.Positive(radius,"circular orbit radius"); Num.Positive(gravitationalParameter,"gravitational parameter")
    return 2*math.pi*math.sqrt(radius^3/gravitationalParameter)
end

return Module
