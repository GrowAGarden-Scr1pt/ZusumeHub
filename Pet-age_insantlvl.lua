-- LocalScript (put in StarterPlayerScripts or StarterGui)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FakeAgeChanger"
screenGui.ResetOnSpawn = false

-- GUI setup
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 120) -- Compact size
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 128, 128) -- Teal
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Text = "ðŸ•’ Set Equipped Pet Age to 50"
title.Font = Enum.Font.FredokaOne -- Match Pet Mutation Finder
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 30)

title.Position = UDim2.new(0, 0, 0, 0)

local petInfo = Instance.new("TextLabel", frame)
petInfo.Text = "Equipped Pet: [None]"
petInfo.Font = Enum.Font.Gotham
petInfo.TextSize = 16
petInfo.TextColor3 = Color3.fromRGB(255, 255, 150)
petInfo.BackgroundTransparency = 1
petInfo.Position = UDim2.new(0, 0, 0, 30)
petInfo.Size = UDim2.new(1, 0, 0, 25)
petInfo.TextScaled = true
petInfo.TextWrapped = true

local function createStyledButton(text, yPos, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(40, 43, 74) -- Dark purple
	btn.Text = text
	btn.Font = Enum.Font.FredokaOne
	btn.TextSize = 16
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.AutoButtonColor = false

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.2

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = color:lerp(Color3.new(1,1,1), 0.2)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = color
	end)

	btn.Parent = frame
	return btn
end

local button = createStyledButton("Set Age to 50", 60, Color3.fromRGB(0, 170, 255))

-- Function to find the equipped pet Tool
local function getEquippedPetTool()
	character = player.Character or player.CharacterAdded:Wait()
	for _, child in pairs(character:GetChildren()) do
		if child:IsA("Tool") and child.Name:find("Age") then
			return child
		end
	end
	return nil
end

-- Update the GUI with the currently equipped pet
local function updateGUI()
	local pet = getEquippedPetTool()
	if pet then
		petInfo.Text = "Equipped Pet: " .. pet.Name
	else
		petInfo.Text = "Equipped Pet: [None]"
	end
end

-- Click to visually update the name after a 20-second countdown
button.MouseButton1Click:Connect(function()
	local tool = getEquippedPetTool()
	if tool then
		-- Countdown before changing age
		for i = 20, 1, -1 do
			button.Text = "Changing Age in " .. i .. "..."
			wait(1)
		end

		-- Change name visually
		local newName = tool.Name:gsub("%[Age%s%d+%]", "[Age 50]")
		tool.Name = newName
		petInfo.Text = "Equipped Pet: " .. tool.Name
		button.Text = "Set Age to 50"
	else
		button.Text = "No Pet Equipped!"
		wait(2)
		button.Text = "Set Age to 50"
	end
end)

-- Periodically update GUI
while true do
	task.wait(1)
	updateGUI()
end.
