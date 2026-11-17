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

local Gradient, ObjectiveValue = AD.Gradient(function(X)
    return AD.Sin(X[1]) * X[2] + X[1] ^ 2
end, {2, 3})

local Quaternion = Kinematics.Quaternion.Exp(Vector3.new(0.1, 0.2, 0))
local Pose = Kinematics.Pose.New(Quaternion, Vector3.new(5, 3, 1))
local Frame = Kinematics.Pose.ToCFrame(Pose)

local Curve = PathGeometry.Bezier.new({
    Vector3.new(0, 3, 0),
    Vector3.new(8, 12, 0),
    Vector3.new(16, 12, 8),
    Vector3.new(24, 3, 8),
})

local PathSamples = Curve:SampleByArcLength(24)
local TimedPath = Trajectory.TimeParameterize(Curve, 12, 20, 24)

local Body = Dynamics.new({
    Mass = 5,
    Inertia = Vector3.new(2, 3, 4),
    Position = Vector3.new(0, 10, 0),
})
Body:ApplyForce(Vector3.new(10, 0, 0))
local BodyState = Body:Step(1 / 60)

local Estimator = Estimation.UKF.new({
    InitialState = {0, 1},
    InitialCovariance = {{1, 0}, {0, 1}},
    ProcessNoise = {{0.01, 0}, {0, 0.01}},
    MeasurementNoise = {{0.1}},
    Transition = function(State, Control, DeltaTime)
        return {State[1] + State[2] * DeltaTime, State[2]}
    end,
    Measurement = function(State)
        return {State[1]}
    end,
})
Estimator:Predict(nil, 1 / 60)
local MeasurementAccepted, MeasurementReport = Estimator:Update({0.02})

local Solution, OptimizationReport = Optimization.BFGS(function(X)
    return (X[1] - 2) ^ 2 + (X[2] + 1) ^ 2
end, {0, 0})

local MatrixSolution = LinearAlgebra.Solve({{4, 1}, {1, 3}}, {1, 2})

print("VectorForge integration demo", ObjectiveValue, Gradient[1], Gradient[2], Frame.Position, #PathSamples, #TimedPath, BodyState.Position, MeasurementAccepted, MeasurementReport.Accepted, Solution[1], Solution[2], OptimizationReport.Converged, MatrixSolution[1])
