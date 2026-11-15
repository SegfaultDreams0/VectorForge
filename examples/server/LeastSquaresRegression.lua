local RS = game:GetService("ReplicatedStorage")
local LA = require(RS.VectorForge:WaitForChild("SpectralLinearAlgebra"))

local samples = {
    {0, 3.1}, {1, 4.8}, {2, 7.2}, {3, 8.9},
    {4, 11.2}, {5, 12.8}, {6, 15.1}
}

local design = {}
local observations = {}

for index, sample in ipairs(samples) do
    local x, y = sample[1], sample[2]
    design[index] = {1, x, x * x}
    observations[index] = y
end

local coefficients, failure = LA.LeastSquares(design, observations)
assert(coefficients, failure)

local intercept, linear, quadratic = coefficients[1], coefficients[2], coefficients[3]
local residualSumSquares = 0

print("[VectorForge] Quadratic least-squares regression")
print(string.format("y = %.6f + %.6fx + %.6fx^2", intercept, linear, quadratic))

for _, sample in ipairs(samples) do
    local x, observed = sample[1], sample[2]
    local predicted = intercept + linear * x + quadratic * x * x
    local residual = observed - predicted
    residualSumSquares += residual * residual

    print(string.format(
        "x=%.2f | observed=%.4f | predicted=%.4f | residual=%.4f",
        x, observed, predicted, residual
    ))
end

print(string.format("Residual sum of squares: %.8f", residualSumSquares))
