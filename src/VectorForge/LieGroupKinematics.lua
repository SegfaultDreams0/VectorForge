local LieGroupKinematics = {}

local EPSILON = 1e-9

local function Clamp(Value, Minimum, Maximum)
    return math.max(Minimum, math.min(Maximum, Value))
end

local function Quaternion(W, X, Y, Z)
    assert(type(W) == "number" and type(X) == "number" and type(Y) == "number" and type(Z) == "number", "Quaternion components must be numeric")
    return {W = W, X = X, Y = Y, Z = Z}
end

local function QuaternionNormSquared(Q)
    return Q.W * Q.W + Q.X * Q.X + Q.Y * Q.Y + Q.Z * Q.Z
end

local function NormalizeQuaternion(Q)
    assert(type(Q) == "table" and type(Q.W) == "number" and type(Q.X) == "number" and type(Q.Y) == "number" and type(Q.Z) == "number", "Invalid quaternion")
    local Length = math.sqrt(QuaternionNormSquared(Q))
    assert(Length > EPSILON, "Cannot normalize a zero quaternion")
    return Quaternion(Q.W / Length, Q.X / Length, Q.Y / Length, Q.Z / Length)
end

local function QuaternionMultiply(A, B)
    return Quaternion(
        A.W * B.W - A.X * B.X - A.Y * B.Y - A.Z * B.Z,
        A.W * B.X + A.X * B.W + A.Y * B.Z - A.Z * B.Y,
        A.W * B.Y - A.X * B.Z + A.Y * B.W + A.Z * B.X,
        A.W * B.Z + A.X * B.Y - A.Y * B.X + A.Z * B.W
    )
end

local function QuaternionConjugate(Q)
    return Quaternion(Q.W, -Q.X, -Q.Y, -Q.Z)
end

local function QuaternionInverse(Q)
    local NormSquared = QuaternionNormSquared(Q)
    assert(NormSquared > EPSILON * EPSILON, "Cannot invert a zero quaternion")
    local Conjugate = QuaternionConjugate(Q)
    return Quaternion(Conjugate.W / NormSquared, Conjugate.X / NormSquared, Conjugate.Y / NormSquared, Conjugate.Z / NormSquared)
end

local function QuaternionDot(A, B)
    return A.W * B.W + A.X * B.X + A.Y * B.Y + A.Z * B.Z
end

local function RotateVector(Q, V)
    Q = NormalizeQuaternion(Q)
    local U = Vector3.new(Q.X, Q.Y, Q.Z)
    local T = 2 * U:Cross(V)
    return V + Q.W * T + U:Cross(T)
end

local function ExpSO3(Omega)
    local Angle = Omega.Magnitude
    local HalfAngle = Angle * 0.5
    if Angle < 1e-6 then
        local Scale = 0.5 - Angle * Angle / 48
        return NormalizeQuaternion(Quaternion(1 - Angle * Angle / 8, Omega.X * Scale, Omega.Y * Scale, Omega.Z * Scale))
    end
    local Scale = math.sin(HalfAngle) / Angle
    return Quaternion(math.cos(HalfAngle), Omega.X * Scale, Omega.Y * Scale, Omega.Z * Scale)
end

local function LogSO3(Q)
    Q = NormalizeQuaternion(Q)
    if Q.W < 0 then
        Q = Quaternion(-Q.W, -Q.X, -Q.Y, -Q.Z)
    end
    local VectorPart = Vector3.new(Q.X, Q.Y, Q.Z)
    local SineHalfAngle = VectorPart.Magnitude
    if SineHalfAngle < EPSILON then
        return VectorPart * 2
    end
    local Angle = 2 * math.atan2(SineHalfAngle, Clamp(Q.W, -1, 1))
    return VectorPart * (Angle / SineHalfAngle)
end

local function Slerp(A, B, Alpha)
    assert(type(Alpha) == "number", "Interpolation parameter must be numeric")
    A = NormalizeQuaternion(A)
    B = NormalizeQuaternion(B)
    local Cosine = QuaternionDot(A, B)
    if Cosine < 0 then
        B = Quaternion(-B.W, -B.X, -B.Y, -B.Z)
        Cosine = -Cosine
    end
    Cosine = Clamp(Cosine, -1, 1)
    if Cosine > 0.9995 then
        return NormalizeQuaternion(Quaternion(
            A.W + Alpha * (B.W - A.W),
            A.X + Alpha * (B.X - A.X),
            A.Y + Alpha * (B.Y - A.Y),
            A.Z + Alpha * (B.Z - A.Z)
        ))
    end
    local Angle = math.acos(Cosine)
    local Denominator = math.sin(Angle)
    local WeightA = math.sin((1 - Alpha) * Angle) / Denominator
    local WeightB = math.sin(Alpha * Angle) / Denominator
    return NormalizeQuaternion(Quaternion(
        A.W * WeightA + B.W * WeightB,
        A.X * WeightA + B.X * WeightB,
        A.Y * WeightA + B.Y * WeightB,
        A.Z * WeightA + B.Z * WeightB
    ))
