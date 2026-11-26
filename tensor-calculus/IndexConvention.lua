-- tensor-calculus implementation for IndexConvention
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.

local Module = {}
function Module.Validate(index,dimension,variance)
    assert(index>=1 and index<=dimension and index%1==0,"tensor index out of range")
    assert(variance=="upper" or variance=="lower","index variance must be upper or lower")
    return {Index=index,Variance=variance}
end
function Module.CanContract(a,b)
    return a.Index~=nil and b.Index~=nil and a.Variance~=b.Variance
end

return Module
