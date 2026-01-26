-- MONSTER HUB FIX TARGETING
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

local Farming = false

-- PHẦN NUT BẤM AUTO FARM
local FarmBtn = Instance.new("TextButton")
FarmBtn.Parent = MainFrame
FarmBtn.Size = UDim2.new(0, 260, 0, 40)
FarmBtn.Position = UDim2.new(0, 20, 0, 110)
FarmBtn.Text = "Auto Farm NPC: TAT"
FarmBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

FarmBtn.MouseButton1Click:Connect(function()
    Farming = not Farming
    FarmBtn.Text = Farming and "Auto Farm NPC: BAT" or "Auto Farm NPC: TAT"
    FarmBtn.BackgroundColor3 = Farming and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 50, 50)
end)

-- VÒNG LẶP KIỂM TRA MỤC TIÊU
task.spawn(function()
    while true do
        task.wait(0.1)
        if Farming then
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if not Farming then break end
                    -- ĐIỀU KIỆN QUAN TRỌNG: Phải là Model, có Humanoid, Máu > 0 và KHÔNG PHẢI Player
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if not game.Players:GetPlayerFromCharacter(v) then -- Kiểm tra xem Model có phải là Player không
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            local vim = game:GetService("VirtualInputManager")
                            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        end
                    end
                end
            end)
        end
    end
end)
