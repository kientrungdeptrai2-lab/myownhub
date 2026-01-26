-- SERVICES / CACHE
local Players = game:GetService("Players")
local VirtualInput = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- SAFE GET CHARACTER
local function getChar()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hum and hrp and hum.Health > 0 then
        return char, hum, hrp
    end
end

-- ================= SPEED =================
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Parent = ContentFrame
SpeedBtn.Size = UDim2.new(1, -20, 0, 40)
SpeedBtn.Text = "Speed: 100"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

SpeedBtn.MouseButton1Click:Connect(function()
    local char, hum = getChar()
    if hum then
        hum.WalkSpeed = 100
    end
end)

-- ================= AUTO FARM =================
local FarmBtn = Instance.new("TextButton")
FarmBtn.Parent = ContentFrame
FarmBtn.Position = UDim2.new(0, 0, 0, 50)
FarmBtn.Size = UDim2.new(1, -20, 0, 40)
FarmBtn.Text = "Auto Farm NPC: OFF"
FarmBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local Farming = false
local FarmThread

-- FIND NEAREST NPC
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

FarmBtn.MouseButton1Click:Connect(function()
    Farming = not Farming
    FarmBtn.Text = Farming and "Auto Farm NPC: ON" or "Auto Farm NPC: OFF"
    FarmBtn.BackgroundColor3 = Farming
        and Color3.fromRGB(200, 60, 60)
        or Color3.fromRGB(50, 50, 50)

    if not Farming then return end

    FarmThread = task.spawn(function()
        while Farming do
            local char, hum, hrp = getChar()
            if not hrp then
                task.wait(1)
                continue
            end

            local npc = getNearestNPC(hrp)
            if npc then
                hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)

                -- CLICK ATTACK
                VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait()
                VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end

            task.wait(0.25) -- giảm load CPU
        end
    end)
end)
