local AutomaticDifferentiation = {}

local Dual = {}
Dual.__index = Dual

local function IsDual(Value)
    return getmetatable(Value) == Dual
end

local function Parts(Value)
    if IsDual(Value) then
        return Value.Value, Value.Derivative
    end
    assert(type(Value) == "number", "Automatic differentiation operands must be numbers or Dual values")
    return Value, 0
end

local function New(Value, Derivative)
    assert(type(Value) == "number" and Value == Value and math.abs(Value) < math.huge, "Dual value must be finite")
    assert(type(Derivative) == "number" and Derivative == Derivative and math.abs(Derivative) < math.huge, "Dual derivative must be finite")
    return setmetatable({Value = Value, Derivative = Derivative}, Dual)
end

function Dual.__add(A, B)
    local AV, AD = Parts(A)
    local BV, BD = Parts(B)
    return New(AV + BV, AD + BD)
end

function Dual.__sub(A, B)
    local AV, AD = Parts(A)
    local BV, BD = Parts(B)
    return New(AV - BV, AD - BD)
end

function Dual.__mul(A, B)
    local AV, AD = Parts(A)
    local BV, BD = Parts(B)
    return New(AV * BV, AD * BV + AV * BD)
end

function Dual.__div(A, B)
    local AV, AD = Parts(A)
    local BV, BD = Parts(B)
    assert(math.abs(BV) > 1e-15, "Division by zero in automatic differentiation")
    return New(AV / BV, (AD * BV - AV * BD) / (BV * BV))
end

function Dual.__pow(A, B)
    local AV, AD = Parts(A)
    local BV, BD = Parts(B)
    local Value = AV ^ BV
    if BD == 0 then
        if AV == 0 and BV < 1 then
            assert(AD == 0, "Power derivative is undefined at zero for this exponent")
            return New(Value, 0)
        end
        local Derivative = BV == 0 and 0 or BV * (AV ^ (BV - 1)) * AD
        return New(Value, Derivative)
    end
    assert(AV > 0, "Variable exponent requires a positive base")
    local Derivative = Value * (BD * math.log(AV) + BV * AD / AV)
    return New(Value, Derivative)
end

function Dual.__unm(A)
    return New(-A.Value, -A.Derivative)
end

function Dual.__tostring(A)
    return string.format("Dual(%g, %g)", A.Value, A.Derivative)
end

function Dual:Clone()
    return New(self.Value, self.Derivative)
end

function Dual:ValueAndDerivative()
    return self.Value, self.Derivative
end

local function Unary(Value, Function, DerivativeFunction)
    if not IsDual(Value) then
        assert(type(Value) == "number", "Unary function requires a numeric value")
        return Function(Value)
    end
    local X, DX = Parts(Value)
    return New(Function(X), DerivativeFunction(X) * DX)
end

local function Sin(Value)
    return Unary(Value, math.sin, math.cos)
end

local function Cos(Value)
    return Unary(Value, math.cos, function(X)
        return -math.sin(X)
    end)
end

local function Tan(Value)
    return Unary(Value, math.tan, function(X)
        local C = math.cos(X)
        return 1 / (C * C)
    end)
end

local function Exp(Value)
    return Unary(Value, math.exp, math.exp)
end

local function Log(Value)
    return Unary(Value, math.log, function(X)
        assert(X > 0, "Logarithm requires a positive value")
        return 1 / X
    end)
end

local function Sqrt(Value)
    return Unary(Value, math.sqrt, function(X)
        assert(X > 0, "Square-root derivative requires a positive value")
        return 0.5 / math.sqrt(X)
    end)
end

local function Asin(Value)
    return Unary(Value, math.asin, function(X)
        return 1 / math.sqrt(1 - X * X)
    end)
end

local function Acos(Value)
    return Unary(Value, math.acos, function(X)
        return -1 / math.sqrt(1 - X * X)
    end)
end

local function Atan(Value)
    return Unary(Value, math.atan, function(X)
        return 1 / (1 + X * X)
    end)
end

local function Sinh(Value)
    return Unary(Value, function(X)
        return (math.exp(X) - math.exp(-X)) * 0.5
    end, function(X)
        return (math.exp(X) + math.exp(-X)) * 0.5
    end)
end

local function Cosh(Value)
    return Unary(Value, function(X)
        return (math.exp(X) + math.exp(-X)) * 0.5
    end, function(X)
        return (math.exp(X) - math.exp(-X)) * 0.5
    end)
end

local function Abs(Value)
    return Unary(Value, math.abs, function(X)
        if X > 0 then
            return 1
        elseif X < 0 then
            return -1
        end
        return 0
    end)
end

local function Pow(Value, Exponent)
    return Value ^ Exponent
end

local function Variable(Value)
    return New(Value, 1)
end

local function Constant(Value)
    return New(Value, 0)
end

