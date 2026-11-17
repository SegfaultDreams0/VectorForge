# API Reference

The VectorForge API provides access to a collection of mathematical operations and numerical algorithms implemented in Roblox Luau.

This document describes the responsibilities, mathematical domains, expected data representations, and intended usage of the library's core modules.

It serves as a technical reference for developers integrating VectorForge into their Roblox projects.

**API Stability:** Experimental. Public interfaces, function signatures, argument conventions, and return values may change during development.

## Table of Contents

- [Getting Started](#getting-started)
- [Module Overview](#module-overview)
- [LieGroupKinematics](#1-liegrouplinematics)
- [SpectralLinearAlgebra](#2-spectrallinearalgebra)
- [BayesianStateEstimation](#3-bayesianstateestimation)
- [DifferentialPathGeometry](#4-differentialpathgeometry)
- [AutomaticDifferentiation](#5-automaticdifferentiation)
- [RigidBodyDynamics](#6-rigidbodydynamics)
- [NumericalOptimization](#7-numericaloptimization)
- [TrajectoryPlanning](#8-trajectoryplanning)
- [Data Representations](#data-representations)
- [Numerical Considerations](#numerical-considerations)
- [Error Handling](#error-handling)
- [API Stability](#api-stability)

---

## Getting Started

VectorForge modules are designed to be loaded through Roblox's standard `require()` mechanism.

After installing the library inside `ReplicatedStorage`, individual modules can be accessed as follows:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = ReplicatedStorage:WaitForChild("VectorForge")

local Lie = require(Modules:WaitForChild("LieGroupKinematics"))

local LinearAlgebra = require(
    Modules:WaitForChild("SpectralLinearAlgebra")
)

local StateEstimation = require(
    Modules:WaitForChild("BayesianStateEstimation")
)

local PathGeometry = require(
    Modules:WaitForChild("DifferentialPathGeometry")
)
```

Each module is responsible for a specific mathematical domain.

Modules should be required only when their functionality is needed.

## Module Overview

| Module | Mathematical Domain | Primary Responsibility |
|---|---|---|
| LieGroupKinematics | Lie Groups and Kinematics | Spatial transformations |
| SpectralLinearAlgebra | Numerical Linear Algebra | Matrix computation |
| BayesianStateEstimation | Bayesian Estimation | Dynamic state estimation |
| DifferentialPathGeometry | Differential Geometry | Curve and trajectory analysis |
| AutomaticDifferentiation | Numerical Differentiation | Derivative propagation |
| RigidBodyDynamics | Classical Mechanics | Rigid-body dynamics calculations |
| NumericalOptimization | Numerical Optimization | Objective minimization |
| TrajectoryPlanning | Motion Planning | Planned trajectory construction and evaluation |

---

## 1. LieGroupKinematics

**Mathematical Domain:** Lie Groups, Quaternion Algebra, and Rigid-Body Kinematics.

LieGroupKinematics provides mathematical representations and operations for three-dimensional rotations and rigid transformations.

The module explores quaternion-based orientation representations and Lie-group operations for manipulating spatial poses.

### Mathematical Concepts

- Quaternion algebra.
- SO(3) rotation group.
- SE(3) rigid transformation group.
- Exponential and logarithmic maps.
- Spherical Linear Interpolation (SLERP).
- Pose composition.
- Pose inversion.
- Spatial transformations.
- Twist representations.

### Core Mathematical Responsibilities

**Rotation Representation**

Represent three-dimensional orientations using quaternion mathematics.

**Rotation Interpolation**

Interpolate between two orientations using spherical interpolation rather than relying exclusively on component-wise interpolation.

**Rigid Transformations**

Represent transformations combining rotation and translation.

**Pose Operations**

Support mathematical operations involving spatial poses, including composition, inversion, and point transformations.

**Lie Algebra Operations**

Explore exponential and logarithmic mappings between local algebra representations and their corresponding group representations.

### Expected Data Types

| Data | Representation |
|---|---|
| Spatial vectors | `Vector3` |
| Rotations | Module-defined quaternion representation |
| Translations | `Vector3` |
| Poses | Module-defined pose representation |
| Twists | Module-defined angular and linear components |

### Potential Applications

- Camera orientation.
- Robotics-inspired movement.
- Spatial animation.
- Rigid-body pose interpolation.
- Procedural transformations.
- Three-dimensional kinematics.

### Implementation Considerations

Quaternion ordering, normalization behaviour, coordinate conventions, and transform composition order must be confirmed against the implementation.

Rotation angles should be interpreted according to the conventions documented by the corresponding functions.

---

## 2. SpectralLinearAlgebra

**Mathematical Domain:** Numerical Linear Algebra and Matrix Computation.

SpectralLinearAlgebra provides a collection of matrix operations and numerical algorithms for solving mathematical problems involving linear systems, matrix decompositions, and least-squares estimation.

It is also intended to provide reusable numerical foundations for other VectorForge modules.

### Mathematical Concepts

- Matrix algebra.
- LU decomposition.
- Cholesky decomposition.
- Householder QR decomposition.
- Eigenvalue approximation.
- Linear-system solving.
- Conjugate Gradient.
- Least-squares estimation.
- Numerical matrix operations.

### Core Mathematical Responsibilities

**Matrix Operations**

Perform fundamental operations such as multiplication and transposition.

**LU Decomposition**

Factorize suitable matrices into lower and upper triangular components, with pivoting where supported by the implementation.

**Cholesky Decomposition**

Factorize suitable symmetric positive-definite matrices.

**QR Decomposition**

Construct orthogonal and triangular factors using Householder transformations.

**Eigenvalue Approximation**

Estimate eigenvalues and associated eigenvectors for supported matrix configurations.

**Conjugate Gradient**

Iteratively solve suitable linear systems using residual-based convergence criteria.

**Least-Squares Estimation**

Estimate unknown parameters by minimizing the squared residual between observations and model predictions.

### Expected Data Types

| Data | Representation |
|---|---|
| Matrix | Nested numeric Luau tables |
| Vector | Numeric Luau array |
| Scalar | Luau number |
| Factorization result | Module-defined numeric tables |

### Potential Applications

- Polynomial regression.
- Numerical optimization.
- Parameter estimation.
- Computational simulation.
- Matrix-based transformations.
- Mathematical modeling.
- Foundation for estimation algorithms.

### Implementation Considerations

Matrix dimensions must be compatible with the requested operation.

Cholesky decomposition requires suitable positive-definite input matrices. Conjugate Gradient is intended for symmetric positive-definite systems.

Singular matrices, poorly conditioned systems, and numerical precision limitations require particular attention.

---

## 3. BayesianStateEstimation

**Mathematical Domain:** Bayesian Inference, Probability Theory, and Dynamic State Estimation.

BayesianStateEstimation explores mathematical methods for estimating the internal state of a dynamic system from uncertain or noisy observations.

The module focuses on prediction and measurement correction using an Extended Kalman Filter.

### Mathematical Concepts

- Bayesian state estimation.
- Extended Kalman Filtering.
- State-transition functions.
- Measurement functions.
- Covariance propagation.
- Numerical Jacobians.
- Innovation calculation.
- Measurement correction.
- Innovation gating.

### Core Mathematical Responsibilities

**State Prediction**

Estimate the next system state using a mathematical transition model.

**Uncertainty Propagation**

Propagate the covariance matrix to represent uncertainty in the predicted state.

**Measurement Prediction**

Estimate the observation expected from the predicted state.

**Measurement Correction**

Compare actual observations against predicted measurements and update the state estimate.

**Innovation Analysis**

Calculate the difference between observed and predicted measurements.

**Measurement Gating**

Evaluate whether a measurement is sufficiently consistent with the predicted state before accepting it.

### General State Representation

A state vector may contain information such as position and velocity.

For example:

```lua
local InitialState = {
    0,
    8,
    0,
    5,
    0,
    2
}
```

The exact meaning of each state component depends on the transition and measurement models supplied to the estimator.

### Potential Applications

- Noisy position tracking.
- Motion estimation.
- Object trajectory prediction.
- Simulated sensor systems.
- Dynamic system modeling.
- Autonomous movement experiments.

### Implementation Considerations

The quality of an estimation system depends on its transition model, measurement model, process noise, and measurement noise assumptions.

Incorrect noise assumptions can produce unreliable estimates.

The numerical Jacobian and covariance calculations should also be validated against representative and degenerate inputs.

---

## 4. DifferentialPathGeometry

**Mathematical Domain:** Differential Geometry and Computational Curve Analysis.

DifferentialPathGeometry focuses on mathematical representations and analysis of parameterized curves in three-dimensional space.

The module explores the geometric properties of curves through their derivatives, curvature, torsion, arc length, and local coordinate frames.

### Mathematical Concepts

- Hermite curve interpolation.
- Differential calculus.
- Curve derivatives.
- Curvature.
- Torsion.
- Arc-length integration.
- Arc-length parameterization.
- Frenet frames.
- Parallel-transport frames.
- Closest-point estimation.
- Minimum-jerk trajectories.

### Core Mathematical Responsibilities

**Curve Evaluation**

Calculate positions along parameterized curves.

**Differential Analysis**

Evaluate derivative-based properties of curves.

**Curvature**

Measure the rate at which the direction of a curve changes relative to its arc length.

**Torsion**

Measure the spatial twisting behaviour of a three-dimensional curve.

**Arc-Length Calculation**

Estimate the distance travelled along a curve using numerical integration.

**Arc-Length Parameterization**

Convert between curve parameters and travelled distance.

**Coordinate Frames**

Construct local frames using Frenet or parallel-transport methods.

**Trajectory Generation**

Explore smooth trajectories using minimum-jerk interpolation.

### Expected Data Types

| Data | Representation |
|---|---|
| Control points | `Vector3` |
| Curve positions | `Vector3` |
| Tangents | `Vector3` |
| Normals | `Vector3` |
| Binormals | `Vector3` |
| Curve parameters | Numeric Luau values |

### Potential Applications

- Procedural path generation.
- Camera rail systems.
- Smooth NPC movement.
- Vehicle trajectories.
- Procedural animation.
- Three-dimensional geometric modeling.

### Implementation Considerations

Curve derivatives may become degenerate in certain configurations.

Frenet frames can become unstable where curvature approaches zero. Parallel-transport frames provide an alternative for constructing smoothly varying orientations.

Arc-length calculations are numerical approximations and depend on the integration method and sampling configuration.

---

## 5. AutomaticDifferentiation

**Mathematical Domain:** Automatic Differentiation and Numerical Calculus.

AutomaticDifferentiation is intended to compute derivative information by propagating derivatives through supported operations.

### Mathematical Concepts

- Forward-mode automatic differentiation.
- Derivative propagation.
- Computational expressions.
- Sensitivity analysis.

### Core Mathematical Responsibilities

**Derivative Evaluation**

Evaluate supported expressions while tracking derivative information.

**Sensitivity Analysis**

Provide derivative information that can help determine how outputs change in response to input variations.

### Implementation Considerations

Supported value types, operation coverage, derivative conventions, and exact public interfaces must be confirmed against the module implementation. This overview does not define function signatures.

## 6. RigidBodyDynamics

**Mathematical Domain:** Classical Mechanics and Rigid-Body Dynamics.

RigidBodyDynamics is intended to represent and evaluate quantities associated with rigid-body motion.

### Mathematical Concepts

- Linear motion.
- Angular motion.
- Forces and torques.
- Mass and inertia.
- Translational and rotational dynamics.

### Core Mathematical Responsibilities

**Dynamic Quantities**

Represent or calculate supported quantities involved in rigid-body motion.

**Motion Evaluation**

Evaluate dynamic behaviour according to the models and inputs supported by the implementation.

### Implementation Considerations

The exact state representation, units, integration method, force conventions, and inertia representation must be checked against the source code.

## 7. NumericalOptimization

**Mathematical Domain:** Numerical Optimization and Iterative Minimization.

NumericalOptimization is intended to provide methods for improving candidate parameters with respect to an objective function.

### Mathematical Concepts

- Objective functions.
- Iterative minimization.
- Gradient-based methods.
- Convergence criteria.
- Parameter estimation.

### Core Mathematical Responsibilities

**Objective Minimization**

Search for parameter values that reduce an objective according to the selected algorithm.

**Convergence Evaluation**

Use method-specific stopping criteria to determine when an iterative process should stop.

### Implementation Considerations

The available algorithms, gradient requirements, constraint handling, line-search behaviour, and convergence guarantees depend on the implementation. Do not assume a specific optimizer or API signature without checking the source.

## 8. TrajectoryPlanning

**Mathematical Domain:** Motion Planning and Trajectory Generation.

TrajectoryPlanning is intended to construct and evaluate motion trajectories between supported states or targets.

### Mathematical Concepts

- Trajectory construction.
- Motion profiles.
- Boundary conditions.
- Smooth motion.
- Time-dependent path evaluation.

### Core Mathematical Responsibilities

**Trajectory Construction**

Generate a trajectory using the constraints and parameters supported by the implementation.

**Trajectory Evaluation**

Evaluate planned motion at supported parameters or times.

### Implementation Considerations

The exact trajectory representation, boundary-condition model, continuity guarantees, and relationship to DifferentialPathGeometry must be verified against the source implementation.

## Data Representations

VectorForge uses a combination of native Roblox data types and Luau table-based numerical structures.

The general conventions used throughout the examples are:

| Data Category | Representation |
|---|---|
| Spatial vectors | `Vector3` |
| Matrices | Nested Luau tables |
| Numeric vectors | Sequential Luau tables |
| Scalar values | `number` |
| Configuration | Luau tables |
| State models | Module-defined structures |

The exact representation of specialized structures such as quaternions, poses, and covariance matrices depends on the corresponding module.

Developers should avoid assuming that two modules use identical internal representations without checking their implementations.

## Numerical Considerations

Numerical algorithms operate using finite-precision floating-point arithmetic.

Consequently, calculated results may contain small deviations from their theoretical values.

Consider the following when using VectorForge:

- Use appropriate numerical tolerances.
- Validate matrix dimensions before computation.
- Avoid unnecessary operations on singular matrices.
- Handle near-zero vector magnitudes.
- Validate finite numerical inputs.
- Consider convergence criteria for iterative algorithms.
- Account for accumulated numerical error in repeated calculations.

Exact equality comparisons should generally be avoided when evaluating floating-point results.

## Error Handling

The behaviour of invalid inputs should be evaluated according to the individual module's implementation.

Important cases include:

- Singular matrices.
- Incompatible matrix dimensions.
- Invalid numerical values.
- Degenerate geometric configurations.
- Undefined curve derivatives.
- Failed numerical convergence.
- Invalid covariance configurations.

Do not assume that every module handles these cases identically.

## API Stability

VectorForge is currently experimental.

The public interfaces, argument conventions, internal representations, and algorithmic implementations may change as the project develops.

Developers integrating the library into other projects should consider pinning a specific repository commit when reproducibility is important.

---

## Related Documentation

- [Architecture](ARCHITECTURE.md)
- [Mathematical Foundations](MATHEMATICS.md)
- [Examples](../examples/README.md)
- [Tests](../tests/README.md)
- [Changelog](../CHANGELOG.md)

---

*This reference documents the intended mathematical responsibilities and organization of VectorForge. Always consult the actual module implementations for authoritative function signatures and behaviour.*