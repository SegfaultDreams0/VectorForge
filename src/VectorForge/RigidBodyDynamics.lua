local LinearAlgebra = require(script.Parent:WaitForChild("SpectralLinearAlgebra"))
local LieGroupKinematics = require(script.Parent:WaitForChild("LieGroupKinematics"))

local RigidBodyDynamics = {}
local Body = {}
Body.__index = Body

local function VectorToMatrix(Vector)
    return {
        {Vector.X, 0, 0},
        {0, Vector.Y, 0},
        {0, 0, Vector.Z},
    }
end

local function ResolveInertia(Inertia)
    if typeof(Inertia) == "Vector3" then
        assert(Inertia.X > 0 and Inertia.Y > 0 and Inertia.Z > 0, "Principal moments of inertia must be positive")
        return VectorToMatrix(Inertia)
    end
    local Rows, Columns = LinearAlgebra.Dimensions(Inertia)
    assert(Rows == 3 and Columns == 3, "Inertia tensor must be Vector3 or a 3 by 3 matrix")
    for Row = 1, 3 do
        for Column = 1, 3 do
            assert(math.abs(Inertia[Row][Column] - Inertia[Column][Row]) <= 1e-8, "Inertia tensor must be symmetric")
        end
        assert(Inertia[Row][Row] > 0, "Inertia tensor diagonal values must be positive")
    end
    local Copy = LinearAlgebra.Copy(Inertia)
    local Factor, Failure = LinearAlgebra.Cholesky(Copy)
    assert(Factor, Failure or "Inertia tensor must be positive definite")
    return Copy
end

local function ToArray(Vector)
    return {Vector.X, Vector.Y, Vector.Z}
end

local function ToVector(Array)
    return Vector3.new(Array[1], Array[2], Array[3])
end

local function Cross(A, B)
    return A:Cross(B)
end

local function WorldInertia(Orientation, BodyInertia)
    local Rotation = LieGroupKinematics.Quaternion.ToRotationMatrix(Orientation)
    return LinearAlgebra.Multiply(LinearAlgebra.Multiply(Rotation, BodyInertia), LinearAlgebra.Transpose(Rotation))
end

local function New(Configuration)
    assert(type(Configuration) == "table", "Configuration is required")
    assert(type(Configuration.Mass) == "number" and Configuration.Mass > 0, "Mass must be positive")
    local Inertia = ResolveInertia(Configuration.Inertia or Vector3.one)
    local Position = Configuration.Position or Vector3.zero
    local Orientation = Configuration.Orientation or LieGroupKinematics.Quaternion.New(1, 0, 0, 0)
    local LinearVelocity = Configuration.LinearVelocity or Vector3.zero
    local AngularVelocity = Configuration.AngularVelocity or Vector3.zero
    local Gravity = Configuration.Gravity or Vector3.new(0, -workspace.Gravity, 0)
    local LinearDamping = Configuration.LinearDamping or 0
    local AngularDamping = Configuration.AngularDamping or 0
    assert(typeof(Position) == "Vector3" and typeof(LinearVelocity) == "Vector3" and typeof(AngularVelocity) == "Vector3" and typeof(Gravity) == "Vector3", "Position, velocities, and gravity must be Vector3 values")
    assert(type(LinearDamping) == "number" and LinearDamping >= 0 and type(AngularDamping) == "number" and AngularDamping >= 0, "Damping values must be non-negative")
    return setmetatable({
        Mass = Configuration.Mass,
        InverseMass = 1 / Configuration.Mass,
        BodyInertia = Inertia,
        Position = Position,
        Orientation = LieGroupKinematics.Quaternion.Normalize(Orientation),
        LinearVelocity = LinearVelocity,
        AngularVelocity = AngularVelocity,
        Gravity = Gravity,
        LinearDamping = LinearDamping,
        AngularDamping = AngularDamping,
        ForceAccumulator = Vector3.zero,
        TorqueAccumulator = Vector3.zero,
        Time = 0,
    }, Body)
end

function Body:ApplyForce(Force, WorldPoint)
    assert(typeof(Force) == "Vector3", "Force must be a Vector3")
    self.ForceAccumulator += Force
    if WorldPoint then
        assert(typeof(WorldPoint) == "Vector3", "WorldPoint must be a Vector3")
        self.TorqueAccumulator += (WorldPoint - self.Position):Cross(Force)
    end
    return self
end

function Body:ApplyTorque(Torque)
    assert(typeof(Torque) == "Vector3", "Torque must be a Vector3")
    self.TorqueAccumulator += Torque
    return self
end

