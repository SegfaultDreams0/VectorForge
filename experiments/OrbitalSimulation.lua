local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local MU = 900
local position = Vector3.new(45, 0, 0)
local velocity = Vector3.new(0, 0, 4.2)
local fixedStep = 1 / 120
local accumulator = 0

local root = Instance.new("Folder")
root.Name = "VectorForgeOrbitalSimulation"
root.Parent = Workspace

local function makeBody(name, size, color, position)
    local part = Instance.new("Part")
    part.Name = name
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.one * size
    part.Anchored = true
    part.Material = Enum.Material.Neon
    part.Color = color
    part.Position = position
    part.Parent = root
    return part
end

makeBody("CentralMass", 12, Color3.fromRGB(35, 25, 55), Vector3.zero)
local body = makeBody("OrbitingBody", 3, Color3.fromRGB(80, 190, 255), position)

local function acceleration(p)
    local r = p.Magnitude
    if r < 1e-4 then return Vector3.zero end
    return -MU * p / (r ^ 3)
end

RunService.Heartbeat:Connect(function(dt)
    accumulator += math.min(dt, 0.1)
    while accumulator >= fixedStep do
        local a0 = acceleration(position)
        local nextPosition = position + velocity * fixedStep + 0.5 * a0 * fixedStep * fixedStep
        local a1 = acceleration(nextPosition)
        velocity += 0.5 * (a0 + a1) * fixedStep
        position = nextPosition
        accumulator -= fixedStep
    end
    body.Position = position
end)
