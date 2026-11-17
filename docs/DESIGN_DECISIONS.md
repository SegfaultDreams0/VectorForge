# Design Decisions

This file records principles and decisions guiding VectorForge.

## D-001: Modular mathematical domains
**Decision:** Keep major mathematical domains in separate modules.

**Rationale:** Responsibilities are easier to understand, test, and evolve.

**Trade-off:** Some operations may be duplicated until a shared utility layer is justified.

## D-002: Keep engine presentation outside core mathematics
**Decision:** Prefer mathematical modules that calculate values without creating or modifying Roblox Instances.

**Rationale:** Computation can be reused and tested independently of rendering.

## D-003: Treat public APIs as experimental
**Decision:** Document API stability honestly while the project evolves.

**Rationale:** Signatures and numerical conventions may change. Consumers can pin a commit for reproducibility.

## D-004: Validate numerical behaviour explicitly
**Decision:** Use residuals, invariants, reference cases, and degeneracy tests where appropriate.

## Future records
For each decision, record context, chosen approach, alternatives, consequences, date, and implementation status.
