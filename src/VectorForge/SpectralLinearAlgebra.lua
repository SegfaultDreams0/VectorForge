local SpectralLinearAlgebra = {}

local DEFAULT_TOLERANCE = 1e-10
local SparseMatrix = {}
SparseMatrix.__index = SparseMatrix

local function IsFinite(Value)
    return type(Value) == "number" and Value == Value and Value > -math.huge and Value < math.huge
end

local function Dimensions(A)
    assert(type(A) == "table" and #A > 0, "Matrix must contain at least one row")
    assert(type(A[1]) == "table" and #A[1] > 0, "Matrix must contain at least one column")
    local Columns = #A[1]
    for Row = 1, #A do
        assert(type(A[Row]) == "table" and #A[Row] == Columns, "Matrix must be rectangular")
        for Column = 1, Columns do
            assert(IsFinite(A[Row][Column]), "Matrix entries must be finite numbers")
        end
    end
    return #A, Columns
end

local function ValidateVector(X, Expected, Label)
    assert(type(X) == "table" and #X == Expected, (Label or "Vector") .. " has an invalid dimension")
    for Index = 1, Expected do
        assert(IsFinite(X[Index]), (Label or "Vector") .. " must contain finite numbers")
    end
end

local function Copy(A)
    local Rows, Columns = Dimensions(A)
    local Result = table.create(Rows)
    for Row = 1, Rows do
        Result[Row] = table.create(Columns)
        for Column = 1, Columns do
            Result[Row][Column] = A[Row][Column]
        end
    end
    return Result
end

local function Zeros(Rows, Columns)
    assert(type(Rows) == "number" and Rows >= 1 and Rows % 1 == 0, "Rows must be a positive integer")
    assert(type(Columns) == "number" and Columns >= 1 and Columns % 1 == 0, "Columns must be a positive integer")
    local Result = table.create(Rows)
    for Row = 1, Rows do
        Result[Row] = table.create(Columns, 0)
    end
    return Result
end

local function Identity(Size)
    local Result = Zeros(Size, Size)
    for Index = 1, Size do
        Result[Index][Index] = 1
    end
    return Result
end

local function Transpose(A)
    local Rows, Columns = Dimensions(A)
    local Result = Zeros(Columns, Rows)
    for Row = 1, Rows do
        for Column = 1, Columns do
            Result[Column][Row] = A[Row][Column]
        end
    end
    return Result
end

local function Multiply(A, B)
    local Rows, Inner = Dimensions(A)
    local OtherRows, Columns = Dimensions(B)
    assert(Inner == OtherRows, "Matrix dimensions are incompatible")
    local Result = Zeros(Rows, Columns)
    for Row = 1, Rows do
        for K = 1, Inner do
            local Value = A[Row][K]
            for Column = 1, Columns do
                Result[Row][Column] += Value * B[K][Column]
            end
        end
    end
    return Result
end

local function MatrixVector(A, X)
    local Rows, Columns = Dimensions(A)
    ValidateVector(X, Columns, "Vector")
    local Result = table.create(Rows, 0)
    for Row = 1, Rows do
        local Sum = 0
        for Column = 1, Columns do
            Sum += A[Row][Column] * X[Column]
        end
        Result[Row] = Sum
    end
    return Result
end

local function Dot(A, B)
    assert(type(A) == "table" and type(B) == "table" and #A == #B, "Vector dimensions are incompatible")
    local Sum = 0
    for Index = 1, #A do
        assert(IsFinite(A[Index]) and IsFinite(B[Index]), "Vector entries must be finite numbers")
        Sum += A[Index] * B[Index]
    end
    return Sum
end

local function Norm(A)
    return math.sqrt(Dot(A, A))
end

local function Add(A, B)
    local Rows, Columns = Dimensions(A)
    local OtherRows, OtherColumns = Dimensions(B)
    assert(Rows == OtherRows and Columns == OtherColumns, "Matrix dimensions are incompatible")
    local Result = Zeros(Rows, Columns)
    for Row = 1, Rows do
        for Column = 1, Columns do
            Result[Row][Column] = A[Row][Column] + B[Row][Column]
        end
    end
    return Result
end

local function Subtract(A, B)
    local Rows, Columns = Dimensions(A)
    local OtherRows, OtherColumns = Dimensions(B)
    assert(Rows == OtherRows and Columns == OtherColumns, "Matrix dimensions are incompatible")
    local Result = Zeros(Rows, Columns)
    for Row = 1, Rows do
        for Column = 1, Columns do
            Result[Row][Column] = A[Row][Column] - B[Row][Column]
        end
    end
    return Result
end

local function Scale(A, Scalar)
    assert(IsFinite(Scalar), "Scalar must be finite")
    local Rows, Columns = Dimensions(A)
    local Result = Zeros(Rows, Columns)
    for Row = 1, Rows do
        for Column = 1, Columns do
            Result[Row][Column] = A[Row][Column] * Scalar
        end
    end
    return Result
end

local function Symmetrize(A)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns, "Symmetrization requires a square matrix")
    local Result = Copy(A)
    for Row = 1, Rows do
        for Column = Row + 1, Columns do
            local Mean = 0.5 * (A[Row][Column] + A[Column][Row])
            Result[Row][Column] = Mean
            Result[Column][Row] = Mean
        end
    end
    return Result
end

local function Trace(A)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns, "Trace requires a square matrix")
    local Result = 0
    for Index = 1, Rows do
        Result += A[Index][Index]
    end
    return Result
end

local function FrobeniusNorm(A)
    local Rows, Columns = Dimensions(A)
    local Sum = 0
    for Row = 1, Rows do
        for Column = 1, Columns do
            Sum += A[Row][Column] * A[Row][Column]
        end
    end
    return math.sqrt(Sum)
end

local function Outer(A, B)
    assert(type(A) == "table" and #A > 0 and type(B) == "table" and #B > 0, "Vectors cannot be empty")
    local Result = Zeros(#A, #B)
    for Row = 1, #A do
        for Column = 1, #B do
            Result[Row][Column] = A[Row] * B[Column]
        end
    end
    return Result
end

local function LUFactor(A, Tolerance)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns, "LU factorization requires a square matrix")
    local N = Rows
    local LU = Copy(A)
    local Permutation = table.create(N)
    local Parity = 1
    local Threshold = Tolerance or DEFAULT_TOLERANCE
    for Index = 1, N do
        Permutation[Index] = Index
    end
    for Column = 1, N do
        local Pivot = Column
        local Maximum = math.abs(LU[Column][Column])
        for Row = Column + 1, N do
            local Candidate = math.abs(LU[Row][Column])
            if Candidate > Maximum then
                Maximum = Candidate
                Pivot = Row
            end
        end
        if Maximum <= Threshold then
            return nil, nil, nil, "Matrix is singular or numerically rank deficient"
        end
        if Pivot ~= Column then
            LU[Column], LU[Pivot] = LU[Pivot], LU[Column]
            Permutation[Column], Permutation[Pivot] = Permutation[Pivot], Permutation[Column]
            Parity = -Parity
        end
        for Row = Column + 1, N do
            LU[Row][Column] /= LU[Column][Column]
            local Factor = LU[Row][Column]
            for K = Column + 1, N do
                LU[Row][K] -= Factor * LU[Column][K]
            end
        end
    end
    return LU, Permutation, Parity
end

local function LUSolve(LU, Permutation, B)
    local N = #LU
    ValidateVector(B, N, "Right-hand side")
    local X = table.create(N)
    for Row = 1, N do
        X[Row] = B[Permutation[Row]]
    end
    for Row = 1, N do
        for Column = 1, Row - 1 do
            X[Row] -= LU[Row][Column] * X[Column]
        end
    end
    for Row = N, 1, -1 do
        for Column = Row + 1, N do
            X[Row] -= LU[Row][Column] * X[Column]
        end
        X[Row] /= LU[Row][Row]
    end
    return X
end

local function Solve(A, B, Tolerance)
    local LU, Permutation, _, Failure = LUFactor(A, Tolerance)
    if not LU then
        return nil, Failure
    end
    return LUSolve(LU, Permutation, B)
end

local function SolveMultiple(A, B, Tolerance)
    local Rows, Columns = Dimensions(B)
    local Factor, Permutation, _, Failure = LUFactor(A, Tolerance)
    if not Factor then
        return nil, Failure
    end
    assert(Rows == #Factor, "Right-hand side dimensions are incompatible")
    local Result = Zeros(Rows, Columns)
    for Column = 1, Columns do
        local Vector = table.create(Rows)
        for Row = 1, Rows do
            Vector[Row] = B[Row][Column]
        end
        local Solution = LUSolve(Factor, Permutation, Vector)
        for Row = 1, Rows do
            Result[Row][Column] = Solution[Row]
        end
    end
    return Result
end

local function Inverse(A, Tolerance)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns, "Inverse requires a square matrix")
    return SolveMultiple(A, Identity(Rows), Tolerance)
end

local function Determinant(A, Tolerance)
    local LU, _, Parity = LUFactor(A, Tolerance)
    if not LU then
        return 0
    end
    local Result = Parity
    for Index = 1, #LU do
        Result *= LU[Index][Index]
    end
    return Result
end

local function Cholesky(A, Tolerance)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns, "Cholesky factorization requires a square matrix")
    local N = Rows
    local L = Zeros(N, N)
    local Threshold = Tolerance or DEFAULT_TOLERANCE
    for Row = 1, N do
        for Column = Row + 1, N do
            assert(math.abs(A[Row][Column] - A[Column][Row]) <= math.max(Threshold, 1e-12), "Cholesky requires a symmetric matrix")
        end
    end
    for Row = 1, N do
        for Column = 1, Row do
            local Sum = A[Row][Column]
            for K = 1, Column - 1 do
                Sum -= L[Row][K] * L[Column][K]
            end
            if Row == Column then
                if Sum <= Threshold then
                    return nil, "Matrix is not positive definite"
                end
                L[Row][Column] = math.sqrt(Sum)
            else
                L[Row][Column] = Sum / L[Column][Column]
            end
        end
    end
    return L
end

local function QR(A, Tolerance)
    local Rows, Columns = Dimensions(A)
    local R = Copy(A)
    local Q = Identity(Rows)
    local Limit = math.min(Rows, Columns)
    local Threshold = Tolerance or DEFAULT_TOLERANCE
    for K = 1, Limit do
        local Length = Rows - K + 1
        local V = table.create(Length, 0)
        local SumSquares = 0
        for Index = 1, Length do
            local Value = R[K + Index - 1][K]
            V[Index] = Value
            SumSquares += Value * Value
        end
        local Magnitude = math.sqrt(SumSquares)
        if Magnitude > Threshold then
            local Sign = V[1] >= 0 and 1 or -1
            V[1] += Sign * Magnitude
            local VNorm = Norm(V)
            if VNorm > Threshold then
                for Index = 1, Length do
                    V[Index] /= VNorm
                end
                for Column = K, Columns do
                    local Projection = 0
                    for Index = 1, Length do
                        Projection += V[Index] * R[K + Index - 1][Column]
                    end
                    for Index = 1, Length do
                        local Row = K + Index - 1
                        R[Row][Column] -= 2 * V[Index] * Projection
                    end
                end
                for Row = 1, Rows do
                    local Projection = 0
                    for Index = 1, Length do
                        Projection += Q[Row][K + Index - 1] * V[Index]
                    end
                    for Index = 1, Length do
                        local Column = K + Index - 1
                        Q[Row][Column] -= 2 * Projection * V[Index]
                    end
                end
            end
        end
    end
    return Q, R
end

local function LeastSquares(A, B, Tolerance)
    local Rows, Columns = Dimensions(A)
    ValidateVector(B, Rows, "Right-hand side")
    assert(Rows >= Columns, "Least-squares QR requires rows >= columns")
    local Q, R = QR(A, Tolerance)
    local QtB = MatrixVector(Transpose(Q), B)
    local Result = table.create(Columns)
    for Row = Columns, 1, -1 do
        local Value = QtB[Row]
        for Column = Row + 1, Columns do
            Value -= R[Row][Column] * Result[Column]
        end
        if math.abs(R[Row][Row]) <= (Tolerance or DEFAULT_TOLERANCE) then
            return nil, "Design matrix is rank deficient"
        end
        Result[Row] = Value / R[Row][Row]
    end
    return Result
end

local function SymmetricEigen(A, MaximumIterations, Tolerance)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns, "Eigen decomposition requires a square matrix")
    local N = Rows
    local D = Copy(A)
    local V = Identity(N)
    local Threshold = Tolerance or DEFAULT_TOLERANCE
    for Row = 1, N do
        for Column = Row + 1, N do
            assert(math.abs(D[Row][Column] - D[Column][Row]) <= 1e-7, "Matrix must be symmetric")
        end
    end
    local Converged = N == 1
    local Iterations = 0
    for Iteration = 1, MaximumIterations or (N * N * 20) do
        local P, Q, Maximum = 1, 1, 0
        for Row = 1, N do
            for Column = Row + 1, N do
                local Value = math.abs(D[Row][Column])
                if Value > Maximum then
                    P, Q, Maximum = Row, Column, Value
                end
            end
        end
        Iterations = Iteration
        if Maximum <= Threshold then
            Converged = true
            break
        end
        local Tau = (D[Q][Q] - D[P][P]) / (2 * D[P][Q])
        local T = (Tau >= 0 and 1 or -1) / (math.abs(Tau) + math.sqrt(1 + Tau * Tau))
        local C = 1 / math.sqrt(1 + T * T)
        local S = T * C
        local App = D[P][P]
        local Aqq = D[Q][Q]
        local Apq = D[P][Q]
        D[P][P] = App - T * Apq
        D[Q][Q] = Aqq + T * Apq
        D[P][Q] = 0
        D[Q][P] = 0
        for K = 1, N do
            if K ~= P and K ~= Q then
                local Akp = D[K][P]
                local Akq = D[K][Q]
                D[K][P] = C * Akp - S * Akq
                D[P][K] = D[K][P]
                D[K][Q] = S * Akp + C * Akq
                D[Q][K] = D[K][Q]
            end
            local Vkp = V[K][P]
            local Vkq = V[K][Q]
            V[K][P] = C * Vkp - S * Vkq
            V[K][Q] = S * Vkp + C * Vkq
        end
    end
    local Eigenvalues = table.create(N)
    for Index = 1, N do
        Eigenvalues[Index] = D[Index][Index]
    end
    for I = 1, N - 1 do
        for J = I + 1, N do
            if Eigenvalues[J] > Eigenvalues[I] then
                Eigenvalues[I], Eigenvalues[J] = Eigenvalues[J], Eigenvalues[I]
                for Row = 1, N do
                    V[Row][I], V[Row][J] = V[Row][J], V[Row][I]
                end
            end
        end
    end
    return Eigenvalues, V, {Converged = Converged, Iterations = Iterations}
end

local function ConjugateGradient(A, B, InitialGuess, Tolerance, MaximumIterations)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns, "Conjugate gradient requires a square matrix")
    ValidateVector(B, Rows, "Right-hand side")
    local N = Rows
    local X = InitialGuess and table.clone(InitialGuess) or table.create(N, 0)
    ValidateVector(X, N, "Initial guess")
    local Product = MatrixVector(A, X)
    local Residual = table.create(N)
    for Index = 1, N do
        Residual[Index] = B[Index] - Product[Index]
    end
    local Direction = table.clone(Residual)
    local ResidualSquared = Dot(Residual, Residual)
    local InitialResidual = math.sqrt(ResidualSquared)
    local Threshold = (Tolerance or 1e-9) * math.max(InitialResidual, 1)
    if InitialResidual <= Threshold then
        return X, {Converged = true, Iterations = 0, Residual = InitialResidual}
    end
    local Iterations = 0
    for Iteration = 1, MaximumIterations or (N * 4) do
        local ADirection = MatrixVector(A, Direction)
        local Denominator = Dot(Direction, ADirection)
        if Denominator <= 0 then
            return X, {Converged = false, Iterations = Iterations, Residual = math.sqrt(ResidualSquared), Reason = "Non-positive curvature detected; matrix must be positive definite"}
        end
        local Alpha = ResidualSquared / Denominator
        for Index = 1, N do
            X[Index] += Alpha * Direction[Index]
            Residual[Index] -= Alpha * ADirection[Index]
        end
        local NextSquared = Dot(Residual, Residual)
        Iterations = Iteration
        if math.sqrt(NextSquared) <= Threshold then
            return X, {Converged = true, Iterations = Iterations, Residual = math.sqrt(NextSquared)}
        end
        local Beta = NextSquared / ResidualSquared
        for Index = 1, N do
            Direction[Index] = Residual[Index] + Beta * Direction[Index]
        end
        ResidualSquared = NextSquared
    end
    return X, {Converged = false, Iterations = Iterations, Residual = math.sqrt(ResidualSquared), Reason = "Maximum iterations reached"}
end

local function PreconditionedConjugateGradient(A, B, Preconditioner, InitialGuess, Tolerance, MaximumIterations)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns, "Preconditioned conjugate gradient requires a square matrix")
    ValidateVector(B, Rows, "Right-hand side")
    local N = Rows
    local X = InitialGuess and table.clone(InitialGuess) or table.create(N, 0)
    ValidateVector(X, N, "Initial guess")
    local R = table.create(N)
    local AX = MatrixVector(A, X)
    for Index = 1, N do
        R[Index] = B[Index] - AX[Index]
    end
    local function ApplyPreconditioner(Vector)
        if Preconditioner == nil then
            return table.clone(Vector)
        elseif type(Preconditioner) == "function" then
            local Result = Preconditioner(table.clone(Vector))
            ValidateVector(Result, N, "Preconditioner output")
            return Result
        else
            local Result, Failure = Solve(Preconditioner, Vector)
            assert(Result, Failure or "Preconditioner solve failed")
            return Result
        end
    end
    local Z = ApplyPreconditioner(R)
    local P = table.clone(Z)
    local RZ = Dot(R, Z)
    local InitialResidual = Norm(R)
    local Threshold = (Tolerance or 1e-9) * math.max(InitialResidual, 1)
    if InitialResidual <= Threshold then
        return X, {Converged = true, Iterations = 0, Residual = InitialResidual}
    end
    local Iterations = 0
    for Iteration = 1, MaximumIterations or (N * 4) do
        local AP = MatrixVector(A, P)
        local Denominator = Dot(P, AP)
        if Denominator <= 0 or RZ <= 0 then
            return X, {Converged = false, Iterations = Iterations, Residual = Norm(R), Reason = "Non-positive curvature or preconditioner response"}
        end
        local Alpha = RZ / Denominator
        for Index = 1, N do
            X[Index] += Alpha * P[Index]
            R[Index] -= Alpha * AP[Index]
        end
        Iterations = Iteration
        local ResidualNorm = Norm(R)
        if ResidualNorm <= Threshold then
            return X, {Converged = true, Iterations = Iterations, Residual = ResidualNorm}
        end
        Z = ApplyPreconditioner(R)
        local NextRZ = Dot(R, Z)
        local Beta = NextRZ / RZ
        for Index = 1, N do
            P[Index] = Z[Index] + Beta * P[Index]
        end
        RZ = NextRZ
    end
    return X, {Converged = false, Iterations = Iterations, Residual = Norm(R), Reason = "Maximum iterations reached"}
