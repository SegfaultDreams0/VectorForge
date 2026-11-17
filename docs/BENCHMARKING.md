# Benchmarking

Benchmarking measures runtime under defined conditions. It is separate from correctness testing.

## Procedure
1. Define one operation and input distribution.
2. Construct inputs outside the timed section when setup is not being measured.
3. Run warm-up iterations.
4. Collect multiple samples.
5. Report median, mean, minimum, and maximum.
6. Repeat at several input sizes.
7. Compare revisions under the same environment and workload.

## Record
- Module and operation.
- Input dimensions or problem size.
- Warm-up count and measured run count.
- Iterations per run.
- Median and mean elapsed time.
- Studio version, device, and commit hash.
- Memory/allocation observations, if measured.

Compare equivalent outputs and accuracy requirements. Do not compare different tolerances without disclosing the difference. Publish configuration and raw samples with summarized results.
