local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("VectorForge")

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

local function Near(A, B, Tolerance)
    return math.abs(A - B) <= (Tolerance or 1e-5)
end

local function Check(Name, Callback)
    local Success, Failure = pcall(Callback)
    if Success then
        Passed += 1
        print("[VectorForge] PASS " .. Name)
    else
        Failed += 1
        warn("[VectorForge] FAIL " .. Name .. ": " .. tostring(Failure))
    end
end

Check("Linear solve and inverse", function()
    local A = {{4, 1}, {1, 3}}
    local X = LinearAlgebra.Solve(A, {1, 2})
    assert(Near(X[1], 1 / 11) and Near(X[2], 7 / 11))
    local Inverse = LinearAlgebra.Inverse(A)
    local Product = LinearAlgebra.Multiply(A, Inverse)
    assert(Near(Product[1][1], 1) and Near(Product[2][2], 1))
end)

Check("SVD reconstruction", function()
    local A = {{1, 2}, {3, 4}, {5, 6}}
    local U, SingularValues, V, Status = LinearAlgebra.SVD(A)
    local Diagonal = {{SingularValues[1], 0}, {0, SingularValues[2]}}
    local Reconstructed = LinearAlgebra.Multiply(LinearAlgebra.Multiply(U, Diagonal), LinearAlgebra.Transpose(V))
    assert(Status.Converged)
    for Row = 1, 3 do
        for Column = 1, 2 do
            assert(Near(Reconstructed[Row][Column], A[Row][Column], 1e-4))
        end
    end
    local Wide = {{1, 2, 3}, {4, 5, 6}}
    local WideU, WideS, WideV, WideStatus = LinearAlgebra.SVD(Wide)
    local WideDiagonal = {{WideS[1], 0}, {0, WideS[2]}}
    local WideReconstructed = LinearAlgebra.Multiply(LinearAlgebra.Multiply(WideU, WideDiagonal), LinearAlgebra.Transpose(WideV))
    assert(WideStatus.Converged)
    for Row = 1, 2 do
        for Column = 1, 3 do
            assert(Near(WideReconstructed[Row][Column], Wide[Row][Column], 1e-4))
        end
    end
end)

Check("Iterative dense and sparse solvers", function()
    local A = {{4, 1}, {1, 3}}
    local B = {1, 2}
    local X, Status = LinearAlgebra.PreconditionedConjugateGradient(A, B, {{4, 0}, {0, 3}})
    assert(Status.Converged and Near(X[1], 1 / 11) and Near(X[2], 7 / 11))
    local Sparse = LinearAlgebra.SparseMatrix.new(2, 2, {
        {Row = 1, Column = 1, Value = 4},
        {Row = 1, Column = 2, Value = 1},
        {Row = 2, Column = 1, Value = 1},
        {Row = 2, Column = 2, Value = 3},
    })
    local SparseX, SparseStatus = LinearAlgebra.SparseConjugateGradient(Sparse, B)
    assert(SparseStatus.Converged and Near(SparseX[1], 1 / 11) and Near(SparseX[2], 7 / 11))
end)

Check("Automatic differentiation gradient", function()
    local Gradient, Value = AD.Gradient(function(X)
        return AD.Sin(X[1]) * X[2] + X[1] ^ 2
    end, {2, 3})
    assert(Near(Value, math.sin(2) * 3 + 4))
    assert(Near(Gradient[1], math.cos(2) * 3 + 4))
    assert(Near(Gradient[2], math.sin(2)))
end)

Check("Quaternion and CFrame conversions", function()
    local Rotation = Kinematics.Quaternion.Exp(Vector3.new(0.2, -0.4, 0.1))
    local Pose = Kinematics.Pose.New(Rotation, Vector3.new(4, 5, 6))
    local RoundTrip = Kinematics.Pose.FromCFrame(Kinematics.Pose.ToCFrame(Pose))
    assert(Kinematics.Quaternion.Distance(Pose.Rotation, RoundTrip.Rotation) < 1e-4)
    assert((Pose.Translation - RoundTrip.Translation).Magnitude < 1e-5)
end)