end

local function SubtractVectorValues(A, B)
    local Result = table.create(#A)
    for Index = 1, #A do
        Result[Index] = A[Index] - B[Index]
    end
    return Result
end

local function Jacobi(A, B, InitialGuess, Tolerance, MaximumIterations)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns, "Jacobi iteration requires a square matrix")
    ValidateVector(B, Rows, "Right-hand side")
    local N = Rows
    local X = InitialGuess and table.clone(InitialGuess) or table.create(N, 0)
    ValidateVector(X, N, "Initial guess")
    local Threshold = Tolerance or 1e-9
    for Index = 1, N do
        assert(math.abs(A[Index][Index]) > DEFAULT_TOLERANCE, "Jacobi iteration requires nonzero diagonal entries")
    end
    for Iteration = 1, MaximumIterations or 500 do
        local Next = table.create(N)
        for Row = 1, N do
            local Sum = B[Row]
            for Column = 1, N do
                if Column ~= Row then
                    Sum -= A[Row][Column] * X[Column]
                end
            end
            Next[Row] = Sum / A[Row][Row]
        end
        local Difference = table.create(N)
        for Index = 1, N do
            Difference[Index] = Next[Index] - X[Index]
        end
        X = Next
        if Norm(Difference) <= Threshold * math.max(Norm(X), 1) then
            return X, {Converged = true, Iterations = Iteration, Residual = Norm(SubtractVectorValues(MatrixVector(A, X), B))}
        end
    end
    return X, {Converged = false, Iterations = MaximumIterations or 500, Residual = Norm(SubtractVectorValues(MatrixVector(A, X), B)), Reason = "Maximum iterations reached"}
