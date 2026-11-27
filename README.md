 <div align="center">

# VectorForge


<img width="2048" height="280" alt="github jan banner" src="https://github.com/SegfaultDreams0/VectorForge/blob/main/docs/assets/vectorforge-banner.png" />

### Advanced Computational Mathematics for Roblox Luau

**English** · [简体中文](docs/readme/README_zh.md) · [日本語](docs/readme/README_ja.md) · [한국어](docs/readme/README_ko.md) · [Tiếng Việt](docs/readme/README_vi.md) · [ไทย](docs/readme/README_th.md) · [العربية](docs/readme/README_ar.md) · [MA Darija (9rombo idea)](docs/readme/README_darija.md)

**Explore numerical methods, geometric computation, and mathematical systems directly inside Roblox.**

VectorForge is an experimental Luau library exploring the implementation of advanced computational mathematics, including Lie group kinematics, numerical linear algebra, Bayesian state estimation, differential geometry, and more.

<p align="center">
  <a href="https://luau.org/"><img alt="Language" src="https://img.shields.io/badge/Language-Luau-blue?style=flat-square"></a>
  <a href="https://www.roblox.com/"><img alt="Platform" src="https://img.shields.io/badge/Platform-Roblox-00A2FF?style=flat-square&logo=roblox&logoColor=white"></a>
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/License-MIT-yellow?style=flat-square"></a>
  <a href="#project-status"><img alt="Status" src="https://img.shields.io/badge/Status-Experimental-orange?style=flat-square"></a>
  <br>
  <img alt="Commit activity" src="https://img.shields.io/github/commit-activity/m/SegfaultDreams0/REPO?style=flat-square">
  <img alt="Last commit" src="https://img.shields.io/github/last-commit/SegfaultDreams0/REPO?style=flat-square">
  <img alt="Contributors" src="https://img.shields.io/github/contributors/SegfaultDreams0/REPO?style=flat-square">
  <img alt="Closed issues" src="https://img.shields.io/github/issues-closed/SegfaultDreams0/REPO?style=flat-square">
</p>

