# Changelog

All notable changes to VectorForge are documented in this file.

This project follows a simplified changelog structure inspired by Keep a Changelog. Version numbers and release entries represent project milestones rather than guarantees of production stability.

## [Unreleased]

Changes currently under development and not yet associated with a published version.

### Added
- `AutomaticDifferentiation` — experimental automatic differentiation utilities.
- `RigidBodyDynamics` — rigid-body motion and dynamics calculations.
- `NumericalOptimization` — numerical optimization methods.
- `TrajectoryPlanning` — trajectory construction and planning utilities.
- Expanded mathematical and API documentation for the eight-module architecture.
- A comprehensive test runner covering robotics, dynamics, estimation, numerical mathematics, and differential geometry.
- An integrated demonstration for the expanded module set.
- Initial API documentation covering the core mathematical modules.
- Architecture documentation describing module responsibilities and system organization.
- Mathematical documentation covering the theoretical foundations of implemented algorithms.
- Practical Roblox demonstrations for:
  - Rigid-body pose interpolation.
  - Differential path geometry.
  - Bayesian motion tracking.
  - Least-squares polynomial regression.
- Initial deterministic regression test suite.
- Rojo project configuration for automated Roblox project mapping.
- Repository documentation and contribution guidelines.

### Documentation
- Added installation instructions for manual Roblox Studio setup.
- Added module descriptions and potential application scenarios.
- Documented mathematical concepts and numerical considerations.
- Established initial repository organization and development guidelines.

### Development Status
- The expanded library currently contains eight mathematical modules.
- Core mathematical implementations remain under development.
- Public APIs are subject to change.
- Numerical stability and edge-case validation require further investigation.
- Runtime performance has not been comprehensively benchmarked.
- Additional examples, tests, and documentation are planned.

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