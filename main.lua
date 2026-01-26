-- MONSTER HUB VERSION 1.0
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonsterHub"
ScreenGui.Parent = game:GetService("CoreGui") -- Giữ menu khi reset

-- 1. TẠO GIAO DIỆN CHÍNH (300x400, Màu xám tối)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Màu xám bạn đã chọn
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.Size = UDim2.new(0, 300, 0, 400) -- Kích thước chuẩn
MainFrame.Active = true
MainFrame.Draggable = true -- Cho phép kéo menu

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "MONSTER HUB - PRIVATE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextSize = 18

-- 2. CHỨC NĂNG TĂNG TỐC (WALKSPEED)
local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Name = "SpeedBtn"
SpeedBtn.Parent = MainFrame
SpeedBtn.Size = UDim2.new(0, 260, 0, 40)
SpeedBtn.Position = UDim2.new(0, 20, 0, 50)
SpeedBtn.Text = "Tang Toc (Speed 100)"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

SpeedBtn.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
    print("Kich hoat Speed!")
end)

-- 3. CHỨC NĂNG AUTO FARM (TP + CLICK)
local FarmBtn = Instance.new("TextButton")
FarmBtn.Parent = MainFrame
FarmBtn.Size = UDim2.new(0, 260, 0, 40)
FarmBtn.Position = UDim2.new(0, 20, 0, 100)
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
            -- Tìm quái gần nhất trong Workspace
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                    if v.Humanoid.Health > 0 and v.Name ~= game.Players.LocalPlayer.Name then
                        -- Dịch chuyển ra sau lưng NPC 3 studs
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        
                        -- Gửi lệnh Click ảo để đánh
                        local vim = game:GetService("VirtualInputManager")
                        vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        
                        task.wait(0.1)
                    end
                end
            end
            task.wait()
        end
    end)
end)

print("Monster Hub Loaded Successfully!")