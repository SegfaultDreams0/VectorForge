local DifferentialPathGeometry = {}

local EPSILON = 1e-9

local function Clamp(X, A, B)
    return math.max(A, math.min(B, X))
end

local function Normalize(Vector)
    local Magnitude = Vector.Magnitude
    if Magnitude <= EPSILON then
        return Vector3.zero
    end
    return Vector / Magnitude
end

local function ChooseNormal(Tangent, PreferredUp)
    local Candidate = PreferredUp or Vector3.yAxis
    local Projected = Candidate - Tangent * Candidate:Dot(Tangent)

    if Projected.Magnitude <= 1e-6 then
        Candidate = math.abs(Tangent.X) < 0.8 and Vector3.xAxis or Vector3.zAxis
        Projected = Candidate - Tangent * Candidate:Dot(Tangent)
    end

    return Normalize(Projected)
end

local function Hermite(P0, P1, M0, M1, T)
    local T2 = T * T
    local T3 = T2 * T
    local H00 = 2 * T3 - 3 * T2 + 1
    local H10 = T3 - 2 * T2 + T
    local H01 = -2 * T3 + 3 * T2
    local H11 = T3 - T2
    return P0 * H00 + M0 * H10 + P1 * H01 + M1 * H11
end

local function HermiteDerivative(P0, P1, M0, M1, T)
    local T2 = T * T
    local H00 = 6 * T2 - 6 * T
    local H10 = 3 * T2 - 4 * T + 1
    local H01 = -6 * T2 + 6 * T
    local H11 = 3 * T2 - 2 * T
    return P0 * H00 + M0 * H10 + P1 * H01 + M1 * H11
end

local function HermiteSecondDerivative(P0, P1, M0, M1, T)
    local H00 = 12 * T - 6
    local H10 = 6 * T - 4
    local H01 = -12 * T + 6
    local H11 = 6 * T - 2
    return P0 * H00 + M0 * H10 + P1 * H01 + M1 * H11
end

local function HermiteThirdDerivative(P0, P1, M0, M1)
    return P0 * 12 + M0 * 6 - P1 * 12 + M1 * 6
end

local function Simpson(Function, A, B)
    local Middle = (A + B) * 0.5
    return (B - A) * (Function(A) + 4 * Function(Middle) + Function(B)) / 6
end

local function AdaptiveSimpson(Function, A, B, Tolerance, MaximumDepth, Whole)
    local Middle = (A + B) * 0.5
    local Left = Simpson(Function, A, Middle)
    local Right = Simpson(Function, Middle, B)
    local Combined = Left + Right
    local Error = Combined - Whole

    if MaximumDepth <= 0 or math.abs(Error) <= 15 * Tolerance then
        return Combined + Error / 15
    end

    return AdaptiveSimpson(Function, A, Middle, Tolerance * 0.5, MaximumDepth - 1, Left)
        + AdaptiveSimpson(Function, Middle, B, Tolerance * 0.5, MaximumDepth - 1, Right)
end

local function Integrate(Function, A, B, Tolerance, MaximumDepth)
    if B <= A then
        return 0
    end

    local Initial = Simpson(Function, A, B)
    return AdaptiveSimpson(Function, A, B, Tolerance or 1e-5, MaximumDepth or 12, Initial)
end

local Curve = {}
Curve.__index = Curve

