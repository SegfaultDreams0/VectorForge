# VectorForge

This document describes the internal organization, module responsibilities, dependency relationships, and runtime integration principles of VectorForge.

The architecture is designed around separation of mathematical concerns, modular development, and reusable computational components.

VectorForge aims to keep numerical implementations independent from application-specific gameplay systems wherever practical.

## Table of Contents

- [Design Overview](#design-overview)
- [Architectural Principles](#architectural-principles)
- [Module Organization](#module-organization)
- [Module Responsibilities](#module-responsibilities)
- [Dependency Relationships](#dependency-relationships)
- [Data Flow](#data-flow)
- [Runtime Integration](#runtime-integration)
- [Numerical Conventions](#numerical-conventions)
- [Performance Considerations](#performance-considerations)
- [Error Boundaries](#error-boundaries)
- [Project Structure](#project-structure)
- [Current Architectural Status](#current-architectural-status)

---

## Design Overview

VectorForge is organized as a collection of focused mathematical modules.

Each module addresses a distinct computational domain and exposes functionality that can be composed by higher-level systems.

```text
                     Roblox Experience
                            |
                            |
                            v
                       VectorForge
                            |
          +-----------------+-----------------+
          |                 |                 |
          v                 v                 v
   LieGroupKinematics  SpectralLinearAlgebra  DifferentialPathGeometry
          |                 |                 |
          |                 |                 |
          v                 v                 v
   Spatial Mathematics  Numerical Methods  Curve Computation
                            |
                            |
                            v
                  BayesianStateEstimation
                            |
                            v
                   State Estimation
```

This diagram illustrates conceptual responsibilities rather than a mandatory execution order or complete dependency graph.

## Architectural Principles

### 1. Separation of Concerns

Each module should focus on its own mathematical domain.

Rotation mathematics should not be coupled unnecessarily with curve rendering, and matrix decomposition algorithms should not contain application-specific gameplay logic.

### 2. Reusability

Mathematical operations should be implemented in a way that allows multiple systems to use them without duplicating their underlying calculations.

### 3. Modularity

Individual components should be understandable, testable, and maintainable independently wherever possible.

### 4. Numerical Transparency

Algorithms should have clear mathematical assumptions, documented input requirements, and understandable failure behaviour.

### 5. Roblox Integration

The library should integrate naturally with Roblox Luau and its native data types while maintaining separation between mathematical computation and engine-specific presentation.

---

## Module Organization

VectorForge currently contains four principal mathematical modules.

### LieGroupKinematics

Responsible for spatial transformations, rotation representations, quaternion operations, and rigid-body kinematics.

Its primary role is to provide mathematical operations for manipulating orientations and poses in three-dimensional space.

### SpectralLinearAlgebra

Responsible for numerical matrix computation, matrix decomposition, and linear-system solving.

It provides foundational numerical operations that may also be useful to other mathematical components.

### BayesianStateEstimation

Responsible for state prediction, covariance propagation, measurement correction, and uncertainty estimation.

It explores filtering techniques for systems operating with incomplete or noisy observations.

### DifferentialPathGeometry

Responsible for curve evaluation, geometric analysis, arc-length calculations, and local coordinate-frame construction.

It separates geometric calculations from the Roblox objects that may consume their results.

---

## Module Responsibilities

The following table summarizes the intended separation of responsibilities.

| Module | Input Domain | Computational Output |
|---|---|---|
| LieGroupKinematics | Rotations, vectors, poses | Spatial transformations |
| SpectralLinearAlgebra | Matrices and numeric vectors | Matrix factors and numerical solutions |
| BayesianStateEstimation | States and observations | Updated state estimates |
| DifferentialPathGeometry | Control points and parameters | Curve positions and geometric properties |

These are conceptual categories. Actual argument and return structures are determined by the source implementations.

## Dependency Relationships

The modules are intended to remain independently usable where practical.

Some mathematical components may benefit from functionality provided by other modules.

For example:

- BayesianStateEstimation may use numerical matrix operations for covariance propagation.
- DifferentialPathGeometry may use vector operations for tangent and frame construction.
- LieGroupKinematics may provide transformation operations to systems consuming geometric trajectories.

Dependencies should remain explicit and should avoid unnecessary coupling.

The architecture does not require every module to depend on every other module.

---

## Data Flow

A typical application may follow a sequence of mathematical operations.

Consider an experimental motion-tracking system:

```text
                  Observations
                       |
                       v
              BayesianStateEstimation
                       |
                       v
                Estimated State
                       |
                       v
              DifferentialPathGeometry
                       |
                       v
                 Motion Trajectory
                       |
                       v
                LieGroupKinematics
                       |
                       v
                Spatial Transform
                       |
                       v
                 Roblox Instance
```

In this conceptual example:

1. Measurements are processed by a state estimator.
2. The resulting estimate is used to determine a trajectory.
3. Geometric calculations produce positions and orientations.
4. Transformation operations are used to represent the resulting pose.
5. Roblox objects consume the calculated results.

This illustrates a possible composition of modules rather than a built-in VectorForge pipeline.

---

## Runtime Integration

VectorForge is designed to operate within Roblox's scripting environment.

The Rojo project configuration maps the source directory into:

```text
ReplicatedStorage
└── VectorForge
```

The modules can then be accessed using Roblox's standard `require()` functionality.

### Server-Side Execution

Server execution is appropriate when mathematical results affect authoritative gameplay state.

Examples include:

- Server-controlled movement calculations.
- Authoritative trajectory validation.
- Shared simulation state.
- Gameplay-critical state estimation.

### Client-Side Execution

Client execution may be appropriate for local calculations that primarily affect presentation.

Examples include:

- Camera interpolation.
- Local animation trajectories.
- Visual path previews.
- Client-side geometric demonstrations.

Execution context should be selected according to the responsibility and security requirements of the consuming system.

### Engine Integration

Mathematical modules should avoid creating or modifying Roblox instances unless that behaviour is explicitly part of their responsibility.

This allows numerical calculations to remain reusable independently of rendering and presentation.

---

## Numerical Conventions

The examples and current documentation use the following general conventions:

| Category | Convention |
|---|---|
| Spatial vectors | Roblox `Vector3` |
| Matrix representation | Nested Luau tables |
| Numeric vectors | Sequential Luau tables |
| Rotation angles | Radians unless documented otherwise |
| Time-dependent calculations | Explicit time steps |
| Numerical comparisons | Finite tolerances |

Developers should verify the following details against the implementations:

- Matrix storage and indexing conventions.
- Quaternion component ordering.
- Coordinate-frame orientation.
- Transform composition order.
- Local-to-world and world-to-local conventions.
- Time-step interpretation.
- Covariance matrix layout.

These details are particularly important when combining multiple mathematical modules.

---

## Performance Considerations

Numerical computations can become expensive depending on input dimensions, solver iterations, and execution frequency.

VectorForge should be used with consideration for Roblox's runtime constraints.

Recommended practices include:

- Avoid repeating expensive decompositions when inputs have not changed.
- Reuse previously calculated numerical results where possible.
- Cache curve samples and reusable geometric information.
- Avoid unnecessarily expensive operations inside `Heartbeat` or `RenderStepped`.
- Limit iterative solver workloads appropriately.
- Profile computational performance with representative input sizes.
- Separate expensive calculations from frame-dependent presentation logic.

The current implementation has not undergone comprehensive performance benchmarking.

No universal execution-time or memory guarantees are currently provided.

---

## Error Boundaries

Mathematical modules should define how they behave when supplied with invalid or unsupported inputs.

Important failure scenarios include:

### Linear Algebra

- Singular matrices.
- Incompatible dimensions.
- Invalid matrix structures.
- Numerical instability.
- Failed iterative convergence.

### State Estimation

- Invalid covariance matrices.
- Incorrect measurement dimensions.
- Degenerate Jacobians.
- Inconsistent noise assumptions.
- Unstable estimation updates.

### Differential Geometry

- Degenerate curve segments.
- Near-zero derivatives.
- Undefined Frenet frames.
- Unstable curvature calculations.
- Numerical integration errors.

### Spatial Mathematics

- Invalid quaternion representations.
- Near-zero rotation axes.
- Incorrect transformation conventions.
- Invalid pose components.

Invalid inputs should not silently produce plausible-looking results.

The exact validation and error-reporting mechanisms remain dependent on each implementation.

---

## Project Structure

```text
VectorForge/
│
├── src/
│   └── VectorForge/
│       ├── LieGroupKinematics.lua
│       ├── SpectralLinearAlgebra.lua
│       ├── BayesianStateEstimation.lua
│       └── DifferentialPathGeometry.lua
│
├── docs/
│   ├── API.md
│   ├── ARCHITECTURE.md
│   └── MATHEMATICS.md
│
├── examples/
│
├── tests/
│
├── default.project.json
├── README.md
└── CHANGELOG.md
```

### Source Directory

Contains the core mathematical implementations.

### Documentation Directory

Contains API documentation, architectural explanations, and mathematical foundations.

### Examples Directory

Contains standalone demonstrations showing how mathematical functionality may be used within Roblox.

### Tests Directory

Contains test scripts for validating mathematical behaviour and detecting regressions.

---

## Current Architectural Status

VectorForge is an experimental project and its architecture is still evolving.

The current structure represents the intended separation of mathematical responsibilities rather than a finalized software architecture.

Some dependencies, error contracts, and implementation boundaries may change as additional functionality is developed.

Future architectural improvements may include:

- More explicit dependency management.
- Shared numerical utility components.
- Improved input validation.
- Expanded diagnostic capabilities.
- Additional mathematical modules.
- Dedicated performance benchmarks.

The architecture should evolve alongside the actual implementations rather than documenting functionality that does not yet exist.

---

## Related Documentation

- [API Reference](API.md)
- [Mathematical Foundations](MATHEMATICS.md)
- [Examples](../examples/README.md)
- [Tests](../tests/README.md)

---

*This document describes the intended architectural organization of VectorForge. Actual runtime behaviour and module dependencies are determined by the current source code.*