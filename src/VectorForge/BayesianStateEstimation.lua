local LinearAlgebra = require(script.Parent:WaitForChild("SpectralLinearAlgebra"))

local BayesianStateEstimation = {}

local function CopyVector(Vector)
    return table.clone(Vector)
end

local function ValidateVector(Vector, Expected, Label)
    assert(type(Vector) == "table" and #Vector == Expected, Label .. " has an invalid dimension")
    for Index = 1, Expected do
        assert(type(Vector[Index]) == "number", Label .. " must contain numeric values")
    end
end

local function ValidateMatrix(Matrix, RowsExpected, ColumnsExpected, Label)
    local Rows, Columns = LinearAlgebra.Dimensions(Matrix)
    assert(Rows == RowsExpected and Columns == ColumnsExpected, Label .. " has an invalid dimension")
end

local function AddVectors(A, B)
    assert(#A == #B, "Vector dimensions are incompatible")
    local Result = table.create(#A)
    for Index = 1, #A do
        Result[Index] = A[Index] + B[Index]
    end
    return Result
end

local function SubtractVectors(A, B)
    assert(#A == #B, "Vector dimensions are incompatible")
    local Result = table.create(#A)
    for Index = 1, #A do
        Result[Index] = A[Index] - B[Index]
    end
    return Result
end

local function Jacobian(Function, Point, OutputDimension, Epsilon)
    local InputDimension = #Point
    local Result = LinearAlgebra.Zeros(OutputDimension, InputDimension)
    local StepScale = Epsilon or 1e-5

    for Column = 1, InputDimension do
        local Positive = CopyVector(Point)
        local Negative = CopyVector(Point)
        local Delta = StepScale * math.max(1, math.abs(Point[Column]))

        Positive[Column] += Delta
        Negative[Column] -= Delta

        local FPositive = Function(Positive)
        local FNegative = Function(Negative)
        ValidateVector(FPositive, OutputDimension, "Positive function output")
        ValidateVector(FNegative, OutputDimension, "Negative function output")

        for Row = 1, OutputDimension do
            Result[Row][Column] = (FPositive[Row] - FNegative[Row]) / (2 * Delta)
        end
    end

    return Result
end

local function ResolveNoise(Noise, State, Control, DeltaTime)
    if type(Noise) == "function" then
        return Noise(CopyVector(State), Control, DeltaTime)
    end
    return Noise
end

local Filter = {}
Filter.__index = Filter

function Filter.new(Configuration)
    assert(type(Configuration) == "table", "Configuration is required")
    assert(type(Configuration.Transition) == "function", "Transition callback is required")
    assert(type(Configuration.Measurement) == "function", "Measurement callback is required")

    local State = CopyVector(Configuration.InitialState)
    local StateDimension = #State
    assert(StateDimension > 0, "Initial state cannot be empty")
    ValidateVector(State, StateDimension, "InitialState")
    ValidateMatrix(Configuration.InitialCovariance, StateDimension, StateDimension, "InitialCovariance")

    local ProcessNoise = Configuration.ProcessNoise or LinearAlgebra.Identity(StateDimension)
    if type(ProcessNoise) == "table" then
        ValidateMatrix(ProcessNoise, StateDimension, StateDimension, "ProcessNoise")
    else
        assert(type(ProcessNoise) == "function", "ProcessNoise must be a matrix or callback")
    end

    local MeasurementNoise = Configuration.MeasurementNoise
    assert(type(MeasurementNoise) == "table", "MeasurementNoise must be a square matrix")

    local MeasurementDimension, MeasurementColumns = LinearAlgebra.Dimensions(MeasurementNoise)
    assert(MeasurementDimension == MeasurementColumns, "MeasurementNoise must be square")

    return setmetatable({
        State = State,
        Covariance = LinearAlgebra.Copy(Configuration.InitialCovariance),
        ProcessNoise = ProcessNoise,
        MeasurementNoise = MeasurementNoise,
        Transition = Configuration.Transition,
        Measurement = Configuration.Measurement,
        TransitionJacobian = Configuration.TransitionJacobian,
        MeasurementJacobian = Configuration.MeasurementJacobian,
        ResidualFunction = Configuration.ResidualFunction,
        NormalizeState = Configuration.NormalizeState,
        GateThreshold = Configuration.GateThreshold,
        JacobianEpsilon = Configuration.JacobianEpsilon or 1e-5,
        StateDimension = StateDimension,
        MeasurementDimension = MeasurementDimension,
        Time = 0,
        AcceptedMeasurements = 0,
        RejectedMeasurements = 0,
    }, Filter)
end

function Filter:Predict(Control, DeltaTime)
    assert(type(DeltaTime) == "number" and DeltaTime > 0, "DeltaTime must be positive")

    local TransitionFunction = function(State)
        local Result = self.Transition(CopyVector(State), Control, DeltaTime)
        ValidateVector(Result, self.StateDimension, "Transition output")
        return Result
    end

    local PredictedState = TransitionFunction(self.State)
    local F

    if self.TransitionJacobian then
        F = self.TransitionJacobian(CopyVector(self.State), Control, DeltaTime)
        ValidateMatrix(F, self.StateDimension, self.StateDimension, "TransitionJacobian")
    else
        F = Jacobian(TransitionFunction, self.State, self.StateDimension, self.JacobianEpsilon)
    end

    local ProcessNoise = ResolveNoise(self.ProcessNoise, PredictedState, Control, DeltaTime)
    ValidateMatrix(ProcessNoise, self.StateDimension, self.StateDimension, "Resolved ProcessNoise")

    local FP = LinearAlgebra.Multiply(F, self.Covariance)
    local Propagated = LinearAlgebra.Multiply(FP, LinearAlgebra.Transpose(F))
    self.Covariance = LinearAlgebra.Symmetrize(LinearAlgebra.Add(Propagated, ProcessNoise))
    self.State = PredictedState

    if self.NormalizeState then
        self.State = self.NormalizeState(CopyVector(self.State))
        ValidateVector(self.State, self.StateDimension, "Normalized state")
    end

    self.Time += DeltaTime
    return self:GetEstimate()
end

function Filter:Update(Observation)
    ValidateVector(Observation, self.MeasurementDimension, "Observation")

    local PredictedObservation = self.Measurement(CopyVector(self.State))
    ValidateVector(PredictedObservation, self.MeasurementDimension, "Measurement output")

    local H
    if self.MeasurementJacobian then
        H = self.MeasurementJacobian(CopyVector(self.State))
        ValidateMatrix(H, self.MeasurementDimension, self.StateDimension, "MeasurementJacobian")
    else
        H = Jacobian(
            function(State)
                return self.Measurement(State)
            end,
            self.State,
            self.MeasurementDimension,
            self.JacobianEpsilon
        )
    end

    local MeasurementNoise = ResolveNoise(self.MeasurementNoise, self.State, Observation, 0)
    ValidateMatrix(MeasurementNoise, self.MeasurementDimension, self.MeasurementDimension, "Resolved MeasurementNoise")

    local Residual
    if self.ResidualFunction then
        Residual = self.ResidualFunction(CopyVector(Observation), PredictedObservation)
    else
        Residual = SubtractVectors(Observation, PredictedObservation)
    end
    ValidateVector(Residual, self.MeasurementDimension, "Residual")

    local HP = LinearAlgebra.Multiply(H, self.Covariance)
    local InnovationCovariance = LinearAlgebra.Add(
        LinearAlgebra.Multiply(HP, LinearAlgebra.Transpose(H)),
        MeasurementNoise
    )

    local Solved, Failure = LinearAlgebra.SolveMultiple(InnovationCovariance, HP)
    if not Solved then
        return false, {
            Accepted = false,
            Reason = Failure,
            Residual = Residual,
        }
    end

    local KalmanGain = LinearAlgebra.Transpose(Solved)
    local SolvedResidual, ResidualFailure = LinearAlgebra.Solve(InnovationCovariance, Residual)
    if not SolvedResidual then
        return false, {
            Accepted = false,
            Reason = ResidualFailure,
            Residual = Residual,
        }
    end

    local MahalanobisSquared = LinearAlgebra.Dot(Residual, SolvedResidual)

    if self.GateThreshold and MahalanobisSquared > self.GateThreshold then
        self.RejectedMeasurements += 1
        return false, {
            Accepted = false,
            Reason = "Innovation gate rejected the observation",
            MahalanobisSquared = MahalanobisSquared,
            Residual = Residual,
        }
    end

    local StateCorrection = LinearAlgebra.MatrixVector(KalmanGain, Residual)
    self.State = AddVectors(self.State, StateCorrection)

    if self.NormalizeState then
        self.State = self.NormalizeState(CopyVector(self.State))
        ValidateVector(self.State, self.StateDimension, "Normalized state")
    end

    local KH = LinearAlgebra.Multiply(KalmanGain, H)
    local ResidualOperator = LinearAlgebra.Subtract(
        LinearAlgebra.Identity(self.StateDimension),
        KH
    )

    local Left = LinearAlgebra.Multiply(
        LinearAlgebra.Multiply(ResidualOperator, self.Covariance),
        LinearAlgebra.Transpose(ResidualOperator)
    )

    local Right = LinearAlgebra.Multiply(
        LinearAlgebra.Multiply(KalmanGain, MeasurementNoise),
        LinearAlgebra.Transpose(KalmanGain)
    )

    self.Covariance = LinearAlgebra.Symmetrize(LinearAlgebra.Add(Left, Right))
    self.AcceptedMeasurements += 1

    return true, {
        Accepted = true,
        MahalanobisSquared = MahalanobisSquared,
        Residual = Residual,
        Gain = KalmanGain,
    }
end

function Filter:SetState(State, Covariance)
    ValidateVector(State, self.StateDimension, "State")
    self.State = CopyVector(State)

    if Covariance then
        ValidateMatrix(Covariance, self.StateDimension, self.StateDimension, "Covariance")
        self.Covariance = LinearAlgebra.Copy(Covariance)
    end

    return self:GetEstimate()
end

function Filter:GetEstimate()
    return {
        State = CopyVector(self.State),
        Covariance = LinearAlgebra.Copy(self.Covariance),
        Time = self.Time,
        AcceptedMeasurements = self.AcceptedMeasurements,
        RejectedMeasurements = self.RejectedMeasurements,
    }
end

function Filter:Reset(State, Covariance)
    local NewState = State or self.State
    ValidateVector(NewState, self.StateDimension, "Reset state")
    self.State = CopyVector(NewState)

    if Covariance then
        ValidateMatrix(Covariance, self.StateDimension, self.StateDimension, "Reset covariance")
        self.Covariance = LinearAlgebra.Copy(Covariance)
    end

    self.Time = 0
    self.AcceptedMeasurements = 0
    self.RejectedMeasurements = 0
    return self:GetEstimate()
end

BayesianStateEstimation.new = Filter.new
BayesianStateEstimation.Jacobian = Jacobian
BayesianStateEstimation.Version = "1.0.0-alpha"

return BayesianStateEstimation
