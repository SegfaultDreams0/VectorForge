local TrajectoryPlanning = {}

local QuinticTrajectory = {}
QuinticTrajectory.__index = QuinticTrajectory
local TrapezoidalProfile = {}
TrapezoidalProfile.__index = TrapezoidalProfile
local SCurveProfile = {}
SCurveProfile.__index = SCurveProfile

local function IsFinite(Value)
    return type(Value) == "number" and Value == Value and math.abs(Value) < math.huge
end

local function Clamp(Value, Minimum, Maximum)
    return math.max(Minimum, math.min(Maximum, Value))
end

local function NewQuintic(StartPosition, StartVelocity, StartAcceleration, EndPosition, EndVelocity, EndAcceleration, Duration)
    assert(type(Duration) == "number" and Duration > 0 and IsFinite(Duration), "Duration must be positive and finite")
    local A0 = StartPosition
    local A1 = StartVelocity or 0
    local A2 = (StartAcceleration or 0) * 0.5
    local T = Duration
    local T2 = T * T
    local T3 = T2 * T
    local T4 = T3 * T
    local T5 = T4 * T
    local PositionResidual = EndPosition - (A0 + A1 * T + A2 * T2)
    local VelocityResidual = (EndVelocity or 0) - (A1 + 2 * A2 * T)
    local AccelerationResidual = (EndAcceleration or 0) - 2 * A2
    local A3 = (10 * PositionResidual - 4 * VelocityResidual * T + 0.5 * AccelerationResidual * T2) / T3
    local A4 = (-15 * PositionResidual + 7 * VelocityResidual * T - AccelerationResidual * T2) / T4
    local A5 = (6 * PositionResidual - 3 * VelocityResidual * T + 0.5 * AccelerationResidual * T2) / T5
    return setmetatable({Duration = Duration, Coefficients = {A0, A1, A2, A3, A4, A5}}, QuinticTrajectory)
end

function QuinticTrajectory:Evaluate(Time)
    local T = Clamp(Time, 0, self.Duration)
    local A = self.Coefficients
    local Position = A[1] + A[2] * T + A[3] * T ^ 2 + A[4] * T ^ 3 + A[5] * T ^ 4 + A[6] * T ^ 5
    local Velocity = A[2] + 2 * A[3] * T + 3 * A[4] * T ^ 2 + 4 * A[5] * T ^ 3 + 5 * A[6] * T ^ 4
    local Acceleration = 2 * A[3] + 6 * A[4] * T + 12 * A[5] * T ^ 2 + 20 * A[6] * T ^ 3
    local Jerk = 6 * A[4] + 24 * A[5] * T + 60 * A[6] * T ^ 2
    return Position, Velocity, Acceleration, Jerk
end

function QuinticTrajectory:Sample(SampleCount)
    local Count = math.max(2, math.floor(SampleCount or 32))
    local Result = table.create(Count)
    for Index = 1, Count do
        local Time = self.Duration * (Index - 1) / (Count - 1)
        local Position, Velocity, Acceleration, Jerk = self:Evaluate(Time)
        Result[Index] = {Time = Time, Position = Position, Velocity = Velocity, Acceleration = Acceleration, Jerk = Jerk}
    end
    return Result
end

local function MinimumJerk(Start, Goal, Duration, Time)
    local Trajectory = NewQuintic(Start, 0, 0, Goal, 0, 0, Duration)
    return Trajectory:Evaluate(Time)
end

local function NewTrapezoidal(Distance, MaximumVelocity, MaximumAcceleration)
    assert(IsFinite(Distance) and Distance ~= 0, "Distance must be finite and nonzero")
    assert(IsFinite(MaximumVelocity) and MaximumVelocity > 0, "MaximumVelocity must be positive")
    assert(IsFinite(MaximumAcceleration) and MaximumAcceleration > 0, "MaximumAcceleration must be positive")
    local Direction = Distance >= 0 and 1 or -1
    local Length = math.abs(Distance)
    local AccelerationTime = MaximumVelocity / MaximumAcceleration
    local AccelerationDistance = 0.5 * MaximumAcceleration * AccelerationTime * AccelerationTime
    local CruiseTime
    local PeakVelocity
    if 2 * AccelerationDistance >= Length then
        AccelerationTime = math.sqrt(Length / MaximumAcceleration)
        PeakVelocity = MaximumAcceleration * AccelerationTime
        CruiseTime = 0
    else
        PeakVelocity = MaximumVelocity
        CruiseTime = (Length - 2 * AccelerationDistance) / PeakVelocity
    end
    local TotalTime = 2 * AccelerationTime + CruiseTime
    return setmetatable({
        Distance = Distance,
        Direction = Direction,
        MaximumAcceleration = MaximumAcceleration,
        PeakVelocity = PeakVelocity,
        AccelerationTime = AccelerationTime,
        CruiseTime = CruiseTime,
        TotalTime = TotalTime,
        AccelerationDistance = 0.5 * MaximumAcceleration * AccelerationTime ^ 2,
    }, TrapezoidalProfile)
