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

function Curve:SampleByArcLength(SampleCount, Tolerance)
    local Count = math.max(2, math.floor(SampleCount or 32))
    local Total = self:ArcLength(Tolerance)
    local Samples = table.create(Count)
    for Index = 1, Count do
        local Distance = Total * (Index - 1) / (Count - 1)
        local Parameter = self:ParameterAtArcLength(Distance, Tolerance)
        local Tangent = Normalize(self:Derivative(Parameter, 1))
        Samples[Index] = {Distance = Distance, Parameter = Parameter, Position = self:Evaluate(Parameter), Tangent = Tangent}
    end
    return Samples
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
DifferentialPathGeometry.Version = "0.2.0-alpha"

local ParametricCurve = {}
ParametricCurve.__index = ParametricCurve

local function NewParametricCurve(Evaluator, MaximumDerivative)
    return setmetatable({
        Evaluator = Evaluator,
        MaximumDerivative = MaximumDerivative or 3,
        CachedLength = nil,
        CachedTolerance = nil,
    }, ParametricCurve)
end

function ParametricCurve:Evaluate(Parameter)
    return self.Evaluator(Clamp(Parameter, 0, 1), 0)
end

function ParametricCurve:Derivative(Parameter, Order)
    local DerivativeOrder = Order or 1
    assert(DerivativeOrder >= 1 and DerivativeOrder <= self.MaximumDerivative, "Unsupported derivative order")
    return self.Evaluator(Clamp(Parameter, 0, 1), DerivativeOrder)
end

function ParametricCurve:Curvature(Parameter)
    local First = self:Derivative(Parameter, 1)
    local Second = self.MaximumDerivative >= 2 and self:Derivative(Parameter, 2) or Vector3.zero
    local Speed = First.Magnitude
    if Speed <= EPSILON then
        return 0
    end
    return First:Cross(Second).Magnitude / Speed ^ 3
end

function ParametricCurve:Torsion(Parameter)
    if self.MaximumDerivative < 3 then
        return 0
    end
    local First = self:Derivative(Parameter, 1)
    local Second = self:Derivative(Parameter, 2)
    local Third = self:Derivative(Parameter, 3)
    local CrossProduct = First:Cross(Second)
    local Denominator = CrossProduct:Dot(CrossProduct)
    if Denominator <= EPSILON then
        return 0
    end
    return CrossProduct:Dot(Third) / Denominator
end

function ParametricCurve:ArcLength(Tolerance)
    local RequestedTolerance = Tolerance or 1e-5
    if self.CachedLength and self.CachedTolerance and RequestedTolerance >= self.CachedTolerance then
        return self.CachedLength
    end
    local Total = Integrate(function(Parameter)
        return self:Derivative(Parameter, 1).Magnitude
    end, 0, 1, RequestedTolerance, 16)
    self.CachedLength = Total
    self.CachedTolerance = RequestedTolerance
    return Total
end

function ParametricCurve:ArcLengthAt(Parameter, Tolerance)
    local T = Clamp(Parameter, 0, 1)
    if T <= 0 then
        return 0
    end
    if T >= 1 then
        return self:ArcLength(Tolerance)
    end
    return Integrate(function(Value)
        return self:Derivative(Value, 1).Magnitude
    end, 0, T, Tolerance or 1e-5, 16)
end

function ParametricCurve:ParameterAtArcLength(Distance, Tolerance)
    local Total = self:ArcLength(Tolerance)
    local Target = Clamp(Distance, 0, Total)
    if Target <= 0 then
        return 0
    elseif Target >= Total then
        return 1
    end
    local Low = 0
    local High = 1
    local Parameter = Target / Total
    local AllowedError = Tolerance or 1e-5
    for _ = 1, 40 do
        local CurrentLength = self:ArcLengthAt(Parameter, AllowedError)
        local Error = CurrentLength - Target
        if math.abs(Error) <= AllowedError then
            break
        end
        if Error > 0 then
            High = Parameter
        else
            Low = Parameter
        end
        local Speed = self:Derivative(Parameter, 1).Magnitude
        local Candidate = Speed > EPSILON and Parameter - Error / Speed or (Low + High) * 0.5
        if Candidate <= Low or Candidate >= High then
            Candidate = (Low + High) * 0.5
        end
        Parameter = Candidate
    end
    return Clamp(Parameter, 0, 1)
end

