-- optimization-methods implementation for GeneticOptimizer
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.

local Module = {}
function Module.Tournament(population,fitness,tournamentSize,random)
    assert(tournamentSize>=1 and tournamentSize<=#population,"invalid tournament size")
    local best=nil; local bestValue=math.huge
    for _=1,tournamentSize do local index=math.floor(random:Next()*#population)+1; local value=fitness(population[index]); if value<bestValue then best=population[index]; bestValue=value end end
    return table.clone(best),bestValue
end
function Module.UniformCrossover(parentA,parentB,random)
    assert(#parentA==#parentB,"parent dimensions mismatch"); local child=table.create(#parentA)
    for i=1,#child do child[i]=if random:Next()<0.5 then parentA[i] else parentB[i] end
    return child
end

return Module