end

function TrapezoidalProfile:Evaluate(Time)
    local T = Clamp(Time, 0, self.TotalTime)
    local A = self.MaximumAcceleration
    local Ta = self.AccelerationTime
    local Tc = self.CruiseTime
    local V = self.PeakVelocity
    local Position
    local Velocity
    local Acceleration
    if T <= Ta then
        Position = 0.5 * A * T * T
        Velocity = A * T
        Acceleration = A
    elseif T <= Ta + Tc then
        Position = self.AccelerationDistance + V * (T - Ta)
        Velocity = V
        Acceleration = 0
    else
        local Remaining = self.TotalTime - T
        Position = math.abs(self.Distance) - 0.5 * A * Remaining * Remaining
        Velocity = A * Remaining
        Acceleration = -A
    end
    if T >= self.TotalTime then
        Position = math.abs(self.Distance)
        Velocity = 0
        Acceleration = 0
    end
    return self.Direction * Position, self.Direction * Velocity, self.Direction * Acceleration
end

local function AccelerationTimeForPeak(PeakVelocity, MaximumAcceleration, MaximumJerk)
    local TransitionVelocity = MaximumAcceleration * MaximumAcceleration / MaximumJerk
    if PeakVelocity <= TransitionVelocity then
        local JerkTime = math.sqrt(PeakVelocity / MaximumJerk)
        return JerkTime, 0
    end
    local JerkTime = MaximumAcceleration / MaximumJerk
    local ConstantAccelerationTime = PeakVelocity / MaximumAcceleration - JerkTime
    return JerkTime, ConstantAccelerationTime
end

local function NewSCurve(Distance, MaximumVelocity, MaximumAcceleration, MaximumJerk)
    assert(IsFinite(Distance) and Distance ~= 0, "Distance must be finite and nonzero")
    assert(IsFinite(MaximumVelocity) and MaximumVelocity > 0, "MaximumVelocity must be positive")
    assert(IsFinite(MaximumAcceleration) and MaximumAcceleration > 0, "MaximumAcceleration must be positive")
    assert(IsFinite(MaximumJerk) and MaximumJerk > 0, "MaximumJerk must be positive")
    local Length = math.abs(Distance)
    local Direction = Distance >= 0 and 1 or -1
    local function DistanceWithoutCruise(Peak)
        local JerkTime, ConstantTime = AccelerationTimeForPeak(Peak, MaximumAcceleration, MaximumJerk)
        local AccelerationDuration = 2 * JerkTime + ConstantTime
        return Peak * AccelerationDuration
    end
    local PeakVelocity = MaximumVelocity
    local CruiseTime = 0
    if DistanceWithoutCruise(MaximumVelocity) > Length then
        local Low = 0
        local High = MaximumVelocity
        for _ = 1, 64 do
            local Middle = 0.5 * (Low + High)
            if DistanceWithoutCruise(Middle) > Length then
                High = Middle
            else
                Low = Middle
            end
        end
        PeakVelocity = 0.5 * (Low + High)
    else
        CruiseTime = (Length - DistanceWithoutCruise(MaximumVelocity)) / MaximumVelocity
    end
    local JerkTime, ConstantAccelerationTime = AccelerationTimeForPeak(PeakVelocity, MaximumAcceleration, MaximumJerk)
    local Durations = {JerkTime, ConstantAccelerationTime, JerkTime, CruiseTime, JerkTime, ConstantAccelerationTime, JerkTime}
    local Jerks = {MaximumJerk, 0, -MaximumJerk, 0, -MaximumJerk, 0, MaximumJerk}
    local Phases = table.create(7)
    local Position, Velocity, Acceleration, CurrentTime = 0, 0, 0, 0
    for Index = 1, 7 do
        local Duration = Durations[Index]
        local Jerk = Jerks[Index]
        Phases[Index] = {StartTime = CurrentTime, Duration = Duration, Position = Position, Velocity = Velocity, Acceleration = Acceleration, Jerk = Jerk}
        Position = Position + Velocity * Duration + 0.5 * Acceleration * Duration ^ 2 + Jerk * Duration ^ 3 / 6
        Velocity = Velocity + Acceleration * Duration + 0.5 * Jerk * Duration ^ 2
        Acceleration = Acceleration + Jerk * Duration
        CurrentTime += Duration
    end
    return setmetatable({
        Distance = Distance,
        Direction = Direction,
        TotalTime = CurrentTime,
        PeakVelocity = PeakVelocity,
        Phases = Phases,
        MaximumVelocity = MaximumVelocity,
        MaximumAcceleration = MaximumAcceleration,
        MaximumJerk = MaximumJerk,
    }, SCurveProfile)
