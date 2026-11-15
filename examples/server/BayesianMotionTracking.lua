local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local EKF = require(RS.VectorForge:WaitForChild("BayesianStateEstimation"))

local name = "VectorForge_EKFExample"
local old = workspace:FindFirstChild(name)
if old then old:Destroy() end

local folder = Instance.new("Folder")
folder.Name = name
folder.Parent = workspace

local function sphere(name, color, size)
    local part = Instance.new("Part")
    part.Name = name
    part.Shape = Enum.PartType.Ball
    part.Size = size
    part.Color = color
    part.Material = Enum.Material.Neon
    part.Anchored = true
    part.CanCollide = false
    part.Parent = folder
    return part
end

local actualMarker = sphere("ActualPosition", Color3.fromRGB(65, 155, 255), Vector3.new(1.5, 1.5, 1.5))
local estimateMarker = sphere("FilteredEstimate", Color3.fromRGB(255, 155, 65), Vector3.new(1.2, 1.2, 1.2))

local filter = EKF.new({
    InitialState = {0, 8, 0, 5, 0, 2},
    InitialCovariance = {
        {4, 0, 0, 0, 0, 0}, {0, 4, 0, 0, 0, 0}, {0, 0, 4, 0, 0, 0},
        {0, 0, 0, 2, 0, 0}, {0, 0, 0, 0, 2, 0}, {0, 0, 0, 0, 0, 2}
    },
    ProcessNoise = {
        {0.01, 0, 0, 0, 0, 0}, {0, 0.01, 0, 0, 0, 0}, {0, 0, 0.01, 0, 0, 0},
        {0, 0, 0, 0.08, 0, 0}, {0, 0, 0, 0, 0.08, 0}, {0, 0, 0, 0, 0, 0.08}
    },
    MeasurementNoise = {{0.35, 0, 0}, {0, 0.35, 0}, {0, 0, 0.35}},
    Transition = function(x, _, h)
        return {x[1] + x[4] * h, x[2] + x[5] * h, x[3] + x[6] * h, x[4], x[5], x[6]}
    end,
    Measurement = function(x)
        return {x[1], x[2], x[3]}
    end,
    GateThreshold = 16.27
})

local random = Random.new(4127)
local elapsed = 0
local connection
connection = RunService.Heartbeat:Connect(function(dt)
    if not folder.Parent then connection:Disconnect() return end
    local h = math.min(dt, 1 / 30)
    elapsed += h

    local actual = Vector3.new(
        5 * elapsed,
        8 + 4 * math.sin(elapsed * 0.7),
        2 * elapsed + 3 * math.sin(elapsed * 0.35)
    )

    local observation = {
        actual.X + random:NextNumber(-0.8, 0.8),
        actual.Y + random:NextNumber(-0.8, 0.8),
        actual.Z + random:NextNumber(-0.8, 0.8)
    }

    filter:Predict(nil, h)
    filter:Update(observation)

    local estimate = filter:GetEstimate()
    local estimated = Vector3.new(estimate.State[1], estimate.State[2], estimate.State[3])

    actualMarker.Position = actual
    estimateMarker.Position = estimated

    if math.floor(elapsed) ~= math.floor(elapsed - h) then
        print(string.format(
            "[VectorForge] t=%.1f | error=%.3f | accepted=%d | rejected=%d",
            elapsed, (actual - estimated).Magnitude,
            estimate.AcceptedMeasurements, estimate.RejectedMeasurements
        ))
    end
end)

print("[VectorForge] EKF motion tracking example running.")
