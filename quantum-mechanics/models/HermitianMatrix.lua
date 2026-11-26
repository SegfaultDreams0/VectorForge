-- quantum-mechanics implementation for HermitianMatrix
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.

local Module = {}
function Module.IsHermitian(realPart,imagPart,tolerance)
    local tol=tolerance or 1e-10
    if #realPart~=#realPart[1] or #imagPart~=#realPart then return false end
    for i=1,#realPart do for j=1,#realPart do
        if math.abs(realPart[i][j]-realPart[j][i])>tol then return false end
        if math.abs(imagPart[i][j]+imagPart[j][i])>tol then return false end
    end end
    return true
end

return Module
