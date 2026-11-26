-- tensor-calculus implementation for LeviCivitaSymbol
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.

local Module = {}
function Module.Value(indices)
    local seen={}; local inversions=0
    for i=1,#indices do if seen[indices[i]] then return 0 end; seen[indices[i]]=true end
    for i=1,#indices do for j=i+1,#indices do if indices[i]>indices[j] then inversions+=1 end end end
    return inversions%2==0 and 1 or -1
end

return Module
