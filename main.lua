--==================================================
-- MONSTER HUB - FULL VERSION
-- Auto Farm + Hitbox + Bring Mob
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local VirtualInput = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

--==================================================
-- GUI
--==================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonsterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 360, 0, 200)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "MONSTER HUB"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local Content = Instance.new("Frame")
Content.Parent = MainFrame
Content.Position = UDim2.new(0, 10, 0, 40)
Content.Size = UDim2.new(1, -20, 1, -50)
Content.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", Content)
UIList.Padding = UDim.new(0, 10)

--==================================================
-- UTILS
--==================================================
local function getCharacter()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hum and hrp and hum.Health > 0 then
        return char, hum, hrp
    end
end

local function createButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Parent = Content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

--==================================================
-- SPEED
--==================================================
local SpeedBtn = createButton("Speed: 100")
SpeedBtn.MouseButton1Click:Connect(function()
    local _, hum = getCharacter()
    if hum then hum.WalkSpeed = 100 end
end)

--==================================================
-- HITBOX + BRING MOB
--==================================================
local HITBOX_SIZE = 25

local function expandHitbox(npc)
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
    hrp.Transparency = 0.7
    hrp.CanCollide = false
end

local function bringMob(npc, playerHrp)
    local nHrp = npc:FindFirstChild("HumanoidRootPart")
    local hum = npc:FindFirstChildOfClass("Humanoid")
    if not nHrp or not hum then return end

    hum.WalkSpeed = 0
    hum.JumpPower = 0
    hum.AutoRotate = false

    nHrp.CFrame = playerHrp.CFrame * CFrame.new(0, 0, -4)
end

local function getNearestNPC(hrp)
    local nearest, dist = nil, math.huge
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model")
        and v:FindFirstChild("Humanoid")
        and v:FindFirstChild("HumanoidRootPart")
        and v.Humanoid.Health > 0
        and not Players:GetPlayerFromCharacter(v) then
            local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then
                dist = d
                nearest = v
            end
        end
    end
    return nearest
end

--==================================================
-- AUTO FARM
--==================================================
local FarmBtn = createButton("Auto Farm NPC: OFF")
local Farming = false

FarmBtn.MouseButton1Click:Connect(function()
    Farming = not Farming
    FarmBtn.Text = Farming and "Auto Farm NPC: ON" or "Auto Farm NPC: OFF"
    FarmBtn.BackgroundColor3 = Farming
        and Color3.fromRGB(180, 60, 60)
        or Color3.fromRGB(50, 50, 50)

    if not Farming then return end

    task.spawn(function()
        while Farming do
            local _, _, hrp = getCharacter()
            if not hrp then
                task.wait(1)
                continue
            end

            local npc = getNearestNPC(hrp)
            if npc then
                expandHitbox(npc)
                bringMob(npc, hrp)

                -- AUTO CLICK
                VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.05)
                VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end

            task.wait(0.25)
        end
    end)
end)

--==================================================
print("[Monster Hub] Loaded successfully!")
