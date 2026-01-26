-- MONSTER HUB AUTO FARM V2
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

-- VÒNG LẶP FARM TỐI ƯU CHO GPO
task.spawn(function()
    while true do
        task.wait(0.1)
        if Farming then
            pcall(function()
                -- Quét cả workspace và các folder quái
                for _, v in pairs(workspace:GetDescendants()) do 
                    if not Farming then break end
                    
                    -- Kiểm tra: Phải có Humanoid, còn máu, và KHÔNG PHẢI Player
                    if v:IsA("Humanoid") and v.Parent:IsA("Model") and v.Health > 0 then
                        local npc = v.Parent
                        if not game.Players:GetPlayerFromCharacter(npc) and npc:FindFirstChild("HumanoidRootPart") then
                            -- Dịch chuyển ra phía sau NPC 3 studs để tránh bị đánh
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            
                            -- Tự động đánh liên tục
                            local vim = game:GetService("VirtualInputManager")
                            vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                            
                            -- Đợi quái chết hoặc Farming bị tắt
                            repeat task.wait() until v.Health <= 0 or not Farming
                        end
                    end
                end
            end)
        end
    end
end)
