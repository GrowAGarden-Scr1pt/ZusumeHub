-- Place this LocalScript in StarterPlayerScripts or StarterGui
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakeAgeChanger"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 128, 128)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Text = "⏳ Set Equipped Pet Age to 50"
title.Font = Enum.Font.FredokaOne
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Parent = frame

local petInfo = Instance.new("TextLabel")
petInfo.Text = "Equipped Pet: [None]"
petInfo.Font = Enum.Font.Gotham
petInfo.TextSize = 16
petInfo.TextColor3 = Color3.fromRGB(255, 255, 150)
petInfo.BackgroundTransparency = 1
petInfo.Position = UDim2.new(0, 0, 0, 30)
petInfo.Size = UDim2.new(1, 0, 0, 25)
petInfo.TextScaled = true
petInfo.TextWrapped = true
petInfo.Parent = frame

-- Sounds
local function createSound(id, parent)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. id
	sound.Volume = 1
	sound.PlayOnRemove = false
	sound.Parent = parent
	return sound
end

local tickSound = createSound(9118823107, frame)      -- Beep tick
local successSound = createSound(12222242, frame)     -- Level up / coin sound
local errorSound = createSound(138199151, frame)      -- Error buzz

-- Styled button
local function createStyledButton(text, yPos, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, yPos)
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.Font = Enum.Font.FredokaOne
	btn.TextSize = 16
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.AutoButtonColor = false

	local uic = Instance.new("UICorner")
	uic.CornerRadius = UDim.new(0, 6)
	uic.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.2
	stroke.Parent = btn

	btn.Parent = frame
	return btn
end

-- Button
local button = createStyledButton("Set Age to 50", 60, Color3.fromRGB(0, 170, 255))

-- Tool detection
local function getEquippedPetTool()
	character = player.Character or player.CharacterAdded:Wait()
	for _, child in pairs(character:GetChildren()) do
		if child:IsA("Tool") and child.Name:match("%[Age%s%d+%]") then
			return child
		end
	end
	return nil
end

-- GUI update
local function updateGUI()
	local tool = getEquippedPetTool()
	if tool then
		petInfo.Text = "Equipped Pet: " .. tool.Name
	else
		petInfo.Text = "Equipped Pet: [None]"
	end
end

-- Debounce
local isBusy = false
button.MouseButton1Click:Connect(function()
	if isBusy then return end
	isBusy = true

	local tool = getEquippedPetTool()
	if tool then
		for i = 20, 1, -1 do
			button.Text = "Changing Age in " .. i .. "..."
			tickSound:Play()
			wait(1)
		end

		local newName = tool.Name:gsub("%[Age%s%d+%]", "[Age 50]")
		tool.Name = newName
		petInfo.Text = "Equipped Pet: " .. tool.Name
		successSound:Play()
	else
		button.Text = "No Pet Equipped!"
		errorSound:Play()
		wait(2)
	end

	button.Text = "Set Age to 50"
	isBusy = false
end)

-- Constant GUI update
task.spawn(function()
	while true do
		updateGUI()
		task.wait(1)
	end
end)
