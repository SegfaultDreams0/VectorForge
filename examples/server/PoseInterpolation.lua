local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lie = require(RS.VectorForge:WaitForChild("LieGroupKinematics"))

local name = "VectorForge_PoseExample"
local old = workspace:FindFirstChild(name)
if old then old:Destroy() end

local folder = Instance.new("Folder")
folder.Name = name
folder.Parent = workspace

local function marker(name, position, color, size)
    local part = Instance.new("Part")
    part.Name = name
    part.Shape = Enum.PartType.Ball
    part.Position = position
    part.Size = size
    part.Color = color
    part.Material = Enum.Material.Neon
    part.Anchored = true
    part.CanCollide = false
    part.Parent = folder
    return part
end

local startPose = Lie.Pose.New(
    Lie.Quaternion.Exp(Vector3.new(0, math.rad(-70), 0)),
    Vector3.new(-18, 8, 0)
)
local endPose = Lie.Pose.New(
    Lie.Quaternion.Exp(Vector3.new(math.rad(100), math.rad(120), math.rad(35))),
    Vector3.new(18, 8, 0)
)

marker("StartPose", startPose.Translation, Color3.fromRGB(65, 160, 255), Vector3.new(1.5, 1.5, 1.5))
marker("EndPose", endPose.Translation, Color3.fromRGB(255, 145, 65), Vector3.new(1.5, 1.5, 1.5))
local mover = marker("InterpolatedPose", startPose.Translation, Color3.fromRGB(80, 235, 160), Vector3.new(2, 2, 2))

local elapsed = 0
local duration = 6
local connection
connection = RunService.Heartbeat:Connect(function(dt)
    if not folder.Parent then connection:Disconnect() return end
    elapsed += dt
    local alpha = (elapsed % (duration * 2)) / duration
    if alpha > 1 then alpha = 2 - alpha end

    local pose = Lie.Pose.Interpolate(startPose, endPose, alpha)
    local axis, angle = Lie.Quaternion.ToAxisAngle(pose.Rotation)
    mover.CFrame = CFrame.new(pose.Translation) * CFrame.fromAxisAngle(axis, angle)
end)

print("[VectorForge] SE(3) pose interpolation example running.")
