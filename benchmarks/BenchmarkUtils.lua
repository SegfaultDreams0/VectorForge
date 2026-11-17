local BenchmarkUtils = {}

local function median(values)
    local sorted = table.clone(values)
    table.sort(sorted)
    local n = #sorted
    if n == 0 then return nil end
    if n % 2 == 1 then return sorted[(n + 1) / 2] end
    return (sorted[n / 2] + sorted[n / 2 + 1]) / 2
end

function BenchmarkUtils.Measure(name, callback, options)
    options = options or {}
    local warmups = options.WarmupRuns or 2
    local runs = options.MeasuredRuns or 7
    local iterations = options.Iterations or 1

    assert(type(name) == "string")
    assert(type(callback) == "function")
    assert(warmups >= 0 and runs >= 1 and iterations >= 1)

    for _ = 1, warmups do
        for _ = 1, iterations do callback() end
    end

    local samples = {}
    local total = 0
    local minimum = math.huge
    local maximum = 0

    for index = 1, runs do
        local started = os.clock()
        for _ = 1, iterations do callback() end
        local elapsed = os.clock() - started
        samples[index] = elapsed
        total += elapsed
        minimum = math.min(minimum, elapsed)
        maximum = math.max(maximum, elapsed)
    end

    local result = {
        Name = name,
        WarmupRuns = warmups,
        MeasuredRuns = runs,
        IterationsPerRun = iterations,
        SamplesSeconds = samples,
        MeanSeconds = total / runs,
        MedianSeconds = median(samples),
        MinSeconds = minimum,
        MaxSeconds = maximum,
        MeanMillisecondsPerIteration = total / runs / iterations * 1000,
    }

    print(string.format(
        "[VectorForge Benchmark] %s | median %.6f s | mean %.6f ms/iteration",
        name, result.MedianSeconds, result.MeanMillisecondsPerIteration
    ))
    return result
end

function BenchmarkUtils.PrintEnvironment(metadata)
    metadata = metadata or {}
    print("[VectorForge Benchmark] PlaceVersion:", game.PlaceVersion)
    print("[VectorForge Benchmark] JobId:", game.JobId)
    print("[VectorForge Benchmark] Platform:", tostring(metadata.Platform or "Not recorded"))
    print("[VectorForge Benchmark] StudioVersion:", tostring(metadata.StudioVersion or "Not recorded"))
    print("[VectorForge Benchmark] Commit:", tostring(metadata.Commit or "Not recorded"))
end

return BenchmarkUtils