Check("Hermite, Bezier, Catmull-Rom and B-spline paths", function()
    local Points = {Vector3.new(0, 0, 0), Vector3.new(5, 5, 0), Vector3.new(10, 0, 0), Vector3.new(15, 5, 0)}
    local Hermite = PathGeometry.new(Points)
    local Bezier = PathGeometry.Bezier.new({Points[1], Points[2], Points[3], Points[4]})
    local Catmull = PathGeometry.CatmullRom.new(Points)
    local BSpline = PathGeometry.BSpline.new(Points, 3)
    assert((Hermite:Evaluate(0) - Points[1]).Magnitude < 1e-5)
    assert((Bezier:Evaluate(0) - Points[1]).Magnitude < 1e-5)
    assert((Bezier:Evaluate(1) - Points[4]).Magnitude < 1e-5)
    assert((Catmull:Evaluate(0) - Points[1]).Magnitude < 1e-5)
    assert((BSpline:Evaluate(0) - Points[1]).Magnitude < 1e-5)
    assert((BSpline:Evaluate(1) - Points[4]).Magnitude < 1e-5)
    assert(Bezier:ArcLength() > 0)
    assert(#Bezier:SampleByArcLength(8) == 8)
    assert(#Bezier:ParallelTransportFrames(8) == 8)
    assert(#Catmull:SampleByArcLength(8) == 8)
end)

Check("Raycast path validation and detour suggestion", function()
    local ClearWorld = {Raycast = function()
        return nil
    end}
    local IsClear = PathGeometry.PathIsClear({Vector3.zero, Vector3.new(10, 0, 0)}, nil, ClearWorld)
    assert(IsClear)
    local Calls = 0
    local Hit = {Position = Vector3.new(5, 0, 0), Normal = Vector3.yAxis}
    local ObstructedWorld = {Raycast = function()
        Calls += 1
        return Calls == 1 and Hit or nil
    end}
    local Detour, Status = PathGeometry.GenerateCollisionAwarePath(Vector3.zero, Vector3.new(10, 0, 0), nil, {World = ObstructedWorld, Padding = 5})
    assert(Detour and #Detour == 3 and Status.Detour)
end)

Check("EKF callback noise and update", function()
    local Filter = Estimation.EKF.new({
        InitialState = {0},
        InitialCovariance = {{1}},
        ProcessNoise = function()
            return {{0.01}}
        end,
        MeasurementNoise = function()
            return {{0.1}}
        end,
        MeasurementDimension = 1,
        JacobianMethod = "automatic",
        AdaptiveNoise = {Rate = 0.05, MinimumScale = 0.1, MaximumScale = 10},
        Transition = function(State, Control, DeltaTime)
            return {State[1] + (Control or 0) * DeltaTime}
        end,
        Measurement = function(State)
            return {AD.Sin(State[1])}
        end,
    })
    Filter:Predict(1, 0.1)
    local Accepted = Filter:Update({math.sin(0.1)})
    assert(Accepted)
    assert(Filter:GetEstimate().AcceptedMeasurements == 1)
    assert(Filter:GetEstimate().AdaptiveNoiseScale ~= 1)
end)

Check("UKF nonlinear prediction and update", function()
    local Filter = Estimation.UKF.new({
        InitialState = {0.5},
        InitialCovariance = {{0.2}},
        ProcessNoise = {{0.01}},
        MeasurementNoise = {{0.05}},
        Transition = function(State, Control, DeltaTime)
            return {State[1] + DeltaTime * State[1] * State[1]}
        end,
        Measurement = function(State)
            return {State[1] * State[1]}
        end,
        Alpha = 0.2,
        Beta = 2,
        Kappa = 0,
    })
    Filter:Predict(nil, 0.01)
    local Accepted = Filter:Update({0.3})
    assert(Accepted)
    assert(Filter:GetEstimate().AcceptedMeasurements == 1)
end)

Check("Independent Gaussian sensor fusion", function()
    local Fused = Estimation.FuseEstimates({
        {State = {0}, Covariance = {{1}}},
        {State = {2}, Covariance = {{1}}},
    })
    assert(Near(Fused.State[1], 1) and Near(Fused.Covariance[1][1], 0.5))
end)

Check("Rigid-body force integration", function()
    local Body = Dynamics.new({
        Mass = 2,
        Inertia = Vector3.new(1, 1, 1),
        Gravity = Vector3.zero,
    })
    Body:ApplyForce(Vector3.new(10, 0, 0))
    local State = Body:Step(0.1)
    assert(Near(State.LinearVelocity.X, 0.5))
    assert(Near(State.Position.X, 0.05))
end)

Check("Gradient descent and BFGS", function()
    local Objective = function(X)
        return (X[1] - 3) ^ 2 + 2 * (X[2] + 2) ^ 2
    end
    local GD, GDStatus = Optimization.GradientDescent(Objective, {0, 0}, {MaximumIterations = 1000, Tolerance = 1e-6})
    assert(GDStatus.Converged and Near(GD[1], 3, 1e-3) and Near(GD[2], -2, 1e-3))
    local BFGS, BFGSStatus = Optimization.BFGS(Objective, {0, 0}, {MaximumIterations = 100, Tolerance = 1e-6})
    assert(BFGSStatus.Converged and Near(BFGS[1], 3, 1e-3) and Near(BFGS[2], -2, 1e-3))
end)

Check("Levenberg-Marquardt least squares", function()
    local Solution, Status = Optimization.LevenbergMarquardt(function(X)
        return {X[1] - 2, 2 * (X[2] + 1)}
    end, {0, 0})
    assert(Status.Converged and Near(Solution[1], 2, 1e-3) and Near(Solution[2], -1, 1e-3))
end)

Check("Quintic, trapezoidal and S-curve profiles", function()
    local Quintic = Trajectory.Quintic(0, 0, 0, 10, 0, 0, 2)
    local Position, Velocity, Acceleration = Quintic:Evaluate(2)
    assert(Near(Position, 10) and Near(Velocity, 0) and Near(Acceleration, 0))
    local Trapezoid = Trajectory.Trapezoidal(10, 4, 2)
    local TrapezoidPosition, TrapezoidVelocity = Trapezoid:Evaluate(Trapezoid.TotalTime)
    assert(Near(TrapezoidPosition, 10) and Near(TrapezoidVelocity, 0))
    local SCurve = Trajectory.SCurve(10, 4, 2, 4)
    local SCurvePosition, SCurveVelocity = SCurve:Evaluate(SCurve.TotalTime)
    assert(Near(SCurvePosition, 10, 1e-4) and Near(SCurveVelocity, 0))
    local TimedPath = Trajectory.TimeParameterize(PathGeometry.new({Vector3.zero, Vector3.new(0, 0, 10)}), 5, 10, 8)
    assert(#TimedPath == 8 and TimedPath[1].Speed == 0 and TimedPath[#TimedPath].Speed == 0)
end)

print(string.format("[VectorForge] Completed: %d passed, %d failed", Passed, Failed))
assert(Failed == 0, "VectorForge test suite reported failures")
