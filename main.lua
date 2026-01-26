-- MONSTER HUB FIX TAB
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonsterHub"
ScreenGui.Parent = game:GetService("CoreGui")

-- KHUNG CHÍNH CÓ TAB
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Size = UDim2.new(0, 450, 0, 300) -- Rộng hơn để chia tab
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Active = true
MainFrame.Draggable = true

-- PHẦN CHỨC NĂNG (Nằm bên phải các Tab)
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Parent = MainFrame
ContentFrame.Position = UDim2.new(0, 120, 0, 10)
ContentFrame.Size = UDim2.new(0, 320, 1, -20)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0, 0, 2, 0)

-- 1. CHỨC NĂNG TĂNG TỐC (SPEED)
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Parent = ContentFrame
SpeedBtn.Size = UDim2.new(1, -20, 0, 40)
SpeedBtn.Text = "Speed: 100"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

SpeedBtn.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

-- 2. CHỨC NĂNG AUTO FARM (TP + CLICK)
local FarmBtn = Instance.new("TextButton")
FarmBtn.Parent = ContentFrame
FarmBtn.Position = UDim2.new(0, 0, 0, 50)
FarmBtn.Size = UDim2.new(1, -20, 0, 40)
FarmBtn.Text = "Auto Farm NPC: TAT"
FarmBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local Farming = false
FarmBtn.MouseButton1Click:Connect(function()
    Farming = not Farming
    FarmBtn.Text = Farming and "Auto Farm NPC: BAT" or "Auto Farm NPC: TAT"
    FarmBtn.BackgroundColor3 = Farming and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 50, 50)
    
    task.spawn(function()
        while Farming do
            for _, v in pairs(workspace:GetChildren()) do
                if Farming and v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    if v.Name ~= game.Players.LocalPlayer.Name then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)
