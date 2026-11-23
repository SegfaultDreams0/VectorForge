local MotionSamples = {
    {
        time = 0.0,
        position = Vector2.new(0.00, 0.05),
    },
    {
        time = 0.5,
        position = Vector2.new(0.52, 0.18),
    },
    {
        time = 1.0,
        position = Vector2.new(1.03, 0.41),
    },
    {
        time = 1.5,
        position = Vector2.new(1.49, 0.62),
    },
    {
        time = 2.0,
        position = Vector2.new(2.02, 0.79),
    },
    {
        time = 2.5,
        position = Vector2.new(2.48, 1.02),
    },
    {
        time = 3.0,
        position = Vector2.new(3.01, 1.19),
    },
}

for _, sample in ipairs(MotionSamples) do
    table.freeze(sample)
end

return table.freeze(MotionSamples)