end

function SCurveProfile:Evaluate(Time)
    local T = Clamp(Time, 0, self.TotalTime)
    local Phase = self.Phases[#self.Phases]
    for _, Candidate in ipairs(self.Phases) do
        if T <= Candidate.StartTime + Candidate.Duration then
            Phase = Candidate
            break
        end
    end
    local LocalTime = Clamp(T - Phase.StartTime, 0, Phase.Duration)
    local Jerk = Phase.Jerk
    local Position = Phase.Position + Phase.Velocity * LocalTime + 0.5 * Phase.Acceleration * LocalTime ^ 2 + Jerk * LocalTime ^ 3 / 6
    local Velocity = Phase.Velocity + Phase.Acceleration * LocalTime + 0.5 * Jerk * LocalTime ^ 2
    local Acceleration = Phase.Acceleration + Jerk * LocalTime
    if T >= self.TotalTime then
        Position = math.abs(self.Distance)
        Velocity = 0
        Acceleration = 0
        Jerk = 0
    end
    return self.Direction * Position, self.Direction * Velocity, self.Direction * Acceleration, self.Direction * Jerk
end

function SCurveProfile:Sample(SampleCount)
    local Count = math.max(2, math.floor(SampleCount or 64))
    local Result = table.create(Count)
    for Index = 1, Count do
        local Time = self.TotalTime * (Index - 1) / (Count - 1)
        local Position, Velocity, Acceleration, Jerk = self:Evaluate(Time)
        Result[Index] = {Time = Time, Position = Position, Velocity = Velocity, Acceleration = Acceleration, Jerk = Jerk}
    end
    return Result
end

local function TimeParameterize(Path, MaximumVelocity, MaximumAcceleration, SampleCount)
    assert(type(Path) == "table" and type(Path.ArcLength) == "function" and type(Path.ParameterAtArcLength) == "function", "Path must support arc-length operations")
    assert(MaximumVelocity > 0 and MaximumAcceleration > 0, "Velocity and acceleration limits must be positive")
    local Count = math.max(2, math.floor(SampleCount or 64))
    local Length = Path:ArcLength()
    assert(Length > 0, "Path length must be positive")
    local Distances = table.create(Count)
    local Speeds = table.create(Count)
    local SegmentLength = Length / (Count - 1)
    for Index = 1, Count do
        Distances[Index] = (Index - 1) * SegmentLength
        Speeds[Index] = MaximumVelocity
    end
    Speeds[1] = 0
    Speeds[Count] = 0
    for Index = 2, Count do
        local Reachable = math.sqrt(math.max(Speeds[Index - 1] ^ 2 + 2 * MaximumAcceleration * SegmentLength, 0))
        Speeds[Index] = math.min(Speeds[Index], Reachable)
    end
    for Index = Count - 1, 1, -1 do
        local Reachable = math.sqrt(math.max(Speeds[Index + 1] ^ 2 + 2 * MaximumAcceleration * SegmentLength, 0))
        Speeds[Index] = math.min(Speeds[Index], Reachable)
    end
    local Result = table.create(Count)
    local Time = 0
    for Index = 1, Count do
        if Index > 1 then
            local AverageSpeed = 0.5 * (Speeds[Index - 1] + Speeds[Index])
            assert(AverageSpeed > 0, "Time parameterization encountered zero segment speed")
            Time += SegmentLength / AverageSpeed
        end
        local Parameter = Path:ParameterAtArcLength(Distances[Index])
        local Position = Path:Evaluate(Parameter)
        local Tangent = Path:Derivative(Parameter, 1)
        local TangentMagnitude = Tangent.Magnitude
        Tangent = TangentMagnitude > 1e-10 and Tangent / TangentMagnitude or Vector3.zero
        local Acceleration = 0
        if Index > 1 and Index < Count then
            Acceleration = (Speeds[Index + 1] ^ 2 - Speeds[Index - 1] ^ 2) / (4 * SegmentLength)
        end
        Result[Index] = {Time = Time, Distance = Distances[Index], Parameter = Parameter, Position = Position, Velocity = Tangent * Speeds[Index], Speed = Speeds[Index], TangentialAcceleration = Acceleration}
    end
    return Result
end

TrajectoryPlanning.Quintic = NewQuintic
TrajectoryPlanning.MinimumJerk = MinimumJerk
TrajectoryPlanning.Trapezoidal = NewTrapezoidal
TrajectoryPlanning.SCurve = NewSCurve
TrajectoryPlanning.TimeParameterize = TimeParameterize
TrajectoryPlanning.Version = "0.2.0-alpha"

return TrajectoryPlanning
