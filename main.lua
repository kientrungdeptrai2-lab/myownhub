-- MONSTER HUB V2 - GIAO DIEN TAB
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

-- KHUNG CHINH
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- THANH DANH MUC BEN TRAI (SIDEBAR)
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 150, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SideBar.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = SideBar
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- KHUNG NOI DUNG BEN PHAI
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0, 400, 1, 0)
ContentFrame.Position = UDim2.new(0, 150, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.Parent = MainFrame

-- HAM TAO TAB
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 40)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
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

-- TAO CAC TAB NHU TRONG ANH
local FarmPage = CreateTab("Auto Farm")
local EspPage = CreateTab("Esp")
local PlayerPage = CreateTab("Player")
local MiscPage = CreateTab("Misc")

-- VI DU THEM NUT TOGGLE VAO TAB AUTO FARM
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
ToggleBtn.Text = "Auto Farm: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.Parent = FarmPage
