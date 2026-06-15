-- Create the Main GUI Container
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local ScriptButton = Instance.new("TextButton")

-- Configure properties
ScreenGui.Name = "CustomExecGui"
ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Size = UDim2.new(0, 350, 0, 200)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
MainFrame.Active = true
MainFrame.Draggable = true -- Allows moving the UI around

TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Text = "Script Controller"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinimizeButton.Position = UDim2.new(1, -60, 0, 5)
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18

CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.Size = UDim2.new(1, -20, 1, -50)

ScriptButton.Name = "ScriptButton"
ScriptButton.Parent = ContentFrame
ScriptButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ScriptButton.Size = UDim2.new(0.8, 0, 0, 40)
ScriptButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ScriptButton.Text = "Load Script"
ScriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptButton.Font = Enum.Font.SourceSans
ScriptButton.TextSize = 18

-- Functionality Setup
local isMinimized = false
local originalSize = MainFrame.Size

-- Toggle Minimize / Maximize 
MinimizeButton.MouseButton1Click:Connect(function()
	if not isMinimized then
		ContentFrame.Visible = false
		MainFrame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 30)
		MinimizeButton.Text = "+"
		isMinimized = true
	else
		MainFrame.Size = originalSize
		ContentFrame.Visible = true
		MinimizeButton.Text = "-"
		isMinimized = false
	end
end)

-- Close Button (Destroys the interface completely)
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Script Loader Trigger
ScriptButton.MouseButton1Click:Connect(function()
	ScriptButton.Text = "Loading..."
	ScriptButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	
	-- Runs your provided HTTP payload safely
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end)
	
	ScriptButton.Text = "Loaded!"
	ScriptButton.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
end)