function ParametricCurve:FrenetFrame(Parameter, PreferredUp)
    local Tangent = Normalize(self:Derivative(Parameter, 1))
    if Tangent.Magnitude <= EPSILON then
        return nil
    end
    local Acceleration = self.MaximumDerivative >= 2 and self:Derivative(Parameter, 2) or Vector3.zero
    local NormalCandidate = Acceleration - Tangent * Acceleration:Dot(Tangent)
    local Normal = NormalCandidate.Magnitude <= EPSILON and ChooseNormal(Tangent, PreferredUp) or Normalize(NormalCandidate)
    local Binormal = Normalize(Tangent:Cross(Normal))
    Normal = Normalize(Binormal:Cross(Tangent))
    return {
        Parameter = Clamp(Parameter, 0, 1),
        Position = self:Evaluate(Parameter),
        Tangent = Tangent,
        Normal = Normal,
        Binormal = Binormal,
        Curvature = self:Curvature(Parameter),
        Torsion = self:Torsion(Parameter),
    }
end

function ParametricCurve:ParallelTransportFrames(SampleCount, PreferredUp)
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
                Normal = Cosine < 0 and ChooseNormal(Tangent, PreviousNormal) or PreviousNormal
            else
                local UnitAxis = Axis / Sine
                local Angle = math.atan2(Sine, Cosine)
                local C = math.cos(Angle)
                local S = math.sin(Angle)
                Normal = PreviousNormal * C + UnitAxis:Cross(PreviousNormal) * S + UnitAxis * UnitAxis:Dot(PreviousNormal) * (1 - C)
            end
            Normal = Normalize(Normal - Tangent * Normal:Dot(Tangent))
            if Normal.Magnitude <= EPSILON then
                Normal = ChooseNormal(Tangent, PreferredUp)
            end
        end
        local Binormal = Normalize(Tangent:Cross(Normal))
        Normal = Normalize(Binormal:Cross(Tangent))
        Frames[Index] = {Parameter = Parameter, Position = self:Evaluate(Parameter), Tangent = Tangent, Normal = Normal, Binormal = Binormal}
        PreviousTangent = Tangent
        PreviousNormal = Normal
    end
    return Frames
end

function ParametricCurve:ClosestParameter(Target, SampleCount, Iterations)
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
    for _ = 1, Iterations or 16 do
        local Difference = self:Evaluate(Parameter) - Target
        local First = self:Derivative(Parameter, 1)
        local Second = self.MaximumDerivative >= 2 and self:Derivative(Parameter, 2) or Vector3.zero
        local Gradient = Difference:Dot(First)
        local Hessian = First:Dot(First) + Difference:Dot(Second)
        if Gradient > 0 then
            High = Parameter
        else
            Low = Parameter
        end
        local Candidate = math.abs(Hessian) > EPSILON and Parameter - Gradient / Hessian or nil
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

function ParametricCurve:SampleByArcLength(SampleCount, Tolerance)
    local Count = math.max(2, math.floor(SampleCount or 32))
    local Total = self:ArcLength(Tolerance)
    local Samples = table.create(Count)
    for Index = 1, Count do
        local Distance = Total * (Index - 1) / (Count - 1)
        local Parameter = self:ParameterAtArcLength(Distance, Tolerance)
        Samples[Index] = {Distance = Distance, Parameter = Parameter, Position = self:Evaluate(Parameter), Tangent = Normalize(self:Derivative(Parameter, 1))}
    end
    return Samples
end

local function BezierPoint(ControlPoints, Parameter)
    local Work = table.clone(ControlPoints)
    for Level = #Work - 1, 1, -1 do
        for Index = 1, Level do
            Work[Index] = Work[Index]:Lerp(Work[Index + 1], Parameter)
        end
    end
    return Work[1]
end

