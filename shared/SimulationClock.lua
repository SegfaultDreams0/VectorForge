-- simulation clock
local Clock = {}
Clock.__index = Clock
function Clock.new(step: number)
    assert(step > 0, "fixed step must be positive")
    return setmetatable({Step=step, Time=0, Frame=0, Accumulator=0}, Clock)
end
function Clock:Advance(delta: number, maxSubsteps: number?)
    assert(delta >= 0, "delta must be nonnegative")
    self.Accumulator += delta
    local count, limit = 0, maxSubsteps or 16
    while self.Accumulator >= self.Step and count < limit do
        self.Accumulator -= self.Step
        self.Time += self.Step
        self.Frame += 1
        count += 1
    end
    return count, self.Accumulator
end
return Clock
