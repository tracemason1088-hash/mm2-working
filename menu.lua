local Window = Rayfield:CreateWindow({
    Name = "MM2 Hacks",
    LoadingTitle = "MM2 Hacks",
    LoadingSubtitle = "by  MustyMenu",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Variables
local ESPEnabled = false
local ESPObjects = {}
local TracerObjects = {}

-- Misc Variables
local NoclipEnabled = false
local InfiniteJumpEnabled = false

local function GetRole(plr)
    local char = plr.Character
    if not char then return "Innocent" end
    if char:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife") then
        return "Murderer"
    elseif char:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

local function CreateESP(plr)
    if plr == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = plr.Character
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = plr.Character
    ESPObjects[plr] = highlight
    
    local tracer = Drawing.new("Line")
    tracer.Thickness = 2
    tracer.Transparency = 1
    tracer.Color = Color3.fromRGB(0, 255, 0) -- Green tracers
    TracerObjects[plr] = tracer
    
    local function UpdateColor()
        local role = GetRole(plr)
        if role == "Murderer" then
            highlight.FillColor = Color3.fromRGB(255, 0, 0)      -- Red
        elseif role == "Sheriff" then
            highlight.FillColor = Color3.fromRGB(0, 100, 255)   -- Blue
        else
            highlight.FillColor = Color3.fromRGB(0, 255, 0)     -- Green
        end
    end
    UpdateColor()
    
    plr.CharacterAdded:Connect(function() task.wait(0.5); CreateESP(plr) end)
    RunService.Heartbeat:Connect(UpdateColor)
end

local function UpdateTracers()
    for plr, tracer in pairs(TracerObjects) do
        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and myRoot then
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
            local myPos = workspace.CurrentCamera:WorldToViewportPoint(myRoot.Position)
            if onScreen then
                tracer.From = Vector2.new(myPos.X, myPos.Y)
                tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                tracer.Visible = true
            else
                tracer.Visible = false
            end
        else
            tracer.Visible = false
        end
    end
end
RunService.RenderStepped:Connect(UpdateTracers)

local function ToggleESP(state)
    ESPEnabled = state
    if state then
        for _, plr in Players:GetPlayers() do CreateESP(plr) end
        Players.PlayerAdded:Connect(CreateESP)
    else
        for _, h in pairs(ESPObjects) do h:Destroy() end
        for _, t in pairs(TracerObjects) do t:Remove() end
        ESPObjects = {}
        TracerObjects = {}
    end
end

local function AutoFarm(state)
    if not state then return end
    task.spawn(function()
        while state do
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, obj in Workspace:GetChildren() do
                    if obj.Name:find("Coin") or obj.Name == "GunDrop" then
                        if (obj.Position - root.Position).Magnitude < 200 then
                            root.CFrame = CFrame.new(obj.Position + Vector3.new(0,4,0))
                            task.wait(0.2)
                        end
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

local function KillAura(state)
    if not state then return end
    task.spawn(function()
        while state do
            local char = LocalPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if tool and (tool.Name == "Knife" or tool.Name == "Gun") then
                for _, plr in Players:GetPlayers() do
                    if plr ~= LocalPlayer and plr.Character then
                        local target = plr.Character:FindFirstChild("HumanoidRootPart")
                        local myRoot = char:FindFirstChild("HumanoidRootPart")
                        if target and myRoot and (target.Position - myRoot.Position).Magnitude < 25 then
                            tool:Activate()
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

-- Misc Loops
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local MainSection = MainTab:CreateSection("Core Features")

MainTab:CreateToggle({
    Name = "Role ESP + Tracers",
    CurrentValue = false,
    Callback = ToggleESP
})

MainTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Callback = AutoFarm
})

MainTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = KillAura
})

local PlayerTab = Window:CreateTab("Player", 4483362458)
PlayerTab:CreateSection("Movement")
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
})

-- Troll Tab
local TrollTab = Window:CreateTab("Trolling", 4483362458)
TrollTab:CreateSection("Troll Options")
TrollTab:CreateButton({
    Name = "Chat Spam",
    Callback = function()
        for i = 1, 8 do
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("trolled 😈", "All")
            task.wait(0.6)
        end
    end
})

TrollTab:CreateButton({
    Name = "Fling Nearest",
    Callback = function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, plr in Players:GetPlayers() do
                if plr ~= LocalPlayer and plr.Character then
                    local t = plr.Character:FindFirstChild("HumanoidRootPart")
                    if t and (t.Position - root.Position).Magnitude < 40 then
                        t.Velocity = root.CFrame.LookVector * 200 + Vector3.new(0, 100, 0)
                    end
                end
            end
        end
    end
})

-- Miscellaneous Tab
local MiscTab = Window:CreateTab("Miscellaneous", 4483362458)
MiscTab:CreateSection("Utility & Fun")

MiscTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(state)
        NoclipEnabled = state
    end
})

MiscTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
    end
})

MiscTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://githubusercontent.com'))()
    end
})

-- Settings
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateButton({
    Name = "Close Menu",
    Callback = function() Rayfield:Destroy() end
})

Rayfield:Notify({
    Title = "MM2 Hacks",
    Content = "ESP colors updated: Murderer=Red, Sheriff=Blue, Innocent=Green. Minimize & Close are on the top bar.",
    Duration = 8
})
