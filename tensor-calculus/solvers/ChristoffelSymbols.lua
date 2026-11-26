-- tensor-calculus implementation for ChristoffelSymbols
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local DomainModules = ReplicatedStorage:WaitForChild("VectorForgeDomains"):WaitForChild("TensorCalculus")
local MetricTensor = require(DomainModules:WaitForChild("models"):WaitForChild("MetricTensor"))

local Module = {}
function Module.FromMetric(metric,derivatives)
    MetricTensor.Validate(metric)
    local n=#metric; assert(#derivatives==n,"one metric derivative matrix per coordinate required")
    local inverse=LA.Inverse(metric); local gamma=table.create(n)
    for upper=1,n do
        gamma[upper]=table.create(n)
        for lower1=1,n do
            gamma[upper][lower1]=table.create(n,0)
            for lower2=1,n do
                local value=0
                for l=1,n do value+=0.5*inverse[upper][l]*(derivatives[lower1][l][lower2]+derivatives[lower2][l][lower1]-derivatives[l][lower1][lower2]) end
                gamma[upper][lower1][lower2]=value
            end
        end
    end
    return gamma
end


-- Contracted connection: Gamma^i_{ik} = partial_k(log(sqrt(det(g)))).
function Module.Contracted(connection)
    local dimension = #connection
    local result = table.create(dimension, 0)
    for k = 1, dimension do
        local trace = 0
        for i = 1, dimension do trace += connection[i][i][k] end
        result[k] = trace
    end
    return result
end

-- Metric-compatibility residual: nabla_k g_ij must vanish for Levi-Civita connection.
function Module.MetricCompatibilityResidual(metric, partialMetric, connection)
    local n = #metric
    assert(#partialMetric == n and #connection == n, "metric-compatibility dimension mismatch")
    local maximum = 0
    for k = 1, n do
        for i = 1, n do
            for j = 1, n do
                local residual = partialMetric[k][i][j]
                for m = 1, n do
                    residual -= connection[m][k][i] * metric[m][j]
                    residual -= connection[m][k][j] * metric[i][m]
                end
                maximum = math.max(maximum, math.abs(residual))
            end
        end
    end
    return maximum
end

return Module
