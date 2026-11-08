
-- DIRECTX V4 | WHITE ORB PROTECTION
-- ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local event = ReplicatedStorage:FindFirstChild("DirectXEvent")

if not event then
    event = Instance.new("RemoteEvent")
    event.Name = "DirectXEvent"
    event.Parent = ReplicatedStorage
end

local function createOrb(character)
    local root = character:WaitForChild("HumanoidRootPart")

    local old = character:FindFirstChild("DirectXWhiteOrb")
    if old then old:Destroy() end

    local orb = Instance.new("Part")
    orb.Name = "DirectXWhiteOrb"
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(9, 9, 9)
    orb.Material = Enum.Material.ForceField
    orb.Color = Color3.fromRGB(220, 245, 255)
    orb.Transparency = 0.65
    orb.CanCollide = false
    orb.CanTouch = false
    orb.Massless = true
    orb.CastShadow = false
    orb.Parent = character

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = root
    weld.Part1 = orb
    weld.Parent = orb

    orb.CFrame = root.CFrame
end

local function removeOrb(character)
    local orb = character:FindFirstChild("DirectXWhiteOrb")
    if orb then orb:Destroy() end
end

event.OnServerEvent:Connect(function(player, enabled)
    if typeof(enabled) ~= "boolean" then return end

    -- Pentru jocul propriu, autorizează aici administratorii.
    player:SetAttribute("DirectXProtection", enabled)

    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if enabled then
        createOrb(character)
    else
        removeOrb(character)
    end
end)

local function setupPlayer(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(1)

        if player:GetAttribute("DirectXProtection") then
            createOrb(character)
        end
    end)
end

Players.PlayerAdded:Connect(setupPlayer)

for _, player in Players:GetPlayers() do
    setupPlayer(player)
end
