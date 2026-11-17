# Changelog

All notable changes to VectorForge are documented in this file.

This project follows a simplified changelog structure inspired by Keep a Changelog. Version numbers and release entries represent project milestones rather than guarantees of production stability.

## [Unreleased]

Changes currently under development and not yet associated with a published version.

### Added

#### Core Modules
- `AutomaticDifferentiation` — experimental automatic differentiation utilities.
- `RigidBodyDynamics` — rigid-body motion and dynamics calculations.
- `NumericalOptimization` — numerical optimization methods.
- `TrajectoryPlanning` — trajectory construction and planning utilities.

#### Testing and Demonstrations
- A comprehensive test runner covering robotics, dynamics, estimation, numerical mathematics, and differential geometry.
- An integrated demonstration for the expanded module set.
- Additional experimental laboratories for mathematical visualization and numerical exploration.

#### Benchmarks
- Added a dedicated `benchmarks/` directory for performance measurement and algorithm evaluation.
- Added `BenchmarkUtils.lua` for timing, repeated measurements, and benchmark reporting.
- Added benchmark templates for:
  - Matrix operations and numerical linear algebra.
  - Numerical optimization workloads.
  - Differential geometry computations.
  - Bayesian state estimation workloads.

#### Experiments
- Added a dedicated `experiments/` directory for experimental mathematical demonstrations.
- Added `CelestialMechanics.server.lua` for simplified orbital and celestial visualization.
- Added `OrbitalSimulation.server.lua` for a basic Newtonian orbital simulation.
- Added `KalmanVisualization.server.lua` for visualizing noisy observations and estimated positions.
- Added `TrajectoryLaboratory.server.lua` for parametric path visualization.
- Added `NumericalStabilityLab.server.lua` for exploring floating-point accumulation errors.

#### Research
- Added a dedicated `research/` directory for mathematical notes and future development investigations.
- Added `LieGroupNotes.md` covering rotation groups, quaternions, and rigid transformations.
- Added `NumericalMethods.md` covering numerical errors, conditioning, and computational stability.
- Added `StateEstimationNotes.md` covering probabilistic state estimation and filter design.
- Added `FutureAlgorithms.md` documenting potential algorithms and future research directions.

#### Documentation
- Expanded mathematical and API documentation for the eight-module architecture.
- Added `NUMERICAL_VALIDATION.md` describing numerical validation strategies, residual checks, mathematical invariants, and tolerance selection.
- Added `BENCHMARKING.md` documenting benchmark methodology, measurement procedures, and reproducibility.
- Added `DESIGN_DECISIONS.md` recording architectural principles and development decisions.
- Added `GLOSSARY.md` defining mathematical and numerical terminology used throughout VectorForge.
- Added installation instructions for manual Roblox Studio setup.
- Added module descriptions and potential application scenarios.
- Documented mathematical concepts and numerical considerations.
- Established initial repository organization and development guidelines.

#### Initial Project Infrastructure
- Added initial API documentation covering the core mathematical modules.
- Added architecture documentation describing module responsibilities and system organization.
- Added mathematical documentation covering the theoretical foundations of implemented algorithms.
- Added practical Roblox demonstrations for:
  - Rigid-body pose interpolation.
  - Differential path geometry.
  - Bayesian motion tracking.
  - Least-squares polynomial regression.
- Added an initial deterministic regression test suite.
- Added Rojo project configuration for automated Roblox project mapping.
- Added repository documentation and contribution guidelines.

### Changed
- Expanded the documented module architecture from four to eight mathematical modules.
- Extended the documented project structure to include benchmarks, experiments, research notes, and additional technical documentation.
- Expanded testing and development documentation to cover the additional mathematical domains.

### Development Status
- The expanded library currently contains eight mathematical modules.
- Core mathematical implementations remain under development.
- Public APIs are subject to change.
- Numerical stability and edge-case validation require further investigation.
- Runtime performance has not been comprehensively benchmarked.
- Benchmark scripts currently provide workload adapters that must be connected to verified module APIs.
- Experimental demonstrations are intended for exploration and visualization, not as validated physical or numerical simulations.
- Additional examples, tests, benchmarks, and documentation are planned.

---

## [0.1.0] — Initial Experimental Milestone

Initial repository milestone introducing the VectorForge mathematical library concept.

### Added
- `LieGroupKinematics` — rotation mathematics and rigid-body transformations.
- `SpectralLinearAlgebra` — matrix operations, numerical decompositions, and linear-system solvers.
- `BayesianStateEstimation` — Bayesian filtering and dynamic state estimation.
- `DifferentialPathGeometry` — differential curve analysis and trajectory computation.

### Project Structure
- Established a modular mathematical architecture.
- Introduced separate directories for source code, documentation, examples, and tests.
- Added initial repository configuration and project metadata.

### Notes
- This milestone represents the initial experimental development of VectorForge.
- The library is incomplete and should not be considered production-ready.
- Functionality, numerical behaviour, and public interfaces may change in subsequent development.

---

## Versioning Policy

VectorForge currently uses semantic versioning as a reference for organizing future releases.

The intended version format is:

`MAJOR.MINOR.PATCH`

- **MAJOR:** Breaking changes to established public interfaces.
- **MINOR:** New functionality and backward-compatible additions.
- **PATCH:** Bug fixes, corrections, and minor improvements.

Versioning conventions may evolve as the project matures.

---

## Change Categories

The following categories are used to organize repository updates:

- **Added:** New functionality, modules, or capabilities.
- **Changed:** Modifications to existing functionality.
- **Fixed:** Bug fixes and corrections.
- **Removed:** Deleted functionality or deprecated components.
- **Deprecated:** Features scheduled for removal.
- **Security:** Security-related improvements and corrections.
- **Documentation:** Changes to technical documentation and project guides.

---

*VectorForge is an ongoing experimental project. This changelog will be updated as implementations evolve, functionality expands, and new development milestones are reached.*