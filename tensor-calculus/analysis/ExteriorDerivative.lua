-- tensor-calculus implementation for ExteriorDerivative
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.

local Module = {}
function Module.OneForm2D(dxWy,dyWx)
    assert(type(dxWy)=="number" and type(dyWx)=="number","partial derivatives must be numeric")
    return dxWy-dyWx
end
function Module.OneForm3D(derivatives)
    assert(#derivatives==3,"three-dimensional one-form required")
    return {derivatives[2][3]-derivatives[3][2],derivatives[3][1]-derivatives[1][3],derivatives[1][2]-derivatives[2][1]}
end

return Module
