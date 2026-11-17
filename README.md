# VectorForge

### Advanced Computational Mathematics for Roblox Luau

VectorForge is an experimental computational mathematics library designed to bring advanced numerical methods, geometric computation, and mathematical modeling into the Roblox development environment.

Rather than focusing on conventional gameplay utilities or general-purpose scripting abstractions, VectorForge explores the implementation of mathematical techniques commonly associated with computational geometry, numerical analysis, robotics, signal processing, and state estimation.

The project aims to provide a modular foundation for developers interested in building mathematically driven systems, conducting numerical experiments, and exploring complex computational techniques directly within Roblox Luau.

**Project Status:** Work in Progress — Experimental Development

VectorForge is an incomplete research-oriented project. Its implementation, API, numerical stability, performance characteristics, and documentation are still evolving. It is currently shared to demonstrate ongoing development, explore potential applications, and encourage technical discussion and community contributions.

---

## Table of Contents

- [Overview](#overview)
- [Core Modules](#core-modules)
  - [LieGroupKinematics](#1-liegrouplinematics)
  - [SpectralLinearAlgebra](#2-spectrallinearalgebra)
  - [BayesianStateEstimation](#3-bayesianstateestimation)
  - [DifferentialPathGeometry](#4-differentialpathgeometry)
  - [AutomaticDifferentiation](#5-automaticdifferentiation)
  - [RigidBodyDynamics](#6-rigidbodydynamics)
  - [NumericalOptimization](#7-numericaloptimization)
  - [TrajectoryPlanning](#8-trajectoryplanning)
- [Mathematical Foundations](#mathematical-foundations)
- [Potential Applications](#potential-applications)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Experiments](#experiments)
- [Benchmarking](#benchmarking)
- [Research Notes](#research-notes)
- [Testing](#testing)
- [Performance Considerations](#performance-considerations)
- [Limitations](#limitations)
- [Development Roadmap](#development-roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

VectorForge is organized around eight mathematical modules, each addressing a different area of computational mathematics.

The objective is to separate mathematical functionality into reusable components rather than implementing complex algorithms directly inside individual game scripts.

The library currently explores the following areas:

| Module | Mathematical Domain | Primary Focus |
|---|---|---|
| LieGroupKinematics | Lie Groups and Robotics Mathematics | Rotations and rigid-body transformations |
| SpectralLinearAlgebra | Numerical Linear Algebra | Matrix operations and numerical solvers |
| BayesianStateEstimation | Probability and State Estimation | Prediction, uncertainty, and measurement filtering |
| DifferentialPathGeometry | Differential Geometry | Curves, curvature, torsion, and trajectories |
| AutomaticDifferentiation | Numerical Differentiation | Derivative propagation through computational expressions |
| RigidBodyDynamics | Classical Mechanics | Rigid-body motion, forces, and dynamics |
| NumericalOptimization | Mathematical Optimization | Numerical methods for minimizing objective functions |
| TrajectoryPlanning | Motion Planning | Construction and evaluation of planned trajectories |

Each module has a distinct responsibility and is intended to operate independently where practical.

## Core Modules

### 1. LieGroupKinematics

**Domain:** Lie Groups, Rotation Theory, and Rigid-Body Kinematics.

LieGroupKinematics focuses on the mathematical representation and manipulation of rotations and rigid transformations in three-dimensional space.

Instead of relying exclusively on conventional transformation interpolation, the module explores quaternion mathematics and Lie-group operations for representing orientation and spatial motion.

Its mathematical foundations include:

- Quaternion algebra and rotation representations.
- SO(3) rotation group operations.
- SE(3) rigid-body transformations.
- Exponential and logarithmic maps.
- Spherical Linear Interpolation (SLERP).
- Pose composition and inversion.
- Twist representations and spatial transformations.

**Potential applications:**

- Smooth camera orientation systems.
- Advanced object transformation.
- Robotics-inspired movement systems.
- Procedural animation.
- Three-dimensional pose interpolation.
- Spatial simulation and kinematics.

The goal is to make advanced spatial mathematics reusable without requiring each application to implement its own rotation and transformation algorithms.

### 2. SpectralLinearAlgebra

**Domain:** Numerical Linear Algebra and Matrix Computation.

SpectralLinearAlgebra explores numerical methods for manipulating matrices, solving linear systems, and performing mathematical decompositions.

Linear algebra is a fundamental component of many computational systems, including optimization, physics simulation, machine learning, and numerical modeling.

The module is intended to provide reusable implementations of operations such as:

- Matrix multiplication and transposition.
- LU decomposition.
- Determinant computation.
- Cholesky decomposition.
- Householder QR decomposition.
- Symmetric eigenvalue approximation.
- Conjugate Gradient optimization.
- Least-squares estimation.
- Linear-system solving.

**Potential applications:**

- Mathematical optimization.
- Numerical simulation.
- Polynomial regression.
- Parameter estimation.
- Procedural mathematical modeling.
- Foundations for more advanced computational algorithms.

The module aims to provide a reusable numerical foundation for other VectorForge components and independent mathematical applications.

### 3. BayesianStateEstimation

**Domain:** Bayesian Inference, Probability, and Dynamic State Estimation.

BayesianStateEstimation explores techniques for estimating the internal state of a dynamic system when observations are incomplete or affected by uncertainty.

Real-world measurements are rarely perfect. A position measurement, for example, may contain noise or inaccuracies.

State estimation techniques combine mathematical models with observed measurements to produce more consistent estimates of a system's behaviour.

The module explores concepts including:

- Extended Kalman Filtering (EKF).
- State-transition models.
- Measurement models.
- Covariance propagation.
- Numerical Jacobian approximation.
- Measurement correction.
- Innovation calculation.
- Statistical measurement gating.

**Potential applications:**

- Noisy object-position tracking.
- Motion prediction.
- Sensor simulation.
- Trajectory estimation.
- Autonomous movement experiments.
- Dynamic system modeling.

One possible application is tracking an object whose measured position changes unpredictably. Instead of treating every observation as perfectly accurate, a state estimator combines previous estimates, predicted motion, and new measurements.

This provides a mathematical approach to handling uncertainty in dynamic environments.

### 4. DifferentialPathGeometry

**Domain:** Differential Geometry and Curve Analysis.

DifferentialPathGeometry focuses on the mathematical analysis of parameterized curves and their geometric properties.

Rather than treating a path as a simple collection of positions, differential geometry allows a path to be studied through its derivatives, curvature, torsion, and local coordinate frames.

The module explores:

- Hermite curve interpolation.
- First and higher-order derivatives.
- Curvature computation.
- Torsion computation.
- Numerical arc-length integration.
- Arc-length parameterization.
- Frenet frames.
- Parallel-transport frames.
- Closest-point estimation.
- Minimum-jerk trajectory generation.

**Potential applications:**

- Procedural path generation.
- Smooth NPC trajectories.
- Camera rail systems.
- Vehicle trajectory modeling.
- Advanced animation.
- Three-dimensional movement analysis.
- Geometric simulation.

For example, an object moving along a curved trajectory can use arc-length parameterization to maintain approximately constant movement speed, rather than moving at a speed determined by the curve's parameterization.

Parallel-transport frames can also help maintain smoother orientation along complex three-dimensional paths.

### 5. AutomaticDifferentiation

**Domain:** Automatic Differentiation and Numerical Calculus.

AutomaticDifferentiation explores methods for computing derivatives by propagating derivative information through arithmetic operations and supported computational expressions.

Its intended mathematical scope includes:

- Forward-mode derivative propagation.
- Computational expression evaluation with derivative tracking.
- Derivatives of supported scalar and vector-valued expressions.
- Sensitivity analysis for numerical models.

**Potential applications:**

- Gradient-based optimization.
- Sensitivity analysis.
- Parameter fitting.
- Differentiable mathematical experiments.

### 6. RigidBodyDynamics

**Domain:** Classical Mechanics and Rigid-Body Dynamics.

RigidBodyDynamics focuses on the motion of rigid bodies under applied forces, torques, and inertial properties.

Its intended mathematical scope includes:

- Linear and angular motion.
- Mass and inertia representations.
- Force and torque relationships.
- Rigid-body state evolution.
- Translational and rotational dynamics.

**Potential applications:**

- Physics experiments.
- Robotics-inspired simulation.
- Mechanical system modeling.
- Motion analysis.

### 7. NumericalOptimization

**Domain:** Numerical Optimization and Iterative Minimization.

NumericalOptimization explores numerical techniques for finding solutions that minimize objective functions subject to supported assumptions and constraints.

Its intended mathematical scope includes:

- Objective-function evaluation.
- Iterative parameter updates.
- Gradient-based optimization concepts.
- Convergence and stopping criteria.
- Numerical minimization.

**Potential applications:**

- Parameter estimation.
- Curve fitting.
- Mathematical calibration.
- Optimization experiments.

### 8. TrajectoryPlanning

**Domain:** Motion Planning and Trajectory Generation.

TrajectoryPlanning focuses on constructing and evaluating paths or time-dependent motion profiles between states or spatial targets.

Its intended mathematical scope includes:

- Trajectory construction.
- Motion-profile evaluation.
- Boundary-condition handling.
- Smooth movement planning.
- Integration with geometric and kinematic representations.

**Potential applications:**

- NPC movement.
- Robotics-inspired path planning.
- Camera and object motion.
- Procedural animation.

---

## Mathematical Foundations

VectorForge explores several mathematical disciplines that complement one another.

| Mathematical Area | Concepts |
|---|---|
| Linear Algebra | Matrix operations, decompositions, eigenvalues |
| Differential Geometry | Curvature, torsion, tangent and normal frames |
| Lie Theory | SO(3), SE(3), exponential and logarithmic maps |
| Numerical Analysis | Approximation, integration, iterative solvers |
| Probability Theory | Bayesian estimation and uncertainty |
| Optimization | Least-squares estimation and iterative minimization |
| Signal Processing | Frequency-domain analysis and numerical transforms |

These disciplines form the theoretical foundation of the library.

For additional mathematical explanations, see [MATHEMATICS.md](docs/MATHEMATICS.md).

---

## Potential Applications

VectorForge is not limited to a particular type of Roblox experience.

Its mathematical components may be useful in projects where conventional gameplay scripting is insufficient or where more sophisticated mathematical modeling is desirable.

Some possible applications include:

**Physics and Simulation**

Numerical solvers, transformations, and mathematical modeling can support experimental physics and simulation systems.

**Procedural Animation**

Quaternion interpolation, trajectory generation, and differential geometry can be used to explore more sophisticated animation techniques.

**Artificial Intelligence Experiments**

State estimation, prediction, and mathematical optimization can provide foundations for experimental intelligent systems.

**Robotics-Inspired Systems**

Rigid-body transformations, spatial coordinates, and kinematic calculations can be applied to robotic movement simulations.

**Computational Geometry**

Curve analysis, geometric transformations, and coordinate-frame calculations can support advanced procedural environments.

These are potential applications rather than claims that VectorForge already implements complete systems for each domain.

---

## Architecture

VectorForge follows a modular architecture in which each mathematical component is maintained independently.

```text
                         Roblox Experience
                                |
                                v
                            VectorForge
                                |
       +------------------------+------------------------+
       |                        |                        |
       v                        v                        v
 LieGroupKinematics    SpectralLinearAlgebra    BayesianStateEstimation
       |                        |                        |
       v                        v                        v
 Spatial Mathematics    Numerical Computation     State Estimation

       +------------------------+------------------------+
       |                        |                        |
       v                        v                        v
DifferentialPathGeometry  AutomaticDifferentiation  RigidBodyDynamics
       |                        |                        |
       v                        v                        v
 Curve Computation       Derivative Analysis       Physical Dynamics

       +------------------------+------------------------+
       |                        |
       v                        v
NumericalOptimization   TrajectoryPlanning
       |                        |
       v                        v
 Optimization Methods    Motion Planning
```

The architecture is intended to provide:

- Separation of mathematical responsibilities.
- Reusable computational components.
- Independent module development.
- Clear interfaces between mathematical systems.
- Easier testing and future expansion.

For more information, see [ARCHITECTURE.md](docs/ARCHITECTURE.md).

---

## Repository Structure

```text
VectorForge/
│
├── benchmarks/
│   ├── README.md
│   ├── BenchmarkUtils.lua
│   ├── MatrixBenchmarks.server.lua
│   ├── OptimizationBenchmarks.server.lua
│   ├── GeometryBenchmarks.server.lua
│   └── StateEstimationBenchmarks.server.lua
│
├── docs/
│   ├── API.md
│   ├── ARCHITECTURE.md
│   ├── MATHEMATICS.md
│   ├── NUMERICAL_VALIDATION.md
│   ├── BENCHMARKING.md
│   ├── DESIGN_DECISIONS.md
│   └── GLOSSARY.md
│
├── examples/
│   └── server/
│       ├── README.md
│       ├── PoseInterpolation.lua
│       ├── DifferentialPath.lua
│       ├── IntegrationDemo.lua
│       ├── BayesianMotionTracking.lua
│       └── LeastSquaresRegression.lua
│
├── experiments/
│   ├── README.md
│   ├── CelestialMechanics.server.lua
│   ├── OrbitalSimulation.server.lua
│   ├── KalmanVisualization.server.lua
│   ├── TrajectoryLaboratory.server.lua
│   └── NumericalStabilityLab.server.lua
│
├── research/
│   ├── README.md
│   ├── LieGroupNotes.md
│   ├── NumericalMethods.md
│   ├── StateEstimationNotes.md
│   └── FutureAlgorithms.md
│
├── src/
│   └── VectorForge/
│       ├── LieGroupKinematics
│       ├── SpectralLinearAlgebra
│       ├── BayesianStateEstimation
│       ├── DifferentialPathGeometry
│       ├── AutomaticDifferentiation
│       ├── RigidBodyDynamics
│       ├── NumericalOptimization
│       └── TrajectoryPlanning
│
├── tests/
│   ├── README.md
│   ├── ComprehensiveTester.lua
│   ├── SmallTaster.lua
│   └── VectorForgeIntegrationTest.lua
│
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── default.project.json
├── LICENSE
├── package.json
├── package-lock.json
└── README.md
```

### Directory Responsibilities

| Directory | Description |
|---|---|
| `src/` | Core mathematical implementations |
| `docs/` | Technical documentation, mathematical explanations, and design references |
| `examples/` | Practical demonstrations and usage scenarios |
| `tests/` | Regression tests and mathematical validation |
| `benchmarks/` | Workload-based performance measurement scripts |
| `experiments/` | Experimental visualizations and numerical demonstrations |
| `research/` | Mathematical notes, algorithm research, and future development ideas |

---

## Installation

### Manual Installation

1. Open Roblox Studio.
2. Navigate to `ReplicatedStorage`.
3. Create a folder named `VectorForge`.
4. Copy the eight ModuleScripts from `src/VectorForge/` into the folder.
5. Ensure that the ModuleScript names remain unchanged.

The expected Roblox hierarchy should look like this:

```text
ReplicatedStorage
└── VectorForge
    ├── LieGroupKinematics
    ├── SpectralLinearAlgebra
    ├── BayesianStateEstimation
    ├── DifferentialPathGeometry
    ├── AutomaticDifferentiation
    ├── RigidBodyDynamics
    ├── NumericalOptimization
    └── TrajectoryPlanning
```

### Rojo Installation

VectorForge includes a Rojo project configuration.

Make sure `default.project.json` maps `src/VectorForge` to `ReplicatedStorage/VectorForge`.

Build the project using:

```bash
rojo build default.project.json -o VectorForge.rbxlx
```

For more information about Rojo, visit:

https://rojo.space/

---

## Usage

After installing the modules, they can be accessed through Roblox's `require()` functionality.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")

local Lie = require(VectorForge:WaitForChild("LieGroupKinematics"))

local LinearAlgebra = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))

local StateEstimation = require(VectorForge:WaitForChild("BayesianStateEstimation"))

local PathGeometry = require(VectorForge:WaitForChild("DifferentialPathGeometry"))

local AutomaticDifferentiation = require(VectorForge:WaitForChild("AutomaticDifferentiation"))

local RigidBodyDynamics = require(VectorForge:WaitForChild("RigidBodyDynamics"))

local NumericalOptimization = require(VectorForge:WaitForChild("NumericalOptimization"))

local TrajectoryPlanning = require(VectorForge:WaitForChild("TrajectoryPlanning"))
```

Each module can then be used according to its exposed API.

For available operations, constructor signatures, and return values, consult:

[API Reference](docs/API.md)

---

## Examples

The `examples/` directory contains standalone demonstrations designed to illustrate how the mathematical modules can be applied within Roblox.

| Example | Description |
|---|---|
| Pose Interpolation | Demonstrates interpolation between rigid-body poses |
| Differential Path | Demonstrates curve sampling and movement along a geometric path |
| Bayesian Motion Tracking | Demonstrates estimation using noisy position observations |
| Least-Squares Regression | Demonstrates polynomial fitting using numerical linear algebra |
| Integration Demo | Demonstrates interactions across the expanded VectorForge module set |

Each example is intended to be independently understandable and can be used as a starting point for further experimentation.

See [examples/README.md](examples/README.md) for setup instructions.

---

## Experiments

The `experiments/` directory contains exploratory scripts designed to demonstrate mathematical concepts visually and investigate possible applications of VectorForge.

Current experiments include:

| Experiment | Description |
|---|---|
| Celestial Mechanics | Educational visualization of simplified gravitational motion |
| Orbital Simulation | Exploration of orbital trajectories using simplified mechanics |
| Kalman Visualization | Visualization of noisy observations and smoothed estimates |
| Trajectory Laboratory | Experimental trajectory construction and visualization |
| Numerical Stability Lab | Comparison of numerical summation approaches |

These scripts are intended for experimentation and learning rather than production-ready simulation.

Some experiments use simplified reference calculations or visualization adapters. They should not be interpreted as proof that every underlying algorithm is implemented by a VectorForge module.

In particular, the celestial and orbital demonstrations are simplified Newtonian models, not general-relativistic simulations. The Kalman visualization is a simplified smoothing demonstration rather than a complete EKF implementation.

See [experiments/README.md](experiments/README.md).

---

## Benchmarking

The `benchmarks/` directory provides workload-oriented scripts for investigating the performance of selected mathematical operations.

The current benchmark collection includes:

- Matrix computation workloads.
- Numerical optimization workloads.
- Differential geometry workloads.
- State estimation workloads.
- Shared benchmark utilities.

The benchmark scripts are intended to provide a starting point for performance measurement and comparison.

Results may vary depending on hardware, Roblox runtime conditions, input sizes, and implementation details.

Some benchmark scripts require adapters to connect their workload callbacks to the verified public APIs of the corresponding modules. Their presence does not imply that comprehensive performance measurements have already been completed.

For benchmarking methodology and guidance, see:

- [BENCHMARKING.md](docs/BENCHMARKING.md)
- [benchmarks/README.md](benchmarks/README.md)

---

## Research Notes

The `research/` directory contains supporting mathematical notes and exploratory material related to the project's development.

Current topics include:

- Lie group mathematics and spatial transformations.
- Numerical methods and computational stability.
- Bayesian state estimation.
- Potential future algorithms and mathematical extensions.

These documents provide a place to record theoretical considerations, investigate alternative methods, and organize ideas before they become part of the core implementation.

Research notes are supplementary material and should not be interpreted as formal mathematical verification.

See [research/README.md](research/README.md).

---

## Testing

VectorForge includes regression and comprehensive test scripts designed to exercise important mathematical operations across its expanded module set.

The test runner checks several areas, including:

- Quaternion operations and rigid transformations.
- Matrix multiplication and decomposition.
- Linear-system solving.
- Eigenvalue calculations.
- Numerical optimization.
- Extended Kalman Filter operations.
- Curve evaluation and differential properties.
- Arc-length calculations.
- Trajectory boundary conditions.
- Automatic differentiation and numerical optimization checks.
- Rigid-body dynamics and trajectory-planning checks.

### Running the Tests

1. Install the VectorForge modules in `ReplicatedStorage/VectorForge`.
2. Place the test runner inside `ServerScriptService`.
3. Start a Play session in Roblox Studio.
4. Open the Output window.
5. Inspect the test results.

The suite represents an initial regression-testing foundation. It does not constitute formal mathematical verification or guarantee numerical stability.

See [tests/README.md](tests/README.md).

---

## Performance Considerations

Numerical algorithms can become computationally expensive depending on their input dimensions, iteration counts, and frequency of execution.

When using VectorForge in Roblox experiences, consider:

- Avoiding unnecessary matrix decompositions.
- Reusing previously calculated results when inputs remain unchanged.
- Limiting expensive numerical operations inside frame-dependent loops.
- Choosing appropriate solver tolerances and iteration limits.
- Profiling algorithms with representative workloads.
- Separating authoritative server calculations from client-side visual calculations where appropriate.

The performance characteristics of the current implementation have not yet been comprehensively benchmarked.

---

## Development Roadmap

VectorForge is still evolving. The following areas represent potential future development directions rather than guaranteed release commitments.

### Numerical Improvements

- Additional matrix decomposition methods.
- Improved numerical stability.
- More robust handling of degenerate inputs.
- Additional iterative solvers.
- Better convergence diagnostics.

### Mathematical Expansion

- Advanced optimization methods.
- Additional probability and estimation techniques.
- More geometric transformation utilities.
- Numerical integration methods.
- Additional differential geometry operations.

### Developer Experience

- Expanded API documentation.
- More practical examples.
- Additional automated tests.
- Performance benchmarks.
- Improved error handling and validation.

### Research and Experimentation

- More numerical experiments.
- Additional visualization tools.
- Expanded mathematical research notes.
- Investigation of new computational algorithms.

---

## Limitations

VectorForge is currently experimental and should not be considered a finalized mathematical framework.

The current project may contain incomplete functionality, numerical limitations, undocumented edge cases, and APIs that are subject to change.

Not every potential application described in this README is currently implemented.

Benchmark scripts may require API-specific adapters, while experimental demonstrations may use simplified reference calculations.

Developers should validate the mathematical behaviour of any functionality before using it in important gameplay systems or production environments.

---

## Contributing

Contributions, technical feedback, bug reports, and suggestions are welcome.

If you discover an issue or want to improve an implementation, please review [CONTRIBUTING.md](CONTRIBUTING.md) before submitting changes.

When reporting an issue, provide:

- The affected module.
- A minimal reproducible example.
- Expected mathematical behaviour.
- Actual observed behaviour.
- Relevant Roblox Studio Output errors.

---

## License

VectorForge is distributed under the MIT License.

See [LICENSE](LICENSE) for the complete license text.

---

## Final Note

VectorForge is an ongoing experimental project exploring how advanced computational mathematics can be implemented and applied within the Roblox Luau environment.

It is not intended to be presented as a finished framework or a complete replacement for specialized numerical software.

The purpose of sharing this project is to document the work, experiment with mathematical implementations, explore possible applications, and make its development accessible to other developers interested in the same field.

**The project is still a work in progress, and there is considerably more to explore.**