**[Quick Start](#quick-start) · [Core Modules](#core-modules) · [Scientific Extensions](#scientific-extensions) · [Examples](#examples) · [Experiments](#experiments) · [Simulations](#simulations) · [Datasets](#datasets) · [Visualizations](#visualizations) · [Documentation](#documentation)**

</div>

---

## Overview

Roblox provides a convenient environment for building interactive experiences, but some mathematical problems require more specialized numerical techniques.

VectorForge explores how these techniques can be implemented in Luau through a collection of independent mathematical modules. The repository now also includes a larger experimental research layer covering scientific computing topics such as fluid dynamics, finite element methods, quantum mechanics, electromagnetics, continuum mechanics, orbital mechanics, and stochastic processes.

The project covers concepts commonly found in numerical analysis, robotics, computational geometry, classical mechanics, probability, and optimization.

Rather than attempting to replace Roblox's built-in APIs, VectorForge focuses on mathematical operations that extend beyond conventional gameplay scripting.

**The goal is to make advanced mathematical techniques accessible, reusable, and open to experimentation within Roblox.**

## Quick Start

### Installation

You can install VectorForge manually or use the included Rojo project configuration.

**Manual installation**

1. Open Roblox Studio.
2. Navigate to `ReplicatedStorage`.
3. Create a folder named `VectorForge`.
4. Copy the ModuleScripts from `src/VectorForge/` into that folder.
5. Create `ReplicatedStorage/VectorForgeShared` and copy the shared utility ModuleScripts into it.
6. Keep the original ModuleScript names and folder structure.

Your Explorer hierarchy should look like this:

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

### Rojo

VectorForge includes a Rojo project configuration.

Make sure `default.project.json` maps `src/VectorForge` to `ReplicatedStorage/VectorForge` and the repository root `VectorForgeShared/` directory to `ReplicatedStorage/VectorForgeShared`. Check the project file before relying on the mapping.

Build the project:

```bash
rojo build default.project.json -o VectorForge.rbxlx
```

[Rojo documentation](https://rojo.space/)

### Basic usage

After installation, load the modules using Roblox's `require()` function.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local VectorForgeShared = ReplicatedStorage:WaitForChild("VectorForgeShared")

local SharedConstants = require(VectorForgeShared:WaitForChild("Constants"))
local Lie = require(VectorForge.LieGroupKinematics)
local LinearAlgebra = require(VectorForge.SpectralLinearAlgebra)
local StateEstimation = require(VectorForge.BayesianStateEstimation)
local PathGeometry = require(VectorForge.DifferentialPathGeometry)

local AutomaticDifferentiation =
    require(VectorForge.AutomaticDifferentiation)

local RigidBodyDynamics =
    require(VectorForge.RigidBodyDynamics)

local NumericalOptimization =
    require(VectorForge.NumericalOptimization)

local TrajectoryPlanning =
    require(VectorForge.TrajectoryPlanning)
```

Each module exposes its own functionality. Refer to the [API Reference](docs/API.md) for available operations, parameters, and return values.

---

## Core Modules

VectorForge currently explores eight mathematical domains.

| Module | Mathematical Domain | Main Focus |
|---|---|---|
| `LieGroupKinematics` | Lie Theory | Rotations and rigid transformations |
| `SpectralLinearAlgebra` | Linear Algebra | Matrix operations and numerical solvers |
| `BayesianStateEstimation` | Probability | State estimation and uncertainty |
| `DifferentialPathGeometry` | Differential Geometry | Curves, curvature, and path analysis |
| `AutomaticDifferentiation` | Numerical Calculus | Derivative propagation |
| `RigidBodyDynamics` | Classical Mechanics | Forces, torques, and rigid-body motion |
| `NumericalOptimization` | Optimization | Numerical minimization |
| `TrajectoryPlanning` | Motion Planning | Trajectory construction and evaluation |

### 1. LieGroupKinematics

**Lie Groups · Rotation Theory · Rigid-Body Kinematics**

Mathematical representations for rotations and rigid transformations in three-dimensional space.

Concepts explored:

- Quaternion algebra.
- SO(3) rotation operations.
- SE(3) rigid-body transformations.
- Exponential and logarithmic maps.
- Spherical Linear Interpolation (SLERP).
- Pose composition and inversion.
- Twist representations.

**Possible applications**

- Procedural animation.
- Smooth camera orientation.
- Robotics-inspired movement.
- Three-dimensional pose interpolation.
- Spatial simulation.

### 2. SpectralLinearAlgebra

**Numerical Linear Algebra · Matrix Computation**

Numerical methods for manipulating matrices, solving linear systems, and performing mathematical decompositions.

Concepts explored:

- Matrix multiplication and transposition.
- LU decomposition.
- Determinant computation.
- Cholesky decomposition.
- Householder QR decomposition.
- Symmetric eigenvalue approximation.
- Conjugate Gradient methods.
- Least-squares estimation.
- Linear-system solving.

**Possible applications**

- Numerical simulation.
- Polynomial regression.
- Parameter estimation.
- Mathematical optimization.
- Computational modeling.

### 3. BayesianStateEstimation

**Bayesian Inference · Probability · State Estimation**

Methods for estimating the internal state of a dynamic system when observations are incomplete or affected by uncertainty.

Concepts explored:

- Extended Kalman Filtering (EKF).
- State-transition models.
- Measurement models.
- Covariance propagation.
- Numerical Jacobian approximation.
- Measurement correction.
- Innovation calculation.
- Statistical measurement gating.

**Possible applications**

- Noisy object-position tracking.
- Motion prediction.
- Sensor simulation.
- Trajectory estimation.
- Dynamic system modeling.

### 4. DifferentialPathGeometry

**Differential Geometry · Curve Analysis**

Mathematical analysis of parameterized curves and their geometric properties.

Concepts explored:

- Hermite curve interpolation.
- First and higher-order derivatives.
- Curvature and torsion.
- Numerical arc-length integration.
- Arc-length parameterization.
- Frenet frames.
- Parallel-transport frames.
- Closest-point estimation.
- Minimum-jerk trajectory generation.

**Possible applications**

- Procedural path generation.
- Smooth NPC trajectories.
- Camera rail systems.
- Vehicle trajectory modeling.
- Three-dimensional movement analysis.

### 5. AutomaticDifferentiation

**Automatic Differentiation · Numerical Calculus**

Explores derivative computation by propagating derivative information through arithmetic operations and supported computational expressions.

Concepts explored:

- Forward-mode derivative propagation.
- Computational expression evaluation.
- Derivative tracking.
- Sensitivity analysis.

**Possible applications**

- Gradient-based optimization.
- Parameter fitting.
- Sensitivity analysis.
- Differentiable mathematical experiments.

### 6. RigidBodyDynamics

**Classical Mechanics · Physical Simulation**

Explores the mathematical description of rigid-body motion under applied forces, torques, and inertial properties.

Concepts explored:

- Linear and angular motion.
- Mass and inertia representations.
- Force and torque relationships.
- Rigid-body state evolution.
- Translational and rotational dynamics.

**Possible applications**

- Physics experiments.
- Mechanical system modeling.
- Robotics-inspired simulation.
- Motion analysis.

### 7. NumericalOptimization

**Numerical Optimization · Iterative Minimization**

Explores numerical techniques for finding solutions that minimize objective functions under supported assumptions and constraints.

Concepts explored:

- Objective-function evaluation.
- Iterative parameter updates.
- Gradient-based optimization concepts.
- Convergence criteria.
- Numerical minimization.

**Possible applications**

- Parameter estimation.
- Curve fitting.
- Mathematical calibration.
- Optimization experiments.

### 8. TrajectoryPlanning

**Motion Planning · Trajectory Generation**

Focuses on constructing and evaluating paths or time-dependent motion profiles between states or spatial targets.

Concepts explored:

- Trajectory construction.
- Motion-profile evaluation.
- Boundary-condition handling.
- Smooth movement planning.
- Integration with geometric and kinematic representations.

**Possible applications**

- NPC movement.
- Robotics-inspired path planning.
- Camera and object motion.
- Procedural animation.

---

## Scientific Extensions

The repository includes a separate experimental extension layer alongside the original eight Core Modules. These additions are organized by scientific domain at the repository root. They are not placed inside `src/VectorForge/`, so the original core library remains distinct from the broader research modules.

The current extension package is organized around:

- **15 scientific domain folders**
- **300 domain modules**, with 20 modules in each domain
- **30 domain support modules**, with two additional files at the root of each domain folder
- **7 shared utility modules** in `VectorForgeShared/`
- **10 named simulation examples**
- **10 numerical invariant and validation examples**

That is **357 Lua files** across the extension package, excluding this README. This is a repository inventory count, not a claim that every module is a fully validated scientific solver.

### Scientific domains

| Domain folder | Main research areas |
|---|---|
| `fluid-dynamics/` | Flow models, momentum equations, transport, and fluid solver foundations |
| `control-systems/` | State-space models, feedback control, observers, and stability analysis |
| `finite-element-methods/` | Element formulations, material data, quadrature, and assembly concepts |
| `signal-processing/` | Discrete transforms, filtering, convolution, and sampling theory |
| `tensor-calculus/` | Tensor storage, contractions, metrics, and differential operations |
| `differential-equations/` | Initial-value integration, boundary-value problems, and numerical stepping |
| `computational-geometry/` | Parametric curves, curvature, geometric predicates, and mesh concepts |
| `optimization-methods/` | Gradient methods, line searches, least-squares objectives, and stopping rules |
| `quantum-mechanics/` | Wavefunction representations, probability density, and quantum model foundations |
| `thermodynamics/` | Equations of state, thermal properties, energy, and thermodynamic conversions |
| `electromagnetics/` | Electromagnetic fields, Lorentz force, constants, and field sampling |
| `orbital-mechanics/` | Two-body motion, orbital parameters, and astrodynamics constants |
| `rigid-body-physics/` | Inertia, angular momentum, contact settings, and rotational dynamics |
| `continuum-mechanics/` | Strain measures, elastic material data, and constitutive model foundations |
| `stochastic-processes/` | Random processes, stochastic stepping, and probability distributions |

### Folder layout

Each scientific domain contains three subfolders:

- `analysis/` — analysis-oriented modules and calculations
- `models/` — model and state representations
- `solvers/` — numerical procedures and solver-oriented modules

Each domain folder also contains two additional support modules directly at its root. These provide domain-specific configuration, material data, constants, sampling rules, or helper functions.

The shared utilities live in the single root folder `VectorForgeShared/`. In Roblox Studio, this folder belongs under `ReplicatedStorage/VectorForgeShared`:

| Module | Responsibility |
|---|---|
| `Constants.lua` | Shared physical and mathematical constants |
| `CoreRegistry.lua` | Explicit registration and lookup of existing VectorForge Core Modules |
| `EquationCatalog.lua` | A compact catalog of governing equations used as references |
| `LinearAlgebra.lua` | Basic row-array matrix operations |
| `NumericalGuards.lua` | Finite-value checks, clamping, and safe division |
| `NumericalKernels.lua` | Shared low-level numerical kernels |
| `SimulationClock.lua` | Fixed-step simulation timing |

### Integration with the Core Modules

The extension modules are kept separate from `src/VectorForge/`. Their `VectorForgeShared/CoreRegistry.lua` provides a dependency-injection mechanism so a bootstrap script can register the actual Core Module instances.

The registry does not guess module paths or automatically load the Core Modules. Register only modules that exist in the project and whose public APIs have been checked.

**Important:** use one shared folder named `VectorForgeShared`. Do not keep parallel copies under `shared`, `Shared`, and `VectorForgeShared`. Domain modules and bootstrap scripts should resolve the same `ReplicatedStorage/VectorForgeShared` instance.

Example:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local CoreRegistry = require(Shared:WaitForChild("CoreRegistry"))

CoreRegistry.Configure({
    SpectralLinearAlgebra = require(path.to.src.VectorForge.SpectralLinearAlgebra),
    AutomaticDifferentiation = require(path.to.src.VectorForge.AutomaticDifferentiation),
    BayesianStateEstimation = require(path.to.src.VectorForge.BayesianStateEstimation),
})

local LinearAlgebraCore = CoreRegistry.Require("SpectralLinearAlgebra")
```

The extension source represents mathematical states with numeric arrays and does not directly depend on Roblox spatial datatypes. This does not mean every algorithm is a complete physical solver or that every module has been validated against a reference implementation.

### Examples and validation files

The `examples/` folder contains individually named numerical studies, including damped oscillator response, coupled state evolution, nonlinear response, energy decay, integration stability, and long-horizon state evolution.

The extension additions in `tests/` include small numerical invariant checks. They are useful starting points for regression tests, but they are not a substitute for analytical benchmarks, dimensional checks, convergence studies, or verification against trusted scientific data.

### Research and production status

The scientific extensions are experimental research scaffolding. Some modules expose reusable numerical routines and domain-specific calculations; others provide a foundation that still needs a problem-specific discretization, boundary conditions, constitutive laws, units, and solver strategy.

Before using an extension in a production experience:

1. Check the module's inputs, outputs, dimensions, and units.
2. Verify its assumptions and boundary conditions.
3. Compare its results against analytical solutions or trusted reference data.
4. Test convergence and numerical stability over representative input ranges.
5. Profile execution cost in Roblox Studio.
6. Verify any Core Module integration against the actual public API.

These additions expand the repository's research scope; they do not change the installation steps for the original eight Core Modules.

---

## How VectorForge works

VectorForge provides a set of independent mathematical modules that can be used inside a Roblox experience. You define a problem or mathematical model, select the relevant module, provide the required inputs, and use the returned results in your own system.

The diagram below gives a high-level overview of this workflow. It is a conceptual explanation of how a developer can use the library; it does not imply that all modules are automatically connected or that VectorForge runs a single fixed pipeline.

![How VectorForge works — computation flow and module overview](docs/assets/how-vectorforge-works.png)

## How VectorForge Fits Together

The modules are organized around separate mathematical responsibilities.

![How VectorForge works — computation flow and module overview](docs/assets/How-VectorForge-Fits-Together.png)

The modular structure is intended to support:

- Independent mathematical components.
- Reusable implementations.
- Clear separation of responsibilities.
- Easier testing and maintenance.
- Future mathematical extensions.

See [ARCHITECTURE.md](docs/ARCHITECTURE.md) for more details.

---

## Examples

The `examples/` directory contains standalone demonstrations showing how selected VectorForge modules can be used inside Roblox.

| Example | Description |
|---|---|
| Pose Interpolation | Interpolation between rigid-body poses |
| Differential Path | Curve sampling and movement along a geometric path |
| Bayesian Motion Tracking | Estimation using noisy position observations |
| Least-Squares Regression | Polynomial fitting using numerical linear algebra |
| Integration Demo | Demonstrations involving the expanded module set |

Each example is intended to be independently understandable and provide a starting point for further experimentation.

See [examples/README.md](examples/README.md).

## Experiments

The `experiments/` directory contains exploratory scripts for visualizing mathematical concepts and investigating possible applications.

| Experiment | Description |
|---|---|
| Celestial Mechanics | Educational visualization of simplified gravitational motion |
| Orbital Simulation | Exploration of orbital trajectories using simplified mechanics |
| Kalman Visualization | Visualization of noisy observations and smoothed estimates |
| Trajectory Laboratory | Experimental trajectory construction |
| Numerical Stability Lab | Comparison of numerical summation approaches |

These experiments are intended for exploration rather than production-ready simulation.

Some demonstrations use simplified reference calculations or visualization adapters. For example, the celestial and orbital demonstrations use simplified Newtonian models, not general relativity. The Kalman visualization is a simplified smoothing demonstration rather than a complete EKF implementation.

See [experiments/README.md](experiments/README.md).


## Simulations

The `simulations/` folder is where the project keeps a couple of standalone numerical models. They are useful when testing how a system changes over time without tying the calculation to a Roblox scene.

The current scripts cover two different problems:

| Script | What it models |
|---|---|
| `TwoBodyOrbit.lua` | Relative motion under a simplified Newtonian gravitational model |
| `DampedOscillator.lua` | A mass attached to a spring with linear damping |

Both use a fourth-order Runge–Kutta step. The caller supplies the initial state and time step, so the simulation clock and stopping conditions stay under the caller's control.

The orbit example uses SI units: metres, metres per second, seconds, and cubic metres per second squared for the gravitational parameter. The oscillator uses metres, kilograms, seconds, newtons per metre, and newton-seconds per metre.

These are intentionally small models. The orbit script does not account for additional bodies, atmospheric drag, collisions, or relativistic effects. The oscillator assumes a linear spring and linear viscous damping. Neither one should be treated as a production physics engine.

See [simulations/README.md](simulations/README.md) for the setup, parameters, and limitations of each script.

## Datasets

The `datasets/` folder holds reference values and sample data used by the project's scripts and experiments. Keeping the data separate from the algorithms makes it easier to reuse the same inputs and see exactly what a demonstration is working with.

| File | Contents |
|---|---|
| `PhysicalConstants.lua` | A small collection of physical constants in SI units |
| `SolarSystem.lua` | Approximate masses, mean semi-major axes, orbital periods, and derived gravitational parameters for selected planets |
| `MotionSamples.lua` | A short synthetic sequence of timestamped 2D position observations |

The planetary values are rounded reference data, not precision ephemerides. The motion samples are generated examples, not measurements from a real sensor. Those distinctions matter when using the data in numerical comparisons or state-estimation experiments.

If you add more data, include its units and say whether it is measured, synthetic, or approximate. It saves a lot of confusion later.

See [datasets/README.md](datasets/README.md) for the data conventions and usage examples.

## Visualizations

The `visualizations/` folder contains small Roblox helpers for displaying calculated results in a 3D scene. The idea is to keep the math and the drawing separate: a simulation or algorithm produces values, and a renderer turns those values into something you can inspect.

| Module | What it displays |
|---|---|
| `TrajectoryRenderer.lua` | A sequence of `Vector3` points connected by anchored segments |
| `VectorFieldRenderer.lua` | Vector samples shown as direction indicators in 3D space |

Both modules create a `Model` under the parent you provide. Their parts are anchored and non-collidable. When you are finished with a visualization, destroy the returned model to clean up the generated instances.

These helpers are meant for debugging and small demonstrations, not dense scientific plotting. A large number of parts can become expensive, especially if they are replicated or rebuilt frequently. Keep the sample count reasonable and profile the result in Studio.

See [visualizations/README.md](visualizations/README.md) for examples and renderer options.

## Benchmarking

The `benchmarks/` directory contains workload-oriented scripts for investigating the performance of selected mathematical operations.

Current benchmark areas include:

- Matrix computation.
- Numerical optimization.
- Differential geometry.
- State estimation.
- Shared benchmark utilities.

Benchmark results can vary with hardware, runtime conditions, input dimensions, and implementation details.

Some scripts require adapters to connect their workload callbacks to the verified public APIs. Their presence does not mean comprehensive performance measurements have already been completed.

Documentation:

- [Benchmarking Guide](docs/BENCHMARKING.md)
- [Benchmark Scripts](benchmarks/README.md)

## Mathematical Foundations

VectorForge draws on several mathematical disciplines.

| Area | Concepts |
|---|---|
| Linear Algebra | Matrix operations, decompositions, eigenvalues |
| Differential Geometry | Curvature, torsion, tangent and normal frames |
| Lie Theory | SO(3), SE(3), exponential and logarithmic maps |
| Numerical Analysis | Approximation, integration, iterative solvers |
| Probability Theory | Bayesian estimation and uncertainty |
| Optimization | Least-squares estimation and iterative minimization |
| Signal Processing | Frequency-domain analysis and numerical transforms |

For additional explanations, see [MATHEMATICS.md](docs/MATHEMATICS.md).

## Research Notes

The `research/` directory contains supporting mathematical notes and exploratory material.

Current topics include:

- Lie group mathematics and spatial transformations.
- Numerical methods and computational stability.
- Bayesian state estimation.
- Potential future algorithms and mathematical extensions.

These notes document theoretical considerations and possible approaches during development. They are supplementary material, not formal mathematical verification.

See [research/README.md](research/README.md).

---

## Testing

VectorForge includes regression and comprehensive test scripts covering important operations across its modules.

The current test areas include:

- Quaternion operations and rigid transformations.
- Matrix multiplication and decomposition.
- Linear-system solving.
- Eigenvalue calculations.
- Numerical optimization.
- Extended Kalman Filter operations.
- Curve evaluation and differential properties.
- Arc-length calculations.
- Trajectory boundary conditions.
- Automatic differentiation.
- Rigid-body dynamics and trajectory planning.

### Running the tests

1. Install the VectorForge modules in `ReplicatedStorage/VectorForge`.
2. Place the test runner inside `ServerScriptService`.
3. Start a Play session in Roblox Studio.
4. Open the Output window.
5. Inspect the test results.

The suite provides an initial regression-testing foundation. It does not constitute formal mathematical verification or guarantee numerical stability.

See [tests/README.md](tests/README.md).

## Performance Considerations

Numerical algorithms can become expensive depending on their input dimensions, iteration counts, and execution frequency.

When using VectorForge, consider:

- Avoiding unnecessary matrix decompositions.
- Reusing calculated results when inputs remain unchanged.
- Limiting expensive operations inside frame-dependent loops.
- Choosing appropriate solver tolerances and iteration limits.
- Profiling with representative workloads.
- Separating authoritative server calculations from client-side visual calculations where appropriate.

The current implementation has not yet been comprehensively benchmarked.

## Repository Structure

```text
VectorForge/
├── benchmarks/
├── computational-research/
├── datasets/
├── docs/
├── examples/
│   └── server/
├── experiments/
├── research/
├── simulations/
├── visualizations/
│
├── fluid-dynamics/
│   ├── analysis/
│   ├── models/
│   ├── solvers/
│   └── domain support modules
├── control-systems/
│   ├── analysis/
│   ├── models/
│   ├── solvers/
│   └── domain support modules
├── finite-element-methods/
├── signal-processing/
├── tensor-calculus/
├── differential-equations/
├── computational-geometry/
├── optimization-methods/
├── quantum-mechanics/
├── thermodynamics/
├── electromagnetics/
├── orbital-mechanics/
├── rigid-body-physics/
├── continuum-mechanics/
├── stochastic-processes/
├── VectorForgeShared/
│   ├── Constants.lua
│   ├── CoreRegistry.lua
│   ├── EquationCatalog.lua
│   ├── LinearAlgebra.lua
│   ├── NumericalGuards.lua
│   ├── NumericalKernels.lua
│   └── SimulationClock.lua
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
├── tests/
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── default.project.json
├── LICENSE
├── package.json
├── package-lock.json
└── README.md
```

| Directory | Responsibility |
|---|---|
| `src/` | Core VectorForge modules for Roblox Luau |
| `docs/` | Technical documentation and mathematical explanations |
| `examples/` | Practical demonstrations of the core modules |
| `tests/` | Regression tests and numerical checks |
| `benchmarks/` | Workload-based performance measurements |
| `experiments/` | Exploratory scripts and demonstrations |
| `research/` | Mathematical notes and ideas under investigation |
| `computational-research/` | Standalone advanced mathematics and scientific scripts |
| `simulations/` | Time-stepped numerical models |
| `datasets/` | Reference constants and sample inputs |
| `visualizations/` | Roblox helpers for displaying numerical results |
| Scientific domain folders | Experimental modules for physics, engineering, geometry, optimization, and scientific computing |
| `VectorForgeShared/` | One shared utility layer and explicit Core Module registration |

---

## FAQ

<details>
<summary><strong>Is VectorForge a replacement for Roblox Vector3 or CFrame?</strong></summary>

No. VectorForge explores mathematical operations that go beyond conventional vector and transformation utilities. Roblox's built-in APIs remain useful and appropriate for many everyday development tasks.

</details>

<details>
<summary><strong>Is VectorForge production-ready?</strong></summary>

Not yet. It is an experimental project. APIs, numerical behavior, performance, and implementation details may change.

</details>

<details>
<summary><strong>Can I use individual modules separately?</strong></summary>

The library is organized into separate mathematical modules, intended to operate independently where practical. Check the API documentation for the available functionality and dependencies.

</details>

<details>
<summary><strong>What are the simulations, datasets, and visualizations folders for?</strong></summary>

They sit alongside the core library. `simulations/` contains small time-stepped models, `datasets/` keeps reference and example inputs, and `visualizations/` contains Roblox helpers for displaying results. They are supporting material and do not change how the core modules are installed.

</details>

<details>
<summary><strong>Does VectorForge include performance benchmarks?</strong></summary>

It includes benchmark scripts for selected workloads. Some require adapters, and comprehensive benchmark results have not yet been established.

</details>

<details>
<summary><strong>Where can I find usage examples?</strong></summary>

Check the `examples/` directory and [examples/README.md](examples/README.md). The `simulations/` and `visualizations/` folders also contain focused demonstrations.

</details>

<details>
<summary><strong>Can I contribute?</strong></summary>

Yes. Technical feedback, bug reports, suggestions, and contributions are welcome. Please review the contribution guidelines before submitting changes.

</details>

---


<details>
<summary><strong>Are the scientific domain folders part of the original Core Modules?</strong></summary>

They are a separate experimental extension layer at the repository root. The original eight Core Modules remain under `src/VectorForge/`. The extensions can be developed and tested independently, with optional Core Module dependencies registered through `VectorForgeShared/CoreRegistry.lua`.

</details>

<details>
<summary><strong>Are all scientific extension modules complete and validated solvers?</strong></summary>

No. The extensions are research scaffolding. Each module must be checked for its mathematical assumptions, units, boundary conditions, convergence, numerical stability, and compatibility with the actual Core Module APIs before production use.

</details>

## Documentation

The `docs/` directory contains the technical references for VectorForge.

- [API Reference](docs/API.md) — Available operations and module interfaces.
- [Architecture](docs/ARCHITECTURE.md) — Module organization and design.
- [Mathematics](docs/MATHEMATICS.md) — Mathematical concepts and foundations.
- [Numerical Validation](docs/NUMERICAL_VALIDATION.md) — Validation considerations.
- [Benchmarking](docs/BENCHMARKING.md) — Benchmark methodology and guidance.
- [Design Decisions](docs/DESIGN_DECISIONS.md) — Project design considerations.
- [Glossary](docs/GLOSSARY.md) — Mathematical and technical terminology.
- [Simulations](simulations/README.md) — Numerical models and integration details.
- [Datasets](datasets/README.md) — Reference values, units, and sample data.
- [Visualizations](visualizations/README.md) — Scene-rendering helpers and usage.

The scientific extension folders currently document their module intent in source-level descriptions and this repository overview. Domain-specific API references and validation reports should be added as those modules are verified.

## Contributing

Contributions, technical feedback, bug reports, and suggestions are welcome.

If you find an issue, please include:

- The affected module.
- A minimal reproducible example.
- Expected mathematical behavior.
- Actual observed behavior.
- Relevant Roblox Studio Output errors.

See [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a pull request.

## Development Status

VectorForge is actively experimental. Possible future development areas include:

**Numerical improvements**
- Additional matrix decomposition methods.
- Improved numerical stability.
- Better handling of degenerate inputs.
- Additional iterative solvers.
- Improved convergence diagnostics.

**Mathematical expansion**
- Additional probability and estimation techniques.
- More geometric transformation utilities.
- Numerical integration methods.
- Additional differential geometry operations.

**Developer experience**
- Expanded API documentation.
- More practical examples.
- Additional automated tests.
- Performance benchmarks.
- Improved error handling and validation.

These are development directions, not guaranteed release commitments.

## License

VectorForge is distributed under the MIT License.

See [LICENSE](LICENSE) for the complete license text.

---

<div align="center">

**VectorForge**

*Exploring computational mathematics in Roblox Luau.*

</div>
