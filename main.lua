-- MONSTER HUB FIX TOGGLE LOGIC
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonsterHub"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.Active = true
MainFrame.Draggable = true 

-- BIẾN KIỂM SOÁT TRẠNG THÁI (QUAN TRỌNG)
local SpeedOn = false
local Farming = false

-- CHỨC NĂNG SPEED
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Parent = MainFrame
SpeedBtn.Size = UDim2.new(0, 260, 0, 40)
SpeedBtn.Position = UDim2.new(0, 20, 0, 60)
SpeedBtn.Text = "Speed: TAT"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

SpeedBtn.MouseButton1Click:Connect(function()
    SpeedOn = not SpeedOn -- Đảo trạng thái thực sự
    if SpeedOn then
        SpeedBtn.Text = "Speed: BAT (100)"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        SpeedBtn.Text = "Speed: TAT"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Trả về mặc định ngay lập tức
        end
    end
end)

-- Vòng lặp Speed an toàn
task.spawn(function()
    while task.wait(0.1) do
        if SpeedOn and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
        end
    end
end)

-- CHỨC NĂNG AUTO FARM
local FarmBtn = Instance.new("TextButton")
FarmBtn.Parent = MainFrame
FarmBtn.Size = UDim2.new(0, 260, 0, 40)
FarmBtn.Position = UDim2.new(0, 20, 0, 110)
FarmBtn.Text = "Auto Farm NPC: TAT"
FarmBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

FarmBtn.MouseButton1Click:Connect(function()
    Farming = not Farming
    if Farming then
        FarmBtn.Text = "Auto Farm NPC: BAT"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        FarmBtn.Text = "Auto Farm NPC: TAT"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Vòng lặp Farm có điều kiện ngắt (Break)
task.spawn(function()
    while true do
        task.wait(0.1)
        if Farming then
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if not Farming then break end -- Ngắt vòng lặp ngay nếu Farming = false
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if v.Name ~= game.Players.LocalPlayer.Name then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        end
                    end
                end
            end)
        end
    end
end)