end

local function GaussSeidel(A, B, InitialGuess, Tolerance, MaximumIterations, Relaxation)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns, "Gauss-Seidel iteration requires a square matrix")
    ValidateVector(B, Rows, "Right-hand side")
    local N = Rows
    local X = InitialGuess and table.clone(InitialGuess) or table.create(N, 0)
    ValidateVector(X, N, "Initial guess")
    local Omega = Relaxation or 1
    assert(Omega > 0 and Omega < 2, "Relaxation must be between zero and two")
    for Index = 1, N do
        assert(math.abs(A[Index][Index]) > DEFAULT_TOLERANCE, "Gauss-Seidel requires nonzero diagonal entries")
    end
    for Iteration = 1, MaximumIterations or 500 do
        local Previous = table.clone(X)
        for Row = 1, N do
            local Sum = B[Row]
            for Column = 1, N do
                if Column ~= Row then
                    Sum -= A[Row][Column] * X[Column]
                end
            end
            local Candidate = Sum / A[Row][Row]
            X[Row] += Omega * (Candidate - X[Row])
        end
        local Difference = SubtractVectorValues(X, Previous)
        if Norm(Difference) <= (Tolerance or 1e-9) * math.max(Norm(X), 1) then
            return X, {Converged = true, Iterations = Iteration, Residual = Norm(SubtractVectorValues(MatrixVector(A, X), B))}
        end
    end
    return X, {Converged = false, Iterations = MaximumIterations or 500, Residual = Norm(SubtractVectorValues(MatrixVector(A, X), B)), Reason = "Maximum iterations reached"}
