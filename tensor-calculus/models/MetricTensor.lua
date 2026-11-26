-- tensor-calculus implementation for MetricTensor
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Validate(metric,tol)
    local rows,cols=LA.Dimensions(metric); assert(rows==cols,"metric must be square")
    assert(LA.FrobeniusNorm(Num.Subtract(metric,LA.Transpose(metric)))<=(tol or 1e-10),"metric must be symmetric")
    assert(LA.Determinant(metric)>0,"metric must have positive determinant")
    assert(LA.Cholesky(metric)~=nil,"metric must be positive definite")
    return true
end
function Module.RaiseIndex(metric,covector)
    Module.Validate(metric)
    return LA.MatrixVector(LA.Inverse(metric),covector)
end
function Module.LowerIndex(metric,vector)
    Module.Validate(metric)
    return LA.MatrixVector(metric,vector)
end


-- Metric volume density: sqrt(det(g)); valid for positive-definite Riemannian metrics.
function Module.VolumeDensity(metric)
    Module.Validate(metric)
    local determinant = LA.Determinant(metric)
    assert(determinant > 0, "metric determinant must be positive")
    return math.sqrt(determinant)
end

-- Metric inner product: <u,v>_g = u^T g v.
function Module.InnerProduct(metric, u, v)
    Module.Validate(metric)
    assert(#u == #metric and #v == #metric, "metric inner-product dimension mismatch")
    local gv = LA.MatrixVector(metric, v)
    return LA.Dot(u, gv)
end

-- Return the metric inverse through the core factorization/solve API.
function Module.Inverse(metric)
    Module.Validate(metric)
    local inverse, reason = LA.Inverse(metric)
    assert(inverse ~= nil, reason or "metric inversion failed")
    local identityResidual = LA.FrobeniusNorm(LA.Subtract(LA.Multiply(metric, inverse), LA.Identity(#metric)))
    return inverse, identityResidual
end

-- Check positive definiteness and symmetry separately for useful diagnostics.
function Module.Diagnostics(metric, tolerance)
    local tol = tolerance or 1e-10
    local symmetryResidual = LA.FrobeniusNorm(LA.Subtract(metric, LA.Transpose(metric)))
    local determinant = LA.Determinant(metric)
    local factor = LA.Cholesky(metric)
    return {
        SymmetryResidual = symmetryResidual,
        Determinant = determinant,
        PositiveDefinite = factor ~= nil,
        Valid = symmetryResidual <= tol and determinant > 0 and factor ~= nil,
    }
end

return Module
