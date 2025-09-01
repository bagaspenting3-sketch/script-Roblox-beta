--// Simple GUI with Auto Click
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Services
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Variables
local autoClick = false
local clickDelay = 0.2 -- default
local minDelay, maxDelay = 0.05, 5

-- GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local AutoClickBtn = Instance.new("TextButton")
local DelayBox = Instance.new("TextBox")

-- ScreenGui
ScreenGui.Name = "TestGUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- Frame
Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)

-- Title
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Astolfo | Test GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- Toggle Button (Minimize/Show)
ToggleBtn.Parent = Frame
ToggleBtn.Size = UDim2.new(0, 280, 0, 25)
ToggleBtn.Position = UDim2.new(0, 10, 0, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "Minimize"

local minimized = false
ToggleBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Frame.Size = UDim2.new(0, 300, 0, 30)
        ToggleBtn.Text = "Show"
    else
        Frame.Size = UDim2.new(0, 300, 0, 200)
        ToggleBtn.Text = "Minimize"
    end
end)

-- Auto Click Button
AutoClickBtn.Parent = Frame
AutoClickBtn.Size = UDim2.new(0, 280, 0, 30)
AutoClickBtn.Position = UDim2.new(0, 10, 0, 80)
AutoClickBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoClickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoClickBtn.Text = "Auto Click: OFF"

AutoClickBtn.MouseButton1Click:Connect(function()
    autoClick = not autoClick
    AutoClickBtn.Text = "Auto Click: " .. (autoClick and "ON" or "OFF")

    if autoClick then
        task.spawn(function()
            while autoClick do
                VirtualUser:ClickButton1(Vector2.new())
                task.wait(clickDelay)
            end
        end)
    end
end)

-- Delay Input
DelayBox.Parent = Frame
DelayBox.Size = UDim2.new(0, 280, 0, 25)
DelayBox.Position = UDim2.new(0, 10, 0, 120)
DelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayBox.Text = "Delay (detik): " .. tostring(clickDelay)
DelayBox.ClearTextOnFocus = true

DelayBox.FocusLost:Connect(function(enterPressed)
    local num = tonumber(DelayBox.Text)
    if num and num >= minDelay and num <= maxDelay then
        clickDelay = num
        DelayBox.Text = "Delay (detik): " .. tostring(clickDelay)
    else
        DelayBox.Text = "Delay harus antara " .. minDelay .. " - " .. maxDelay .. " (Sekarang: " .. clickDelay .. ")"
    end
end)

-- Dragging the Frame
local dragging, dragInput, dragStart, startPos
Frame.Active = true
Frame.Draggable = true -- untuk executor modern biasanya workMinimize.Position = UDim2.new(1, -85, 0, 2)
Minimize.Text = "Minimize"
Minimize.TextColor3 = Color3.fromRGB(255,255,255)
Minimize.BackgroundColor3 = Color3.fromRGB(70,70,70)

-- ================= Fitur =================
-- Inf Jump
local InfJumpBtn = Instance.new("TextButton", Frame)
InfJumpBtn.Size = UDim2.new(0, 280, 0, 30)
InfJumpBtn.Position = UDim2.new(0, 10, 0, 40)
InfJumpBtn.Text = "Infinite Jump: OFF"
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
InfJumpBtn.TextColor3 = Color3.fromRGB(255,255,255)

local infJump = false
InfJumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    InfJumpBtn.Text = "Infinite Jump: " .. (infJump and "ON" or "OFF")
end)

UIS.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- TP Walk
local TpWalkBtn = Instance.new("TextButton", Frame)
TpWalkBtn.Size = UDim2.new(0, 280, 0, 30)
TpWalkBtn.Position = UDim2.new(0, 10, 0, 80)
TpWalkBtn.Text = "TP Walk: OFF"
TpWalkBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
TpWalkBtn.TextColor3 = Color3.fromRGB(255,255,255)

local tpWalk = false
local tpSpeed = 5

TpWalkBtn.MouseButton1Click:Connect(function()
    tpWalk = not tpWalk
    TpWalkBtn.Text = "TP Walk: " .. (tpWalk and "ON" or "OFF")
end)

RS.Heartbeat:Connect(function()
    if tpWalk and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
            LocalPlayer.Character:TranslateBy(LocalPlayer.Character.Humanoid.MoveDirection * tpSpeed/10)
        end
    end
end)

-- Auto Click
local AutoClickBtn = Instance.new("TextButton", Frame)
AutoClickBtn.Size = UDim2.new(0, 280, 0, 30)
AutoClickBtn.Position = UDim2.new(0, 10, 0, 120)
AutoClickBtn.Text = "Auto Click: OFF"
AutoClickBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
AutoClickBtn.TextColor3 = Color3.fromRGB(255,255,255)

local autoClick = false
AutoClickBtn.MouseButton1Click:Connect(function()
    autoClick = not autoClick
    AutoClickBtn.Text = "Auto Click: " .. (autoClick and "ON" or "OFF")
    if autoClick then
        task.spawn(function()
            while autoClick do
                VirtualUser:ClickButton1(Vector2.new())
                task.wait(0.1)
            end
        end)
    end
end)

-- Fix FPS
local FixFpsBtn = Instance.new("TextButton", Frame)
FixFpsBtn.Size = UDim2.new(0, 280, 0, 30)
FixFpsBtn.Position = UDim2.new(0, 10, 0, 160)
FixFpsBtn.Text = "Fix My FPS"
FixFpsBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
FixFpsBtn.TextColor3 = Color3.fromRGB(255,255,255)

FixFpsBtn.MouseButton1Click:Connect(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    workspace.GlobalShadows = false
    
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
    
    if workspace:FindFirstChildOfClass("Terrain") then
        workspace.Terrain.WaterWaveSize = 0
        workspace.Terrain.WaterWaveSpeed = 0
        workspace.Terrain.WaterReflectance = 0
        workspace.Terrain.WaterTransparency = 0
    end
    
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 9e9
    
    FixFpsBtn.Text = "FPS Fixed ✅"
end)

-- FPS + Ping Display
local StatsLabel = Instance.new("TextLabel", Frame)
StatsLabel.Size = UDim2.new(0, 280, 0, 30)
StatsLabel.Position = UDim2.new(0, 10, 0, 200)
StatsLabel.TextColor3 = Color3.fromRGB(255,255,255)
StatsLabel.BackgroundColor3 = Color3.fromRGB(50,50,50)
StatsLabel.Text = "FPS: ... | Ping: ..."

local FrameCounter, FPS, Timer = 0, 60, tick()
RS.RenderStepped:Connect(function()
    FrameCounter += 1
    if tick() - Timer >= 1 then
        FPS = FrameCounter
        FrameCounter = 0
        Timer = tick()
    end
    local Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    StatsLabel.Text = "FPS: " .. tostring(FPS) .. " | Ping: " .. tostring(Ping).." ms"
end)

-- ================= Minimize Logic =================
local Minimized = false
Minimize.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    Frame.Size = Minimized and UDim2.new(0, 300, 0, 30) or UDim2.new(0, 300, 0, 300)
    for _,v in pairs(Frame:GetChildren()) do
        if v:IsA("TextButton") or v:IsA("TextLabel") then
            if v ~= Title and v ~= Minimize then
                v.Visible = not Minimized
            end
        end
    end
    Minimize.Text = Minimized and "Show" or "Minimize"
end)Frame.Size = UDim2.new(0, 250, 0, 120)
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
