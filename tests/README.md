# VectorForge Test Suite

The VectorForge test suite provides a lightweight environment for validating the mathematical operations and numerical algorithms implemented throughout the library.

It is designed as a self-contained Roblox server-side test runner and does not require TestEZ or any other third-party testing framework.

The primary objective is to identify implementation errors, verify mathematical properties, and detect regressions during development.

## Setup

Before executing the test suite, ensure that all VectorForge modules are available inside `ReplicatedStorage`.

### Required Hierarchy

```text
ReplicatedStorage
└── VectorForge
    ├── LieGroupKinematics
    ├── SpectralLinearAlgebra
    ├── BayesianStateEstimation
    └── DifferentialPathGeometry

ServerScriptService
└── VectorForgeIntegrationTest.lua
```

### Running the Tests

1. Open your project in Roblox Studio.
2. Verify that all four ModuleScripts are installed correctly.
3. Place `VectorForgeIntegrationTest.lua` inside `ServerScriptService`.
4. Start a Play test.
5. Open the Output window.
6. Inspect the individual test results and final execution summary.

The runner reports successful tests using `[PASS]` and unsuccessful tests using `[FAIL]`.

## Test Coverage

The current suite covers four mathematical domains.

### 1. Lie Group Kinematics

Validates operations involving three-dimensional rotations and rigid transformations.

Coverage includes:

- SO(3) exponential and logarithmic maps.
- Quaternion rotation and magnitude preservation.
- Spherical Linear Interpolation (SLERP).
- SE(3) pose inversion.
- SE(3) exponential and logarithmic maps.

### 2. Spectral Linear Algebra

Validates matrix operations, numerical decompositions, and linear-system solvers.

Coverage includes:

- Matrix multiplication.
- LU-based linear-system solving.
- Determinant computation.
- Singular-system detection.
- Cholesky decomposition and reconstruction.
- Householder QR reconstruction.
- Matrix orthogonality.
- Symmetric eigenpair residuals.
- Conjugate Gradient convergence.
- Least-squares regression.

### 3. Bayesian State Estimation

Validates numerical estimation and filtering operations.

Coverage includes:

- Numerical Jacobian approximation.
- Extended Kalman Filter prediction.
- Measurement correction.
- Innovation-based measurement rejection.
- Accepted and rejected measurement tracking.

### 4. Differential Path Geometry

Validates curve evaluation and differential geometric properties.

Coverage includes:

- Hermite curve boundary conditions.
- Curvature computation.
- Torsion computation.
- Arc-length inversion.
- Frenet frame construction.
- Parallel-transport frames.
- Closest-point parameter estimation.
- Minimum-jerk trajectory boundary conditions.

## Test Execution Results

Each test is executed independently using protected error handling.

A failed test does not immediately terminate the remaining test cases. Instead, the runner records the failure and continues execution before producing the final summary.

Example output:

```text
[VectorForge][PASS] SO3 exponential/logarithmic maps
[VectorForge][PASS] Quaternion rotation preserves magnitude
[VectorForge][PASS] Matrix multiplication
[VectorForge][PASS] Cholesky reconstruction
[VectorForge][FAIL] EKF prediction and measurement update

================================================
[VectorForge] 22 passed | 1 failed
================================================
```

The output above is illustrative and does not represent an actual test execution.

## Numerical Validation

The current test suite uses deterministic inputs and finite numerical tolerances to evaluate expected mathematical behaviour.

This approach provides an initial regression-testing foundation but does not constitute formal mathematical verification.

Further testing is recommended in the following areas:

- Randomized input generation.
- Ill-conditioned matrix systems.
- Degenerate geometric configurations.
- Numerical precision and stability.
- Large-scale computational workloads.
- Solver convergence under difficult conditions.
- Runtime performance and memory consumption.

## Limitations

The test suite is experimental and may not cover every possible input configuration or numerical edge case.

Passing all available tests should not be interpreted as a guarantee of production readiness or universal numerical correctness.

Additional validation is necessary before relying on the library in performance-critical or gameplay-authoritative systems.

## Contributing Tests

Contributions that improve mathematical validation are welcome.

When introducing new functionality, consider including:

- Deterministic test cases.
- Expected numerical results.
- Appropriate floating-point tolerances.
- Invalid-input scenarios.
- Boundary-condition tests.
- Regression tests for previously identified issues.

The objective is to gradually expand the test suite as VectorForge evolves.
