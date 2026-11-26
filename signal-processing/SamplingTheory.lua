-- sampling theory
local M = {}
function M.NyquistFrequency(sampleRate)
    assert(sampleRate > 0, "sample rate must be positive")
    return sampleRate/2
end
function M.IsUnaliased(signalFrequency,sampleRate)
    return math.abs(signalFrequency) < M.NyquistFrequency(sampleRate)
end
function M.AngularFrequency(frequency)
    return 2*math.pi*frequency
end
return M
