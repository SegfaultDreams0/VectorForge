local TrajectoryRenderer = {}

local function makeSegment(parent, startPosition, endPosition, thickness, color)
    local offset = endPosition - startPosition
    local length = offset.Magnitude

    if length <= 1e-6 then
        return nil
    end

    local part = Instance.new("Part")
    part.Name = "TrajectorySegment"
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Material = Enum.Material.Neon
    part.Color = color
    part.Size = Vector3.new(thickness, thickness, length)
    part.CFrame = CFrame.lookAt((startPosition + endPosition) * 0.5, endPosition)
    part.Parent = parent

    return part
end

function TrajectoryRenderer.draw(points, options)
    assert(type(points) == "table", "points must be a table")
    assert(#points >= 2, "at least two points are required")

    options = options or {}

    local parent = options.parent or workspace
    local thickness = options.thickness or 0.12
    local color = options.color or Color3.fromRGB(70, 170, 255)

    assert(typeof(parent) == "Instance", "parent must be an Instance")
    assert(type(thickness) == "number" and thickness > 0, "thickness must be positive")
    assert(typeof(color) == "Color3", "color must be a Color3")

    local model = Instance.new("Model")
    model.Name = options.name or "TrajectoryVisualization"
    model.Parent = parent

    for index, point in ipairs(points) do
        assert(typeof(point) == "Vector3", "every point must be a Vector3")

        if index > 1 then
            makeSegment(model, points[index - 1], point, thickness, color)
        end
    end

    return model
end

return TrajectoryRenderer