end

local function SVD(A, MaximumSweeps, Tolerance)
    local Rows, Columns = Dimensions(A)
    if Rows < Columns then
        local TransposedU, SingularValues, TransposedV, Status = SVD(Transpose(A), MaximumSweeps, Tolerance)
        return TransposedV, SingularValues, TransposedU, Status
    end
    local B = Copy(A)
    local V = Identity(Columns)
    local Threshold = Tolerance or 1e-10
    local Sweeps = MaximumSweeps or math.max(12, Columns * Columns * 8)
    local Converged = false
    local Iterations = 0
    local MatrixScale = FrobeniusNorm(B)
    local ZeroThresholdSquared = Threshold * Threshold * math.max(MatrixScale * MatrixScale, 1)
    for Sweep = 1, Sweeps do
        local Changed = false
        for P = 1, Columns - 1 do
            for Q = P + 1, Columns do
                local Alpha, Beta, Gamma = 0, 0, 0
                for Row = 1, Rows do
                    local BP = B[Row][P]
                    local BQ = B[Row][Q]
                    Alpha += BP * BP
                    Beta += BQ * BQ
                    Gamma += BP * BQ
                end
                if Alpha > ZeroThresholdSquared and Beta > ZeroThresholdSquared and math.abs(Gamma) > Threshold * math.sqrt(math.max(Alpha * Beta, 0)) then
                    local Zeta = (Beta - Alpha) / (2 * Gamma)
                    local T = (Zeta >= 0 and 1 or -1) / (math.abs(Zeta) + math.sqrt(1 + Zeta * Zeta))
                    local C = 1 / math.sqrt(1 + T * T)
                    local S = C * T
                    for Row = 1, Rows do
                        local BP = B[Row][P]
                        local BQ = B[Row][Q]
                        B[Row][P] = C * BP - S * BQ
                        B[Row][Q] = S * BP + C * BQ
                    end
                    for Row = 1, Columns do
                        local VP = V[Row][P]
                        local VQ = V[Row][Q]
                        V[Row][P] = C * VP - S * VQ
                        V[Row][Q] = S * VP + C * VQ
                    end
                    Changed = true
                end
            end
        end
        Iterations = Sweep
        if not Changed then
            Converged = true
            break
        end
    end
    local SingularValues = table.create(Columns)
    for Column = 1, Columns do
        local Sum = 0
        for Row = 1, Rows do
            Sum += B[Row][Column] * B[Row][Column]
        end
        SingularValues[Column] = math.sqrt(Sum)
    end
    local Order = table.create(Columns)
    for Index = 1, Columns do
        Order[Index] = Index
    end
    table.sort(Order, function(AIndex, BIndex)
        return SingularValues[AIndex] > SingularValues[BIndex]
    end)
    local Count = math.min(Rows, Columns)
    local U = Zeros(Rows, Count)
    local VReduced = Zeros(Columns, Count)
    local SReduced = table.create(Count)
    for NewColumn = 1, Count do
        local OldColumn = Order[NewColumn]
        local Sigma = SingularValues[OldColumn]
        SReduced[NewColumn] = Sigma
        for Row = 1, Columns do
            VReduced[Row][NewColumn] = V[Row][OldColumn]
        end
        if Sigma > Threshold then
            for Row = 1, Rows do
                U[Row][NewColumn] = B[Row][OldColumn] / Sigma
            end
        else
            local Candidate = table.create(Rows, 0)
            local Found = false
            for Basis = 1, Rows do
                table.clear(Candidate)
                for Index = 1, Rows do
                    Candidate[Index] = Index == Basis and 1 or 0
                end
                for Previous = 1, NewColumn - 1 do
                    local Projection = 0
                    for Index = 1, Rows do
                        Projection += Candidate[Index] * U[Index][Previous]
                    end
                    for Index = 1, Rows do
                        Candidate[Index] -= Projection * U[Index][Previous]
                    end
                end
                local Length = Norm(Candidate)
                if Length > Threshold then
                    for Index = 1, Rows do
                        U[Index][NewColumn] = Candidate[Index] / Length
                    end
                    Found = true
                    break
                end
            end
            if not Found then
                for Row = 1, Rows do
                    U[Row][NewColumn] = 0
                end
            end
        end
    end
    return U, SReduced, VReduced, {Converged = Converged, Sweeps = Iterations}
