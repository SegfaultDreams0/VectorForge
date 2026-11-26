-- differential-equations implementation for BoundaryConditionSet
-- Assumptions: state components retain caller-defined physical units; integration routines require consistent time units, valid initial data, and method-appropriate step sizes.

local Module = {}
function Module.AddDirichlet(set,index,value)
    assert(index>=1 and index%1==0,"boundary index must be positive integer"); set.Dirichlet=set.Dirichlet or {}; set.Dirichlet[index]=value; return set
end
function Module.AddNeumann(set,index,flux)
    assert(index>=1 and index%1==0,"boundary index must be positive integer"); set.Neumann=set.Neumann or {}; set.Neumann[index]=flux; return set
end

return Module
