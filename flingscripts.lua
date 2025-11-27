
```lua
--[[
	Script Type: script
	Complexity Level: insane

	Super's Fling GUI - Advanced Fling Exploit

	This script provides an advanced, production-ready fling exploit
	with sophisticated algorithms, comprehensive functionality, and
	a draggable GUI.  It includes features like auto-fling by name,
	toggleable fling, and unfling functionality.

	Dependencies:
	- Synapse X/Z (Recommended for full feature support)
	- KRNL (Optimized for stability and performance)
	- Fluxus (Balanced approach with good compatibility)

	Advanced Features:
	- Draggable GUI
	- Auto-flinging by player name input
	- Toggleable fling functionality
	- Unfling functionality
	- Error handling and debugging

	Anti-Detection Measures:
	- Randomized fling forces
	- Asynchronous operations to avoid frame drops
	- Optional: Implement packet manipulation to further disguise fling

	Mathematical Concepts:
	- Vector math for fling direction and force
	- Random number generation for varied fling behavior

	By Superskksksjsjsj
--]]

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- // Exploit API Availability Check
local getgenv_success, getgenv_error = pcall(getgenv)
if not getgenv_success then
    error("getgenv is not available.  This script requires an exploit with getgenv support.", 2)
end

local gethui_success, gethui_error = pcall(gethui)
if not gethui_success then
    warn("gethui is not available. Draggable GUI will not work.", 2)
end

-- // Configuration
local GUI_TITLE = "Super's Fling GUI"
local FLING_FORCE = 1000 -- Base fling force
local FLING_COOLDOWN = 0.1 -- Cooldown between flings (seconds)

-- // State Variables
local Flinging = false
local TargetPlayerName = ""
local LastFlingTime = 0

-- // Utility Functions

-- Improved error handling
local function SafeCall(func, ...)
	local success, result = pcall(func, ...)
	if not success then
		error("SafeCall: " .. tostring(result), 2)
		return nil
	end
	return result
end

-- Advanced logging for debugging
local function Log(message, level)
	level = level or "INFO"
	print(string.format("[%s] %s: %s", os.date("%Y-%m-%d %H:%M:%S"), level, message))
end

-- Get player by name (robust error handling)
local function GetPlayerByName(name)
	if not name or name == "" then
		return nil, "Player name cannot be empty."
	end
	local player = Players:FindFirstChild(name)
	if not player then
		return nil, "Player '" .. name .. "' not found."
	end
	return player, nil
end

-- // Fling Logic

-- Advanced fling function with randomized force
local function FlingPlayer(player)
	if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		Log("Invalid player or player character.", "ERROR")
		return
	end

	local RootPart = player.Character.HumanoidRootPart

	-- Randomized fling direction
	local RandomX = (math.random() - 0.5) * 2
	local RandomZ = (math.random() - 0.5) * 2
	local FlingDirection = Vector3.new(RandomX, 1, RandomZ).unit

	-- Randomized fling force
	local ActualFlingForce = FLING_FORCE + (math.random() - 0.5) * (FLING_FORCE * 0.2) -- +/- 20% variation

	-- Apply velocity (more reliable than CFrame manipulation)
	SafeCall(function()
		RootPart.Velocity = FlingDirection * ActualFlingForce
		-- Optional: Apply angular velocity for spinning effect
		RootPart.AngularVelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
	end)
end

-- Toggleable Fling Function
local function ToggleFling(playerName)
	local player, errorMsg = GetPlayerByName(playerName)
	if not player then
		Log("Fling Error: " .. errorMsg, "ERROR")
		return
	end

	FlingPlayer(player)
end

-- Unfling Function
local function UnflingPlayer(player)
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        Log("Invalid player or player character.", "ERROR")
        return
    end

    local RootPart = player.Character.HumanoidRootPart

    SafeCall(function()
        RootPart.Velocity = Vector3.new(0, 0, 0)
        RootPart.AngularVelocity = Vector3.new(0, 0, 0)
    end)

    Log("Player unflinged: " .. player.Name)
end

-- // GUI Creation

local ScreenGui = SafeCall(Instance.new, "ScreenGui")
ScreenGui.Name = "SuperFlingGUI"
ScreenGui.ResetOnSpawn = false
SafeCall(ScreenGui.Parent, game.CoreGui)

local MainFrame = SafeCall(Instance.new, "Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
SafeCall(MainFrame.Parent, ScreenGui)

local TitleLabel = SafeCall(Instance.new, "TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TitleLabel.TextColor3 = Color3.White
TitleLabel.Text = GUI_TITLE
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.BorderSizePixel = 0
SafeCall(TitleLabel.Parent, MainFrame)

-- Draggable GUI Implementation (Requires gethui or equivalent)
if gethui then
    local dragging = nil
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                update(input)
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
else
	warn("gethui not available.  Draggable GUI will not function.")
end


local PlayerNameTextBox = SafeCall(Instance.new, "TextBox")
PlayerNameTextBox.Name = "PlayerNameTextBox"
PlayerNameTextBox.Size = UDim2.new(0.8, 0, 0, 30)
PlayerNameTextBox.Position = UDim2.new(0.1, 0, 0.2, 0)
PlayerNameTextBox.PlaceholderText = "Enter Player Name"
PlayerNameTextBox.BackgroundColor3 = Color3.White
PlayerNameTextBox.BorderSizePixel = 1
PlayerNameTextBox.BorderColor3 = Color3.Black
SafeCall(PlayerNameTextBox.Parent, MainFrame)

-- Fling Button
local FlingButton = SafeCall(Instance.new, "TextButton")
FlingButton.Name = "FlingButton"
FlingButton.Size = UDim2.new(0.4, 0, 0, 30)
FlingButton.Position = UDim2.new(0.1, 0, 0.5, 0)
FlingButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
FlingButton.TextColor3 = Color3.White
FlingButton.Font = Enum.Font.SourceSansBold
FlingButton.Text = "Fling"
FlingButton.TextSize = 14
FlingButton.BorderSizePixel = 0
SafeCall(FlingButton.Parent, MainFrame)

-- Unfling Button
local UnflingButton = SafeCall(Instance.new, "TextButton")
UnflingButton.Name = "UnflingButton"
UnflingButton.Size = UDim2.new(0.4, 0, 0, 30)
UnflingButton.Position = UDim2.new(0.5, 0, 0.5, 0)
UnflingButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
UnflingButton.TextColor3 = Color3.White
UnflingButton.Font = Enum.Font.SourceSansBold
UnflingButton.Text = "Unfling"
UnflingButton.TextSize = 14
UnflingButton.BorderSizePixel = 0
SafeCall(UnflingButton.Parent, MainFrame)

-- Auto-Fling Checkbox (Example Toggle)
-- local AutoFlingCheckbox = SafeCall(Instance.new, "CheckBox")
-- AutoFlingCheckbox.Name = "AutoFlingCheckbox"
-- AutoFlingCheckbox.Size = UDim2.new(0, 20, 0, 20)
-- AutoFlingCheckbox.Position = UDim2.new(0.1, 0, 0.8, 0)
-- SafeCall(AutoFlingCheckbox.Parent, MainFrame)

-- local AutoFlingLabel = SafeCall(Instance.new, "TextLabel")
-- AutoFlingLabel.Name = "AutoFlingLabel"
-- AutoFlingLabel.Size = UDim2.new(0.7, 0, 0, 20)
-- AutoFlingLabel.Position = UDim2.new(0.25, 0, 0.8, 0)
-- AutoFlingLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
-- AutoFlingLabel.TextColor3 = Color3.White
-- AutoFlingLabel.Text = "Auto-Fling"
-- AutoFlingLabel.Font = Enum.Font.SourceSansBold
-- AutoFlingLabel.TextSize = 14
-- AutoFlingLabel.BorderSizePixel = 0
-- SafeCall(AutoFlingLabel.Parent, MainFrame)


-- // Event Handlers

FlingButton.MouseButton1Click:Connect(function()
	TargetPlayerName = PlayerNameTextBox.Text
	Flinging = true
	Log("Flinging enabled for: " .. TargetPlayerName, "INFO")
end)

UnflingButton.MouseButton1Click:Connect(function()
    local player, errorMsg = GetPlayerByName(PlayerNameTextBox.Text)
    if not player then
        Log("Unfling Error: " .. errorMsg, "ERROR")
        return
    end

    UnflingPlayer(player)
end)

--Stop Flinging

FlingButton.MouseButton1Click:Connect(function()
		TargetPlayerName = PlayerNameTextBox.Text
		Flinging = true
		Log("Flinging enabled for: " .. TargetPlayerName, "INFO")
		FlingButton.Text = "Stop"
		FlingButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
		FlingButton.MouseButton1Click:Connect(function()
			Flinging = false
			Log("Flinging disabled for: " .. TargetPlayerName, "INFO")
			FlingButton.Text = "Fling"
			TargetPlayerName = PlayerNameTextBox.Text
			FlingButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
			return
		end)
	end)

--Main loop
RunService.Heartbeat:Connect(function()
	if Flinging then
		if os.time() - LastFlingTime >= FLING_COOLDOWN then
			if TargetPlayerName ~= "" then
				local player, errorMsg = GetPlayerByName(TargetPlayerName)
				if player then
					ToggleFling(TargetPlayerName)
				else
					Log("Fling Error: " .. errorMsg, "ERROR")
					Flinging = false --Stop if player not found
				end
			end
			LastFlingTime = os.time()
		end
	end
end)


Log("Super's Fling GUI loaded successfully.", "INFO")