end

local function Rank(A, Tolerance)
    local _, SingularValues = SVD(A, nil, Tolerance)
    local Threshold = Tolerance or 1e-10
    local Result = 0
    for _, Value in ipairs(SingularValues) do
        if Value > Threshold then
            Result += 1
        end
    end
    return Result
end

function SparseMatrix.new(Rows, Columns, Entries)
    assert(type(Rows) == "number" and Rows >= 1 and Rows % 1 == 0, "Rows must be a positive integer")
    assert(type(Columns) == "number" and Columns >= 1 and Columns % 1 == 0, "Columns must be a positive integer")
    local self = setmetatable({Rows = Rows, Columns = Columns, Values = {}}, SparseMatrix)
    for _, Entry in ipairs(Entries or {}) do
        self:Set(Entry.Row, Entry.Column, Entry.Value)
    end
    return self
end

function SparseMatrix:Set(Row, Column, Value)
    assert(Row >= 1 and Row <= self.Rows and Row % 1 == 0, "Sparse row index is out of range")
    assert(Column >= 1 and Column <= self.Columns and Column % 1 == 0, "Sparse column index is out of range")
    assert(IsFinite(Value), "Sparse values must be finite numbers")
    if Value == 0 then
        if self.Values[Row] then
            self.Values[Row][Column] = nil
        end
    else
        self.Values[Row] = self.Values[Row] or {}
        self.Values[Row][Column] = Value
    end
    return self
