-- optimization-methods implementation for DifferentialEvolution
-- Assumptions: objective and parameter scaling are problem-defined; gradient and Hessian methods assume differentiable objectives where required.

local Module = {}
function Module.Minimize(objective,population,bounds,scaleFactor,crossover,random)
    local n=#population; assert(n>=4,"differential evolution needs at least four candidates"); local dimension=#bounds
    local F=scaleFactor or 0.8; local CR=crossover or 0.9; local nextPopulation={}
    for i=1,n do
        local choices={}; while #choices<3 do local r=math.floor(random:Next()*n)+1; if r~=i and not table.find(choices,r) then table.insert(choices,r) end end
        local a,b,c=population[choices[1]],population[choices[2]],population[choices[3]]
        local forced=math.floor(random:Next()*dimension)+1; local trial=table.clone(population[i])
        for j=1,dimension do if random:Next()<CR or j==forced then trial[j]=a[j]+F*(b[j]-c[j]) end; trial[j]=math.max(bounds[j][1],math.min(bounds[j][2],trial[j])) end
        nextPopulation[i]=if objective(trial)<objective(population[i]) then trial else table.clone(population[i])
    end
    return nextPopulation
end

return Module
