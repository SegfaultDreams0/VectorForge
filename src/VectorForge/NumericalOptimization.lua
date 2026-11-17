local LinearAlgebra = require(script.Parent:WaitForChild("SpectralLinearAlgebra"))
local AutomaticDifferentiation = require(script.Parent:WaitForChild("AutomaticDifferentiation"))

local NumericalOptimization = {}

local function ValidatePoint(Point)
    assert(type(Point) == "table" and #Point > 0, "Optimization point must be a non-empty array")
    for Index = 1, #Point do
        assert(type(Point[Index]) == "number" and Point[Index] == Point[Index] and math.abs(Point[Index]) < math.huge, "Optimization point must contain finite numbers")
    end
end

local function Add(A, B)
    assert(#A == #B, "Vector dimensions are incompatible")
    local Result = table.create(#A)
    for Index = 1, #A do
        Result[Index] = A[Index] + B[Index]
    end
    return Result
end

local function Subtract(A, B)
    assert(#A == #B, "Vector dimensions are incompatible")
    local Result = table.create(#A)
    for Index = 1, #A do
        Result[Index] = A[Index] - B[Index]
    end
    return Result
end

local function Scale(A, Scalar)
    local Result = table.create(#A)
    for Index = 1, #A do
        Result[Index] = A[Index] * Scalar
    end
    return Result
end

local function Evaluate(Function, Point)
    local Value = Function(table.clone(Point))
    assert(type(Value) == "number" and Value == Value and math.abs(Value) < math.huge, "Objective must return a finite number")
    return Value
end

local function FiniteDifferenceGradient(Function, Point, Step)
    local Result = table.create(#Point)
    local Epsilon = Step or 1e-6
    for Index = 1, #Point do
        local Positive = table.clone(Point)
        local Negative = table.clone(Point)
        local Delta = Epsilon * math.max(1, math.abs(Point[Index]))
        Positive[Index] += Delta
        Negative[Index] -= Delta
        Result[Index] = (Evaluate(Function, Positive) - Evaluate(Function, Negative)) / (2 * Delta)
    end
    return Result
end

local function Gradient(Function, Point, Options)
    local GradientFunction = Options and Options.Gradient
    if GradientFunction then
        local Result = GradientFunction(table.clone(Point))
        assert(type(Result) == "table" and #Result == #Point, "Gradient callback returned an invalid dimension")
        return Result, Evaluate(Function, Point), "custom"
    end
    local Success, Result, Value = pcall(AutomaticDifferentiation.Gradient, Function, Point)
    if Success then
        return Result, Value, "automatic"
    end
    return FiniteDifferenceGradient(Function, Point, Options and Options.DifferenceStep), Evaluate(Function, Point), "finite-difference"
end

local function Jacobian(ResidualFunction, Point, Step)
    local Base = ResidualFunction(table.clone(Point))
    assert(type(Base) == "table" and #Base > 0, "Residual function must return a non-empty array")
    local Rows = #Base
    local Columns = #Point
    local Result = LinearAlgebra.Zeros(Rows, Columns)
    local Epsilon = Step or 1e-6
    for Column = 1, Columns do
        local Positive = table.clone(Point)
        local Negative = table.clone(Point)
        local Delta = Epsilon * math.max(1, math.abs(Point[Column]))
        Positive[Column] += Delta
        Negative[Column] -= Delta
        local FP = ResidualFunction(Positive)
        local FM = ResidualFunction(Negative)
        assert(type(FP) == "table" and #FP == Rows and type(FM) == "table" and #FM == Rows, "Residual dimension changed")
        for Row = 1, Rows do
            Result[Row][Column] = (FP[Row] - FM[Row]) / (2 * Delta)
        end
    end
    return Result, Base
end

local function Backtracking(Function, Point, Value, Direction, GradientValue, Options)
    local Alpha = Options and Options.InitialStep or 1
    local C1 = Options and Options.Armijo or 1e-4
    local Shrink = Options and Options.ShrinkFactor or 0.5
    local Minimum = Options and Options.MinimumStep or 1e-10
    local DirectionalDerivative = LinearAlgebra.Dot(GradientValue, Direction)
    while Alpha >= Minimum do
        local Candidate = Add(Point, Scale(Direction, Alpha))
        local CandidateValue = Evaluate(Function, Candidate)
        if CandidateValue <= Value + C1 * Alpha * DirectionalDerivative then
            return Candidate, CandidateValue, Alpha
        end
        Alpha *= Shrink
    end
    return nil, Value, 0
end

local function GradientDescent(Function, InitialPoint, Options)
    assert(type(Function) == "function", "Objective function is required")
    ValidatePoint(InitialPoint)
    local Settings = Options or {}
    local Point = table.clone(InitialPoint)
    local Value = Evaluate(Function, Point)
    local Tolerance = Settings.Tolerance or 1e-7
    local MaximumIterations = Settings.MaximumIterations or 500
    local History = {}
    local GradientSource = ""
    for Iteration = 1, MaximumIterations do
        local G
        G, Value, GradientSource = Gradient(Function, Point, Settings)
        local GradientNorm = LinearAlgebra.Norm(G)
        table.insert(History, {Iteration = Iteration, Value = Value, GradientNorm = GradientNorm})
        if GradientNorm <= Tolerance then
            return Point, {Converged = true, Iterations = Iteration - 1, Value = Value, GradientNorm = GradientNorm, GradientSource = GradientSource, History = History}
        end
        local Candidate, CandidateValue, Step = Backtracking(Function, Point, Value, Scale(G, -1), G, Settings)
        if not Candidate then
            return Point, {Converged = false, Iterations = Iteration - 1, Value = Value, GradientNorm = GradientNorm, GradientSource = GradientSource, Reason = "Line search failed", History = History}
        end
        Point = Candidate
        Value = CandidateValue
        if Step <= (Settings.MinimumStep or 1e-10) then
            break
        end
    end
    local FinalGradient = Gradient(Function, Point, Settings)
    return Point, {Converged = false, Iterations = #History, Value = Evaluate(Function, Point), GradientNorm = LinearAlgebra.Norm(FinalGradient), GradientSource = GradientSource, Reason = "Maximum iterations reached", History = History}
end

local function Newton(Function, InitialPoint, Options)
    assert(type(Function) == "function", "Objective function is required")
    ValidatePoint(InitialPoint)
    local Settings = Options or {}
    local Point = table.clone(InitialPoint)
    local Value = Evaluate(Function, Point)
    local Tolerance = Settings.Tolerance or 1e-7
    local MaximumIterations = Settings.MaximumIterations or 100
    local History = {}
    for Iteration = 1, MaximumIterations do
        local G = Gradient(Function, Point, Settings)
        local GradientNorm = LinearAlgebra.Norm(G)
        table.insert(History, {Iteration = Iteration, Value = Value, GradientNorm = GradientNorm})
        if GradientNorm <= Tolerance then
            return Point, {Converged = true, Iterations = Iteration - 1, Value = Value, GradientNorm = GradientNorm, History = History}
        end
        local H = Settings.Hessian and Settings.Hessian(table.clone(Point)) or AutomaticDifferentiation.Hessian(Function, Point, Settings.HessianStep)
        local Direction, Failure = LinearAlgebra.Solve(H, Scale(G, -1), Settings.LinearTolerance)
        if not Direction then
            return Point, {Converged = false, Iterations = Iteration - 1, Value = Value, GradientNorm = GradientNorm, Reason = Failure or "Hessian solve failed", History = History}
        end
        local Candidate, CandidateValue = Backtracking(Function, Point, Value, Direction, G, Settings)
        if not Candidate then
            return Point, {Converged = false, Iterations = Iteration - 1, Value = Value, GradientNorm = GradientNorm, Reason = "Line search failed", History = History}
        end
        Point = Candidate
        Value = CandidateValue
    end
    local FinalGradient = Gradient(Function, Point, Settings)
    return Point, {Converged = false, Iterations = MaximumIterations, Value = Evaluate(Function, Point), GradientNorm = LinearAlgebra.Norm(FinalGradient), Reason = "Maximum iterations reached", History = History}
end

local function BFGS(Function, InitialPoint, Options)
    assert(type(Function) == "function", "Objective function is required")
    ValidatePoint(InitialPoint)
    local Settings = Options or {}
    local Point = table.clone(InitialPoint)
    local N = #Point
    local InverseHessian = LinearAlgebra.Identity(N)
    local Value = Evaluate(Function, Point)
    local Tolerance = Settings.Tolerance or 1e-7
    local MaximumIterations = Settings.MaximumIterations or 300
    local History = {}
    local GradientValue = Gradient(Function, Point, Settings)
    for Iteration = 1, MaximumIterations do
        local GradientNorm = LinearAlgebra.Norm(GradientValue)
        table.insert(History, {Iteration = Iteration, Value = Value, GradientNorm = GradientNorm})
        if GradientNorm <= Tolerance then
            return Point, {Converged = true, Iterations = Iteration - 1, Value = Value, GradientNorm = GradientNorm, History = History}
        end
        local Direction = Scale(LinearAlgebra.MatrixVector(InverseHessian, GradientValue), -1)
        if LinearAlgebra.Dot(Direction, GradientValue) >= 0 then
            InverseHessian = LinearAlgebra.Identity(N)
            Direction = Scale(GradientValue, -1)
        end
        local Candidate, CandidateValue = Backtracking(Function, Point, Value, Direction, GradientValue, Settings)
        if not Candidate then
            return Point, {Converged = false, Iterations = Iteration - 1, Value = Value, GradientNorm = GradientNorm, Reason = "Line search failed", History = History}
        end
        local NextGradient = Gradient(Function, Candidate, Settings)
        local S = Subtract(Candidate, Point)
        local Y = Subtract(NextGradient, GradientValue)
        local YS = LinearAlgebra.Dot(Y, S)
        if YS > 1e-12 then
            local Rho = 1 / YS
            local Identity = LinearAlgebra.Identity(N)
            local SY = LinearAlgebra.Outer(S, Y)
            local YSMatrix = LinearAlgebra.Outer(Y, S)
            local Left = LinearAlgebra.Subtract(Identity, LinearAlgebra.Scale(SY, Rho))
            local Right = LinearAlgebra.Subtract(Identity, LinearAlgebra.Scale(YSMatrix, Rho))
            local Updated = LinearAlgebra.Multiply(LinearAlgebra.Multiply(Left, InverseHessian), Right)
            InverseHessian = LinearAlgebra.Add(Updated, LinearAlgebra.Scale(LinearAlgebra.Outer(S, S), Rho))
            InverseHessian = LinearAlgebra.Symmetrize(InverseHessian)
        end
        Point = Candidate
        Value = CandidateValue
        GradientValue = NextGradient
    end
    return Point, {Converged = false, Iterations = MaximumIterations, Value = Value, GradientNorm = LinearAlgebra.Norm(GradientValue), Reason = "Maximum iterations reached", History = History}
end

local function LevenbergMarquardt(ResidualFunction, InitialPoint, Options)
    assert(type(ResidualFunction) == "function", "Residual function is required")
    ValidatePoint(InitialPoint)
    local Settings = Options or {}
    local Point = table.clone(InitialPoint)
    local Damping = Settings.InitialDamping or 1e-3
    local DampingIncrease = Settings.DampingIncrease or 10
    local DampingDecrease = Settings.DampingDecrease or 0.3
    local MinimumDamping = Settings.MinimumDamping or 1e-12
    local MaximumDamping = Settings.MaximumDamping or 1e12
    local MaximumIterations = Settings.MaximumIterations or 200
    local Tolerance = Settings.Tolerance or 1e-7
    local function Cost(Residual)
        return 0.5 * LinearAlgebra.Dot(Residual, Residual)
    end
    local Residual = ResidualFunction(table.clone(Point))
    assert(type(Residual) == "table" and #Residual > 0, "Residual function must return a non-empty array")
    local Value = Cost(Residual)
    local History = {}
    for Iteration = 1, MaximumIterations do
        local J
        J, Residual = Jacobian(ResidualFunction, Point, Settings.DifferenceStep)
        local JT = LinearAlgebra.Transpose(J)
        local GradientValue = LinearAlgebra.MatrixVector(JT, Residual)
        local GradientNorm = LinearAlgebra.Norm(GradientValue)
        table.insert(History, {Iteration = Iteration, Cost = Value, GradientNorm = GradientNorm, Damping = Damping})
        if GradientNorm <= Tolerance then
            return Point, {Converged = true, Iterations = Iteration - 1, Cost = Value, GradientNorm = GradientNorm, Damping = Damping, History = History}
        end
        local Normal = LinearAlgebra.Multiply(JT, J)
        for Index = 1, #Point do
            Normal[Index][Index] += Damping
        end
        local Step, Failure = LinearAlgebra.Solve(Normal, Scale(GradientValue, -1), Settings.LinearTolerance)
        if not Step then
            Damping = math.min(Damping * DampingIncrease, MaximumDamping)
        else
            local Candidate = Add(Point, Step)
            local CandidateResidual = ResidualFunction(table.clone(Candidate))
            assert(type(CandidateResidual) == "table" and #CandidateResidual == #Residual, "Residual dimension changed")
            local CandidateValue = Cost(CandidateResidual)
            if CandidateValue < Value then
                Point = Candidate
                Residual = CandidateResidual
                Value = CandidateValue
                Damping = math.max(Damping * DampingDecrease, MinimumDamping)
                if LinearAlgebra.Norm(Step) <= Tolerance * (LinearAlgebra.Norm(Point) + Tolerance) then
                    return Point, {Converged = true, Iterations = Iteration, Cost = Value, GradientNorm = GradientNorm, Damping = Damping, History = History}
                end
            else
                Damping = math.min(Damping * DampingIncrease, MaximumDamping)
            end
        end
        if Damping >= MaximumDamping then
            return Point, {Converged = false, Iterations = Iteration, Cost = Value, Damping = Damping, Reason = "Damping limit reached", History = History}
        end
    end
    return Point, {Converged = false, Iterations = MaximumIterations, Cost = Value, Damping = Damping, Reason = "Maximum iterations reached", History = History}
end

NumericalOptimization.Gradient = Gradient
NumericalOptimization.FiniteDifferenceGradient = FiniteDifferenceGradient
NumericalOptimization.Jacobian = Jacobian
NumericalOptimization.GradientDescent = GradientDescent
NumericalOptimization.Newton = Newton
NumericalOptimization.BFGS = BFGS
NumericalOptimization.LevenbergMarquardt = LevenbergMarquardt
NumericalOptimization.Version = "0.2.0-alpha"

return NumericalOptimization
