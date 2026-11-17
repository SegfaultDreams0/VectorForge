# Numerical Validation

Tests provide evidence for tested cases; they do not prove correctness for every input.

## Validation layers
1. Input dimensions, finite values, ranges, and matrix preconditions.
2. Mathematical invariants, such as rotation orthogonality where applicable.
3. Residuals measuring how closely results satisfy defining equations.
4. Analytically known cases or independent reference implementations.
5. Boundary and degenerate inputs.
6. Regression tests for previously verified behaviour.

## Suggested checks

| Module | Checks |
|---|---|
| LieGroupKinematics | Unit quaternion norm, rotation orthogonality, determinant near +1, inverse consistency |
| SpectralLinearAlgebra | Factorization reconstruction residuals, solve residuals, orthogonality of Q |
| BayesianStateEstimation | Covariance symmetry, finite states, innovation dimensions, synthetic observations |
| DifferentialPathGeometry | Endpoint interpolation, derivative checks, arc-length convergence, frame orthogonality |
| AutomaticDifferentiation | Compare derivatives with analytic functions and selected finite differences |
| RigidBodyDynamics | Conservation checks in idealized cases, force/torque dimensional consistency |
| NumericalOptimization | Objective reduction, gradient checks, termination behaviour |
| TrajectoryPlanning | Boundary position, velocity, and acceleration constraints |

Apply checks only when their mathematical assumptions hold.

## Tolerances

Choose tolerances based on input scale, conditioning, floating-point precision, and algorithm stopping criteria. A useful comparison form is:

`abs(actual - expected) <= absoluteTolerance + relativeTolerance * abs(expected)`

For vectors and matrices, state which norm is used.

## Reproducibility

Use deterministic inputs where possible, record random seeds, Studio version, commit hash, input scale, expected result, and tolerance.