end

local function QuaternionDistance(A, B)
    local Cosine = math.abs(Clamp(QuaternionDot(NormalizeQuaternion(A), NormalizeQuaternion(B)), -1, 1))
    return 2 * math.acos(Cosine)
end

local function LeftJacobianSO3(Omega, Vector)
    local Theta = Omega.Magnitude
    local First
    local Second
    if Theta < 1e-5 then
        local Theta2 = Theta * Theta
        First = 0.5 - Theta2 / 24 + Theta2 * Theta2 / 720
        Second = 1 / 6 - Theta2 / 120 + Theta2 * Theta2 / 5040
    else
        local Theta2 = Theta * Theta
        First = (1 - math.cos(Theta)) / Theta2
        Second = (Theta - math.sin(Theta)) / (Theta2 * Theta)
    end
    local Cross1 = Omega:Cross(Vector)
    local Cross2 = Omega:Cross(Cross1)
    return Vector + First * Cross1 + Second * Cross2
end

local function InverseLeftJacobianSO3(Omega, Vector)
    local Theta = Omega.Magnitude
    local Coefficient
    if Theta < 1e-4 then
        local Theta2 = Theta * Theta
        Coefficient = 1 / 12 + Theta2 / 720 + Theta2 * Theta2 / 30240
    else
        local Half = Theta * 0.5
        local Sine = math.sin(Half)
        assert(math.abs(Sine) > EPSILON, "SE(3) logarithm is singular at this rotation")
        local CotangentHalf = math.cos(Half) / Sine
        Coefficient = (1 - Half * CotangentHalf) / (Theta * Theta)
    end
    local Cross1 = Omega:Cross(Vector)
    local Cross2 = Omega:Cross(Cross1)
    return Vector - 0.5 * Cross1 + Coefficient * Cross2
end

local function NewPose(Rotation, Translation)
    assert(Translation == nil or typeof(Translation) == "Vector3", "Pose translation must be a Vector3")
    return {
        Rotation = NormalizeQuaternion(Rotation or Quaternion(1, 0, 0, 0)),
        Translation = Translation or Vector3.zero,
    }
end

local function Compose(A, B)
    return NewPose(QuaternionMultiply(A.Rotation, B.Rotation), A.Translation + RotateVector(A.Rotation, B.Translation))
end

local function Inverse(Pose)
    local Rotation = QuaternionConjugate(NormalizeQuaternion(Pose.Rotation))
    return NewPose(Rotation, RotateVector(Rotation, -Pose.Translation))
end

local function TransformPoint(Pose, Point)
    return Pose.Translation + RotateVector(Pose.Rotation, Point)
end

local function TransformVector(Pose, Vector)
    return RotateVector(Pose.Rotation, Vector)
end

local function ExpSE3(Twist)
    assert(typeof(Twist.Angular) == "Vector3" and typeof(Twist.Linear) == "Vector3", "Twist requires Angular and Linear Vector3 values")
    local Omega = Twist.Angular
    return NewPose(ExpSO3(Omega), LeftJacobianSO3(Omega, Twist.Linear))
end

local function LogSE3(Pose)
    local Omega = LogSO3(Pose.Rotation)
    return {Angular = Omega, Linear = InverseLeftJacobianSO3(Omega, Pose.Translation)}
end

local function ScaleTwist(Twist, Scalar)
    return {Angular = Twist.Angular * Scalar, Linear = Twist.Linear * Scalar}
end

local function InterpolateSE3(A, B, Alpha)
    local Relative = Compose(Inverse(A), B)
    return Compose(A, ExpSE3(ScaleTwist(LogSE3(Relative), Alpha)))
end

local function TransformTwist(Pose, Twist)
    local Angular = RotateVector(Pose.Rotation, Twist.Angular)
    local Linear = RotateVector(Pose.Rotation, Twist.Linear)
    return {Angular = Angular, Linear = Linear + Pose.Translation:Cross(Angular)}
end

