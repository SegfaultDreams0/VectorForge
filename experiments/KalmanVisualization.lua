local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local BayesianStateEstimation = require(VectorForge:WaitForChild("BayesianStateEstimation"))

local root = Instance.new("Folder")
root.Name = "VectorForgeKalmanVisualization"
root.Parent = Workspace

local function marker(name, color, size)
    local part = Instance.new("Part")
    part.Name = name
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.one * size
    part.Anchored = true
    part.CanCollide = false
    part.Color = color
    part.Material = Enum.Material.Neon
    part.Parent = root
    return part
end

local observation = marker("Observation", Color3.fromRGB(255, 100, 100), 1.2)
local estimate = marker("Estimate", Color3.fromRGB(80, 220, 150), 1.6)
local current = Vector3.new(0, 8, 0)
local started = os.clock()

local function referenceSmoother(measured, previous, dt)
    local alpha = math.clamp(dt * 3, 0, 1)
    return previous:Lerp(measured, alpha)
end

while true do
    local t = os.clock() - started
    local truth = Vector3.new(math.sin(t) * 20, 8, t * 2)
    local noise = Vector3.new(math.random(-100, 100) / 25, math.random(-100, 100) / 25, math.random(-100, 100) / 25)
    local measured = truth + noise
    current = referenceSmoother(measured, current, 1 / 30)
    observation.Position = measured
    estimate.Position = current
    task.wait(1 / 30)
end
