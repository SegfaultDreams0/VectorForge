# VectorForge Benchmarks

Repeatable performance experiments. Benchmarks measure runtime behaviour; they do not establish correctness.

## Contents
- `BenchmarkUtils.lua`: timing and reporting helper.
- `MatrixBenchmarks.server.lua`: matrix workload adapter.
- `OptimizationBenchmarks.server.lua`: optimization workload adapter.
- `GeometryBenchmarks.server.lua`: curve workload adapter.
- `StateEstimationBenchmarks.server.lua`: estimator workload adapter.

## Running
Install VectorForge in `ReplicatedStorage/VectorForge`, place the scripts in `ServerScriptService`, then connect each adapter callback to a function verified in your current module source. These templates deliberately avoid assuming undocumented function signatures.

Use warm-ups, multiple samples, identical inputs and tolerances, and record Studio version, device, and commit hash. Compare medians and retain raw samples.