local function Extract(Value)
    if IsDual(Value) then
        return Value.Value, Value.Derivative
    end
    assert(type(Value) == "number", "Function output must be numeric")
    return Value, 0
end

local function Gradient(Function, Point)
    assert(type(Function) == "function" and type(Point) == "table" and #Point > 0, "Function and non-empty point are required")
    local Variables = table.create(#Point)
    for Index = 1, #Point do
        Variables[Index] = Constant(Point[Index])
    end
    local Values = table.create(#Point)
    local Result = table.create(#Point)
    for Index = 1, #Point do
        for VariableIndex = 1, #Point do
            Values[VariableIndex] = VariableIndex == Index and Variable(Point[VariableIndex]) or Constant(Point[VariableIndex])
        end
        local Output = Function(Values)
        local OutputValue, OutputDerivative = Extract(Output)
        Result[Index] = OutputDerivative
        if Index == 1 then
            Variables[1] = OutputValue
        end
    end
    return Result, Variables[1]
end

local function Derivative(Function, Point)
    assert(type(Function) == "function" and type(Point) == "number", "Function and scalar point are required")
    local Output = Function(Variable(Point))
    local _, Result = Extract(Output)
    return Result
end

local function Jacobian(Function, Point)
    assert(type(Function) == "function" and type(Point) == "table" and #Point > 0, "Function and non-empty point are required")
    local OutputDimension
    local Columns = #Point
    local Matrix
    for Column = 1, Columns do
        local Variables = table.create(Columns)
        for Index = 1, Columns do
            Variables[Index] = Index == Column and Variable(Point[Index]) or Constant(Point[Index])
        end
        local Output = Function(Variables)
        assert(type(Output) == "table" and #Output > 0, "Jacobian function must return a non-empty array")
        if not OutputDimension then
            OutputDimension = #Output
            Matrix = table.create(OutputDimension)
            for Row = 1, OutputDimension do
                Matrix[Row] = table.create(Columns, 0)
            end
        else
            assert(#Output == OutputDimension, "Function output dimension changed between evaluations")
        end
        for Row = 1, OutputDimension do
            local _, Partial = Extract(Output[Row])
            Matrix[Row][Column] = Partial
        end
    end
    local Values = table.create(OutputDimension)
    local Constants = table.create(Columns)
    for Index = 1, Columns do
        Constants[Index] = Constant(Point[Index])
    end
    local BaseOutput = Function(Constants)
    for Row = 1, OutputDimension do
        Values[Row] = Extract(BaseOutput[Row])
    end
    return Matrix, Values
end

local function Hessian(Function, Point, Step)
    assert(type(Function) == "function" and type(Point) == "table" and #Point > 0, "Function and non-empty point are required")
    local N = #Point
    local Result = table.create(N)
    local H = Step or 1e-4
    local function GradientAt(X)
        return Gradient(Function, X)
    end
    for Row = 1, N do
        Result[Row] = table.create(N, 0)
    end
    for Column = 1, N do
        local Positive = table.clone(Point)
        local Negative = table.clone(Point)
        local Delta = H * math.max(1, math.abs(Point[Column]))
        Positive[Column] += Delta
        Negative[Column] -= Delta
        local GP = GradientAt(Positive)
        local GM = GradientAt(Negative)
        for Row = 1, N do
            Result[Row][Column] = (GP[Row] - GM[Row]) / (2 * Delta)
        end
    end
    for Row = 1, N do
        for Column = Row + 1, N do
            local Mean = 0.5 * (Result[Row][Column] + Result[Column][Row])
            Result[Row][Column] = Mean
            Result[Column][Row] = Mean
        end
    end
    return Result
end

AutomaticDifferentiation.Dual = Dual
AutomaticDifferentiation.New = New
AutomaticDifferentiation.Variable = Variable
AutomaticDifferentiation.Constant = Constant
AutomaticDifferentiation.IsDual = IsDual
AutomaticDifferentiation.Value = function(Value)
    return Extract(Value)
end
AutomaticDifferentiation.Sin = Sin
AutomaticDifferentiation.Cos = Cos
AutomaticDifferentiation.Tan = Tan
AutomaticDifferentiation.Exp = Exp
AutomaticDifferentiation.Log = Log
AutomaticDifferentiation.Sqrt = Sqrt
AutomaticDifferentiation.Asin = Asin
AutomaticDifferentiation.Acos = Acos
AutomaticDifferentiation.Atan = Atan
AutomaticDifferentiation.Sinh = Sinh
AutomaticDifferentiation.Cosh = Cosh
AutomaticDifferentiation.Abs = Abs
AutomaticDifferentiation.Pow = Pow
AutomaticDifferentiation.Derivative = Derivative
AutomaticDifferentiation.Gradient = Gradient
AutomaticDifferentiation.Jacobian = Jacobian
AutomaticDifferentiation.Hessian = Hessian
AutomaticDifferentiation.Version = "0.2.0-alpha"

return AutomaticDifferentiation
