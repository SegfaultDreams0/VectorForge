local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local Constants = require(Shared:WaitForChild("Constants"))
-- quantum-mechanics implementation for DensityMatrix
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.
local Num = require(Shared:WaitForChild("NumericalKernels"))

local Module = {}
function Module.PureState(psi)
    local norm2=0; for _,z in ipairs(psi) do norm2+=Num.ComplexAbs2(z) end
    Num.Positive(norm2,"wavefunction norm")
    local rho=table.create(#psi)
    for i=1,#psi do
        rho[i]=table.create(#psi)
        for j=1,#psi do
            local product=Num.ComplexMul(psi[i],{Re=psi[j].Re,Im=-psi[j].Im})
            rho[i][j]={Re=product.Re/norm2,Im=product.Im/norm2}
        end
    end
    return rho
end


-- Purity Tr(rho^2), equal to one for pure states and below one for mixed states.
function Module.Purity(rho)
    local n = #rho
    assert(n > 0 and n == #rho[1], "density matrix must be square")
    local traceReal,traceImaginary=0,0
    for i=1,n do
        for j=1,n do
            local left,right=rho[i][j],rho[j][i]
            local product=Num.ComplexMul(left,right)
            traceReal+=product.Re
            traceImaginary+=product.Im
        end
    end
    assert(math.abs(traceImaginary)<=1e-9,"density purity has a non-negligible imaginary part")
    return traceReal
end

-- Hermiticity residual ||rho-rho^dagger||_F for complex density matrices.
function Module.HermiticityResidual(rho)
    assert(#rho > 0 and #rho == #rho[1], "density matrix must be square")
    local sum=0
    for i=1,#rho do for j=1,#rho do
        local differenceRe=rho[i][j].Re-rho[j][i].Re
        local differenceIm=rho[i][j].Im+rho[j][i].Im
        sum+=differenceRe*differenceRe+differenceIm*differenceIm
    end end
    return math.sqrt(sum)
end

-- Von Neumann entropy for a supplied nonnegative eigenvalue spectrum.
function Module.EntropyFromEigenvalues(eigenvalues, boltzmannConstant)
    local kB = boltzmannConstant or Constants.K_B
    Num.Positive(kB, "Boltzmann constant")
    local sum, probabilitySum = 0, 0
    for _, probability in ipairs(eigenvalues) do
        assert(probability >= -1e-12 and probability <= 1 + 1e-12, "density eigenvalues must lie in [0,1]")
        probabilitySum += probability
        if probability > 0 then sum -= kB * probability * math.log(probability) end
    end
    assert(math.abs(probabilitySum - 1) <= 1e-8, "density eigenvalues must sum to one")
    return sum
end

return Module
