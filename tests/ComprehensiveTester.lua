local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("VectorForge")
local Workspace = game:GetService("Workspace")

local LinearAlgebra = require(Modules:WaitForChild("SpectralLinearAlgebra"))
local Kinematics = require(Modules:WaitForChild("LieGroupKinematics"))
local Estimation = require(Modules:WaitForChild("BayesianStateEstimation"))
local PathGeometry = require(Modules:WaitForChild("DifferentialPathGeometry"))
local AD = require(Modules:WaitForChild("AutomaticDifferentiation"))
local Dynamics = require(Modules:WaitForChild("RigidBodyDynamics"))
local Optimization = require(Modules:WaitForChild("NumericalOptimization"))
local Trajectory = require(Modules:WaitForChild("TrajectoryPlanning"))

local Passed = 0
local Failed = 0
local ExperimentResults = {}
local ActiveExperiment = nil

local function Near(A, B, Tolerance)
    assert(type(A) == "number" and type(B) == "number", "Near expects numeric values")
    assert(math.abs(A - B) <= (Tolerance or 1e-5), string.format("Expected %.9g, received %.9g", B, A))
end

local function VectorNear(A, B, Tolerance)
    assert(typeof(A) == "Vector3" and typeof(B) == "Vector3", "VectorNear expects Vector3 values")
    assert((A - B).Magnitude <= (Tolerance or 1e-5), string.format("Vector distance %.9g exceeded tolerance", (A - B).Magnitude))
end

local function MatrixNear(A, B, Tolerance)
    local RowsA, ColumnsA = LinearAlgebra.Dimensions(A)
    local RowsB, ColumnsB = LinearAlgebra.Dimensions(B)
    assert(RowsA == RowsB and ColumnsA == ColumnsB, "Matrix dimensions do not match")
    for Row = 1, RowsA do
        for Column = 1, ColumnsA do
            Near(A[Row][Column], B[Row][Column], Tolerance)
        end
    end
end

local function Check(Name, Callback)
    local Success, Failure = pcall(Callback)
    if Success then
        Passed += 1
        ActiveExperiment.Passed += 1
        print("[VectorForge Tester] PASS | " .. Name)
    else
        Failed += 1
        ActiveExperiment.Failed += 1
        warn("[VectorForge Tester] FAIL | " .. Name .. " | " .. tostring(Failure))
    end
    return Success, Failure
end

local function MakeFolder(Parent, Name)
    local Folder = Instance.new("Folder")
    Folder.Name = Name
    Folder.Parent = Parent
    return Folder
end

local function MakeMarker(Parent, Position, Color, Size, Name)
    local Part = Instance.new("Part")
    Part.Name = Name or "Sample"
    Part.Shape = Enum.PartType.Ball
    Part.Size = Vector3.new(Size or 0.65, Size or 0.65, Size or 0.65)
    Part.Position = Position
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Material = Enum.Material.Neon
    Part.Color = Color
    Part.Parent = Parent
    return Part
end

local function MakeSegment(Parent, A, B, Color, Thickness)
    local Delta = B - A
    if Delta.Magnitude <= 1e-5 then
        return nil
    end
    local Part = Instance.new("Part")
    Part.Name = "PathSegment"
    Part.Shape = Enum.PartType.Cylinder
    Part.Size = Vector3.new(Thickness or 0.16, Delta.Magnitude, Thickness or 0.16)
    Part.CFrame = CFrame.lookAt((A + B) * 0.5, B) * CFrame.Angles(math.pi * 0.5, 0, 0)
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Material = Enum.Material.Neon
    Part.Color = Color
    Part.Parent = Parent
    return Part
end

local function DrawPolyline(Parent, Points, Color, MarkerSize, Thickness)
    for Index, Point in ipairs(Points) do
        MakeMarker(Parent, Point, Color, MarkerSize, "Sample_" .. Index)
        if Index > 1 then
            MakeSegment(Parent, Points[Index - 1], Point, Color, Thickness)
        end
    end
end

local function RunExperiment(Index, Name, Origin, Callback)
    local Folder = MakeFolder(Workspace.VectorForgeTesterResults, string.format("%02d_%s", Index, Name:gsub("%s+", "")))
    ActiveExperiment = {Name = Name, Passed = 0, Failed = 0}
    print("[VectorForge Tester] EXPERIMENT " .. Index .. "/4 | " .. Name)
    local Success, Failure = pcall(Callback, Folder, Origin)
    if not Success then
        Failed += 1
        ActiveExperiment.Failed += 1
        warn("[VectorForge Tester] EXPERIMENT ERROR | " .. Name .. " | " .. tostring(Failure))
    end
    local Result = {
        Name = Name,
        Passed = ActiveExperiment.Passed,
        Failed = ActiveExperiment.Failed,
        Success = ActiveExperiment.Failed == 0,
    }
    table.insert(ExperimentResults, Result)
    local State = Result.Success and "PASS" or "FAIL"
    print(string.format("[VectorForge Tester] EXPERIMENT RESULT | %s | %d passed | %d failed | %s", Name, Result.Passed, Result.Failed, State))
    ActiveExperiment = nil
