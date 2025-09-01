--[[ 
    Simple Test Script with GUI
    Features:
    ✅ FPS Counter
    ✅ Infinite Jump (toggle)
    ✅ Minimize / Restore Button
    ✅ Kill GUI Button
]]

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer

-- Vars
local infJump = false
local FPS = 60
local FrameCounter, FrameTimer = 0, tick()
local minimized = false
local connections = {}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TestGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0.5, -125, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BorderSizePixel = 0
Title.Text = "⚡ Test Script GUI"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 40, 0, 30)
MinBtn.Position = UDim2.new(1, -80, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Parent = Frame

-- Kill Button
local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0, 40, 0, 30)
KillBtn.Position = UDim2.new(1, -40, 0, 0)
KillBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
KillBtn.BorderSizePixel = 0
KillBtn.Text = "X"
KillBtn.Font = Enum.Font.GothamBold
KillBtn.TextSize = 20
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.Parent = Frame

-- FPS Label
local FpsLabel = Instance.new("TextLabel")
FpsLabel.Size = UDim2.new(1, 0, 0, 30)
FpsLabel.Position = UDim2.new(0, 0, 0, 35)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: 0 | Ping: 0 ms"
FpsLabel.Font = Enum.Font.Gotham
FpsLabel.TextSize = 14
FpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
FpsLabel.Parent = Frame

-- Toggle Button (Infinite Jump)
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, -20, 0, 30)
Button.Position = UDim2.new(0, 10, 0, 75)
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Button.BorderSizePixel = 0
Button.Text = "Infinite Jump: OFF"
Button.Font = Enum.Font.GothamBold
Button.TextSize = 14
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Parent = Frame

-- Minimize Logic
local function toggleMinimize()
    minimized = not minimized
    if minimized then
        Frame.Size = UDim2.new(0, 250, 0, 30)
        MinBtn.Text = "+"
        FpsLabel.Visible = false
        Button.Visible = false
    else
        Frame.Size = UDim2.new(0, 250, 0, 120)
        MinBtn.Text = "-"
        FpsLabel.Visible = true
        Button.Visible = true
    end
end

MinBtn.MouseButton1Click:Connect(toggleMinimize)

-- Kill GUI Logic
KillBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(connections) do
        c:Disconnect()
    end
    ScreenGui:Destroy()
end)

-- Button Click (Inf Jump)
Button.MouseButton1Click:Connect(function()
    infJump = not infJump
    if infJump then
        Button.Text = "Infinite Jump: ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        Button.Text = "Infinite Jump: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end)

-- Infinite Jump
table.insert(connections, UIS.JumpRequest:Connect(function()
    if infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end))

-- FPS Counter
table.insert(connections, RunService.RenderStepped:Connect(function()
    FrameCounter += 1
    if tick() - FrameTimer >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    if not minimized then
        FpsLabel.Text = ("FPS: %d | Ping: %d ms"):format(FPS, math.floor(ping))
    end
end))
