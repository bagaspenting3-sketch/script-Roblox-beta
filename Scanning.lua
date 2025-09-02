-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Variables toggle
local autoCollectEnabled = false
local espEnabled = false
local antiRespawnEnabled = false
local autoChatEnabled = false
local chatMessage = "Raja GT Here!"
local chatDelay = 1

-- ESP Table
local espTable = {}
local lastCFrame = nil

-- Remote Chat
local ChatRemote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ChatRemote")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RajaGT_Executor"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 360)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Raja GT Executor (Beta)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Function to create toggle buttons
local function createToggle(name, yPos, callback, default)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0, 30)
    button.Position = UDim2.new(0.1, 0, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    local toggled = default or false
    button.Text = name .. (toggled and ": ON" or ": OFF")
    button.Parent = MainFrame

    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        button.Text = name .. (toggled and ": ON" or ": OFF")
        callback(toggled)
    end)
end

-- Create toggles
createToggle("Auto Collect", 50, function(val) autoCollectEnabled = val end, false)
createToggle("ESP + Arrow/Name", 90, function(val) espEnabled = val end, false)
createToggle("Anti Respawn (Must Jump)", 130, function(val) antiRespawnEnabled = val end, false)
createToggle("Auto Spam Chat", 170, function(val) autoChatEnabled = val end, false)

-- Chat Input
local ChatInput = Instance.new("TextBox")
ChatInput.Size = UDim2.new(0.8, 0, 0, 25)
ChatInput.Position = UDim2.new(0.1, 0, 0, 210)
ChatInput.PlaceholderText = "Chat Message"
ChatInput.Text = chatMessage
ChatInput.TextColor3 = Color3.fromRGB(255,255,255)
ChatInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
ChatInput.Font = Enum.Font.SourceSans
ChatInput.TextSize = 14
ChatInput.Parent = MainFrame
ChatInput.FocusLost:Connect(function()
    chatMessage = ChatInput.Text
end)

-- Chat Delay
local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(0.8, 0, 0, 20)
SliderLabel.Position = UDim2.new(0.1, 0, 0, 240)
SliderLabel.BackgroundTransparency = 1
SliderLabel.TextColor3 = Color3.fromRGB(255,255,255)
SliderLabel.Font = Enum.Font.SourceSans
SliderLabel.TextSize = 14
SliderLabel.Text = "Chat Delay: "..chatDelay.."s"
SliderLabel.Parent = MainFrame

local ChatSlider = Instance.new("TextBox")
ChatSlider.Size = UDim2.new(0.8, 0, 0, 25)
ChatSlider.Position = UDim2.new(0.1, 0, 0, 265)
ChatSlider.PlaceholderText = "1 - 30 (seconds)"
ChatSlider.Text = tostring(chatDelay)
ChatSlider.TextColor3 = Color3.fromRGB(255,255,255)
ChatSlider.BackgroundColor3 = Color3.fromRGB(50,50,50)
ChatSlider.Font = Enum.Font.SourceSans
ChatSlider.TextSize = 14
ChatSlider.Parent = MainFrame
ChatSlider.FocusLost:Connect(function()
    local val = tonumber(ChatSlider.Text)
    if val and val >= 1 and val <= 30 then
        chatDelay = val
        SliderLabel.Text = "Chat Delay: "..chatDelay.."s"
    else
        ChatSlider.Text = tostring(chatDelay)
    end
end)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Parent = MainFrame
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
MinimizeButton.Text = "_"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 18
MinimizeButton.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeButton.Parent = MainFrame
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in pairs(MainFrame:GetChildren()) do
        if child:IsA("TextButton") and child ~= CloseButton and child ~= MinimizeButton then
            child.Visible = not minimized
        end
    end
    for _, child in pairs(MainFrame:GetChildren()) do
        if child:IsA("TextBox") or child:IsA("TextLabel") then
            child.Visible = not minimized
        end
    end
end)

