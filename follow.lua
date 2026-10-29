-- FollowPlayerGui.lua
-- Place this as a LocalScript inside StarterPlayer > StarterPlayerScripts
-- Creates a draggable GUI listing all players; click a name to follow them.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

-- ===== GUI SETUP =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FollowPlayerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title bar (acts as the drag handle)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Follow Player"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0, 28, 0, 24)
stopButton.Position = UDim2.new(1, -32, 0, 4)
stopButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
stopButton.Text = "X"
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.Font = Enum.Font.GothamBold
stopButton.TextSize = 14
stopButton.AutoButtonColor = false
stopButton.Parent = titleBar

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -16, 0, 20)
statusLabel.Position = UDim2.new(0, 8, 0, 36)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Not following anyone"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Scrolling list of player buttons
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, -16, 1, -68)
listFrame.Position = UDim2.new(0, 8, 0, 60)
listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 4
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.Parent = mainFrame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 6)
listCorner.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = listFrame

-- ===== DRAG LOGIC (mouse + touch) =====
local dragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

-- ===== FOLLOW LOGIC =====
local targetPlayer = nil
local followConnection = nil
local FOLLOW_DISTANCE = 1 -- studs to keep between you and the target (nhỏ hơn = đứng sát hơn)

local playerButtons = {}

local function highlightSelected()
	for player, button in pairs(playerButtons) do
		button.BackgroundColor3 = (player == targetPlayer)
			and Color3.fromRGB(70, 120, 200)
			or Color3.fromRGB(40, 40, 48)
	end
end

local function stopFollowing()
	targetPlayer = nil
	statusLabel.Text = "Not following anyone"
	if followConnection then
		followConnection:Disconnect()
		followConnection = nil
	end
	highlightSelected()
end

local function startFollowing(player)
	targetPlayer = player
	statusLabel.Text = "Following: " .. player.Name

	if followConnection then
		followConnection:Disconnect()
	end

	followConnection = RunService.Heartbeat:Connect(function()
		if not targetPlayer or not targetPlayer.Parent then
			stopFollowing()
			return
		end

		local myChar = localPlayer.Character
		local theirChar = targetPlayer.Character
		if not myChar or not theirChar then return end

		local myHrp = myChar:FindFirstChild("HumanoidRootPart")
		local theirHrp = theirChar:FindFirstChild("HumanoidRootPart")
		if not (myHrp and theirHrp) then return end

		-- Tính vị trí ngay phía sau lưng người được theo dõi (dựa theo hướng họ đang nhìn)
		local theirCFrame = theirHrp.CFrame
		local behindPosition = theirCFrame.Position - (theirCFrame.LookVector * FOLLOW_DISTANCE)

		-- Dịch chuyển (teleport) tới đó mỗi frame, quay mặt cùng hướng với họ
		myHrp.CFrame = CFrame.new(behindPosition, theirCFrame.Position)
	end)
end

stopButton.MouseButton1Click:Connect(stopFollowing)

-- ===== PLAYER LIST POPULATION =====
local function updateCanvasSize()
	listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end

local function addPlayerButton(player)
	if player == localPlayer then return end -- you can't follow yourself

	local button = Instance.new("TextButton")
	button.Name = player.Name
	button.Size = UDim2.new(1, -8, 0, 32)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
	button.Text = player.DisplayName .. " (@" .. player.Name .. ")"
	button.TextColor3 = Color3.fromRGB(230, 230, 230)
	button.Font = Enum.Font.Gotham
	button.TextSize = 13
	button.AutoButtonColor = false
	button.Parent = listFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = button

	button.MouseButton1Click:Connect(function()
		if targetPlayer == player then
			stopFollowing()
		else
			startFollowing(player)
		end
		highlightSelected()
	end)

	playerButtons[player] = button
	updateCanvasSize()
end

local function removePlayerButton(player)
	local button = playerButtons[player]
	if button then
		button:Destroy()
		playerButtons[player] = nil
	end
	if targetPlayer == player then
		stopFollowing()
	end
	updateCanvasSize()
end

for _, player in ipairs(Players:GetPlayers()) do
	addPlayerButton(player)
end

Players.PlayerAdded:Connect(addPlayerButton)
Players.PlayerRemoving:Connect(removePlayerButton)
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)