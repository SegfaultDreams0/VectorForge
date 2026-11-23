local S = {}

local Complex = {}
Complex.__index = Complex

function Complex.new(re, im)
    return setmetatable({re = re or 0, im = im or 0}, Complex)
end

local function parts(z)
    if getmetatable(z) == Complex then return z.re, z.im end
    assert(type(z) == "number", "expected complex number or scalar")
    return z, 0
end

function Complex.__add(a, b)
    local ar, ai = parts(a)
    local br, bi = parts(b)
    return Complex.new(ar + br, ai + bi)
end

function Complex.__sub(a, b)
    local ar, ai = parts(a)
    local br, bi = parts(b)
    return Complex.new(ar - br, ai - bi)
end

function Complex.__mul(a, b)
    local ar, ai = parts(a)
    local br, bi = parts(b)
    return Complex.new(ar * br - ai * bi, ar * bi + ai * br)
end

function Complex.__div(a, b)
    local ar, ai = parts(a)
    local br, bi = parts(b)
    local denominator = br * br + bi * bi
    assert(denominator > 1e-28, "complex division by zero")
    return Complex.new((ar * br + ai * bi) / denominator, (ai * br - ar * bi) / denominator)
end

function Complex:abs()
    return math.sqrt(self.re * self.re + self.im * self.im)
end

function Complex:conjugate()
    return Complex.new(self.re, -self.im)
end

function S.fft(input, inverse)
    local n = #input
    assert(n > 0 and n % 1 == 0 and (n & (n - 1)) == 0, "fft length must be a power of two")
    local a = {}
    for i = 1, n do
        local z = input[i]
        if getmetatable(z) ~= Complex then z = Complex.new(z, 0) end
        a[i] = Complex.new(z.re, z.im)
    end

    local j = 0
    for i = 0, n - 1 do
        if i < j then a[i + 1], a[j + 1] = a[j + 1], a[i + 1] end
        local bit = n // 2
        while bit > 0 and j >= bit do
            j = j - bit
            bit = bit // 2
        end
        j = j + bit
    end

    local length = 2
    while length <= n do
        local angle = (inverse and 2 or -2) * math.pi / length
        local root = Complex.new(math.cos(angle), math.sin(angle))
        local half = length // 2
        for start = 1, n, length do
            local w = Complex.new(1, 0)
            for k = 0, half - 1 do
                local u = a[start + k]
                local v = a[start + k + half] * w
                a[start + k] = u + v
                a[start + k + half] = u - v
                w = w * root
            end
        end
        length = length * 2
    end

    if inverse then
        for i = 1, n do a[i] = a[i] / n end
    end
    return a
end

function S.spectral_energy(spectrum)
    local total = 0
    for i = 1, #spectrum do
        local z = spectrum[i]
        if getmetatable(z) ~= Complex then z = Complex.new(z, 0) end
        total = total + z:abs() ^ 2
    end
    return total / #spectrum
end

function S.newton_cotes_weights(degree)
    assert(degree >= 1 and degree <= 12 and degree % 1 == 0, "degree must be between 1 and 12")
    local n = degree
    local matrix, rhs = {}, {}
    for k = 0, n do
        matrix[k + 1] = {}
        for j = 0, n do matrix[k + 1][j + 1] = j ^ k end
        rhs[k + 1] = n ^ (k + 1) / (k + 1)
    end

    for k = 1, n + 1 do
        local pivot = k
        for i = k + 1, n + 1 do
            if math.abs(matrix[i][k]) > math.abs(matrix[pivot][k]) then pivot = i end
        end
        assert(math.abs(matrix[pivot][k]) > 1e-14, "singular moment system")
        matrix[k], matrix[pivot] = matrix[pivot], matrix[k]
        rhs[k], rhs[pivot] = rhs[pivot], rhs[k]
        local divisor = matrix[k][k]
        for j = k, n + 1 do matrix[k][j] = matrix[k][j] / divisor end
        rhs[k] = rhs[k] / divisor
        for i = 1, n + 1 do
            if i ~= k then
                local factor = matrix[i][k]
                for j = k, n + 1 do matrix[i][j] = matrix[i][j] - factor * matrix[k][j] end
                rhs[i] = rhs[i] - factor * rhs[k]
            end
        end
    end
    return rhs
end

S.Complex = Complex

return S
