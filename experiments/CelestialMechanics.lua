local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local rootName = "VectorForgeCelestialMechanics"
local old = Workspace:FindFirstChild(rootName)
if old then old:Destroy() end

local root = Instance.new("Folder")
root.Name = rootName
root.Parent = Workspace

local function sphere(name, radius, position, color, material)
    local part = Instance.new("Part")
    part.Name = name
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.one * radius * 2
    part.Position = position
    part.Anchored = true
    part.Material = material or Enum.Material.SmoothPlastic
    part.Color = color
    part.Parent = root
    return part
end

local center = Vector3.new(0, 18, 0)
sphere("CentralBody", 5, center, Color3.fromRGB(20, 20, 28), Enum.Material.Neon)
sphere("Glow", 5.35, center, Color3.fromRGB(110, 70, 210), Enum.Material.ForceField)

local function orbit(radius, color)
    local previous
    for i = 0, 96 do
        local a = i / 96 * math.pi * 2
        local point = center + Vector3.new(math.cos(a) * radius, 0, math.sin(a) * radius)
        if previous then
            local segment = Instance.new("Part")
            segment.Anchored = true
            segment.CanCollide = false
            segment.Material = Enum.Material.Neon
            segment.Color = color
            segment.Size = Vector3.new(0.08, 0.08, (point - previous).Magnitude)
            segment.CFrame = CFrame.lookAt((point + previous) / 2, point)
            segment.Parent = root
        end
        previous = point
    end
end

orbit(18, Color3.fromRGB(90, 170, 255))
orbit(30, Color3.fromRGB(255, 180, 90))
local planetA = sphere("PlanetA", 1.5, center + Vector3.new(18, 0, 0), Color3.fromRGB(80, 160, 255))
local planetB = sphere("PlanetB", 2.2, center + Vector3.new(0, 0, 30), Color3.fromRGB(230, 150, 80))
local started = os.clock()

RunService.Heartbeat:Connect(function()
    local t = os.clock() - started
    local a, b = t * 0.45, t * 0.22
    planetA.Position = center + Vector3.new(math.cos(a) * 18, 0, math.sin(a) * 18)
    planetB.Position = center + Vector3.new(math.cos(b) * 30, 0, math.sin(b) * 30)
end)