end

function SparseMatrix:Get(Row, Column)
    assert(Row >= 1 and Row <= self.Rows and Column >= 1 and Column <= self.Columns, "Sparse index is out of range")
    return self.Values[Row] and self.Values[Row][Column] or 0
end

function SparseMatrix:MultiplyVector(Vector)
    ValidateVector(Vector, self.Columns, "Sparse matrix vector")
    local Result = table.create(self.Rows, 0)
    for Row, Values in pairs(self.Values) do
        local Sum = 0
        for Column, Value in pairs(Values) do
            Sum += Value * Vector[Column]
        end
        Result[Row] = Sum
    end
    return Result
end

function SparseMatrix:ToDense()
    local Result = Zeros(self.Rows, self.Columns)
    for Row, Values in pairs(self.Values) do
        for Column, Value in pairs(Values) do
            Result[Row][Column] = Value
        end
    end
    return Result
end

function SparseMatrix:NonzeroCount()
    local Count = 0
    for _, Values in pairs(self.Values) do
        for _ in pairs(Values) do
            Count += 1
        end
    end
    return Count
end

function SparseMatrix:Transpose()
    local Result = SparseMatrix.new(self.Columns, self.Rows)
    for Row, Values in pairs(self.Values) do
        for Column, Value in pairs(Values) do
            Result:Set(Column, Row, Value)
        end
    end
    return Result
