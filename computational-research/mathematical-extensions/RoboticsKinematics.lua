local R = {}

local function identity4()
    return {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    }
end

local function multiply4(a, b)
    local c = {{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0}}
    for i = 1, 4 do
        for k = 1, 4 do
            for j = 1, 4 do c[i][j] = c[i][j] + a[i][k] * b[k][j] end
        end
    end
    return c
end

local function dh(a, alpha, d, theta)
    local ct, st = math.cos(theta), math.sin(theta)
    local ca, sa = math.cos(alpha), math.sin(alpha)
    return {
        {ct, -st * ca, st * sa, a * ct},
        {st, ct * ca, -ct * sa, a * st},
        {0, sa, ca, d},
        {0, 0, 0, 1}
    }
end

local function cross(a, b)
    return {
        a[2] * b[3] - a[3] * b[2],
        a[3] * b[1] - a[1] * b[3],
        a[1] * b[2] - a[2] * b[1]
    }
end

local function sub(a, b)
    return {a[1] - b[1], a[2] - b[2], a[3] - b[3]}
end

local function norm(a)
    return math.sqrt(a[1]^2 + a[2]^2 + a[3]^2)
end

local function transpose(a)
    local t = {}
    for i = 1, #a do
        t[i] = {}
        for j = 1, #a[i] do t[i][j] = a[i][j] end
    end
    return t
end

local function solve(a, b, tolerance)
    local n = #b
    local m = {}
    for i = 1, n do
        m[i] = {}
        for j = 1, n do m[i][j] = a[i][j] end
        m[i][n + 1] = b[i]
    end
    for k = 1, n do
        local pivot, largest = k, math.abs(m[k][k])
        for i = k + 1, n do
            if math.abs(m[i][k]) > largest then pivot, largest = i, math.abs(m[i][k]) end
        end
        if largest <= (tolerance or 1e-12) then return nil end
        m[k], m[pivot] = m[pivot], m[k]
        for i = k + 1, n do
            local factor = m[i][k] / m[k][k]
            for j = k, n + 1 do m[i][j] = m[i][j] - factor * m[k][j] end
        end
    end
    local x = {}
    for i = n, 1, -1 do
        local value = m[i][n + 1]
        for j = i + 1, n do value = value - m[i][j] * x[j] end
        x[i] = value / m[i][i]
    end
    return x
end

function R.forward_kinematics(links, joints)
    assert(#links == #joints, "link and joint counts differ")
    local transform = identity4()
    local frames = {}
    for i = 1, #links do
        local link = links[i]
        local theta = joints[i] + (link.theta_offset or 0)
        transform = multiply4(transform, dh(link.a or 0, link.alpha or 0, link.d or 0, theta))
        frames[i] = transform
    end
    return transform, frames
end

function R.geometric_jacobian(frames)
    local n = #frames
    local jacobian = {{},{},{},{},{},{}}
    local end_position = {frames[n][1][4], frames[n][2][4], frames[n][3][4]}
    for i = 1, n do
        local z = {frames[i][1][3], frames[i][2][3], frames[i][3][3]}
        local origin = {frames[i][1][4], frames[i][2][4], frames[i][3][4]}
        local linear = cross(z, sub(end_position, origin))
        for r = 1, 3 do
            jacobian[r][i] = linear[r]
            jacobian[r + 3][i] = z[r]
        end
    end
    return jacobian
end

function R.damped_least_squares(jacobian, error_vector, damping)
    damping = damping or 1e-3
    local rows, cols = #jacobian, #jacobian[1]
    assert(#error_vector == rows and damping > 0, "invalid inverse-kinematics system")
    local jt = transpose(jacobian)
    local jj = {}
    for i = 1, rows do
        jj[i] = {}
        for j = 1, rows do
            local sum = i == j and damping * damping or 0
            for k = 1, cols do sum = sum + jacobian[i][k] * jacobian[j][k] end
            jj[i][j] = sum
        end
    end
    local y = solve(jj, error_vector)
    if not y then return nil end
    local delta = {}
    for i = 1, cols do
        local sum = 0
        for j = 1, rows do sum = sum + jt[i][j] * y[j] end
        delta[i] = sum
    end
    return delta
end

function R.iterative_ik(links, initial_joints, target, options)
    options = options or {}
    local damping = options.damping or 1e-2
    local tolerance = options.tolerance or 1e-5
    local max_iterations = options.max_iterations or 200
    local step_limit = options.step_limit or 0.2
    local joints = {}
    for i = 1, #initial_joints do joints[i] = initial_joints[i] end

    for iteration = 1, max_iterations do
        local transform, frames = R.forward_kinematics(links, joints)
        local position = {transform[1][4], transform[2][4], transform[3][4]}
        local error_vector = sub(target, position)
        local error_norm = norm(error_vector)
        if error_norm <= tolerance then return joints, true, iteration, error_norm end

        local jacobian = R.geometric_jacobian(frames)
        local linear_jacobian = {jacobian[1], jacobian[2], jacobian[3]}
        local delta = R.damped_least_squares(linear_jacobian, error_vector, damping)
        if not delta then return joints, false, iteration, error_norm end

        for i = 1, #joints do
            local change = math.max(-step_limit, math.min(step_limit, delta[i]))
            joints[i] = joints[i] + change
        end
    end

    local transform = R.forward_kinematics(links, joints)
    local position = {transform[1][4], transform[2][4], transform[3][4]}
    local error_norm = norm(sub(target, position))
    return joints, false, max_iterations, error_norm
end

return R
