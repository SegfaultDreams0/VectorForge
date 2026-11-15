# Contributing

Thank you for your interest in VectorForge. Reproducible bug reports, documentation improvements, tests, and carefully scoped contributions are welcome.

## Before contributing

- Read the README and relevant documents in `docs/`.
- Check whether the issue has already been reported.
- Keep changes focused.
- Do not claim numerical guarantees that have not been tested.

## Bug reports

Include the Roblox Studio version, module and function, minimal reproducible input, expected result, actual result, and relevant Output errors or numerical values. For numerical issues, include tolerances and explain how the expected value was obtained.

## Pull requests

- Explain the problem being solved.
- Describe the mathematical approach.
- Include deterministic tests for new behaviour.
- Add or update examples when public usage changes.
- Update API documentation and changelog entries.
- Avoid unrelated refactoring.

## Numerical implementation guidelines

- State matrix dimensions and preconditions clearly.
- Prefer stable numerical methods.
- Handle singular and degenerate inputs deliberately.
- Use tolerances appropriate to the problem scale.
- Test residuals, reconstruction error, orthogonality, and boundary conditions where relevant.
- Avoid expensive work in per-frame loops when results can be cached.

## Style

Use clear Luau names and consistent formatting. Keep mathematical responsibilities separate from Roblox presentation code. Avoid unnecessary dependencies.

## Project direction

VectorForge is not yet a finished product. Contributions should improve correctness, clarity, usability, or test coverage without overstating project maturity.