end

local function SparseConjugateGradient(A, B, InitialGuess, Tolerance, MaximumIterations)
    assert(getmetatable(A) == SparseMatrix, "A must be a SparseMatrix")
    local N = A.Rows
    assert(A.Columns == N, "Sparse conjugate gradient requires a square matrix")
    ValidateVector(B, N, "Right-hand side")
    local X = InitialGuess and table.clone(InitialGuess) or table.create(N, 0)
    ValidateVector(X, N, "Initial guess")
    local AX = A:MultiplyVector(X)
    local R = table.create(N)
    for Index = 1, N do
        R[Index] = B[Index] - AX[Index]
    end
    local P = table.clone(R)
    local RR = Dot(R, R)
    local Threshold = (Tolerance or 1e-9) * math.max(math.sqrt(RR), 1)
    if math.sqrt(RR) <= Threshold then
        return X, {Converged = true, Iterations = 0, Residual = math.sqrt(RR)}
    end
    for Iteration = 1, MaximumIterations or N * 4 do
        local AP = A:MultiplyVector(P)
        local Denominator = Dot(P, AP)
        if Denominator <= 0 then
            return X, {Converged = false, Iterations = Iteration - 1, Residual = math.sqrt(RR), Reason = "Non-positive curvature detected"}
        end
        local Alpha = RR / Denominator
        for Index = 1, N do
            X[Index] += Alpha * P[Index]
            R[Index] -= Alpha * AP[Index]
        end
        local NextRR = Dot(R, R)
        if math.sqrt(NextRR) <= Threshold then
            return X, {Converged = true, Iterations = Iteration, Residual = math.sqrt(NextRR)}
        end
        local Beta = NextRR / RR
        for Index = 1, N do
            P[Index] = R[Index] + Beta * P[Index]
        end
        RR = NextRR
    end
    return X, {Converged = false, Iterations = MaximumIterations or N * 4, Residual = math.sqrt(RR), Reason = "Maximum iterations reached"}
