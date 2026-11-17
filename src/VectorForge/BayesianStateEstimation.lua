local LinearAlgebra = require(script.Parent:WaitForChild("SpectralLinearAlgebra"))
local AutomaticDifferentiation = require(script.Parent:WaitForChild("AutomaticDifferentiation"))

local BayesianStateEstimation = {}
local Filter = {}
Filter.__index = Filter
local UnscentedFilter = {}
UnscentedFilter.__index = UnscentedFilter

local function CopyVector(Vector)
    return table.clone(Vector)
end

local function ValidateVector(Vector, Expected, Label)
    assert(type(Vector) == "table" and #Vector == Expected, (Label or "Vector") .. " has an invalid dimension")
    for Index = 1, Expected do
        assert(type(Vector[Index]) == "number" and Vector[Index] == Vector[Index] and math.abs(Vector[Index]) < math.huge, (Label or "Vector") .. " must contain finite numbers")
    end
end

local function ValidateMatrix(Matrix, RowsExpected, ColumnsExpected, Label)
    local Rows, Columns = LinearAlgebra.Dimensions(Matrix)
    assert(Rows == RowsExpected and Columns == ColumnsExpected, (Label or "Matrix") .. " has an invalid dimension")
end

local function ValidateDifferentiableVector(Vector, Expected, Label)
    assert(type(Vector) == "table" and #Vector == Expected, (Label or "Vector") .. " has an invalid dimension")
    for Index = 1, Expected do
        local Value = Vector[Index]
        if not AutomaticDifferentiation.IsDual(Value) then
            assert(type(Value) == "number" and Value == Value and math.abs(Value) < math.huge, (Label or "Vector") .. " must contain finite numbers or Dual values")
        end
    end
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

local function ScaleVector(A, Scalar)
    local Result = table.create(#A)
    for Index = 1, #A do
        Result[Index] = A[Index] * Scalar
    end
    return Result
end

local function DefaultResidual(A, B)
    return SubtractVectors(A, B)
end

local function DefaultStateAdd(A, B)
    return AddVectors(A, B)
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

local function ResolveNoise(Noise, State, Context, DeltaTime, Rows)
    local Result
    if type(Noise) == "function" then
        Result = Noise(CopyVector(State), Context, DeltaTime)
    else
        Result = Noise
    end
    ValidateMatrix(Result, Rows, Rows, "Resolved noise covariance")
    return LinearAlgebra.Symmetrize(Result)
end

local function AdaptiveConfiguration(Configuration)
    local Adaptive = Configuration.AdaptiveNoise
    if Adaptive == true then
        Adaptive = {}
    end
    if type(Adaptive) ~= "table" then
        return nil
    end
    local Rate = Adaptive.Rate or 0.02
    local MinimumScale = Adaptive.MinimumScale or 0.1
    local MaximumScale = Adaptive.MaximumScale or 10
    local InitialScale = Adaptive.InitialScale or 1
    assert(type(Rate) == "number" and Rate >= 0 and Rate < math.huge, "Adaptive noise rate must be non-negative and finite")
    assert(type(MinimumScale) == "number" and MinimumScale > 0 and MinimumScale < math.huge, "Minimum adaptive scale must be positive and finite")
    assert(type(MaximumScale) == "number" and MaximumScale >= MinimumScale and MaximumScale < math.huge, "Maximum adaptive scale must be finite and at least the minimum scale")
    assert(type(InitialScale) == "number" and InitialScale >= MinimumScale and InitialScale <= MaximumScale and InitialScale < math.huge, "Initial adaptive scale must be within its configured bounds")
    return {
        Rate = Rate,
        MinimumScale = MinimumScale,
        MaximumScale = MaximumScale,
        InitialScale = InitialScale,
        Scale = InitialScale,
    }
end

local function ApplyAdaptiveScale(Matrix, Scale)
    return LinearAlgebra.Scale(Matrix, Scale)
end

local function CreateBase(Configuration, Method)
    assert(type(Configuration) == "table", "Configuration is required")
    assert(type(Configuration.Transition) == "function", "Transition callback is required")
    assert(type(Configuration.Measurement) == "function", "Measurement callback is required")
    assert(Configuration.TransitionJacobian == nil or type(Configuration.TransitionJacobian) == "function", "TransitionJacobian must be a function")
    assert(Configuration.MeasurementJacobian == nil or type(Configuration.MeasurementJacobian) == "function", "MeasurementJacobian must be a function")
    assert(Configuration.NormalizeState == nil or type(Configuration.NormalizeState) == "function", "NormalizeState must be a function")
    assert(Configuration.ResidualFunction == nil or type(Configuration.ResidualFunction) == "function", "ResidualFunction must be a function")
    assert(Configuration.StateResidualFunction == nil or type(Configuration.StateResidualFunction) == "function", "StateResidualFunction must be a function")
    assert(Configuration.StateAddFunction == nil or type(Configuration.StateAddFunction) == "function", "StateAddFunction must be a function")
    assert(Configuration.MeasurementResidualFunction == nil or type(Configuration.MeasurementResidualFunction) == "function", "MeasurementResidualFunction must be a function")
    assert(Configuration.MeasurementAddFunction == nil or type(Configuration.MeasurementAddFunction) == "function", "MeasurementAddFunction must be a function")
    assert(Configuration.GateThreshold == nil or (type(Configuration.GateThreshold) == "number" and Configuration.GateThreshold >= 0 and Configuration.GateThreshold < math.huge), "GateThreshold must be non-negative and finite")
    assert(Configuration.JacobianEpsilon == nil or (type(Configuration.JacobianEpsilon) == "number" and Configuration.JacobianEpsilon > 0 and Configuration.JacobianEpsilon < math.huge), "JacobianEpsilon must be positive and finite")
    local State = CopyVector(Configuration.InitialState)
    local StateDimension = #State
    assert(StateDimension > 0, "Initial state cannot be empty")
    ValidateVector(State, StateDimension, "InitialState")
    if Configuration.NormalizeState then
        State = Configuration.NormalizeState(CopyVector(State))
        ValidateVector(State, StateDimension, "Normalized initial state")
    end
    ValidateMatrix(Configuration.InitialCovariance, StateDimension, StateDimension, "InitialCovariance")
    local MeasurementNoise = Configuration.MeasurementNoise
    assert(type(MeasurementNoise) == "table" or type(MeasurementNoise) == "function", "MeasurementNoise must be a matrix or callback")
    local MeasurementDimension
    if type(MeasurementNoise) == "table" then
        local Rows, Columns = LinearAlgebra.Dimensions(MeasurementNoise)
        assert(Rows == Columns, "MeasurementNoise must be square")
        MeasurementDimension = Rows
    else
        MeasurementDimension = Configuration.MeasurementDimension
        assert(type(MeasurementDimension) == "number" and MeasurementDimension > 0 and MeasurementDimension % 1 == 0, "MeasurementDimension is required when MeasurementNoise is a callback")
    end
    local ProcessNoise = Configuration.ProcessNoise or LinearAlgebra.Zeros(StateDimension, StateDimension)
    if type(ProcessNoise) == "table" then
        ValidateMatrix(ProcessNoise, StateDimension, StateDimension, "ProcessNoise")
    else
        assert(type(ProcessNoise) == "function", "ProcessNoise must be a matrix or callback")
    end
    local InitialCovariance = LinearAlgebra.Symmetrize(Configuration.InitialCovariance)
    local Adaptive = AdaptiveConfiguration(Configuration)
    local JacobianMethod = Configuration.JacobianMethod or "finite-difference"
    assert(JacobianMethod == "finite-difference" or JacobianMethod == "automatic", "JacobianMethod must be finite-difference or automatic")
    return {
        State = State,
        Covariance = InitialCovariance,
        ProcessNoise = ProcessNoise,
        MeasurementNoise = MeasurementNoise,
        Transition = Configuration.Transition,
        Measurement = Configuration.Measurement,
        TransitionJacobian = Configuration.TransitionJacobian,
        MeasurementJacobian = Configuration.MeasurementJacobian,
        ResidualFunction = Configuration.ResidualFunction or DefaultResidual,
        StateResidualFunction = Configuration.StateResidualFunction or DefaultResidual,
        StateAddFunction = Configuration.StateAddFunction or DefaultStateAdd,
        MeasurementResidualFunction = Configuration.MeasurementResidualFunction or Configuration.ResidualFunction or DefaultResidual,
        MeasurementAddFunction = Configuration.MeasurementAddFunction or DefaultStateAdd,
        NormalizeState = Configuration.NormalizeState,
        GateThreshold = Configuration.GateThreshold,
        JacobianEpsilon = Configuration.JacobianEpsilon or 1e-5,
        JacobianMethod = JacobianMethod,
        StateDimension = StateDimension,
        MeasurementDimension = MeasurementDimension,
        Time = 0,
        AcceptedMeasurements = 0,
        RejectedMeasurements = 0,
        AdaptiveNoise = Adaptive,
        Method = Method,
    }
end

local function NormalizeState(self)
    if self.NormalizeState then
        self.State = self.NormalizeState(CopyVector(self.State))
        ValidateVector(self.State, self.StateDimension, "Normalized state")
    end
end

local function AdaptNoise(self, MahalanobisSquared)
    if not self.AdaptiveNoise then
        return
    end
    local Adaptive = self.AdaptiveNoise
    local Ratio = MahalanobisSquared / self.MeasurementDimension
    Adaptive.Scale = math.clamp(Adaptive.Scale * math.exp(Adaptive.Rate * (Ratio - 1)), Adaptive.MinimumScale, Adaptive.MaximumScale)
end

local function GetEstimate(self)
    return {
        State = CopyVector(self.State),
        Covariance = LinearAlgebra.Copy(self.Covariance),
        Time = self.Time,
        AcceptedMeasurements = self.AcceptedMeasurements,
        RejectedMeasurements = self.RejectedMeasurements,
        Method = self.Method,
        AdaptiveNoiseScale = self.AdaptiveNoise and self.AdaptiveNoise.Scale or nil,
    }
end

function Filter.new(Configuration)
    local Data = CreateBase(Configuration, "EKF")
    return setmetatable(Data, Filter)
end

function Filter:Predict(Control, DeltaTime)
    assert(type(DeltaTime) == "number" and DeltaTime > 0 and DeltaTime < math.huge, "DeltaTime must be positive and finite")
    local TransitionFunction = function(State)
        local Result = self.Transition(CopyVector(State), Control, DeltaTime)
        if self.JacobianMethod == "automatic" then
            ValidateDifferentiableVector(Result, self.StateDimension, "Transition output")
        else
            ValidateVector(Result, self.StateDimension, "Transition output")
        end
        return Result
    end
    local PredictedState = TransitionFunction(self.State)
    local F
    if self.TransitionJacobian then
        F = self.TransitionJacobian(CopyVector(self.State), Control, DeltaTime)
        ValidateMatrix(F, self.StateDimension, self.StateDimension, "TransitionJacobian")
    else
        F = self.JacobianMethod == "automatic"
            and AutomaticDifferentiation.Jacobian(TransitionFunction, self.State)
            or Jacobian(TransitionFunction, self.State, self.StateDimension, self.JacobianEpsilon)
    end
    local ProcessNoise = ResolveNoise(self.ProcessNoise, PredictedState, Control, DeltaTime, self.StateDimension)
    local FP = LinearAlgebra.Multiply(F, self.Covariance)
    local Propagated = LinearAlgebra.Multiply(FP, LinearAlgebra.Transpose(F))
    self.Covariance = LinearAlgebra.Symmetrize(LinearAlgebra.Add(Propagated, ProcessNoise))
    self.State = PredictedState
    NormalizeState(self)
    self.Time += DeltaTime
    return GetEstimate(self)
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
        local MeasurementFunction = function(State)
            return self.Measurement(State)
        end
        H = self.JacobianMethod == "automatic"
            and AutomaticDifferentiation.Jacobian(MeasurementFunction, self.State)
            or Jacobian(MeasurementFunction, self.State, self.MeasurementDimension, self.JacobianEpsilon)
    end
    local MeasurementNoise = ResolveNoise(self.MeasurementNoise, self.State, Observation, 0, self.MeasurementDimension)
    if self.AdaptiveNoise then
        MeasurementNoise = ApplyAdaptiveScale(MeasurementNoise, self.AdaptiveNoise.Scale)
    end
    local Residual = self.ResidualFunction(CopyVector(Observation), PredictedObservation)
    ValidateVector(Residual, self.MeasurementDimension, "Residual")
    local HP = LinearAlgebra.Multiply(H, self.Covariance)
    local InnovationCovariance = LinearAlgebra.Symmetrize(LinearAlgebra.Add(
        LinearAlgebra.Multiply(HP, LinearAlgebra.Transpose(H)), MeasurementNoise
    ))
    local Solved, Failure = LinearAlgebra.SolveMultiple(InnovationCovariance, HP)
    if not Solved then
        self.RejectedMeasurements += 1
        return false, {Accepted = false, Reason = Failure, Residual = Residual}
    end
    local SolvedResidual, ResidualFailure = LinearAlgebra.Solve(InnovationCovariance, Residual)
    if not SolvedResidual then
        self.RejectedMeasurements += 1
        return false, {Accepted = false, Reason = ResidualFailure, Residual = Residual}
    end
    local MahalanobisSquared = LinearAlgebra.Dot(Residual, SolvedResidual)
    if self.GateThreshold and MahalanobisSquared > self.GateThreshold then
        self.RejectedMeasurements += 1
        return false, {Accepted = false, Reason = "Innovation gate rejected the observation", MahalanobisSquared = MahalanobisSquared, Residual = Residual}
    end
    local KalmanGain = LinearAlgebra.Transpose(Solved)
    local StateCorrection = LinearAlgebra.MatrixVector(KalmanGain, Residual)
    self.State = self.StateAddFunction(CopyVector(self.State), StateCorrection)
    ValidateVector(self.State, self.StateDimension, "Updated state")
    NormalizeState(self)
    local KH = LinearAlgebra.Multiply(KalmanGain, H)
    local ResidualOperator = LinearAlgebra.Subtract(LinearAlgebra.Identity(self.StateDimension), KH)
    local Left = LinearAlgebra.Multiply(LinearAlgebra.Multiply(ResidualOperator, self.Covariance), LinearAlgebra.Transpose(ResidualOperator))
    local Right = LinearAlgebra.Multiply(LinearAlgebra.Multiply(KalmanGain, MeasurementNoise), LinearAlgebra.Transpose(KalmanGain))
    self.Covariance = LinearAlgebra.Symmetrize(LinearAlgebra.Add(Left, Right))
    self.AcceptedMeasurements += 1
    AdaptNoise(self, MahalanobisSquared)
    return true, {Accepted = true, MahalanobisSquared = MahalanobisSquared, Residual = Residual, Gain = KalmanGain}
end

function Filter:UpdateBatch(Observations)
    assert(type(Observations) == "table", "Observations must be an array")
    local Results = table.create(#Observations)
    for Index, Observation in ipairs(Observations) do
        local Accepted, Report = self:Update(Observation)
        Results[Index] = {Accepted = Accepted, Report = Report}
    end
    return Results, GetEstimate(self)
end

function Filter:SetState(State, Covariance)
    ValidateVector(State, self.StateDimension, "State")
    self.State = CopyVector(State)
    if Covariance then
        ValidateMatrix(Covariance, self.StateDimension, self.StateDimension, "Covariance")
        self.Covariance = LinearAlgebra.Symmetrize(Covariance)
    end
    NormalizeState(self)
    return GetEstimate(self)
end

function Filter:GetEstimate()
    return GetEstimate(self)
end

function Filter:Reset(State, Covariance)
    local NewState = State or self.State
    ValidateVector(NewState, self.StateDimension, "Reset state")
    self.State = CopyVector(NewState)
    if Covariance then
        ValidateMatrix(Covariance, self.StateDimension, self.StateDimension, "Reset covariance")
        self.Covariance = LinearAlgebra.Symmetrize(Covariance)
    end
    self.Time = 0
    self.AcceptedMeasurements = 0
    self.RejectedMeasurements = 0
    if self.AdaptiveNoise then
        self.AdaptiveNoise.Scale = self.AdaptiveNoise.InitialScale
    end
    NormalizeState(self)
    return GetEstimate(self)
end

local function PositiveCholesky(Covariance, Jitter, Attempts)
    local Matrix = LinearAlgebra.Copy(Covariance)
    local Amount = Jitter or 1e-10
    for Attempt = 1, Attempts or 8 do
        local Factor = LinearAlgebra.Cholesky(Matrix)
        if Factor then
            return Factor
        end
        for Index = 1, #Matrix do
            Matrix[Index][Index] += Amount
        end
        Amount *= 10
    end
    return nil, "Covariance is not positive definite after diagonal jitter"
end

local function SigmaPoints(self)
    local N = self.StateDimension
    local Alpha = self.Alpha
    local Lambda = Alpha * Alpha * (N + self.Kappa) - N
    local Scale = N + Lambda
    assert(Scale > 0, "Unscented transform requires N + lambda > 0")
    local Factor, Failure = PositiveCholesky(self.Covariance, self.CholeskyJitter, self.CholeskyAttempts)
    assert(Factor, Failure)
    local Sigma = table.create(2 * N + 1)
    local MeanWeights = table.create(2 * N + 1)
    local CovarianceWeights = table.create(2 * N + 1)
    Sigma[1] = CopyVector(self.State)
    MeanWeights[1] = Lambda / Scale
    CovarianceWeights[1] = MeanWeights[1] + (1 - Alpha * Alpha + self.Beta)
    local Spread = math.sqrt(Scale)
    for Column = 1, N do
        local Offset = table.create(N)
        for Row = 1, N do
            Offset[Row] = Factor[Row][Column] * Spread
        end
        Sigma[1 + Column] = self.StateAddFunction(CopyVector(self.State), Offset)
        Sigma[1 + N + Column] = self.StateAddFunction(CopyVector(self.State), ScaleVector(Offset, -1))
        if self.NormalizeState then
            Sigma[1 + Column] = self.NormalizeState(Sigma[1 + Column])
            Sigma[1 + N + Column] = self.NormalizeState(Sigma[1 + N + Column])
            ValidateVector(Sigma[1 + Column], N, "Normalized sigma point")
            ValidateVector(Sigma[1 + N + Column], N, "Normalized sigma point")
        end
        MeanWeights[1 + Column] = 1 / (2 * Scale)
        MeanWeights[1 + N + Column] = 1 / (2 * Scale)
        CovarianceWeights[1 + Column] = MeanWeights[1 + Column]
        CovarianceWeights[1 + N + Column] = MeanWeights[1 + N + Column]
    end
    return Sigma, MeanWeights, CovarianceWeights
end

local function WeightedMean(Values, Weights, ResidualFunction, AddFunction, Reference)
    local Mean = CopyVector(Reference or Values[1])
    local Accumulated = table.create(#Mean, 0)
    for Index, Value in ipairs(Values) do
        local Difference = ResidualFunction(CopyVector(Value), Mean)
        for Component = 1, #Accumulated do
            Accumulated[Component] += Weights[Index] * Difference[Component]
        end
    end
    return AddFunction(Mean, Accumulated)
end

local function WeightedCovariance(Values, Mean, Weights, ResidualFunction, Dimension)
    local Covariance = LinearAlgebra.Zeros(Dimension, Dimension)
    for Index, Value in ipairs(Values) do
        local Difference = ResidualFunction(CopyVector(Value), Mean)
        local Outer = LinearAlgebra.Outer(Difference, Difference)
        Covariance = LinearAlgebra.Add(Covariance, LinearAlgebra.Scale(Outer, Weights[Index]))
    end
    return Covariance
end

function UnscentedFilter.new(Configuration)
    local Data = CreateBase(Configuration, "UKF")
    Data.Alpha = Configuration.Alpha or 0.3
    Data.Beta = Configuration.Beta or 2
    Data.Kappa = Configuration.Kappa or 0
    Data.CholeskyJitter = Configuration.CholeskyJitter or 1e-10
    Data.CholeskyAttempts = Configuration.CholeskyAttempts or 8
    assert(type(Data.Alpha) == "number" and Data.Alpha > 0 and Data.Alpha < math.huge, "Alpha must be positive and finite")
    assert(type(Data.Beta) == "number" and Data.Beta >= 0 and Data.Beta < math.huge, "Beta must be non-negative and finite")
    assert(type(Data.Kappa) == "number" and Data.Kappa == Data.Kappa and math.abs(Data.Kappa) < math.huge, "Kappa must be finite")
    local Scale = Data.Alpha * Data.Alpha * (Data.StateDimension + Data.Kappa)
    assert(Scale > 0, "Unscented transform requires N + lambda > 0")
    return setmetatable(Data, UnscentedFilter)
end

function UnscentedFilter:Predict(Control, DeltaTime)
    assert(type(DeltaTime) == "number" and DeltaTime > 0 and DeltaTime < math.huge, "DeltaTime must be positive and finite")
    local Sigma, MeanWeights, CovarianceWeights = SigmaPoints(self)
    local PredictedSigma = table.create(#Sigma)
    for Index, State in ipairs(Sigma) do
        local Result = self.Transition(CopyVector(State), Control, DeltaTime)
        ValidateVector(Result, self.StateDimension, "Transition output")
        PredictedSigma[Index] = Result
    end
    local PredictedState = WeightedMean(PredictedSigma, MeanWeights, self.StateResidualFunction, self.StateAddFunction, PredictedSigma[1])
    if self.NormalizeState then
        PredictedState = self.NormalizeState(PredictedState)
        ValidateVector(PredictedState, self.StateDimension, "Normalized predicted state")
    end
    local PredictedCovariance = WeightedCovariance(PredictedSigma, PredictedState, CovarianceWeights, self.StateResidualFunction, self.StateDimension)
    local ProcessNoise = ResolveNoise(self.ProcessNoise, PredictedState, Control, DeltaTime, self.StateDimension)
    self.State = PredictedState
    self.Covariance = LinearAlgebra.Symmetrize(LinearAlgebra.Add(PredictedCovariance, ProcessNoise))
    self.Time += DeltaTime
    return GetEstimate(self)
end

function UnscentedFilter:Update(Observation)
    ValidateVector(Observation, self.MeasurementDimension, "Observation")
    local Sigma, MeanWeights, CovarianceWeights = SigmaPoints(self)
    local MeasurementSigma = table.create(#Sigma)
    for Index, State in ipairs(Sigma) do
        local Value = self.Measurement(CopyVector(State))
        ValidateVector(Value, self.MeasurementDimension, "Measurement output")
        MeasurementSigma[Index] = Value
    end
    local MeasurementResidual = self.MeasurementResidualFunction
    local PredictedObservation = WeightedMean(MeasurementSigma, MeanWeights, MeasurementResidual, self.MeasurementAddFunction, MeasurementSigma[1])
    local Innovation = MeasurementResidual(CopyVector(Observation), PredictedObservation)
    ValidateVector(Innovation, self.MeasurementDimension, "Innovation")
    local InnovationCovariance = WeightedCovariance(MeasurementSigma, PredictedObservation, CovarianceWeights, MeasurementResidual, self.MeasurementDimension)
    local CrossCovariance = LinearAlgebra.Zeros(self.StateDimension, self.MeasurementDimension)
    for Index, State in ipairs(Sigma) do
        local StateDifference = self.StateResidualFunction(CopyVector(State), self.State)
        local MeasurementDifference = MeasurementResidual(CopyVector(MeasurementSigma[Index]), PredictedObservation)
        local Outer = LinearAlgebra.Outer(StateDifference, MeasurementDifference)
        CrossCovariance = LinearAlgebra.Add(CrossCovariance, LinearAlgebra.Scale(Outer, CovarianceWeights[Index]))
    end
    local MeasurementNoise = ResolveNoise(self.MeasurementNoise, self.State, Observation, 0, self.MeasurementDimension)
    if self.AdaptiveNoise then
        MeasurementNoise = ApplyAdaptiveScale(MeasurementNoise, self.AdaptiveNoise.Scale)
    end
    InnovationCovariance = LinearAlgebra.Symmetrize(LinearAlgebra.Add(InnovationCovariance, MeasurementNoise))
    local Solved, Failure = LinearAlgebra.SolveMultiple(InnovationCovariance, LinearAlgebra.Transpose(CrossCovariance))
    if not Solved then
        self.RejectedMeasurements += 1
        return false, {Accepted = false, Reason = Failure, Residual = Innovation}
    end
    local Gain = LinearAlgebra.Transpose(Solved)
    local SolvedInnovation, ResidualFailure = LinearAlgebra.Solve(InnovationCovariance, Innovation)
    if not SolvedInnovation then
        self.RejectedMeasurements += 1
        return false, {Accepted = false, Reason = ResidualFailure, Residual = Innovation}
    end
    local MahalanobisSquared = LinearAlgebra.Dot(Innovation, SolvedInnovation)
    if self.GateThreshold and MahalanobisSquared > self.GateThreshold then
        self.RejectedMeasurements += 1
        return false, {Accepted = false, Reason = "Innovation gate rejected the observation", MahalanobisSquared = MahalanobisSquared, Residual = Innovation}
    end
    local Correction = LinearAlgebra.MatrixVector(Gain, Innovation)
    self.State = self.StateAddFunction(CopyVector(self.State), Correction)
    ValidateVector(self.State, self.StateDimension, "Updated state")
    if self.NormalizeState then
        self.State = self.NormalizeState(self.State)
        ValidateVector(self.State, self.StateDimension, "Normalized state")
    end
    local Reduction = LinearAlgebra.Multiply(LinearAlgebra.Multiply(Gain, InnovationCovariance), LinearAlgebra.Transpose(Gain))
    self.Covariance = LinearAlgebra.Symmetrize(LinearAlgebra.Subtract(self.Covariance, Reduction))
    self.AcceptedMeasurements += 1
    AdaptNoise(self, MahalanobisSquared)
    return true, {Accepted = true, MahalanobisSquared = MahalanobisSquared, Residual = Innovation, Gain = Gain}
end

function UnscentedFilter:UpdateBatch(Observations)
    assert(type(Observations) == "table", "Observations must be an array")
    local Results = table.create(#Observations)
    for Index, Observation in ipairs(Observations) do
        local Accepted, Report = self:Update(Observation)
        Results[Index] = {Accepted = Accepted, Report = Report}
    end
    return Results, GetEstimate(self)
end

function UnscentedFilter:SetState(State, Covariance)
    ValidateVector(State, self.StateDimension, "State")
    self.State = CopyVector(State)
    if Covariance then
        ValidateMatrix(Covariance, self.StateDimension, self.StateDimension, "Covariance")
        self.Covariance = LinearAlgebra.Symmetrize(Covariance)
    end
    NormalizeState(self)
    return GetEstimate(self)
end

function UnscentedFilter:GetEstimate()
    return GetEstimate(self)
end

function UnscentedFilter:Reset(State, Covariance)
    local NewState = State or self.State
    ValidateVector(NewState, self.StateDimension, "Reset state")
    self.State = CopyVector(NewState)
    if Covariance then
        ValidateMatrix(Covariance, self.StateDimension, self.StateDimension, "Reset covariance")
        self.Covariance = LinearAlgebra.Symmetrize(Covariance)
    end
    self.Time = 0
    self.AcceptedMeasurements = 0
    self.RejectedMeasurements = 0
    if self.AdaptiveNoise then
        self.AdaptiveNoise.Scale = self.AdaptiveNoise.InitialScale
    end
    NormalizeState(self)
    return GetEstimate(self)
end

local function FuseEstimates(Estimates)
    assert(type(Estimates) == "table" and #Estimates >= 2, "At least two estimates are required")
    local StateDimension = #Estimates[1].State
    local Information = LinearAlgebra.Zeros(StateDimension, StateDimension)
    local InformationState = table.create(StateDimension, 0)
    for _, Estimate in ipairs(Estimates) do
        ValidateVector(Estimate.State, StateDimension, "Estimate state")
        ValidateMatrix(Estimate.Covariance, StateDimension, StateDimension, "Estimate covariance")
        local InverseCovariance, Failure = LinearAlgebra.Inverse(Estimate.Covariance)
        assert(InverseCovariance, Failure or "Estimate covariance is singular")
        Information = LinearAlgebra.Add(Information, InverseCovariance)
        local Contribution = LinearAlgebra.MatrixVector(InverseCovariance, Estimate.State)
        InformationState = AddVectors(InformationState, Contribution)
    end
    local Covariance, Failure = LinearAlgebra.Inverse(Information)
    assert(Covariance, Failure or "Combined information matrix is singular")
    local State = LinearAlgebra.MatrixVector(Covariance, InformationState)
    return {State = State, Covariance = LinearAlgebra.Symmetrize(Covariance)}
end

BayesianStateEstimation.new = Filter.new
BayesianStateEstimation.EKF = {new = Filter.new}
BayesianStateEstimation.UKF = {new = UnscentedFilter.new}
BayesianStateEstimation.Unscented = {new = UnscentedFilter.new}
BayesianStateEstimation.Jacobian = Jacobian
BayesianStateEstimation.FuseEstimates = FuseEstimates
BayesianStateEstimation.Version = "0.2.0-alpha"

return BayesianStateEstimation
