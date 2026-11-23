local V = {}

local function check(a)
    assert(type(a) == "table" and #a > 0, "expected a non-empty vector")
    for i = 1, #a do
        assert(type(a[i]) == "number" and a[i] == a[i] and a[i] ~= math.huge and a[i] ~= -math.huge, "invalid vector component")
    end
end

local function same(a, b)
    check(a)
    check(b)
    assert(#a == #b, "vector dimensions differ")
end

function V.new(...)
    local values = {...}
    check(values)
    return values
end

function V.add(a, b)
    same(a, b)
    local r = {}
    for i = 1, #a do r[i] = a[i] + b[i] end
    return r
end

function V.sub(a, b)
    same(a, b)
    local r = {}
    for i = 1, #a do r[i] = a[i] - b[i] end
    return r
end

function V.scale(a, s)
    check(a)
    assert(type(s) == "number", "expected numeric scale")
    local r = {}
    for i = 1, #a do r[i] = a[i] * s end
    return r
end

function V.dot(a, b)
    same(a, b)
    local sum, correction = 0, 0
    for i = 1, #a do
        local term = a[i] * b[i] - correction
        local next_sum = sum + term
        correction = (next_sum - sum) - term
        sum = next_sum
    end
    return sum
end

function V.norm(a)
    check(a)
    local scale, sum = 0, 1
    for i = 1, #a do
        local x = math.abs(a[i])
        if x ~= 0 then
            if scale < x then
                sum = 1 + sum * (scale / x) ^ 2
                scale = x
            else
                sum = sum + (x / scale) ^ 2
            end
        end
    end
    return scale == 0 and 0 or scale * math.sqrt(sum)
end

function V.normalize(a, tolerance)
    local n = V.norm(a)
    assert(n > (tolerance or 1e-14), "cannot normalize a zero vector")
    return V.scale(a, 1 / n)
end

function V.cross(a, b)
    assert(#a == 3 and #b == 3, "cross product requires three dimensions")
    return {
        a[2] * b[3] - a[3] * b[2],
        a[3] * b[1] - a[1] * b[3],
        a[1] * b[2] - a[2] * b[1]
    }
end

function V.project(a, b)
    same(a, b)
    local denominator = V.dot(b, b)
    assert(denominator > 1e-28, "projection direction is degenerate")
    return V.scale(b, V.dot(a, b) / denominator)
end

function V.reject(a, b)
    return V.sub(a, V.project(a, b))
end

function V.angle(a, b)
    same(a, b)
    local denominator = V.norm(a) * V.norm(b)
    assert(denominator > 1e-14, "angle is undefined for a zero vector")
    local c = V.dot(a, b) / denominator
    return math.acos(math.max(-1, math.min(1, c)))
end

function V.reflect(direction, normal)
    same(direction, normal)
    local n = V.normalize(normal)
    return V.sub(direction, V.scale(n, 2 * V.dot(direction, n)))
end

function V.gram_schmidt(columns, tolerance)
    tolerance = tolerance or 1e-12
    local basis = {}
    for i = 1, #columns do
        local u = V.new(table.unpack(columns[i]))
        for j = 1, #basis do
            u = V.sub(u, V.scale(basis[j], V.dot(u, basis[j])))
        end
        local n = V.norm(u)
        if n > tolerance then
            basis[#basis + 1] = V.scale(u, 1 / n)
        end
    end
    return basis
end

function V.lerp(a, b, t)
    same(a, b)
    local r = {}
    for i = 1, #a do r[i] = a[i] + t * (b[i] - a[i]) end
    return r
end

function V.distance(a, b)
    return V.norm(V.sub(a, b))
end

function V.triple(a, b, c)
    return V.dot(a, V.cross(b, c))
end

return V