end

local PreviousResults = Workspace:FindFirstChild("VectorForgeTesterResults")
if PreviousResults then
    PreviousResults:Destroy()
end

local ResultsFolder = MakeFolder(Workspace, "VectorForgeTesterResults")

RunExperiment(1, "RoboticsAndTrajectory", Vector3.new(-120, 8, 0), function(Folder, Origin)
    local RotationA = Kinematics.Quaternion.Exp(Vector3.new(0.25, -0.35, 0.1))
    local RotationB = Kinematics.Quaternion.Exp(Vector3.new(-0.15, 0.55, 0.3))
    local IdentityQuaternion = Kinematics.Quaternion.New(1, 0, 0, 0)

    Check("Quaternion exponential and logarithm round-trip", function()
        local RotationVector = Vector3.new(0.25, -0.35, 0.1)
        local Recovered = Kinematics.Quaternion.Log(Kinematics.Quaternion.Exp(RotationVector))
        VectorNear(Recovered, RotationVector, 1e-5)
    end)

    Check("Quaternion multiplication and inverse", function()
        local Product = Kinematics.Quaternion.Multiply(RotationA, Kinematics.Quaternion.Inverse(RotationA))
        assert(Kinematics.Quaternion.Distance(Product, IdentityQuaternion) < 1e-5)
    end)

    Check("Quaternion slerp endpoints and axis-angle", function()
        local AtStart = Kinematics.Quaternion.Slerp(RotationA, RotationB, 0)
        local AtEnd = Kinematics.Quaternion.Slerp(RotationA, RotationB, 1)
        assert(Kinematics.Quaternion.Distance(AtStart, RotationA) < 1e-5)
        assert(Kinematics.Quaternion.Distance(AtEnd, RotationB) < 1e-5)
        local Axis, Angle = Kinematics.Quaternion.ToAxisAngle(RotationA)
        assert(Axis.Magnitude > 0.99 and Angle > 0)
    end)

    Check("Quaternion rotation-matrix conversion", function()
        local Matrix = Kinematics.Quaternion.ToRotationMatrix(RotationA)
        local Recovered = Kinematics.Quaternion.FromRotationMatrix(Matrix)
        assert(Kinematics.Quaternion.Distance(Recovered, RotationA) < 1e-5)
        Near(Kinematics.Quaternion.NormSquared(Kinematics.Quaternion.Normalize(RotationA)), 1, 1e-6)
    end)

    local PoseA = Kinematics.Pose.New(RotationA, Origin + Vector3.new(2, 2, 1))
    local PoseB = Kinematics.Pose.New(RotationB, Origin + Vector3.new(30, 10, 12))

    Check("SE(3) pose composition and inverse", function()
        local IdentityPose = Kinematics.Pose.Compose(PoseA, Kinematics.Pose.Inverse(PoseA))
        VectorNear(IdentityPose.Translation, Vector3.zero, 1e-5)
        assert(Kinematics.Quaternion.Distance(IdentityPose.Rotation, IdentityQuaternion) < 1e-5)
    end)

    Check("Pose point and vector transformations", function()
        local Point = Vector3.new(1, 2, 3)
        local Combined = Kinematics.Pose.Compose(PoseA, PoseB)
        local Direct = Kinematics.Pose.TransformPoint(Combined, Point)
        local Sequential = Kinematics.Pose.TransformPoint(PoseA, Kinematics.Pose.TransformPoint(PoseB, Point))
        VectorNear(Direct, Sequential, 1e-4)
        local TransformedVector = Kinematics.Pose.TransformVector(PoseA, Vector3.xAxis)
        assert(TransformedVector.Magnitude > 0.99)
    end)

    Check("CFrame conversion round-trip", function()
        local Frame = Kinematics.Pose.ToCFrame(PoseB)
        local Recovered = Kinematics.Pose.FromCFrame(Frame)
        VectorNear(Recovered.Translation, PoseB.Translation, 1e-5)
        assert(Kinematics.Quaternion.Distance(Recovered.Rotation, PoseB.Rotation) < 1e-4)
    end)

    Check("SE(3) logarithm and exponential round-trip", function()
        local Twist = Kinematics.Pose.Log(PoseA)
        local Recovered = Kinematics.Pose.Exp(Twist)
        VectorNear(Recovered.Translation, PoseA.Translation, 1e-4)
        assert(Kinematics.Quaternion.Distance(Recovered.Rotation, PoseA.Rotation) < 1e-4)
    end)

    Check("Screw interpolation produces a valid midpoint", function()
        local Midpoint = Kinematics.Pose.ScrewInterpolate(PoseA, PoseB, 0.5)
        assert(typeof(Midpoint.Translation) == "Vector3")
        assert(Midpoint.Rotation.W == Midpoint.Rotation.W)
        assert(Midpoint.Translation.Magnitude > 0)
    end)

    local Quintic = Trajectory.Quintic(0, 0, 0, 12, 0, 0, 3)
    local Trapezoid = Trajectory.Trapezoidal(12, 4, 2)
    local SCurve = Trajectory.SCurve(12, 4, 2, 4)

    Check("Quintic trajectory endpoint constraints", function()
        local StartPosition, StartVelocity, StartAcceleration = Quintic:Evaluate(0)
        local EndPosition, EndVelocity, EndAcceleration = Quintic:Evaluate(Quintic.Duration)
        Near(StartPosition, 0)
        Near(StartVelocity, 0)
        Near(StartAcceleration, 0)
        Near(EndPosition, 12)
        Near(EndVelocity, 0)
        Near(EndAcceleration, 0)
        assert(#Quintic:Sample(17) == 17)
    end)

    Check("Trapezoidal profile endpoint and bounds", function()
        local Position, Velocity, Acceleration = Trapezoid:Evaluate(Trapezoid.TotalTime)
        Near(Position, 12)
        Near(Velocity, 0)
        Near(Acceleration, 0)
        assert(Trapezoid.PeakVelocity <= 4 + 1e-5)
    end)

    Check("S-curve velocity, acceleration, and jerk limits", function()
        local Samples = SCurve:Sample(61)
        assert(#Samples == 61)
        for _, Sample in ipairs(Samples) do
            assert(math.abs(Sample.Velocity) <= 4 + 1e-5)
            assert(math.abs(Sample.Acceleration) <= 2 + 1e-5)
            assert(math.abs(Sample.Jerk) <= 4 + 1e-5)
        end
        Near(Samples[#Samples].Position, 12, 1e-4)
    end)

    Check("Path time-parameterization", function()
        local Path = PathGeometry.new({Origin, Origin + Vector3.new(12, 6, 4), Origin + Vector3.new(24, 0, 8)})
        local Timed = Trajectory.TimeParameterize(Path, 8, 12, 15)
        assert(#Timed == 15)
        Near(Timed[1].Speed, 0)
        Near(Timed[#Timed].Speed, 0)
        for Index = 2, #Timed do
            assert(Timed[Index].Time > Timed[Index - 1].Time)
            assert(Timed[Index].Speed <= 8 + 1e-5)
        end
    end)

    local VisualPoints = table.create(21)
    for Index = 1, 21 do
        local Alpha = (Index - 1) / 20
        local Pose = Kinematics.Pose.ScrewInterpolate(PoseA, PoseB, Alpha)
        VisualPoints[Index] = Pose.Translation
    end
    DrawPolyline(Folder, VisualPoints, Color3.fromRGB(185, 105, 255), 0.75, 0.18)
    MakeMarker(Folder, VisualPoints[1], Color3.fromRGB(80, 255, 150), 1.6, "RobotStart")
    MakeMarker(Folder, VisualPoints[#VisualPoints], Color3.fromRGB(255, 100, 100), 1.6, "RobotGoal")
end)

RunExperiment(2, "DynamicsAndStateEstimation", Vector3.new(-40, 8, 0), function(Folder, Origin)
    Check("Rigid-body linear force integration", function()
        local Body = Dynamics.new({Mass = 2, Inertia = Vector3.new(1, 1, 1), Gravity = Vector3.zero})
        Body:ApplyForce(Vector3.new(10, 0, 0))
        local State = Body:Step(0.1)
        Near(State.LinearVelocity.X, 0.5, 1e-5)
        Near(State.Position.X, 0.05, 1e-5)
        Near(State.LinearMomentum.X, 1, 1e-5)
    end)

    Check("Rigid-body torque and angular momentum", function()
        local Body = Dynamics.new({Mass = 3, Inertia = Vector3.new(1, 2, 3), Gravity = Vector3.zero})
        Body:ApplyTorque(Vector3.new(0, 0, 3))
        local State = Body:Step(0.1)
        assert(State.AngularVelocity.Magnitude > 0)
        assert(State.AngularMomentum.Magnitude > 0)
        local WorldInertia = Body:GetWorldInertia()
        assert(LinearAlgebra.Dimensions(WorldInertia) == 3)
    end)

    Check("Rigid-body impulse and reset", function()
        local Body = Dynamics.new({Mass = 2, Inertia = Vector3.one, Gravity = Vector3.zero})
        Body:ApplyImpulse(Vector3.new(4, 0, 0))
        Near(Body.LinearVelocity.X, 2)
        Body:Reset({Position = Vector3.new(3, 4, 5)})
        VectorNear(Body.Position, Vector3.new(3, 4, 5))
        VectorNear(Body.LinearVelocity, Vector3.zero)
    end)

    local EKF = Estimation.EKF.new({
        InitialState = {0, 1},
        InitialCovariance = {{1, 0}, {0, 1}},
        ProcessNoise = function(State, Control, DeltaTime)
            local Q = 0.001 * DeltaTime
            return {{Q, 0}, {0, Q * 5}}
        end,
        MeasurementNoise = function(State, Observation)
            return {{0.05}}
        end,
        MeasurementDimension = 1,
        JacobianMethod = "automatic",
        AdaptiveNoise = {Rate = 0.04, MinimumScale = 0.5, MaximumScale = 4},
        GateThreshold = 50,
        Transition = function(State, Control, DeltaTime)
            local Acceleration = Control or 0
            return {
                State[1] + State[2] * DeltaTime + 0.5 * Acceleration * DeltaTime * DeltaTime,
                State[2] + Acceleration * DeltaTime,
            }
        end,
        Measurement = function(State)
            return {State[1]}
        end,
    })

    Check("EKF prediction with callback process noise and automatic Jacobian", function()
        local Estimate = EKF:Predict(0.2, 0.1)
        assert(Estimate.Method == "EKF")
        Near(Estimate.Time, 0.1)
        assert(Estimate.Covariance[1][1] > 0)
    end)

    Check("EKF callback measurement noise and adaptive update", function()
        local Accepted, Report = EKF:Update({0.11})
        assert(Accepted, Report and Report.Reason or "EKF rejected a nominal observation")
        assert(Report.Accepted)
        local Estimate = EKF:GetEstimate()
        assert(Estimate.AcceptedMeasurements == 1)
        assert(Estimate.AdaptiveNoiseScale >= 0.5 and Estimate.AdaptiveNoiseScale <= 4)
    end)

    Check("EKF batched measurements and state assignment", function()
        local Results, Estimate = EKF:UpdateBatch({{0.2}, {0.21}})
        assert(#Results == 2)
        assert(Estimate.AcceptedMeasurements >= 2)
        local Updated = EKF:SetState({1, 0.5})
        Near(Updated.State[1], 1)
        Near(Updated.State[2], 0.5)
    end)

    Check("EKF innovation gate rejects an extreme outlier", function()
        local Gate = Estimation.EKF.new({
            InitialState = {0},
            InitialCovariance = {{1}},
            ProcessNoise = {{0}},
            MeasurementNoise = {{0.1}},
            GateThreshold = 0.2,
            Transition = function(State)
                return {State[1]}
            end,
            Measurement = function(State)
                return {State[1]}
            end,
        })
        local Accepted, Report = Gate:Update({100})
        assert(not Accepted)
        assert(not Report.Accepted)
        assert(Gate:GetEstimate().RejectedMeasurements == 1)
    end)

    Check("EKF reset clears time and counters", function()
        local Reset = EKF:Reset({0, 1})
        Near(Reset.Time, 0)
        assert(Reset.AcceptedMeasurements == 0 and Reset.RejectedMeasurements == 0)
    end)

    local UKF = Estimation.UKF.new({
        InitialState = {0.5},
        InitialCovariance = {{0.2}},
        ProcessNoise = {{0.01}},
        MeasurementNoise = function()
            return {{0.05}}
        end,
        MeasurementDimension = 1,
        Alpha = 0.3,
        Beta = 2,
        Kappa = 0,
        Transition = function(State, Control, DeltaTime)
            return {State[1] + DeltaTime * 0.1 * State[1] * State[1]}
        end,
        Measurement = function(State)
            return {State[1] * State[1]}
        end,
    })

    Check("UKF nonlinear sigma-point prediction and update", function()
        local Estimate = UKF:Predict(nil, 0.02)
        assert(Estimate.Method == "UKF")
        local Accepted, Report = UKF:Update({0.26})
        assert(Accepted, Report and Report.Reason or "UKF rejected a nominal observation")
        assert(UKF:GetEstimate().AcceptedMeasurements == 1)
    end)

    Check("UKF batch update and reset", function()
        local Results = UKF:UpdateBatch({{0.25}, {0.255}})
        assert(#Results == 2)
        local Estimate = UKF:Reset({0.5})
        Near(Estimate.Time, 0)
        assert(Estimate.AcceptedMeasurements == 0)
    end)

    Check("Independent Gaussian sensor fusion", function()
        local Fused = Estimation.FuseEstimates({
            {State = {0, 2}, Covariance = {{1, 0}, {0, 4}}},
            {State = {2, 0}, Covariance = {{1, 0}, {0, 1}}},
        })
        Near(Fused.State[1], 1)
        Near(Fused.State[2], 0.4)
        Near(Fused.Covariance[1][1], 0.5)
        Near(Fused.Covariance[2][2], 0.8)
    end)

    local Body = Dynamics.new({
        Mass = 4,
        Inertia = Vector3.new(2, 3, 4),
        Position = Origin + Vector3.new(0, 2, 0),
        Gravity = Vector3.zero,
        LinearDamping = 0.02,
        AngularDamping = 0.03,
    })
    local ActualPoints = {}
    for Index = 1, 36 do
        Body:ApplyForce(Vector3.new(8, 0, 1))
        Body:ApplyTorque(Vector3.new(0, 0.4, 0.2))
        local State = Body:Step(1 / 30)
        if Index % 3 == 0 then
            table.insert(ActualPoints, State.Position)
        end
    end
    DrawPolyline(Folder, ActualPoints, Color3.fromRGB(70, 190, 255), 0.7, 0.16)

    local EstimatedPoints = {}
    for Index = 1, 15 do
        local Position = Origin + Vector3.new(Index * 2, 5 + math.sin(Index * 0.4), 3)
        table.insert(EstimatedPoints, Position)
    end
    DrawPolyline(Folder, EstimatedPoints, Color3.fromRGB(255, 205, 70), 0.55, 0.12)
    MakeMarker(Folder, ActualPoints[1], Color3.fromRGB(70, 255, 150), 1.4, "ActualStart")
    MakeMarker(Folder, ActualPoints[#ActualPoints], Color3.fromRGB(255, 100, 100), 1.4, "ActualEnd")
end)

RunExperiment(3, "NumericalMathematicsAndOptimization", Vector3.new(40, 8, 0), function(Folder, Origin)
    local A = {{4, 1}, {1, 3}}
    local B = {1, 2}

    Check("Dense linear solve and multiple right-hand sides", function()
        local Solution = LinearAlgebra.Solve(A, B)
        Near(Solution[1], 1 / 11)
        Near(Solution[2], 7 / 11)
        local Multiple = LinearAlgebra.SolveMultiple(A, {{1, 0}, {2, 1}})
        assert(LinearAlgebra.Dimensions(Multiple) == 2)
    end)

    Check("LU factorization, determinant, and inverse", function()
        local LU, Permutation, Parity = LinearAlgebra.LUFactor(A)
        assert(LU and #Permutation == 2 and (Parity == 1 or Parity == -1))
        Near(LinearAlgebra.Determinant(A), 11)
        local Inverse = LinearAlgebra.Inverse(A)
        local Product = LinearAlgebra.Multiply(A, Inverse)
        MatrixNear(Product, LinearAlgebra.Identity(2), 1e-5)
    end)

    Check("Matrix utilities and outer product", function()
        Near(LinearAlgebra.Trace(A), 7)
        assert(LinearAlgebra.FrobeniusNorm(A) > 5)
        local Outer = LinearAlgebra.Outer({1, 2}, {3, 4})
        MatrixNear(Outer, {{3, 4}, {6, 8}})
        MatrixNear(LinearAlgebra.Symmetrize({{1, 2}, {4, 3}}), {{1, 3}, {3, 3}})
        assert(LinearAlgebra.Dimensions(LinearAlgebra.Transpose(A)) == 2)
    end)

    Check("Cholesky factorization", function()
        local Factor = LinearAlgebra.Cholesky(A)
        assert(Factor)
        MatrixNear(LinearAlgebra.Multiply(Factor, LinearAlgebra.Transpose(Factor)), A, 1e-5)
    end)

    Check("Householder QR factorization", function()
        local Matrix = {{1, 2}, {3, 4}, {5, 7}}
        local Q, R = LinearAlgebra.QR(Matrix)
        MatrixNear(LinearAlgebra.Multiply(Q, R), Matrix, 1e-5)
        MatrixNear(LinearAlgebra.Multiply(LinearAlgebra.Transpose(Q), Q), LinearAlgebra.Identity(3), 1e-5)
    end)

    Check("Least-squares linear regression", function()
        local Solution = LinearAlgebra.LeastSquares({{1, 0}, {1, 1}, {1, 2}, {1, 3}}, {1, 3, 5, 7})
        Near(Solution[1], 1, 1e-5)
        Near(Solution[2], 2, 1e-5)
    end)

    Check("Symmetric eigenvalue decomposition", function()
        local Values, Vectors, Status = LinearAlgebra.SymmetricEigen(A)
        assert(Status.Converged)
        Near(Values[1], (7 + math.sqrt(5)) / 2, 1e-5)
        Near(Values[2], (7 - math.sqrt(5)) / 2, 1e-5)
        assert(LinearAlgebra.Dimensions(Vectors) == 2)
    end)

    Check("Conjugate gradient and preconditioned conjugate gradient", function()
        local CG, CGStatus = LinearAlgebra.ConjugateGradient(A, B)
        local PCG, PCGStatus = LinearAlgebra.PreconditionedConjugateGradient(A, B, {{4, 0}, {0, 3}})
        assert(CGStatus.Converged and PCGStatus.Converged)
        Near(CG[1], 1 / 11, 1e-6)
        Near(PCG[2], 7 / 11, 1e-6)
    end)

    Check("Jacobi and Gauss-Seidel iterative solvers", function()
        local Jacobi, JacobiStatus = LinearAlgebra.Jacobi(A, B, nil, 1e-10, 1000)
        local GaussSeidel, GaussSeidelStatus = LinearAlgebra.GaussSeidel(A, B, nil, 1e-10, 1000)
        assert(JacobiStatus.Converged and GaussSeidelStatus.Converged)
        Near(Jacobi[1], 1 / 11, 1e-7)
        Near(GaussSeidel[2], 7 / 11, 1e-7)
    end)

    Check("Tall and wide SVD reconstruction and rank", function()
        local Tall = {{1, 2}, {3, 4}, {5, 6}}
        local U, SingularValues, V, Status = LinearAlgebra.SVD(Tall)
        assert(Status.Converged)
        local Sigma = LinearAlgebra.Zeros(#SingularValues, #SingularValues)
        for Index = 1, #SingularValues do
            Sigma[Index][Index] = SingularValues[Index]
        end
        MatrixNear(LinearAlgebra.Multiply(LinearAlgebra.Multiply(U, Sigma), LinearAlgebra.Transpose(V)), Tall, 1e-4)
        assert(LinearAlgebra.Rank(Tall) == 2)
        local Wide = {{1, 2, 3}, {4, 5, 6}}
        local WideU, WideS, WideV, WideStatus = LinearAlgebra.SVD(Wide)
        assert(WideStatus.Converged)
        local WideSigma = LinearAlgebra.Zeros(#WideS, #WideS)
        for Index = 1, #WideS do
            WideSigma[Index][Index] = WideS[Index]
        end
        MatrixNear(LinearAlgebra.Multiply(LinearAlgebra.Multiply(WideU, WideSigma), LinearAlgebra.Transpose(WideV)), Wide, 1e-4)
    end)

    Check("Sparse matrix storage, transpose, and conjugate gradient", function()
        local Sparse = LinearAlgebra.SparseMatrix.new(2, 2, {
            {Row = 1, Column = 1, Value = 4},
            {Row = 1, Column = 2, Value = 1},
            {Row = 2, Column = 1, Value = 1},
            {Row = 2, Column = 2, Value = 3},
        })
        assert(Sparse:NonzeroCount() == 4)
        Near(Sparse:Get(2, 2), 3)
        local Product = Sparse:MultiplyVector(B)
        Near(Product[1], 6)
        Near(Product[2], 7)
        local Transposed = Sparse:Transpose()
        MatrixNear(Transposed:ToDense(), A)
        Sparse:Set(1, 2, 0)
        assert(Sparse:NonzeroCount() == 3)
        local Symmetric = LinearAlgebra.SparseMatrix.new(2, 2, {
            {Row = 1, Column = 1, Value = 4},
            {Row = 1, Column = 2, Value = 1},
            {Row = 2, Column = 1, Value = 1},
            {Row = 2, Column = 2, Value = 3},
        })
        local Solution, Status = LinearAlgebra.SparseConjugateGradient(Symmetric, B)
        assert(Status.Converged)
        Near(Solution[1], 1 / 11, 1e-6)
    end)

    Check("Automatic differentiation scalar derivative", function()
        local Derivative = AD.Derivative(function(X)
            return X ^ 3 + AD.Sin(X)
        end, 2)
        Near(Derivative, 12 + math.cos(2), 1e-6)
    end)

    Check("Automatic differentiation gradient, Jacobian, and Hessian", function()
        local Function = function(X)
            return X[1] * X[1] + 3 * X[1] * X[2] + 2 * X[2] * X[2]
        end
        local Gradient, Value = AD.Gradient(Function, {2, 3})
        Near(Value, 40)
        Near(Gradient[1], 13)
        Near(Gradient[2], 18)
        local Jacobian, Output = AD.Jacobian(function(X)
            return {X[1] * X[2], AD.Sin(X[1]) + X[2] * X[2]}
        end, {2, 3})
        MatrixNear(Jacobian, {{3, 2}, {math.cos(2), 6}}, 1e-5)
        Near(Output[1], 6)
        Near(Output[2], math.sin(2) + 9)
        MatrixNear(AD.Hessian(Function, {2, 3}), {{2, 3}, {3, 4}}, 1e-3)
    end)

    local Objective = function(X)
        return (X[1] - 3) ^ 2 + 2 * (X[2] + 2) ^ 2
    end
    local BFGSSolution
    local BFGSStatus

    Check("Gradient descent optimization", function()
        local Solution, Status = Optimization.GradientDescent(Objective, {0, 0}, {MaximumIterations = 1000, Tolerance = 1e-6})
        assert(Status.Converged, Status.Reason or "Gradient descent did not converge")
        Near(Solution[1], 3, 1e-3)
        Near(Solution[2], -2, 1e-3)
    end)

    Check("Newton optimization", function()
        local Solution, Status = Optimization.Newton(Objective, {0, 0}, {MaximumIterations = 30, Tolerance = 1e-6})
        assert(Status.Converged, Status.Reason or "Newton method did not converge")
        Near(Solution[1], 3, 1e-3)
        Near(Solution[2], -2, 1e-3)
    end)

    Check("BFGS optimization and convergence history", function()
        BFGSSolution, BFGSStatus = Optimization.BFGS(Objective, {0, 0}, {MaximumIterations = 100, Tolerance = 1e-6})
        assert(BFGSStatus.Converged, BFGSStatus.Reason or "BFGS did not converge")
        Near(BFGSSolution[1], 3, 1e-3)
        Near(BFGSSolution[2], -2, 1e-3)
        assert(type(BFGSStatus.History) == "table" and #BFGSStatus.History > 0)
    end)

    Check("Levenberg-Marquardt nonlinear least squares", function()
        local Solution, Status = Optimization.LevenbergMarquardt(function(X)
            return {X[1] - 2, 2 * (X[2] + 1)}
        end, {0, 0})
        assert(Status.Converged, Status.Reason or "Levenberg-Marquardt did not converge")
        Near(Solution[1], 2, 1e-3)
        Near(Solution[2], -1, 1e-3)
    end)

    if BFGSStatus and BFGSStatus.History then
        local PlotPoints = {}
        for Index, Entry in ipairs(BFGSStatus.History) do
            local Height = math.log(1 + math.max(Entry.Value, 0)) * 2
            table.insert(PlotPoints, Origin + Vector3.new(Index * 1.4, Height, 0))
        end
        if #PlotPoints > 1 then
            DrawPolyline(Folder, PlotPoints, Color3.fromRGB(95, 255, 180), 0.55, 0.12)
        end
    end
    MakeMarker(Folder, Origin, Color3.fromRGB(255, 190, 70), 1.2, "OptimizationOrigin")
end)

RunExperiment(4, "DifferentialGeometryAndPathPlanning", Vector3.new(100, 8, 0), function(Folder, Origin)
    local Points = {
        Origin + Vector3.new(0, 3, 0),
        Origin + Vector3.new(10, 13, 5),
        Origin + Vector3.new(20, 2, 10),
        Origin + Vector3.new(30, 12, 2),
    }
    local Hermite = PathGeometry.new(Points)
    local Bezier = PathGeometry.Bezier.new(Points)
    local CatmullRom = PathGeometry.CatmullRom.new(Points)
    local BSpline = PathGeometry.BSpline.new(Points, 3)

    Check("Hermite curve interpolation and derivatives", function()
        VectorNear(Hermite:Evaluate(0), Points[1], 1e-5)
        VectorNear(Hermite:Evaluate(1), Points[#Points], 1e-5)
        assert(Hermite:Derivative(0.5, 1).Magnitude > 0)
        assert(Hermite:Derivative(0.5, 2).Magnitude >= 0)
        assert(Hermite:Derivative(0.5, 3).Magnitude >= 0)
    end)

    Check("Cubic Bezier endpoints and derivatives", function()
        VectorNear(Bezier:Evaluate(0), Points[1], 1e-5)
        VectorNear(Bezier:Evaluate(1), Points[4], 1e-5)
        assert(Bezier:Derivative(0.5, 1).Magnitude > 0)
    end)

    Check("Catmull-Rom and B-spline endpoint behavior", function()
        VectorNear(CatmullRom:Evaluate(0), Points[1], 1e-4)
        VectorNear(CatmullRom:Evaluate(1), Points[#Points], 1e-4)
        VectorNear(BSpline:Evaluate(0), Points[1], 1e-4)
        VectorNear(BSpline:Evaluate(1), Points[#Points], 1e-4)
    end)

    Check("Arc length and inverse arc-length parameterization", function()
        for _, Curve in ipairs({Hermite, Bezier, CatmullRom, BSpline}) do
            assert(Curve:ArcLength() > 0)
            local HalfDistance = Curve:ArcLength() * 0.5
            local Parameter = Curve:ParameterAtArcLength(HalfDistance)
            assert(Parameter > 0 and Parameter < 1)
            Near(Curve:ArcLengthAt(Parameter), HalfDistance, 2e-3)
        end
    end)

    Check("Equal arc-length sampling and curvature/torsion", function()
        local Samples = Bezier:SampleByArcLength(17)
        assert(#Samples == 17)
        assert(Bezier:Curvature(0.5) >= 0)
        local Torsion = Bezier:Torsion(0.5)
        assert(Torsion == Torsion and math.abs(Torsion) < math.huge)
        assert(Samples[1].Distance == 0)
        Near(Samples[#Samples].Distance, Bezier:ArcLength(), 1e-5)
    end)

    Check("Frenet and parallel-transport frames", function()
        local Frenet = Bezier:FrenetFrame(0.5, Vector3.yAxis)
        assert(Frenet and Frenet.Tangent.Magnitude > 0.99)
        assert(Frenet.Normal.Magnitude > 0.99)
        assert(Frenet.Binormal.Magnitude > 0.99)
        local Frames = Bezier:ParallelTransportFrames(19, Vector3.yAxis)
        assert(#Frames == 19)
        for _, Frame in ipairs(Frames) do
            Near(Frame.Tangent.Magnitude, 1, 1e-4)
            Near(Frame.Normal.Magnitude, 1, 1e-4)
            Near(Frame.Binormal.Magnitude, 1, 1e-4)
            Near(Frame.Tangent:Dot(Frame.Normal), 0, 1e-4)
        end
    end)

    Check("Closest-point parameter search", function()
        local Target = Bezier:Evaluate(0.4)
        local Parameter, Position = Bezier:ClosestParameter(Target, 96, 20)
        Near(Parameter, 0.4, 2e-3)
        VectorNear(Position, Target, 1e-3)
    end)

    Check("Minimum-jerk position, velocity, and acceleration", function()
        local Position0, Velocity0, Acceleration0 = PathGeometry.MinimumJerk(0, 10, 2, 0)
        local Position1, Velocity1, Acceleration1 = PathGeometry.MinimumJerk(0, 10, 2, 2)
        Near(Position0, 0)
        Near(Velocity0, 0)
        Near(Acceleration0, 0)
        Near(Position1, 10)
        Near(Velocity1, 0)
        Near(Acceleration1, 0)
    end)

    Check("Clear path validation", function()
        local ClearWorld = {Raycast = function()
            return nil
        end}
        local Clear = PathGeometry.PathIsClear({Points[1], Points[4]}, nil, ClearWorld)
        assert(Clear)
        local Path, Status = PathGeometry.GenerateCollisionAwarePath(Points[1], Points[4], nil, {World = ClearWorld})
        assert(Path and Status.Direct and not Status.Detour)
    end)

    local PlaneX = Origin.X + 10
    local BarrierHeight = Origin.Y + 10
    local ObstructedWorld = {}
    function ObstructedWorld:Raycast(RayOrigin, RayDirection)
        local Finish = RayOrigin + RayDirection
        local DeltaX = Finish.X - RayOrigin.X
        if math.abs(DeltaX) <= 1e-8 then
            return nil
        end
        local Alpha = (PlaneX - RayOrigin.X) / DeltaX
        if Alpha < 0 or Alpha > 1 then
            return nil
        end
        local HitPosition = RayOrigin + RayDirection * Alpha
        if HitPosition.Y < BarrierHeight then
            return {Position = HitPosition, Normal = Vector3.xAxis}
        end
        return nil
    end

    local DetourStart = Origin + Vector3.new(0, 3, 25)
    local DetourGoal = Origin + Vector3.new(20, 3, 25)
    local DetourPath

    Check("Collision-aware detour generation and revalidation", function()
        DetourPath = PathGeometry.GenerateCollisionAwarePath(DetourStart, DetourGoal, nil, {
            World = ObstructedWorld,
            Padding = 12,
        })
        assert(DetourPath and #DetourPath == 3)
        local Clear = PathGeometry.PathIsClear(DetourPath, nil, ObstructedWorld)
        assert(Clear)
    end)

    local CurveDefinitions = {
        {Path = Hermite, Color = Color3.fromRGB(120, 190, 255), Name = "Hermite"},
        {Path = Bezier, Color = Color3.fromRGB(200, 115, 255), Name = "Bezier"},
        {Path = CatmullRom, Color = Color3.fromRGB(80, 255, 180), Name = "CatmullRom"},
        {Path = BSpline, Color = Color3.fromRGB(255, 190, 70), Name = "BSpline"},
    }
    for CurveIndex, Definition in ipairs(CurveDefinitions) do
        local Samples = Definition.Path:SampleByArcLength(15)
        local Visual = MakeFolder(Folder, Definition.Name)
        local Shifted = table.create(#Samples)
        local Shift = Vector3.new(0, 0, (CurveIndex - 1) * 4)
        for Index, Sample in ipairs(Samples) do
            Shifted[Index] = Sample.Position + Shift
        end
        DrawPolyline(Visual, Shifted, Definition.Color, 0.48, 0.1)
    end

    local Wall = Instance.new("Part")
    Wall.Name = "VisualizedObstacle"
    Wall.Size = Vector3.new(2, 8, 8)
    Wall.Position = Origin + Vector3.new(10, 3, 25)
    Wall.Anchored = true
    Wall.CanCollide = false
    Wall.CanTouch = false
    Wall.CanQuery = false
    Wall.Transparency = 0.3
    Wall.Material = Enum.Material.ForceField
    Wall.Color = Color3.fromRGB(255, 85, 85)
    Wall.Parent = Folder

    if DetourPath then
        DrawPolyline(Folder, DetourPath, Color3.fromRGB(255, 245, 90), 0.95, 0.2)
    end
end)

local TotalExperimentsPassed = 0
local TotalExperimentsFailed = 0
for _, Result in ipairs(ExperimentResults) do
    if Result.Success then
        TotalExperimentsPassed += 1
    else
        TotalExperimentsFailed += 1
    end
end

print("[VectorForge Tester] ========================================")
print(string.format("[VectorForge Tester] EXPERIMENTS | %d passed | %d failed | %d total", TotalExperimentsPassed, TotalExperimentsFailed, #ExperimentResults))
print(string.format("[VectorForge Tester] CHECKS | %d passed | %d failed | %d total", Passed, Failed, Passed + Failed))
print("[VectorForge Tester] VISUAL OUTPUT | Workspace.VectorForgeTesterResults")
print("[VectorForge Tester] ========================================")

if Failed > 0 then
    warn("[VectorForge Tester] Completed with failures. Review every FAIL line in the Output window.")
else
    print("[VectorForge Tester] ALL EXPERIMENTS AND CHECKS PASSED")
end