local function ToAxisAngle(Q)
    local RotationVector = LogSO3(Q)
    local Angle = RotationVector.Magnitude
    if Angle < EPSILON then
        return Vector3.xAxis, 0
    end
    return RotationVector / Angle, Angle
end

local function FromRotationMatrix(Matrix)
    assert(type(Matrix) == "table" and #Matrix == 3, "Rotation matrix must be 3 by 3")
    for Row = 1, 3 do
        assert(type(Matrix[Row]) == "table" and #Matrix[Row] == 3, "Rotation matrix must be 3 by 3")
    end
    local M00, M01, M02 = Matrix[1][1], Matrix[1][2], Matrix[1][3]
    local M10, M11, M12 = Matrix[2][1], Matrix[2][2], Matrix[2][3]
    local M20, M21, M22 = Matrix[3][1], Matrix[3][2], Matrix[3][3]
    local Trace = M00 + M11 + M22
    local Q
    if Trace > 0 then
        local S = math.sqrt(Trace + 1) * 2
        Q = Quaternion(0.25 * S, (M21 - M12) / S, (M02 - M20) / S, (M10 - M01) / S)
    elseif M00 > M11 and M00 > M22 then
        local S = math.sqrt(1 + M00 - M11 - M22) * 2
        Q = Quaternion((M21 - M12) / S, 0.25 * S, (M01 + M10) / S, (M02 + M20) / S)
    elseif M11 > M22 then
        local S = math.sqrt(1 + M11 - M00 - M22) * 2
        Q = Quaternion((M02 - M20) / S, (M01 + M10) / S, 0.25 * S, (M12 + M21) / S)
    else
        local S = math.sqrt(1 + M22 - M00 - M11) * 2
        Q = Quaternion((M10 - M01) / S, (M02 + M20) / S, (M12 + M21) / S, 0.25 * S)
    end
    return NormalizeQuaternion(Q)
end

local function ToRotationMatrix(Q)
    Q = NormalizeQuaternion(Q)
    local W, X, Y, Z = Q.W, Q.X, Q.Y, Q.Z
    return {
        {1 - 2 * (Y * Y + Z * Z), 2 * (X * Y - Z * W), 2 * (X * Z + Y * W)},
        {2 * (X * Y + Z * W), 1 - 2 * (X * X + Z * Z), 2 * (Y * Z - X * W)},
        {2 * (X * Z - Y * W), 2 * (Y * Z + X * W), 1 - 2 * (X * X + Y * Y)},
    }
end

local function FromCFrame(Value)
    assert(typeof(Value) == "CFrame", "Expected a CFrame")
    local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = Value:GetComponents()
    local Rotation = FromRotationMatrix({{R00, R01, R02}, {R10, R11, R12}, {R20, R21, R22}})
    return NewPose(Rotation, Vector3.new(X, Y, Z))
end

local function ToCFrame(Pose)
    local Matrix = ToRotationMatrix(Pose.Rotation)
    return CFrame.new(
        Pose.Translation.X, Pose.Translation.Y, Pose.Translation.Z,
        Matrix[1][1], Matrix[1][2], Matrix[1][3],
        Matrix[2][1], Matrix[2][2], Matrix[2][3],
        Matrix[3][1], Matrix[3][2], Matrix[3][3]
    )
end

local function ScrewInterpolate(A, B, Alpha)
    return InterpolateSE3(A, B, Alpha)
end

LieGroupKinematics.Quaternion = {
    New = Quaternion,
    Normalize = NormalizeQuaternion,
    NormSquared = QuaternionNormSquared,
    Dot = QuaternionDot,
    Multiply = QuaternionMultiply,
    Conjugate = QuaternionConjugate,
    Inverse = QuaternionInverse,
    Rotate = RotateVector,
    Exp = ExpSO3,
    Log = LogSO3,
    Slerp = Slerp,
    Distance = QuaternionDistance,
    ToAxisAngle = ToAxisAngle,
    FromRotationMatrix = FromRotationMatrix,
    ToRotationMatrix = ToRotationMatrix,
}

LieGroupKinematics.Pose = {
    New = NewPose,
    Compose = Compose,
    Inverse = Inverse,
    TransformPoint = TransformPoint,
    TransformVector = TransformVector,
    Exp = ExpSE3,
    Log = LogSE3,
    Interpolate = InterpolateSE3,
    ScrewInterpolate = ScrewInterpolate,
    TransformTwist = TransformTwist,
    FromCFrame = FromCFrame,
    ToCFrame = ToCFrame,
}

LieGroupKinematics.Version = "0.2.0-alpha"

return LieGroupKinematics
