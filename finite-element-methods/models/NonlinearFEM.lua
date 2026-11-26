-- finite-element-methods implementation for NonlinearFEM
-- Units: SI for geometry, stress, modulus, density, and loads; linear element routines use the small-displacement and constitutive assumptions named by each element.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Num = require(Shared:WaitForChild("NumericalKernels"))
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local Module = {}
function Module.NewtonSolve(initial,residual,tangent,maxIterations,tolerance)
    local x=table.clone(initial); local tol=tolerance or 1e-9
    for iteration=1,(maxIterations or 30) do
        local r=residual(x); local norm=LA.Norm(r)
        if norm<=tol then return x,{Converged=true,Iterations=iteration-1,Residual=norm} end
        local Kt=tangent(x); local dx,reason=LA.Solve(Kt,Num.Scale(r,-1)); assert(dx,reason or "tangent solve failed")
        x=Num.Add(x,dx)
    end
    local finalNorm=LA.Norm(residual(x)); return x,{Converged=finalNorm<=tol,Iterations=maxIterations or 30,Residual=finalNorm}
end

return Module
