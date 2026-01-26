-- MONSTER HUB V2 - FULL TOGGLE & DRAGGABLE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonsterHubV2"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- KHUNG CHÍNH CÓ THỂ KÉO (DRAGGABLE)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Kich hoat tinh nang keo re
MainFrame.Parent = ScreenGui

-- SIDEBAR DANH MỤC
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 150, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SideBar.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = SideBar
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- KHUNG NỘI DUNG CHỨA CÁC NÚT CHỨC NĂNG
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -150, 1, 0)
ContentFrame.Position = UDim2.new(0, 150, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.Parent = MainFrame

-- HÀM TẠO NÚT GẠT (TOGGLE) GIỐNG KAIZENSCRIPT
local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 50, 0, 25)
    Button.Position = UDim2.new(1, -55, 0.5, -12)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.Text = ""
    Button.Parent = ToggleFrame

    local Status = false
    Button.MouseButton1Click:Connect(function()
        Status = not Status
        Button.BackgroundColor3 = Status and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
        callback(Status)
    end)
end

-- TẠO CÁC TAB
local function AddTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 45)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Parent = SideBar

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -20, 1, -20)
    Page.Position = UDim2.new(0, 10, 0, 10)
    Page.Visible = false
    Page.BackgroundTransparency = 1
    Page.Parent = ContentFrame

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(ContentFrame:GetChildren()) do p.Visible = false end
        Page.Visible = true
    end)
    return Page
end

-- THIẾT LẬP CÁC CHỨC NĂNG CỤ THỂ
local FarmPage = AddTab("Auto Farm")
local PlayerPage = AddTab("Player")

-- THÊM NÚT GẠT VÀO TAB PLAYER
CreateToggle(PlayerPage, "Tang Toc (Speed 100)", function(state)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = state and 100 or 16
end)

-- THÊM NÚT GẠT VÀO TAB AUTO FARM
CreateToggle(FarmPage, "Auto Click", function(state)
    _G.AutoClick = state
    while _G.AutoClick do
        local vim = game:GetService("VirtualInputManager")
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        task.wait(0.1)
    end
end)
