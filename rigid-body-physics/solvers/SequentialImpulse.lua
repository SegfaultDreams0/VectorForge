-- rigid-body-physics implementation for SequentialImpulse
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.

local Module = {}
function Module.SolveRows(rows,iterations)
    local impulses=table.create(#rows,0)
    for _=1,(iterations or 40) do
        for i,row in ipairs(rows) do
            local delta=(row.Target-row.Velocity-row.Bias)/row.EffectiveMass
            local nextImpulse=math.max(row.Lower or 0,math.min(row.Upper or math.huge,impulses[i]+delta))
            local change=nextImpulse-impulses[i]; impulses[i]=nextImpulse
            if row.Apply then row.Apply(change) end
        end
    end
    return impulses
end

return Module