function Body:ApplyImpulse(Impulse, WorldPoint)
    assert(typeof(Impulse) == "Vector3", "Impulse must be a Vector3")
    self.LinearVelocity += Impulse * self.InverseMass
    if WorldPoint then
        assert(typeof(WorldPoint) == "Vector3", "WorldPoint must be a Vector3")
        local TorqueImpulse = (WorldPoint - self.Position):Cross(Impulse)
        local IWorld = WorldInertia(self.Orientation, self.BodyInertia)
        local AngularDelta, Failure = LinearAlgebra.Solve(IWorld, ToArray(TorqueImpulse))
        assert(AngularDelta, Failure or "Could not solve angular impulse")
        self.AngularVelocity += ToVector(AngularDelta)
    end
    return self
end

function Body:GetWorldInertia()
    return WorldInertia(self.Orientation, self.BodyInertia)
end

function Body:GetAngularMomentum()
    return ToVector(LinearAlgebra.MatrixVector(self:GetWorldInertia(), ToArray(self.AngularVelocity)))
end

function Body:Step(DeltaTime, ExternalForce, ExternalTorque)
    assert(type(DeltaTime) == "number" and DeltaTime > 0 and DeltaTime < math.huge, "DeltaTime must be positive and finite")
    ExternalForce = ExternalForce or Vector3.zero
    ExternalTorque = ExternalTorque or Vector3.zero
    assert(typeof(ExternalForce) == "Vector3" and typeof(ExternalTorque) == "Vector3", "External force and torque must be Vector3 values")
    local Force = self.ForceAccumulator + ExternalForce
    local Torque = self.TorqueAccumulator + ExternalTorque
    local Acceleration = self.Gravity + Force * self.InverseMass
    self.LinearVelocity += Acceleration * DeltaTime
    if self.LinearDamping > 0 then
        self.LinearVelocity *= math.exp(-self.LinearDamping * DeltaTime)
    end
    self.Position += self.LinearVelocity * DeltaTime

    local InertiaWorld = self:GetWorldInertia()
    local AngularMomentum = ToVector(LinearAlgebra.MatrixVector(InertiaWorld, ToArray(self.AngularVelocity)))
    local GyroscopicTorque = self.AngularVelocity:Cross(AngularMomentum)
    local NetTorque = Torque - GyroscopicTorque
    local AngularAcceleration, Failure = LinearAlgebra.Solve(InertiaWorld, ToArray(NetTorque))
    assert(AngularAcceleration, Failure or "Angular acceleration solve failed")
    self.AngularVelocity += ToVector(AngularAcceleration) * DeltaTime
    if self.AngularDamping > 0 then
        self.AngularVelocity *= math.exp(-self.AngularDamping * DeltaTime)
    end
    local RotationIncrement = LieGroupKinematics.Quaternion.Exp(self.AngularVelocity * DeltaTime)
    self.Orientation = LieGroupKinematics.Quaternion.Normalize(
        LieGroupKinematics.Quaternion.Multiply(RotationIncrement, self.Orientation)
    )
    self.Time += DeltaTime
    self.ForceAccumulator = Vector3.zero
    self.TorqueAccumulator = Vector3.zero
    return self:GetState()
end

function Body:GetState()
    return {
        Mass = self.Mass,
        Position = self.Position,
        Orientation = table.clone(self.Orientation),
        LinearVelocity = self.LinearVelocity,
        AngularVelocity = self.AngularVelocity,
        LinearMomentum = self.LinearVelocity * self.Mass,
        AngularMomentum = self:GetAngularMomentum(),
        Time = self.Time,
    }
end

function Body:Reset(State)
    assert(type(State) == "table", "State is required")
    self.Position = State.Position or Vector3.zero
    self.Orientation = LieGroupKinematics.Quaternion.Normalize(State.Orientation or LieGroupKinematics.Quaternion.New(1, 0, 0, 0))
    self.LinearVelocity = State.LinearVelocity or Vector3.zero
    self.AngularVelocity = State.AngularVelocity or Vector3.zero
    assert(typeof(self.Position) == "Vector3" and typeof(self.LinearVelocity) == "Vector3" and typeof(self.AngularVelocity) == "Vector3", "Reset state vectors must be Vector3 values")
    self.Time = 0
    self.ForceAccumulator = Vector3.zero
    self.TorqueAccumulator = Vector3.zero
    return self:GetState()
end

RigidBodyDynamics.new = New
RigidBodyDynamics.Body = Body
RigidBodyDynamics.Version = "0.2.0-alpha"

return RigidBodyDynamics