function Curve.new(Points, Tangents)
    assert(type(Points) == "table" and #Points >= 2, "At least two points are required")

    local PointCopy = table.create(#Points)
    local TangentCopy = table.create(#Points)

    for Index, Point in ipairs(Points) do
        assert(typeof(Point) == "Vector3", "Path points must be Vector3 values")
        PointCopy[Index] = Point
    end

    if Tangents then
        assert(#Tangents == #Points, "One tangent is required per point")
        for Index, Tangent in ipairs(Tangents) do
            assert(typeof(Tangent) == "Vector3", "Path tangents must be Vector3 values")
            TangentCopy[Index] = Tangent
        end
    else
        for Index = 1, #PointCopy do
            if Index == 1 then
                TangentCopy[Index] = PointCopy[2] - PointCopy[1]
            elseif Index == #PointCopy then
                TangentCopy[Index] = PointCopy[Index] - PointCopy[Index - 1]
            else
                TangentCopy[Index] = (PointCopy[Index + 1] - PointCopy[Index - 1]) * 0.5
            end
        end
    end

    return setmetatable({
        Points = PointCopy,
        Tangents = TangentCopy,
        SegmentCount = #PointCopy - 1,
        SegmentLengths = nil,
        TotalLength = nil,
        LengthTolerance = nil,
    }, Curve)
end

function Curve:_Segment(Parameter)
    local T = Clamp(Parameter, 0, 1)
    local Scaled = T * self.SegmentCount
    local Index = math.min(math.floor(Scaled) + 1, self.SegmentCount)
    local Local = Scaled - (Index - 1)
    return Index, Clamp(Local, 0, 1)
end

function Curve:_EvaluateLocal(Index, T, Order)
    local P0 = self.Points[Index]
    local P1 = self.Points[Index + 1]
    local M0 = self.Tangents[Index]
    local M1 = self.Tangents[Index + 1]

    if Order == 0 then
        return Hermite(P0, P1, M0, M1, T)
    elseif Order == 1 then
        return HermiteDerivative(P0, P1, M0, M1, T) * self.SegmentCount
    elseif Order == 2 then
        return HermiteSecondDerivative(P0, P1, M0, M1, T) * self.SegmentCount * self.SegmentCount
    elseif Order == 3 then
        return HermiteThirdDerivative(P0, P1, M0, M1)
            * self.SegmentCount * self.SegmentCount * self.SegmentCount
    end

    error("Derivative order must be between zero and three")
end

function Curve:Evaluate(Parameter)
    local Index, T = self:_Segment(Parameter)
    return self:_EvaluateLocal(Index, T, 0)
end

function Curve:Derivative(Parameter, Order)
    local Index, T = self:_Segment(Parameter)
    return self:_EvaluateLocal(Index, T, Order or 1)
end

function Curve:Curvature(Parameter)
    local First = self:Derivative(Parameter, 1)
    local Second = self:Derivative(Parameter, 2)
    local Speed = First.Magnitude

    if Speed <= EPSILON then
        return 0
    end

    return First:Cross(Second).Magnitude / (Speed * Speed * Speed)
end

function Curve:Torsion(Parameter)
    local First = self:Derivative(Parameter, 1)
    local Second = self:Derivative(Parameter, 2)
    local Third = self:Derivative(Parameter, 3)
    local Cross = First:Cross(Second)
    local Denominator = Cross:Dot(Cross)

    if Denominator <= EPSILON then
        return 0
    end

    return Cross:Dot(Third) / Denominator
end

function Curve:_SegmentLength(Index, EndParameter, Tolerance)
    local Integrand = function(LocalParameter)
        return self:_EvaluateLocal(Index, LocalParameter, 1).Magnitude / self.SegmentCount
    end
    return Integrate(Integrand, 0, EndParameter, Tolerance, 14)
end

function Curve:ArcLength(Tolerance)
    local RequestedTolerance = Tolerance or 1e-5
    if self.TotalLength and self.LengthTolerance and RequestedTolerance >= self.LengthTolerance then
        return self.TotalLength
    end

    local Total = 0
    local Lengths = table.create(self.SegmentCount)

    for Index = 1, self.SegmentCount do
        Lengths[Index] = self:_SegmentLength(Index, 1, Tolerance)
        Total += Lengths[Index]
    end

    self.SegmentLengths = Lengths
    self.TotalLength = Total
    self.LengthTolerance = RequestedTolerance
    return Total
end

function Curve:ArcLengthAt(Parameter, Tolerance)
    local T = Clamp(Parameter, 0, 1)
    if T <= 0 then
        return 0
    end

    self:ArcLength(Tolerance)
    if T >= 1 then
        return self.TotalLength
    end

    local Index, Local = self:_Segment(T)
    local Total = 0
    for Segment = 1, Index - 1 do
        Total += self.SegmentLengths[Segment]
    end
    Total += self:_SegmentLength(Index, Local, Tolerance)
    return Total
end

function Curve:ParameterAtArcLength(Distance, Tolerance)
    local Total = self:ArcLength(Tolerance)
    local Target = Clamp(Distance, 0, Total)

    if Target <= 0 then
        return 0
    elseif Target >= Total then
        return 1
    end

    local SegmentIndex = 1
    local Before = 0

    for Index, Length in ipairs(self.SegmentLengths) do
        if Before + Length >= Target then
            SegmentIndex = Index
            break
        end
        Before += Length
    end

    local LocalTarget = Target - Before
    local SegmentLength = self.SegmentLengths[SegmentIndex]
    local Low = 0
    local High = 1
    local Local = SegmentLength > EPSILON and LocalTarget / SegmentLength or 0

    for _ = 1, 24 do
        local CurrentLength = self:_SegmentLength(SegmentIndex, Local, Tolerance)
        local Error = CurrentLength - LocalTarget

        if math.abs(Error) <= (Tolerance or 1e-5) then
            break
        end

        if Error > 0 then
            High = Local
        else
            Low = Local
        end

        local Speed = self:_EvaluateLocal(SegmentIndex, Local, 1).Magnitude
        local Candidate = Speed > EPSILON and Local - Error * self.SegmentCount / Speed or (Low + High) * 0.5

        if Candidate <= Low or Candidate >= High then
            Candidate = (Low + High) * 0.5
        end
        Local = Candidate
    end

    return ((SegmentIndex - 1) + Local) / self.SegmentCount
end

function Curve:FrenetFrame(Parameter, PreferredUp)
    local Tangent = Normalize(self:Derivative(Parameter, 1))
    if Tangent.Magnitude <= EPSILON then
        return nil
    end

    local Acceleration = self:Derivative(Parameter, 2)
    local NormalCandidate = Acceleration - Tangent * Acceleration:Dot(Tangent)
    local Normal = NormalCandidate.Magnitude <= EPSILON
        and ChooseNormal(Tangent, PreferredUp)
        or Normalize(NormalCandidate)
    local Binormal = Normalize(Tangent:Cross(Normal))
    Normal = Normalize(Binormal:Cross(Tangent))

    return {
        Position = self:Evaluate(Parameter),
        Tangent = Tangent,
        Normal = Normal,
        Binormal = Binormal,
        Curvature = self:Curvature(Parameter),
        Torsion = self:Torsion(Parameter),
    }
end

function Curve:ParallelTransportFrames(SampleCount, PreferredUp)
    local Count = math.max(2, math.floor(SampleCount or 32))
    local Frames = table.create(Count)
    local PreviousTangent
    local PreviousNormal

    for Index = 1, Count do
        local Parameter = (Index - 1) / (Count - 1)
        local Tangent = Normalize(self:Derivative(Parameter, 1))
        if Tangent.Magnitude <= EPSILON then
            Tangent = PreviousTangent or Vector3.xAxis
        end

        local Normal
        if not PreviousTangent then
            Normal = ChooseNormal(Tangent, PreferredUp)
        else
            local Axis = PreviousTangent:Cross(Tangent)
            local Sine = Axis.Magnitude
            local Cosine = Clamp(PreviousTangent:Dot(Tangent), -1, 1)

            if Sine <= 1e-7 then
                if Cosine < 0 then
                    Normal = ChooseNormal(Tangent, PreviousNormal)
                else
                    Normal = PreviousNormal
                end
            else
                local UnitAxis = Axis / Sine
                local Angle = math.atan2(Sine, Cosine)
                local C = math.cos(Angle)
                local S = math.sin(Angle)
                Normal = PreviousNormal * C
                    + UnitAxis:Cross(PreviousNormal) * S
                    + UnitAxis * UnitAxis:Dot(PreviousNormal) * (1 - C)
            end

            Normal = Normalize(Normal - Tangent * Normal:Dot(Tangent))
            if Normal.Magnitude <= EPSILON then
                Normal = ChooseNormal(Tangent, PreferredUp)
            end
        end

        local Binormal = Normalize(Tangent:Cross(Normal))
        Normal = Normalize(Binormal:Cross(Tangent))

        Frames[Index] = {
            Parameter = Parameter,
            Position = self:Evaluate(Parameter),
            Tangent = Tangent,
            Normal = Normal,
            Binormal = Binormal,
        }

        PreviousTangent = Tangent
        PreviousNormal = Normal
    end

    return Frames
end

function Curve:ClosestParameter(Target, SampleCount, Iterations)
    assert(typeof(Target) == "Vector3", "Target must be a Vector3")

    local Count = math.max(8, math.floor(SampleCount or 64))
    local BestParameter = 0
    local BestDistance = math.huge

    for Index = 0, Count do
        local Parameter = Index / Count
        local Difference = self:Evaluate(Parameter) - Target
        local DistanceSquared = Difference:Dot(Difference)

        if DistanceSquared < BestDistance then
            BestDistance = DistanceSquared
            BestParameter = Parameter
        end
    end

    local Low = math.max(0, BestParameter - 1 / Count)
    local High = math.min(1, BestParameter + 1 / Count)
    local Parameter = BestParameter

    for _ = 1, Iterations or 12 do
        local Difference = self:Evaluate(Parameter) - Target
        local First = self:Derivative(Parameter, 1)
        local Second = self:Derivative(Parameter, 2)
        local Gradient = Difference:Dot(First)
        local Hessian = First:Dot(First) + Difference:Dot(Second)

        if Gradient > 0 then
            High = Parameter
        else
            Low = Parameter
        end

        local Candidate
        if math.abs(Hessian) > EPSILON then
            Candidate = Parameter - Gradient / Hessian
        end

        if not Candidate or Candidate <= Low or Candidate >= High then
            Candidate = (Low + High) * 0.5
        end

        if math.abs(Candidate - Parameter) < 1e-8 then
            Parameter = Candidate
            break
        end

        Parameter = Candidate
    end

    return Parameter, self:Evaluate(Parameter)
end

local function MinimumJerk(Start, Goal, Duration, Time)
    assert(Duration > 0, "Duration must be positive")
    local U = Clamp(Time / Duration, 0, 1)
    local U2 = U * U
    local U3 = U2 * U
    local U4 = U3 * U
    local U5 = U4 * U

    local PositionBlend = 10 * U3 - 15 * U4 + 6 * U5
    local VelocityBlend = (30 * U2 - 60 * U3 + 30 * U4) / Duration
    local AccelerationBlend = (60 * U - 180 * U2 + 120 * U3) / (Duration * Duration)
    local Delta = Goal - Start

    return Start + Delta * PositionBlend, Delta * VelocityBlend, Delta * AccelerationBlend
end

DifferentialPathGeometry.new = Curve.new
DifferentialPathGeometry.MinimumJerk = MinimumJerk
DifferentialPathGeometry.Version = "1.0.0-alpha"

return DifferentialPathGeometry
