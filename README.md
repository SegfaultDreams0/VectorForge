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
- [Mathematical Foundations](#mathematical-foundations)
- [Potential Applications](#potential-applications)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Testing](#testing)
- [Performance Considerations](#performance-considerations)
- [Limitations](#limitations)
- [Development Roadmap](#development-roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

VectorForge is organized around four independent mathematical modules, each addressing a different area of computational mathematics.

The objective is to separate mathematical functionality into reusable components rather than implementing complex algorithms directly inside individual game scripts.

The library currently explores the following areas:

| Module | Mathematical Domain | Primary Focus |
|---|---|---|
| LieGroupKinematics | Lie Groups and Robotics Mathematics | Rotations and rigid-body transformations |
| SpectralLinearAlgebra | Numerical Linear Algebra | Matrix operations and numerical solvers |
| BayesianStateEstimation | Probability and State Estimation | Prediction, uncertainty, and measurement filtering |
| DifferentialPathGeometry | Differential Geometry | Curves, curvature, torsion, and trajectories |

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
                         |
                    VectorForge
                         |
          +--------------+--------------+
          |              |              |
          v              v              v
 LieGroupKinematics      |      SpectralLinearAlgebra
          |              |
          |              |
          v              v
   Spatial Mathematics  Numerical Computation
                         |
                         |
                         v
               BayesianStateEstimation
                         |
                         |
                         v
              DifferentialPathGeometry
                         |
                         v
                 Curve Computation
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
├── docs/
│   ├── API.md
│   ├── ARCHITECTURE.md
│   └── MATHEMATICS.md
│
├── examples/
│   ├── README.md
│   ├── PoseInterpolation.lua
│   ├── DifferentialPath.lua
│   ├── BayesianMotionTracking.lua
│   └── LeastSquaresRegression.lua
│
├── src/
│   └── VectorForge/
│       ├── LieGroupKinematics.lua
│       ├── SpectralLinearAlgebra.lua
│       ├── BayesianStateEstimation.lua
│       └── DifferentialPathGeometry.lua
│
├── tests/
│   ├── README.md
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
| `docs/` | Technical documentation and mathematical explanations |
| `examples/` | Demonstrations and practical usage scenarios |
| `tests/` | Regression tests and mathematical validation |

---

## Installation

### Manual Installation

1. Open Roblox Studio.
2. Navigate to `ReplicatedStorage`.
3. Create a folder named `VectorForge`.
4. Copy the four ModuleScripts from `src/VectorForge/` into the folder.
5. Ensure that the ModuleScript names remain unchanged.

The expected Roblox hierarchy should look like this:

```text
ReplicatedStorage
└── VectorForge
    ├── LieGroupKinematics
    ├── SpectralLinearAlgebra
    ├── BayesianStateEstimation
    └── DifferentialPathGeometry
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

Each example is intended to be independently understandable and can be used as a starting point for further experimentation.

See [examples/README.md](examples/README.md) for setup instructions.

---

## Testing

VectorForge includes an initial test suite designed to validate important mathematical operations.

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

### Running the Tests

1. Install the VectorForge modules in `ReplicatedStorage/VectorForge`.
2. Place `RunAll.server.lua` inside `ServerScriptService`.
3. Start a Play session in Roblox Studio.
4. Open the Output window.
5. Inspect the test results.

The suite represents an initial regression-testing foundation. It does not constitute a formal mathematical verification or guarantee of numerical stability.

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

---

## Limitations

VectorForge is currently experimental and should not be considered a finalized mathematical framework.

The current project may contain incomplete functionality, numerical limitations, undocumented edge cases, and APIs that are subject to change.

Not every potential application described in this README is currently implemented.

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
