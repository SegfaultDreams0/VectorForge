local VectorFieldRenderer = {}

local function makeSample(parent, position, vector, scale, thickness, color)
    local magnitude = vector.Magnitude

    if magnitude <= 1e-6 then
        return
    end

    local endpoint = position + vector * scale
    local midpoint = (position + endpoint) * 0.5

    local shaft = Instance.new("Part")
    shaft.Name = "VectorShaft"
    shaft.Anchored = true
    shaft.CanCollide = false
    shaft.CanTouch = false
    shaft.CanQuery = false
    shaft.Material = Enum.Material.Neon
    shaft.Color = color
    shaft.Size = Vector3.new(thickness, thickness, (endpoint - position).Magnitude)
    shaft.CFrame = CFrame.lookAt(midpoint, endpoint)
    shaft.Parent = parent

    local marker = Instance.new("Part")
    marker.Name = "VectorEndpoint"
    marker.Shape = Enum.PartType.Ball
    marker.Anchored = true
    marker.CanCollide = false
    marker.CanTouch = false
    marker.CanQuery = false
    marker.Material = Enum.Material.Neon
    marker.Color = color
    marker.Size = Vector3.new(thickness * 2.5, thickness * 2.5, thickness * 2.5)
    marker.Position = endpoint
    marker.Parent = parent
end

function VectorFieldRenderer.draw(samples, options)
    assert(type(samples) == "table", "samples must be a table")

    options = options or {}

    local parent = options.parent or workspace
    local scale = options.scale or 1
    local thickness = options.thickness or 0.08
    local color = options.color or Color3.fromRGB(255, 190, 70)

    assert(typeof(parent) == "Instance", "parent must be an Instance")
    assert(type(scale) == "number" and scale > 0, "scale must be positive")
    assert(type(thickness) == "number" and thickness > 0, "thickness must be positive")
    assert(typeof(color) == "Color3", "color must be a Color3")

    local model = Instance.new("Model")
    model.Name = options.name or "VectorFieldVisualization"
    model.Parent = parent

    for _, sample in ipairs(samples) do
        assert(typeof(sample) == "table", "each sample must be a table")
        assert(typeof(sample.position) == "Vector3", "sample.position must be a Vector3")
        assert(typeof(sample.vector) == "Vector3", "sample.vector must be a Vector3")

        makeSample(model, sample.position, sample.vector, scale, thickness, color)
    end

    return model
end

return VectorFieldRenderer
