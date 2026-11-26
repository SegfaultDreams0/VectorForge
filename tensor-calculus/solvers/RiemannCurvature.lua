-- tensor-calculus implementation for RiemannCurvature
-- Assumptions: tensor indices use the documented upper/lower convention; metric-based routines require a symmetric non-singular metric; coordinate units are caller-defined.

local Module = {}
function Module.FromConnection(gamma,partialGamma)
    local n=#gamma; local R=table.create(n)
    for a=1,n do
        R[a]=table.create(n)
        for b=1,n do
            R[a][b]=table.create(n)
            for c=1,n do
                R[a][b][c]=table.create(n)
                for d=1,n do
                    local value=partialGamma[c][a][d][b]-partialGamma[d][a][c][b]
                    for m=1,n do value+=gamma[a][c][m]*gamma[m][d][b]-gamma[a][d][m]*gamma[m][c][b] end
                    R[a][b][c][d]=value
                end
            end
        end
    end
    return R
end


-- Lower the first Riemann index with g_ia: R_abcd = g_ae R^e_bcd.
function Module.LowerFirstIndex(curvature, metric)
    local n = #curvature
    assert(#metric == n, "curvature and metric dimensions mismatch")
    local lowered = table.create(n)
    for a = 1, n do
        lowered[a] = table.create(n)
        for b = 1, n do
            lowered[a][b] = table.create(n)
            for c = 1, n do
                lowered[a][b][c] = table.create(n, 0)
                for d = 1, n do
                    for e = 1, n do lowered[a][b][c][d] += metric[a][e] * curvature[e][b][c][d] end
                end
            end
        end
    end
    return lowered
end

-- First Bianchi identity residual: R_abcd + R_acdb + R_adbc = 0 after lowering.
function Module.FirstBianchiResidual(lowered)
    local n = #lowered
    local maximum = 0
    for a = 1, n do for b = 1, n do for c = 1, n do for d = 1, n do
        local residual = lowered[a][b][c][d] + lowered[a][c][d][b] + lowered[a][d][b][c]
        maximum = math.max(maximum, math.abs(residual))
    end end end end
    return maximum
end

-- Kretschmann scalar K = R_abcd R^abcd for a positive-definite metric.
function Module.KretschmannScalar(lowered, inverseMetric)
    local n = #lowered
    assert(#inverseMetric == n, "inverse metric dimension mismatch")
    local raised = table.create(n)
    for a = 1, n do
        raised[a] = table.create(n)
        for b = 1, n do
            raised[a][b] = table.create(n)
            for c = 1, n do
                raised[a][b][c] = table.create(n, 0)
                for d = 1, n do
                    for e = 1, n do for f = 1, n do for g = 1, n do for h = 1, n do
                        raised[a][b][c][d] += inverseMetric[a][e] * inverseMetric[b][f] * inverseMetric[c][g] * inverseMetric[d][h] * lowered[e][f][g][h]
                    end end end end
                end
            end
        end
    end
    local scalar = 0
    for a = 1, n do for b = 1, n do for c = 1, n do for d = 1, n do
        scalar += lowered[a][b][c][d] * raised[a][b][c][d]
    end end end end
    return scalar
end

return Module
