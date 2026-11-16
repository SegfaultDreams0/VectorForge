local LieGroupKinematics = {}

local EPSILON = 1e-9

local function Clamp(X, A, B)
    return math.max(A, math.min(B, X))
end

local function Quaternion(W, X, Y, Z)
    return {W = W, X = X, Y = Y, Z = Z}
end

local function NormalizeQuaternion(Q)
    local Length = math.sqrt(Q.W * Q.W + Q.X * Q.X + Q.Y * Q.Y + Q.Z * Q.Z)
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
        return NormalizeQuaternion(Quaternion(
            1 - Angle * Angle / 8,
            Omega.X * Scale,
            Omega.Y * Scale,
            Omega.Z * Scale
        ))
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
        return Vector3.new(Q.X, Q.Y, Q.Z) * 2
    end

    local Angle = 2 * math.atan2(SineHalfAngle, Clamp(Q.W, -1, 1))
    return VectorPart * (Angle / SineHalfAngle)
end

local function Slerp(A, B, Alpha)
    A = NormalizeQuaternion(A)
    B = NormalizeQuaternion(B)

    local Cosine = A.W * B.W + A.X * B.X + A.Y * B.Y + A.Z * B.Z

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
        local CotangentHalf = math.cos(Half) / math.sin(Half)
        Coefficient = (1 - Half * CotangentHalf) / (Theta * Theta)
    end

    local Cross1 = Omega:Cross(Vector)
    local Cross2 = Omega:Cross(Cross1)
    return Vector - 0.5 * Cross1 + Coefficient * Cross2
end

local function NewPose(Rotation, Translation)
    return {
        Rotation = NormalizeQuaternion(Rotation or Quaternion(1, 0, 0, 0)),
        Translation = Translation or Vector3.zero,
    }
end

local function Compose(A, B)
    return NewPose(
        QuaternionMultiply(A.Rotation, B.Rotation),
        A.Translation + RotateVector(A.Rotation, B.Translation)
    )
end

local function Inverse(Pose)
    local Rotation = QuaternionConjugate(NormalizeQuaternion(Pose.Rotation))
    return NewPose(Rotation, RotateVector(Rotation, -Pose.Translation))
end

local function TransformPoint(Pose, Point)
    return Pose.Translation + RotateVector(Pose.Rotation, Point)
end

local function ExpSE3(Twist)
    local Omega = Twist.Angular
    return NewPose(ExpSO3(Omega), LeftJacobianSO3(Omega, Twist.Linear))
end

local function LogSE3(Pose)
    local Omega = LogSO3(Pose.Rotation)
    return {
        Angular = Omega,
        Linear = InverseLeftJacobianSO3(Omega, Pose.Translation),
    }
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

LieGroupKinematics.Quaternion = {
    New = Quaternion,
    Normalize = NormalizeQuaternion,
    Multiply = QuaternionMultiply,
    Conjugate = QuaternionConjugate,
    Rotate = RotateVector,
    Exp = ExpSO3,
    Log = LogSO3,
    Slerp = Slerp,
    ToAxisAngle = ToAxisAngle,
}

LieGroupKinematics.Pose = {
    New = NewPose,
    Compose = Compose,
    Inverse = Inverse,
    TransformPoint = TransformPoint,
    Exp = ExpSE3,
    Log = LogSE3,
    Interpolate = InterpolateSE3,
    TransformTwist = TransformTwist,
}

LieGroupKinematics.Version = "1.0.0-alpha"

return LieGroupKinematics
