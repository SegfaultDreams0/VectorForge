-- quantum-mechanics implementation for PauliMatrices
-- Assumptions: non-relativistic single-particle equations unless named otherwise; SI units are used for mass, length, time, and energy; wavefunction normalization follows the supplied grid convention.

local Module = {}
function Module.All()
    return {
        SigmaX={Re={{0,1},{1,0}},Im={{0,0},{0,0}}},
        SigmaY={Re={{0,0},{0,0}},Im={{0,-1},{1,0}}},
        SigmaZ={Re={{1,0},{0,-1}},Im={{0,0},{0,0}}},
    }
end

return Module
