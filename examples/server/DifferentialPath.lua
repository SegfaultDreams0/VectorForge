local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Geometry = require(RS.VectorForge:WaitForChild("DifferentialPathGeometry"))

local name = "VectorForge_PathExample"
local old = workspace:FindFirstChild(name)
if old then old:Destroy() end

local folder = Instance.new("Folder")
folder.Name = name
folder.Parent = workspace

local path = Geometry.new({
    Vector3.new(-35, 7, -15),
    Vector3.new(-18, 22, 18),
    Vector3.new(8, 10, 28),
    Vector3.new(35, 19, -8),
    Vector3.new(48, 8, -25)
})

local frames = path:ParallelTransportFrames(60)
local totalLength = path:ArcLength()

for index, frame in ipairs(frames) do
    local dot = Instance.new("Part")
    dot.Name = "PathSample_" .. index
    dot.Shape = Enum.PartType.Ball
    dot.Size = Vector3.new(0.35, 0.35, 0.35)
    dot.Position = frame.Position
    dot.Color = Color3.fromRGB(75, 205, 145)
    dot.Material = Enum.Material.Neon
    dot.Anchored = true
    dot.CanCollide = false
    dot.Parent = folder
end

local mover = Instance.new("Part")
mover.Name = "ArcLengthMover"
mover.Shape = Enum.PartType.Ball
mover.Size = Vector3.new(2, 2, 2)
mover.Color = Color3.fromRGB(65, 155, 255)
mover.Material = Enum.Material.Neon
mover.Anchored = true
mover.CanCollide = false
mover.Parent = folder

local elapsed = 0
local duration = 14
local connection
connection = RunService.Heartbeat:Connect(function(dt)
    if not folder.Parent then connection:Disconnect() return end
    elapsed += dt

    local distance = (elapsed % duration) / duration * totalLength
    local parameter = path:ParameterAtArcLength(distance)
    local frame = path:FrenetFrame(parameter)

    mover.CFrame = CFrame.lookAt(
        frame.Position,
        frame.Position + frame.Tangent,
        frame.Normal
    )
end)

local middle = path:FrenetFrame(0.5)
print(string.format(
    "[VectorForge] Path length %.3f | curvature %.6f | torsion %.6f",
    totalLength, middle.Curvature, middle.Torsion
))
