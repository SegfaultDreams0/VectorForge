local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local DifferentialPathGeometry = require(VectorForge:WaitForChild("DifferentialPathGeometry"))

local root = Instance.new("Folder")
root.Name = "VectorForgeTrajectoryLaboratory"
root.Parent = Workspace

local function curve(t)
    return Vector3.new(-40 + 80 * t, 12 + math.sin(t * math.pi * 2) * 12, math.cos(t * math.pi * 2) * 20)
end

local previous
for i = 0, 100 do
    local point = curve(i / 100)
    local marker = Instance.new("Part")
    marker.Name = "Sample"
    marker.Shape = Enum.PartType.Ball
    marker.Size = Vector3.one * 0.65
    marker.Anchored = true
    marker.CanCollide = false
    marker.Material = Enum.Material.Neon
    marker.Color = Color3.fromRGB(100, 190, 255)
    marker.Position = point
    marker.Parent = root

    if previous then
        local segment = Instance.new("Part")
        segment.Name = "PathSegment"
        segment.Anchored = true
        segment.CanCollide = false
        segment.Material = Enum.Material.Neon
        segment.Color = Color3.fromRGB(180, 120, 255)
        segment.Size = Vector3.new(0.18, 0.18, (point - previous).Magnitude)
        segment.CFrame = CFrame.lookAt((point + previous) / 2, point)
        segment.Parent = root
    end
    previous = point
end

assert(DifferentialPathGeometry ~= nil, "DifferentialPathGeometry failed to load")
