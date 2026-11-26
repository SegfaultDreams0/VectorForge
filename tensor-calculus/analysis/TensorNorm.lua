-- tensor-calculus implementation for TensorNorm
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.

local Module = {}
function Module.Frobenius(data)
    local total=0
    local function accumulate(value)
        if type(value)=="number" then total+=value*value else for _,entry in ipairs(value) do accumulate(entry) end end
    end
    accumulate(data)
    return math.sqrt(total)
end


-- Squared Frobenius norm avoids a square root in optimization objectives.
function Module.FrobeniusSquared(data)
    local function accumulate(value)
        if type(value) == "number" then return value * value end
        local subtotal = 0
        for _, entry in ipairs(value) do subtotal += accumulate(entry) end
        return subtotal
    end
    return accumulate(data)
end

-- General p-norm over every scalar component of a nested tensor.
function Module.EntryPNorm(data, p)
    assert(type(p) == "number" and p >= 1, "tensor p-norm requires p >= 1")
    local total = 0
    local function accumulate(value)
        if type(value) == "number" then total += math.abs(value) ^ p else
            for _, entry in ipairs(value) do accumulate(entry) end
        end
    end
    accumulate(data)
    return total ^ (1 / p)
end

return Module
