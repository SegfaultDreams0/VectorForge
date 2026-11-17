local function naiveSum(values)
    local total = 0
    for _, value in ipairs(values) do total += value end
    return total
end

local function compensatedSum(values)
    local total, compensation = 0, 0
    for _, value in ipairs(values) do
        local adjusted = value - compensation
        local nextTotal = total + adjusted
        compensation = (nextTotal - total) - adjusted
        total = nextTotal
    end
    return total
end

local values = {}
for _ = 1, 100000 do values[#values + 1] = 0.1 end

local expected = #values * 0.1
local naive = naiveSum(values)
local compensated = compensatedSum(values)
print("Expected:", expected)
print("Naive sum:", naive)
print("Compensated sum:", compensated)
print("Naive absolute error:", math.abs(expected - naive))
print("Compensated absolute error:", math.abs(expected - compensated))