end

SpectralLinearAlgebra.Dimensions = Dimensions
SpectralLinearAlgebra.ValidateVector = ValidateVector
SpectralLinearAlgebra.Copy = Copy
SpectralLinearAlgebra.Zeros = Zeros
SpectralLinearAlgebra.Identity = Identity
SpectralLinearAlgebra.Transpose = Transpose
SpectralLinearAlgebra.Multiply = Multiply
SpectralLinearAlgebra.MatrixVector = MatrixVector
SpectralLinearAlgebra.Dot = Dot
SpectralLinearAlgebra.Norm = Norm
SpectralLinearAlgebra.Add = Add
SpectralLinearAlgebra.Subtract = Subtract
SpectralLinearAlgebra.Scale = Scale
SpectralLinearAlgebra.Symmetrize = Symmetrize
SpectralLinearAlgebra.Trace = Trace
SpectralLinearAlgebra.FrobeniusNorm = FrobeniusNorm
SpectralLinearAlgebra.Outer = Outer
SpectralLinearAlgebra.LUFactor = LUFactor
SpectralLinearAlgebra.Solve = Solve
SpectralLinearAlgebra.SolveMultiple = SolveMultiple
SpectralLinearAlgebra.Inverse = Inverse
SpectralLinearAlgebra.Determinant = Determinant
SpectralLinearAlgebra.Cholesky = Cholesky
SpectralLinearAlgebra.QR = QR
SpectralLinearAlgebra.LeastSquares = LeastSquares
SpectralLinearAlgebra.SymmetricEigen = SymmetricEigen
SpectralLinearAlgebra.ConjugateGradient = ConjugateGradient
SpectralLinearAlgebra.PreconditionedConjugateGradient = PreconditionedConjugateGradient
SpectralLinearAlgebra.Jacobi = Jacobi
SpectralLinearAlgebra.GaussSeidel = GaussSeidel
SpectralLinearAlgebra.SVD = SVD
SpectralLinearAlgebra.Rank = Rank
SpectralLinearAlgebra.SparseMatrix = SparseMatrix
SpectralLinearAlgebra.SparseConjugateGradient = SparseConjugateGradient
SpectralLinearAlgebra.Version = "0.2.0-alpha"

return SpectralLinearAlgebra
