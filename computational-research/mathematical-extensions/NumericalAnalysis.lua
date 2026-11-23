local N = {}

local function finite(x)
    return type(x) == "number" and x == x and x ~= math.huge and x ~= -math.huge
end

function N.derivative(f, x, h)
    h = h or 1e-5 * math.max(1, math.abs(x))
    assert(h > 0, "step must be positive")
    return (f(x - 2 * h) - 8 * f(x - h) + 8 * f(x + h) - f(x + 2 * h)) / (12 * h)
end

function N.second_derivative(f, x, h)
    h = h or 1e-4 * math.max(1, math.abs(x))
    assert(h > 0, "step must be positive")
    return (f(x + h) - 2 * f(x) + f(x - h)) / (h * h)
end

function N.richardson(f, x, h, levels)
    levels = levels or 5
    assert(h > 0 and levels >= 1, "invalid extrapolation parameters")
    local tableau = {}
    for i = 1, levels do
        local step = h / 2 ^ (i - 1)
        tableau[i] = {(f(x + step) - f(x - step)) / (2 * step)}
        for j = 2, i do
            local factor = 4 ^ (j - 1)
            tableau[i][j] = tableau[i][j - 1] +
                (tableau[i][j - 1] - tableau[i - 1][j - 1]) / (factor - 1)
        end
    end
    return tableau[levels][levels], tableau
end

function N.adaptive_simpson(f, a, b, tolerance, max_depth)
    tolerance = tolerance or 1e-9
    max_depth = max_depth or 24
    assert(tolerance > 0 and max_depth >= 0, "invalid integration settings")
    if a == b then return 0, 0 end
    if b < a then
        local value, error_estimate = N.adaptive_simpson(f, b, a, tolerance, max_depth)
        return -value, error_estimate
    end

    local function simpson(x0, x1, f0, fm, f1)
        return (x1 - x0) * (f0 + 4 * fm + f1) / 6
    end

    local function recurse(x0, x1, f0, fm, f1, whole, tol, depth)
        local mid = (x0 + x1) / 2
        local left_mid, right_mid = (x0 + mid) / 2, (mid + x1) / 2
        local flm, frm = f(left_mid), f(right_mid)
        local left = simpson(x0, mid, f0, flm, fm)
        local right = simpson(mid, x1, fm, frm, f1)
        local delta = left + right - whole
        if depth == 0 or math.abs(delta) <= 15 * tol then
            return left + right + delta / 15, math.abs(delta) / 15
        end
        local lv, le = recurse(x0, mid, f0, flm, fm, left, tol / 2, depth - 1)
        local rv, re = recurse(mid, x1, fm, frm, f1, right, tol / 2, depth - 1)
        return lv + rv, le + re
    end

    local mid = (a + b) / 2
    local fa, fm, fb = f(a), f(mid), f(b)
    return recurse(a, b, fa, fm, fb, simpson(a, b, fa, fm, fb), tolerance, max_depth)
end

function N.gauss_legendre_8(f, a, b)
    local nodes = {
        -0.9602898564975363, -0.7966664774136267,
        -0.5255324099163290, -0.1834346424956498,
         0.1834346424956498,  0.5255324099163290,
         0.7966664774136267,  0.9602898564975363
    }
    local weights = {
        0.1012285362903763, 0.2223810344533745,
        0.3137066458778873, 0.3626837833783620,
        0.3626837833783620, 0.3137066458778873,
        0.2223810344533745, 0.1012285362903763
    }
    local center, half = (a + b) / 2, (b - a) / 2
    local sum = 0
    for i = 1, 8 do sum = sum + weights[i] * f(center + half * nodes[i]) end
    return half * sum
end

function N.bisection(f, a, b, tolerance, iterations)
    tolerance, iterations = tolerance or 1e-12, iterations or 160
    local fa, fb = f(a), f(b)
    assert(fa == 0 or fb == 0 or fa * fb < 0, "root is not bracketed")
    if fa == 0 then return a, true, 0 end
    if fb == 0 then return b, true, 0 end
    for i = 1, iterations do
        local mid = (a + b) / 2
        local fm = f(mid)
        if math.abs(fm) <= tolerance or math.abs(b - a) <= tolerance then
            return mid, true, i
        end
        if fa * fm < 0 then b, fb = mid, fm else a, fa = mid, fm end
    end
    return (a + b) / 2, false, iterations
end

function N.newton(f, df, x, tolerance, iterations)
    tolerance, iterations = tolerance or 1e-12, iterations or 80
    for i = 1, iterations do
        local fx = f(x)
        if math.abs(fx) <= tolerance then return x, true, i end
        local dfx = df(x)
        assert(math.abs(dfx) > 1e-14, "newton iteration encountered a singular derivative")
        local next_x = x - fx / dfx
        if not finite(next_x) then return x, false, i end
        if math.abs(next_x - x) <= tolerance then
            return next_x, math.abs(f(next_x)) <= tolerance * 10, i
        end
        x = next_x
    end
    return x, false, iterations
end

function N.secant(f, x0, x1, tolerance, iterations)
    tolerance, iterations = tolerance or 1e-12, iterations or 100
    local f0, f1 = f(x0), f(x1)
    for i = 1, iterations do
        local denominator = f1 - f0
        if math.abs(denominator) <= 1e-15 then return x1, false, i end
        local x2 = x1 - f1 * (x1 - x0) / denominator
        if not finite(x2) then return x1, false, i end
        if math.abs(x2 - x1) <= tolerance or math.abs(f(x2)) <= tolerance then
            return x2, true, i
        end
        x0, x1, f0, f1 = x1, x2, f1, f(x2)
    end
    return x1, false, iterations
end

function N.rk4(f, t, y, h)
    local k1 = f(t, y)
    local k2 = f(t + h / 2, y + h * k1 / 2)
    local k3 = f(t + h / 2, y + h * k2 / 2)
    local k4 = f(t + h, y + h * k3)
    return y + h * (k1 + 2 * k2 + 2 * k3 + k4) / 6
end

function N.solve_rk4(f, t0, y0, h, count)
    assert(count >= 1 and count % 1 == 0, "count must be a positive integer")
    local result, t, y = {{t = t0, y = y0}}, t0, y0
    for i = 1, count do
        y = N.rk4(f, t, y, h)
        t = t + h
        result[i + 1] = {t = t, y = y}
    end
    return result
end

return N
