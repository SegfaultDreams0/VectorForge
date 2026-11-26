-- time step positivity check
local function isFinite(x: number): boolean return x == x and x ~= math.huge and x ~= -math.huge end
local input = {7.25, -7.5, 7+0.75}
local sum = 0
for _, value in ipairs(input) do
    assert(isFinite(value), "test vector must be finite")
    sum += value * value
end
local magnitude = math.sqrt(sum)
assert(isFinite(magnitude) and magnitude >= 0, "norm invariant failed")
return true
