local SpectralLinearAlgebra = {}

local DEFAULT_TOLERANCE = 1e-10

local function Dimensions(A)
    assert(type(A) == "table" and #A > 0, "Matrix must contain at least one row")
    local Columns = #A[1]
    assert(Columns > 0, "Matrix must contain at least one column")

    for Row = 1, #A do
        assert(type(A[Row]) == "table" and #A[Row] == Columns, "Matrix must be rectangular")
        for Column = 1, Columns do
            assert(type(A[Row][Column]) == "number", "Matrix entries must be numeric")
        end
    end

    return #A, Columns
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
    assert(#X == Columns, "Matrix and vector dimensions are incompatible")

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
    assert(#A == #B, "Vector dimensions are incompatible")
    local Sum = 0
    for Index = 1, #A do
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

local function LUFactor(A, Tolerance)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns, "LU factorization requires a square matrix")

    local N = Rows
    local LU = Copy(A)
    local Permutation = table.create(N)
    local Parity = 1

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

        if Maximum <= (Tolerance or DEFAULT_TOLERANCE) then
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
    assert(#B == N, "Right-hand side has an incompatible dimension")

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
            assert(math.abs(A[Row][Column] - A[Column][Row]) <= 1e-7, "Cholesky requires a symmetric matrix")
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

    return Q, R
end

local function LeastSquares(A, B, Tolerance)
    local Rows, Columns = Dimensions(A)
    assert(#B == Rows, "Right-hand side has an incompatible dimension")
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

    for _ = 1, MaximumIterations or (N * N * 12) do
        local P, Q, Maximum = 1, 1, 0

        for Row = 1, N do
            for Column = Row + 1, N do
                local Value = math.abs(D[Row][Column])
                if Value > Maximum then
                    P, Q, Maximum = Row, Column, Value
                end
            end
        end

        if Maximum <= Threshold then
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

    return Eigenvalues, V
end

local function ConjugateGradient(A, B, InitialGuess, Tolerance, MaximumIterations)
    local Rows, Columns = Dimensions(A)
    assert(Rows == Columns and #B == Rows, "Conjugate gradient requires a square compatible system")

    local N = Rows
    local X = InitialGuess and table.clone(InitialGuess) or table.create(N, 0)
    assert(#X == N, "Initial guess has an incompatible dimension")

    local Product = MatrixVector(A, X)
    local Residual = table.create(N)
    for Index = 1, N do
        Residual[Index] = B[Index] - Product[Index]
    end

    local Direction = table.clone(Residual)
    local ResidualSquared = Dot(Residual, Residual)
    local InitialResidual = math.sqrt(ResidualSquared)
    local Threshold = (Tolerance or 1e-9) * math.max(InitialResidual, 1)
    local Iterations = 0

    if InitialResidual <= Threshold then
        return X, {Converged = true, Iterations = 0, Residual = InitialResidual}
    end

    for Iteration = 1, MaximumIterations or (N * 4) do
        local ADirection = MatrixVector(A, Direction)
        local Denominator = Dot(Direction, ADirection)

        if Denominator <= 0 then
            return X, {
                Converged = false,
                Iterations = Iterations,
                Residual = math.sqrt(ResidualSquared),
                Reason = "Non-positive curvature detected; matrix may not be positive definite",
            }
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

    return X, {Converged = false, Iterations = Iterations, Residual = math.sqrt(ResidualSquared)}
end

SpectralLinearAlgebra.Dimensions = Dimensions
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
SpectralLinearAlgebra.LUFactor = LUFactor
SpectralLinearAlgebra.Solve = Solve
SpectralLinearAlgebra.SolveMultiple = SolveMultiple
SpectralLinearAlgebra.Determinant = Determinant
SpectralLinearAlgebra.Cholesky = Cholesky
SpectralLinearAlgebra.QR = QR
SpectralLinearAlgebra.LeastSquares = LeastSquares
SpectralLinearAlgebra.SymmetricEigen = SymmetricEigen
SpectralLinearAlgebra.ConjugateGradient = ConjugateGradient
SpectralLinearAlgebra.Version = "1.0.0-alpha"

return SpectralLinearAlgebra
