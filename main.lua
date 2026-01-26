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

-- 1. CHỨC NĂNG TĂNG TỐC (SPEED TOGGLE)
local SpeedToggle = false
SpeedBtn.MouseButton1Click:Connect(function()
    SpeedToggle = not SpeedToggle -- Đảo trạng thái mỗi khi bấm
    if SpeedToggle then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
        SpeedBtn.Text = "Speed: BAT (100)"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Màu xanh khi bật
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Tốc độ mặc định
        SpeedBtn.Text = "Speed: TAT"
        SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Màu xám khi tắt
    end
end)

-- 2. CHỨC NĂNG AUTO FARM (AUTO FARM TOGGLE)
local Farming = false
FarmBtn.MouseButton1Click:Connect(function()
    Farming = not Farming
    if Farming then
        FarmBtn.Text = "Auto Farm NPC: BAT"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Màu đỏ khi đang farm
    else
        FarmBtn.Text = "Auto Farm NPC: TAT"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
    
    -- Vòng lặp chỉ chạy khi Farming = true
    task.spawn(function()
        while Farming do
            pcall(function() -- Dùng pcall để tránh lỗi khi quái chết
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                        if v.Humanoid.Health > 0 and v.Name ~= game.Players.LocalPlayer.Name then
                            -- Chỉ dịch chuyển và đánh nếu Farming vẫn đang bật
                            if not Farming then break end 
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            
                            local vim = game:GetService("VirtualInputManager")
                            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end)