-- Auto Collect Function
RunService.RenderStepped:Connect(function()
    if autoCollectEnabled then
        local droppedBlocks = Workspace:FindFirstChild("FloatingObjects") and Workspace.FloatingObjects:FindFirstChild("DroppedBlock")
        local Character = Player.Character
        if droppedBlocks and Character then
            local RootPart = Character:FindFirstChild("HumanoidRootPart")
            if RootPart then
                for _, item in pairs(droppedBlocks:GetChildren()) do
                    if item:IsA("BasePart") then
                        RootPart.CFrame = CFrame.new(item.Position)
                        if ReplicatedStorage.Events:FindFirstChild("CollectItem") then
                            ReplicatedStorage.Events.CollectItem:FireServer(item)
                        end
                    end
                end
            end
        end
    end
end)

-- ESP Functions
local function createESP(plr)
    if espTable[plr] then return end
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = root
    billboard.Size = UDim2.new(0, 50, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = ScreenGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,1,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255,0,0)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.Text = plr.Name
    nameLabel.Parent = billboard

    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = root
    box.Size = Vector3.new(2,5,1)
    box.Color3 = Color3.fromRGB(255,0,0)
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = root

    espTable[plr] = {billboard = billboard, box = box}
end

local function removeESP(plr)
    if espTable[plr] then
        if espTable[plr].billboard then espTable[plr].billboard:Destroy() end
        if espTable[plr].box then espTable[plr].box:Destroy() end
        espTable[plr] = nil
    end
end

-- Update ESP
RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            createESP(plr)
            if espTable[plr].billboard then espTable[plr].billboard.Enabled = espEnabled end
            if espTable[plr].box then espTable[plr].box.Visible = espEnabled end
        else
            removeESP(plr)
        end
    end
end)

Players.PlayerRemoving:Connect(removeESP)

-- Anti Respawn
local function trackCharacter(char)
    local humanoid = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")

    RunService.Heartbeat:Connect(function()
        if root and humanoid and humanoid.Health > 0 then
            lastCFrame = root.CFrame
        end
    end)
end

Player.CharacterAdded:Connect(function(char)
    trackCharacter(char)
    local root = char:WaitForChild("HumanoidRootPart")
    if antiRespawnEnabled and lastCFrame then
        local start = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if tick()-start < 3 and root then
                root.CFrame = lastCFrame
            else
                if conn then conn:Disconnect() end
            end
        end)
    end
end)

if Player.Character then
    trackCharacter(Player.Character)
end

-- Auto Spam Chat
spawn(function()
    while true do
        if autoChatEnabled then
            pcall(function()
                ChatRemote:FireServer(chatMessage)
            end)
        end
        task.wait(chatDelay)
    end
end)

-- =========================
-- GrowScan Section
-- =========================

-- GrowScan Button
local GrowScanBtn = Instance.new("TextButton")
GrowScanBtn.Size = UDim2.new(0.8, 0, 0, 30)
GrowScanBtn.Position = UDim2.new(0.1, 0, 0, 300)
GrowScanBtn.Text = "🌱 GrowScan"
GrowScanBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
GrowScanBtn.TextColor3 = Color3.fromRGB(255,255,255)
GrowScanBtn.Font = Enum.Font.SourceSansBold
GrowScanBtn.TextSize = 14
GrowScanBtn.Parent = MainFrame

GrowScanBtn.MouseButton1Click:Connect(function()
    -- Load GrowScan GUI dari GitHub
    loadstring(game:HttpGet("https://raw.githubusercontent.com/bagaspenting3-sketch/script-Roblox-beta/refs/heads/main/RajaGT_GrowScan.lua"))()
end)        local conn
        conn = RunService.Heartbeat:Connect(function()
            if tick() - start < 3 and root then
                root.CFrame = lastCFrame
            else
                if conn then conn:Disconnect() end
            end
        end)
    end
end)

if Player.Character then
    trackCharacter(Player.Character)
end

-- Auto Spam Chat Function
spawn(function()
    while true do
        if autoChatEnabled then
            pcall(function()
                ChatRemote:FireServer(chatMessage)
            end)
        end
        task.wait(chatDelay)
    end
end)
