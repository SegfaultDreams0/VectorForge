-- numerical guards
local Guards = {}
function Guards.IsFinite(x: number): boolean return x == x and x ~= math.huge and x ~= -math.huge end
function Guards.AssertFiniteArray(x: {number}, label: string?)
    for i,v in ipairs(x) do assert(Guards.IsFinite(v), (label or "array") .. " invalid at " .. i) end
end
function Guards.Clamp(x: number, lo: number, hi: number): number
    assert(lo <= hi, "invalid clamp interval")
    return math.max(lo, math.min(hi,x))
end
function Guards.SafeDivide(a: number,b: number,epsilon: number?): number
    assert(math.abs(b) > (epsilon or 1e-12), "division by near-zero")
    return a/b
end
return Guards
