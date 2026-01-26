--// MONSTER HUB - SIMPLE AUTO FARM UI
--// Tested for exploit (Synapse / KRNL / Fluxus)

-- Anti duplicate UI
if game.CoreGui:FindFirstChild("MonsterHub") then
    game.CoreGui.MonsterHub:Destroy()
end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonsterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- MAIN FRAME
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 420, 0, 260)
Main.Position = UDim2.new(0.5, -210, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
Main.Active = true
Main.Draggable = true

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundColor3 = Color3.fromRGB(20,20,20)
Title.Text = "MONSTER HUB"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- CONTENT
local Content = Instance.new("Frame")
Content.Parent = Main
Content.Position = UDim2.new(0,0,0,45)
Content.Size = UDim2.new(1,0,1,-45)
Content.BackgroundTransparency = 1

-- FUNCTION CREATE BUTTON
local function CreateButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Parent = Content
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.Position = UDim2.new(0.05,0,0,posY)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    return btn
end

---------------------------------------------------
-- SPEED TOGGLE
---------------------------------------------------
local SpeedOn = false
local SpeedBtn = CreateButton("Speed: OFF", 0)

SpeedBtn.MouseButton1Click:Connect(function()
    SpeedOn = not SpeedOn
    if SpeedOn then
        SpeedBtn.Text = "Speed: ON"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        SpeedBtn.Text = "Speed: OFF"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end
end)

-- Apply speed continuously
RunService.Heartbeat:Connect(function()
    if SpeedOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)

---------------------------------------------------
-- AUTO FARM TOGGLE
---------------------------------------------------
local AutoFarm = false
local FarmBtn = CreateButton("Auto Farm: OFF", 50)

FarmBtn.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    if AutoFarm then
        FarmBtn.Text = "Auto Farm: ON"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
    else
        FarmBtn.Text = "Auto Farm: OFF"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end
end)

-- AUTO FARM LOOP
task.spawn(function()
    while task.wait(0.15) do
        if AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, mob in pairs(workspace:GetChildren()) do
                if not AutoFarm then break end

                if mob:IsA("Model")
                and mob ~= LocalPlayer.Character
                and mob:FindFirstChild("Humanoid")
                and mob:FindFirstChild("HumanoidRootPart")
                and mob.Humanoid.Health > 0 then

                    -- Teleport behind mob
                    LocalPlayer.Character.HumanoidRootPart.CFrame =
                        mob.HumanoidRootPart.CFrame * CFrame.new(0,0,3)

                    -- Attack (click)
                    mouse1click()
                    task.wait(0.1)
                end
            end
        end
    end
end)

---------------------------------------------------
-- CLOSE UI
---------------------------------------------------
local Close = Instance.new("TextButton")
Close.Parent = Title
Close.Size = UDim2.new(0,40,1,0)
Close.Position = UDim2.new(1,-40,0,0)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(150,0,0)
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
