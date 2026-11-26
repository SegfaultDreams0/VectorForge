-- electromagnetics implementation for LaplaceElectrostatics
-- Units: SI (m, s, kg, A, V, T); vacuum constants come from shared/Constants.lua unless material parameters are explicitly supplied.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.Jacobi2D(potential,boundaryIterations,tolerance)
    local current=LA.Copy(potential); local rows=#current; local cols=#current[1]; local maxChange=math.huge
    for iteration=1,boundaryIterations do
        local nextField=LA.Copy(current); maxChange=0
        for i=2,rows-1 do for j=2,cols-1 do
            nextField[i][j]=0.25*(current[i+1][j]+current[i-1][j]+current[i][j+1]+current[i][j-1])
            maxChange=math.max(maxChange,math.abs(nextField[i][j]-current[i][j]))
        end end
        current=nextField; if maxChange<=(tolerance or 1e-8) then return current,{Converged=true,Iterations=iteration,Residual=maxChange} end
    end
    return current,{Converged=false,Iterations=boundaryIterations,Residual=maxChange}
end

return Module
