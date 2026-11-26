-- optimization-methods implementation for SimplexSearch
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}

function Module.NelderMeadStep(simplex, objective, reflection, expansion, contraction, shrink)
    assert(type(simplex) == "table" and #simplex >= 2, "simplex must contain at least two vertices")
    assert(type(objective) == "function", "objective must be callable")
    local dimension = #simplex[1]
    assert(dimension >= 1 and #simplex == dimension + 1, "an n-dimensional simplex must contain n+1 vertices")
    local alpha, gamma = reflection or 1, expansion or 2
    local rho, sigma = contraction or 0.5, shrink or 0.5
    assert(alpha > 0 and gamma > 1 and rho > 0 and rho < 1 and sigma > 0 and sigma < 1, "invalid Nelder-Mead coefficients")

    local scored = table.create(#simplex)
    for i = 1, #simplex do
        assert(#simplex[i] == dimension, "simplex vertices must have equal dimensions")
        scored[i] = {Point = table.clone(simplex[i]), Value = objective(simplex[i])}
    end
    table.sort(scored, function(a, b) return a.Value < b.Value end)

    local centroid = table.create(dimension, 0)
    for i = 1, dimension do
        centroid = Num.Add(centroid, Num.Scale(scored[i].Point, 1 / dimension))
    end

    local worst = scored[#scored].Point
    local reflected = Num.Add(centroid, Num.Scale(Num.Subtract(centroid, worst), alpha))
    local reflectedValue = objective(reflected)
    local replacement

    if reflectedValue < scored[1].Value then
        local expanded = Num.Add(centroid, Num.Scale(Num.Subtract(reflected, centroid), gamma))
        replacement = if objective(expanded) < reflectedValue then expanded else reflected
    elseif reflectedValue < scored[dimension].Value then
        replacement = reflected
    else
        local outside = reflectedValue < scored[#scored].Value
        local contracted = if outside
            then Num.Add(centroid, Num.Scale(Num.Subtract(reflected, centroid), rho))
            else Num.Add(centroid, Num.Scale(Num.Subtract(worst, centroid), rho))
        local contractedValue = objective(contracted)
        if (outside and contractedValue <= reflectedValue) or (not outside and contractedValue < scored[#scored].Value) then
            replacement = contracted
        else
            local nextSimplex = table.create(#scored)
            nextSimplex[1] = scored[1].Point
            for i = 2, #scored do
                nextSimplex[i] = Num.Add(scored[1].Point, Num.Scale(Num.Subtract(scored[i].Point, scored[1].Point), sigma))
            end
            return nextSimplex
        end
    end

    local nextSimplex = table.create(#scored)
    for i = 1, dimension do nextSimplex[i] = scored[i].Point end
    nextSimplex[#scored] = replacement
    return nextSimplex
end

return Module
