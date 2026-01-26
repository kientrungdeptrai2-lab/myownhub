--==================================================
-- MONSTER HUB - FULL FIXED VERSION
--==================================================

-- SERVICES
local Players = game:GetService("Players")
local VirtualInput = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

--==================================================
-- GUI SETUP (KHÔNG DÙNG COREGUI)
--==================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonsterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- MAIN FRAME
--==================================================
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

-- BO GÓC
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

--==================================================
-- TITLE
--==================================================
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "MONSTER HUB"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

--==================================================
-- CONTENT FRAME
--==================================================
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Parent = MainFrame
ContentFrame.Position = UDim2.new(0, 120, 0, 35)
ContentFrame.Size = UDim2.new(0, 320, 1, -45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarImageTransparency = 0.5
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.CanvasSize = UDim2.new()

local UIList = Instance.new("UIListLayout", ContentFrame)
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
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = ContentFrame

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

--==================================================
-- SPEED BUTTON
--==================================================
local SpeedBtn = createButton("Speed: 100")

SpeedBtn.MouseButton1Click:Connect(function()
    local _, hum = getCharacter()
    if hum then
        hum.WalkSpeed = 100
    end
end)

--==================================================
-- AUTO FARM
--==================================================
local FarmBtn = createButton("Auto Farm NPC: OFF")
local Farming = false

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
                hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)

                -- CLICK ATTACK
                VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.05)
                VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end

            task.wait(0.25)
        end
    end)
end)

--==================================================
-- DONE
--==================================================
print("[Monster Hub] Loaded successfully!")