local function DifferenceControlPoints(ControlPoints, Degree)
    local Result = table.create(math.max(0, #ControlPoints - 1))
    for Index = 1, #ControlPoints - 1 do
        Result[Index] = (ControlPoints[Index + 1] - ControlPoints[Index]) * Degree
    end
    return Result
end

local function BezierNew(ControlPoints)
    assert(type(ControlPoints) == "table" and #ControlPoints >= 2, "Bezier requires at least two control points")
    local Points = table.clone(ControlPoints)
    for _, Point in ipairs(Points) do
        assert(typeof(Point) == "Vector3", "Bezier control points must be Vector3 values")
    end
    local DerivativeControls = {Points}
    local MaximumDerivative = math.min(3, #Points - 1)
    for Order = 1, MaximumDerivative do
        DerivativeControls[Order + 1] = DifferenceControlPoints(DerivativeControls[Order], #DerivativeControls[Order] - 1)
    end
    local function Evaluator(Parameter, Order)
        if Order > MaximumDerivative then
            return Vector3.zero
        end
        return BezierPoint(DerivativeControls[Order + 1], Parameter)
    end
    return NewParametricCurve(Evaluator, 3)
end

local function CatmullRomNew(Points, Tension)
    assert(type(Points) == "table" and #Points >= 2, "Catmull-Rom requires at least two points")
    local Scale = Tension or 0.5
    local Tangents = table.create(#Points)
    for Index, Point in ipairs(Points) do
        assert(typeof(Point) == "Vector3", "Catmull-Rom points must be Vector3 values")
        if Index == 1 then
            Tangents[Index] = (Points[2] - Point) * (2 * Scale)
        elseif Index == #Points then
            Tangents[Index] = (Point - Points[Index - 1]) * (2 * Scale)
        else
            Tangents[Index] = (Points[Index + 1] - Points[Index - 1]) * Scale
        end
    end
    return Curve.new(Points, Tangents)
end

local function MakeOpenUniformKnots(ControlPointCount, Degree)
    local Knots = {}
    local KnotCount = ControlPointCount + Degree + 1
    for Index = 1, KnotCount do
        if Index <= Degree + 1 then
            Knots[Index] = 0
        elseif Index >= ControlPointCount + 1 then
            Knots[Index] = 1
        else
            Knots[Index] = (Index - Degree - 1) / (ControlPointCount - Degree)
        end
    end
    return Knots
end

local function FindKnotSpan(ControlPointCount, Degree, Parameter, Knots)
    if Parameter >= Knots[ControlPointCount + 1] then
        return ControlPointCount
    end
    local Low = Degree + 1
    local High = ControlPointCount + 1
    local Middle = math.floor((Low + High) / 2)
    while Parameter < Knots[Middle] or Parameter >= Knots[Middle + 1] do
        if Parameter < Knots[Middle] then
            High = Middle
        else
            Low = Middle
        end
        Middle = math.floor((Low + High) / 2)
    end
    return Middle
end

local function DeBoor(ControlPoints, Degree, Knots, Parameter)
    local Count = #ControlPoints
    if Degree == 0 then
        local Span = FindKnotSpan(Count, Degree, Parameter, Knots)
        return ControlPoints[Span]
    end
    local Span = FindKnotSpan(Count, Degree, Parameter, Knots)
    local Work = table.create(Degree + 1)
    for Index = 0, Degree do
        Work[Index + 1] = ControlPoints[Span - Degree + Index]
    end
    for Level = 1, Degree do
        for Index = Degree, Level, -1 do
            local KnotIndex = Span - Degree + Index
            local Denominator = Knots[KnotIndex + Degree - Level + 1] - Knots[KnotIndex]
            local Alpha = math.abs(Denominator) <= EPSILON and 0 or (Parameter - Knots[KnotIndex]) / Denominator
            Work[Index + 1] = Work[Index]:Lerp(Work[Index + 1], Alpha)
        end
    end
    return Work[Degree + 1]
end

local function BSplineDerivativeControls(ControlPoints, Degree, Knots)
    if Degree <= 0 then
        return {}, 0, {}
    end
    local Result = table.create(#ControlPoints - 1)
    for Index = 1, #ControlPoints - 1 do
        local Denominator = Knots[Index + Degree + 1] - Knots[Index + 1]
        if math.abs(Denominator) <= EPSILON then
            Result[Index] = Vector3.zero
        else
            Result[Index] = (ControlPoints[Index + 1] - ControlPoints[Index]) * (Degree / Denominator)
        end
    end
    local ReducedKnots = table.create(#Knots - 2)
    for Index = 2, #Knots - 1 do
        ReducedKnots[Index - 1] = Knots[Index]
    end
    return Result, Degree - 1, ReducedKnots
end

local function BSplineNew(ControlPoints, Degree)
    assert(type(ControlPoints) == "table" and #ControlPoints >= 2, "B-spline requires at least two control points")
    local Points = table.clone(ControlPoints)
    for _, Point in ipairs(Points) do
        assert(typeof(Point) == "Vector3", "B-spline control points must be Vector3 values")
    end
    local Order = Degree or math.min(3, #Points - 1)
    assert(type(Order) == "number" and Order >= 1 and Order < #Points and Order % 1 == 0, "B-spline degree must be an integer from one to control point count minus one")
    local ControlSets = {{Points, Order, MakeOpenUniformKnots(#Points, Order)}}
    for Index = 2, 4 do
        local Previous = ControlSets[Index - 1]
        if Previous[2] <= 0 or #Previous[1] <= 1 then
            break
        end
        local NextPoints, NextDegree, NextKnots = BSplineDerivativeControls(Previous[1], Previous[2], Previous[3])
        ControlSets[Index] = {NextPoints, NextDegree, NextKnots}
    end
    local MaximumDerivative = math.min(3, Order)
    local function Evaluator(Parameter, DerivativeOrder)
        local Set = ControlSets[DerivativeOrder + 1]
        if not Set or #Set[1] == 0 then
            return Vector3.zero
        end
        return DeBoor(Set[1], Set[2], Set[3], Parameter)
    end
    return NewParametricCurve(Evaluator, 3)
end

local function PathIsClear(Points, RaycastParams, World)
    assert(type(Points) == "table" and #Points >= 2, "At least two path points are required")
    local QueryWorld = World or workspace
    assert(type(QueryWorld.Raycast) == "function", "World must provide Raycast")
    for _, Point in ipairs(Points) do
        assert(typeof(Point) == "Vector3", "Path points must be Vector3 values")
    end
    for Index = 1, #Points - 1 do
        local Origin = Points[Index]
        local Delta = Points[Index + 1] - Origin
        if Delta.Magnitude > EPSILON then
            local Result = QueryWorld:Raycast(Origin, Delta, RaycastParams)
            if Result then
                return false, Index, Result
            end
        end
    end
    return true
end

local function GenerateCollisionAwarePath(Start, Goal, RaycastParams, Options)
    assert(typeof(Start) == "Vector3" and typeof(Goal) == "Vector3", "Start and Goal must be Vector3 values")
    local Settings = Options or {}
    local QueryWorld = Settings.World or workspace
    local DirectDelta = Goal - Start
    if DirectDelta.Magnitude <= EPSILON then
        return {Start, Goal}, {Direct = true, Detour = false}
    end
    local DirectHit = QueryWorld:Raycast(Start, DirectDelta, RaycastParams)
    if not DirectHit then
        return {Start, Goal}, {Direct = true, Detour = false}
    end
    local Padding = Settings.Padding or 6
    assert(type(Padding) == "number" and Padding > 0 and Padding < math.huge, "Padding must be positive and finite")
    local Directions = {
        DirectHit.Normal,
        Vector3.yAxis,
        -Vector3.yAxis,
        Vector3.xAxis,
        -Vector3.xAxis,
        Vector3.zAxis,
        -Vector3.zAxis,
    }
    for _, Direction in ipairs(Directions) do
        local Offset = Direction.Magnitude > EPSILON and Direction.Unit * Padding or Vector3.yAxis * Padding
        local Candidate = DirectHit.Position + Offset
        local FirstClear = not QueryWorld:Raycast(Start, Candidate - Start, RaycastParams)
        local SecondClear = not QueryWorld:Raycast(Candidate, Goal - Candidate, RaycastParams)
        if FirstClear and SecondClear then
            return {Start, Candidate, Goal}, {Direct = false, Detour = true, Hit = DirectHit, Waypoint = Candidate}
        end
    end
    return nil, {Direct = false, Detour = false, Hit = DirectHit, Reason = "No clear single-waypoint detour was found"}
end

DifferentialPathGeometry.Bezier = {new = BezierNew}
DifferentialPathGeometry.CatmullRom = {new = CatmullRomNew}
DifferentialPathGeometry.BSpline = {new = BSplineNew}
DifferentialPathGeometry.SampleByArcLength = function(Path, Count, Tolerance)
    return Path:SampleByArcLength(Count, Tolerance)
end
DifferentialPathGeometry.PathIsClear = PathIsClear
DifferentialPathGeometry.GenerateCollisionAwarePath = GenerateCollisionAwarePath
DifferentialPathGeometry.ParametricCurve = ParametricCurve
DifferentialPathGeometry.Version = "0.2.0-alpha"

return DifferentialPathGeometry
