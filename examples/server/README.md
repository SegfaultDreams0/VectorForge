# VectorForge Examples

This directory contains practical demonstrations of the mathematical modules provided by VectorForge.

Each example illustrates a particular computational technique and demonstrates how it can be integrated into a Roblox environment.

The examples are intended to provide a starting point for experimentation, mathematical exploration, and further development.

## Setup

Before running any example, ensure that the four VectorForge ModuleScripts are installed inside `ReplicatedStorage/VectorForge`.

### Required ModuleScripts

```text
ReplicatedStorage
└── VectorForge
    ├── LieGroupKinematics
    ├── SpectralLinearAlgebra
    ├── BayesianStateEstimation
    └── DifferentialPathGeometry
```

### Execution

1. Open the desired example script.
2. Place it inside `ServerScriptService`.
3. Ensure the required VectorForge modules are available.
4. Start a Play test in Roblox Studio.
5. Inspect the Workspace and Output window to observe the results.

Run visual examples individually to avoid overlapping demonstrations.

## Included Examples

### 01. Pose Interpolation

**File:** `01_PoseInterpolation.server.lua`

Demonstrates interpolation between two three-dimensional rigid-body poses.

The example constructs two different poses using rotational and translational components, then interpolates between them over time.

**Mathematical concepts:**

- Quaternion representations.
- SO(3) rotation operations.
- SE(3) rigid transformations.
- Spherical Linear Interpolation.
- Pose interpolation.

**Demonstration:**

A Part moves between two spatial positions while its orientation changes continuously according to the interpolated rotational state.

### 02. Differential Path Geometry

**File:** `02_DifferentialPath.server.lua`

Demonstrates the evaluation and visualization of a smooth three-dimensional path.

The example constructs a curve from control points and samples its geometric properties to visualize the resulting trajectory.

**Mathematical concepts:**

- Hermite curve interpolation.
- Differential geometry.
- Curvature and torsion.
- Arc-length parameterization.
- Frenet frames.
- Parallel-transport frames.

**Demonstration:**

A Part moves along the generated trajectory using arc-length-based positioning.

Additional markers visualize sampled positions along the curve.

### 03. Bayesian Motion Tracking

**File:** `03_BayesianMotionTracking.server.lua`

Demonstrates state estimation using an Extended Kalman Filter.

The example generates a moving object with simulated measurement noise and compares its actual position against the estimated position produced by the filter.

**Mathematical concepts:**

- Bayesian state estimation.
- Extended Kalman Filtering.
- State-transition models.
- Measurement models.
- Covariance propagation.
- Measurement noise.
- Innovation gating.

**Demonstration:**

Two visual markers represent the actual position and the estimated position.

The estimated position is updated using noisy observations and the filter's prediction and correction stages.

### 04. Least-Squares Regression

**File:** `04_LeastSquaresRegression.server.lua`

Demonstrates polynomial regression using numerical linear algebra.

The example constructs a quadratic design matrix from sample observations and estimates the polynomial coefficients using a least-squares solver.

**Mathematical concepts:**

- Linear systems.
- Householder QR decomposition.
- Least-squares estimation.
- Polynomial regression.
- Residual analysis.

**Demonstration:**

The script calculates a quadratic model from sample data and prints the estimated coefficients, predicted values, residuals, and residual sum of squares.

## Example Overview

| Example | Mathematical Domain | Main Demonstration |
|---|---|---|
| Pose Interpolation | Lie Groups | Rigid-pose interpolation |
| Differential Path | Differential Geometry | Three-dimensional trajectory |
| Bayesian Motion Tracking | State Estimation | Noisy measurement filtering |
| Least-Squares Regression | Linear Algebra | Quadratic model estimation |

## Workspace Behaviour

Visual examples create dedicated folders inside `Workspace` to keep their generated objects organized.

Generated demonstration objects are anchored and non-collidable.

For a clean testing environment, stop the Play session before executing another visual example.

## Important Notes

These examples are educational and experimental demonstrations rather than complete production gameplay systems.

They are intended to illustrate mathematical operations and provide reference implementations for developers exploring VectorForge.

Their numerical behaviour and runtime performance should be evaluated before adapting them to production environments.

## Extending the Examples

Developers are encouraged to experiment with the existing scripts and create additional demonstrations.

Potential areas for future examples include:

- Robotic inverse kinematics.
- Numerical trajectory optimization.
- Three-dimensional orientation tracking.
- Procedural geometric modeling.
- Dynamic system simulation.
- Advanced numerical integration.
- Signal analysis and frequency decomposition.

New examples should clearly identify the mathematical methods being demonstrated and include the necessary setup instructions.