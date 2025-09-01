-- Modern Utility UI (Android Friendly) - AutoClick, Speed Hack, Fix FPS, Inf Jump

-- Hapus UI lama
if game.CoreGui:FindFirstChild("ModernUI") then
    game.CoreGui.ModernUI:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variabel
local autoClickEnabled = false
local clickDelay = 0.1
local walkSpeedValue = 16
local infJumpEnabled = false
local minimized = false

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Frame Utama
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 380, 0, 350)
Frame.Position = UDim2.new(0.5, -190, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Topbar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Modern Utility UI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 25)
MinBtn.Position = UDim2.new(1, -65, 0.5, -12)
MinBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MinBtn.Text = "_"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 18
MinBtn.Parent = TopBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TopBar

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = Frame

-------------------------------
-- AUTO CLICKER (ANDROID SAFE)
-------------------------------
local AutoClickBtn = Instance.new("TextButton")
AutoClickBtn.Size = UDim2.new(0, 160, 0, 40)
AutoClickBtn.Position = UDim2.new(0, 10, 0, 10)
AutoClickBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoClickBtn.Text = "AutoClick: OFF"
AutoClickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoClickBtn.Font = Enum.Font.SourceSansBold
AutoClickBtn.TextSize = 16
AutoClickBtn.Parent = Content

AutoClickBtn.MouseButton1Click:Connect(function()
    autoClickEnabled = not autoClickEnabled
    if autoClickEnabled then
        AutoClickBtn.Text = "AutoClick: ON"
        AutoClickBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    else
        AutoClickBtn.Text = "AutoClick: OFF"
        AutoClickBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

-- Loop AutoClick (FireTouchInterest buat Android)
task.spawn(function()
    while true do
        if autoClickEnabled then
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function()
                    tool:Activate()
                end)
            end
        end
        task.wait(clickDelay)
    end
end)

-- Slider Click Delay
local SliderClick = Instance.new("Frame")
SliderClick.Size = UDim2.new(0, 280, 0, 20)
SliderClick.Position = UDim2.new(0, 10, 0, 60)
SliderClick.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderClick.Parent = Content

local BarClick = Instance.new("Frame")
BarClick.Size = UDim2.new(0.3, 0, 1, 0)
BarClick.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
BarClick.Parent = SliderClick

local LabelClick = Instance.new("TextLabel")
LabelClick.Size = UDim2.new(1, 0, 0, 20)
LabelClick.Position = UDim2.new(0, 0, 0, -25)
LabelClick.BackgroundTransparency = 1
LabelClick.Text = "Click Delay: 0.10s"
LabelClick.TextColor3 = Color3.fromRGB(255, 255, 255)
LabelClick.Font = Enum.Font.SourceSans
LabelClick.TextSize = 16
LabelClick.Parent = SliderClick

local dragging1 = false
SliderClick.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging1 = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging1 = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging1 and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp((input.Position.X - SliderClick.AbsolutePosition.X) / SliderClick.AbsoluteSize.X, 0, 1)
        BarClick.Size = UDim2.new(relativeX, 0, 1, 0)
        clickDelay = 0.5 - (relativeX * 0.49)
        clickDelay = math.max(0.01, clickDelay)
        LabelClick.Text = string.format("Click Delay: %.2fs", clickDelay)
    end
end)

-------------------------------
-- SPEED HACK
-------------------------------
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 100)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "WalkSpeed"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextSize = 16
SpeedLabel.Parent = Content

local SliderSpeed = Instance.new("Frame")
SliderSpeed.Size = UDim2.new(0, 280, 0, 20)
SliderSpeed.Position = UDim2.new(0, 10, 0, 130)
SliderSpeed.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderSpeed.Parent = Content

local BarSpeed = Instance.new("Frame")
BarSpeed.Size = UDim2.new(0.2, 0, 1, 0)
BarSpeed.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
BarSpeed.Parent = SliderSpeed

local LabelSpeed = Instance.new("TextLabel")
LabelSpeed.Size = UDim2.new(1, 0, 0, 20)
LabelSpeed.Position = UDim2.new(0, 0, 0, -25)
LabelSpeed.BackgroundTransparency = 1
LabelSpeed.Text = "WalkSpeed: 16"
LabelSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
LabelSpeed.Font = Enum.Font.SourceSans
LabelSpeed.TextSize = 16
LabelSpeed.Parent = SliderSpeed

local dragging2 = false
SliderSpeed.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging2 = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging2 = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging2 and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp((input.Position.X - SliderSpeed.AbsolutePosition.X) / SliderSpeed.AbsoluteSize.X, 0, 1)
        BarSpeed.Size = UDim2.new(relativeX, 0, 1, 0)
        walkSpeedValue = math.floor(16 + (relativeX * 184))
        LabelSpeed.Text = "WalkSpeed: " .. walkSpeedValue
    end
end)

-- Loop paksa WalkSpeed biar ga reset
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkSpeedValue
    end
end)

-------------------------------
-- INFINITY JUMP
-------------------------------
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local InfJumpBtn = Instance.new("TextButton")
InfJumpBtn.Size = UDim2.new(0, 160, 0, 40)
InfJumpBtn.Position = UDim2.new(0, 10, 0, 170)
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
InfJumpBtn.Text = "Inf Jump: OFF"
InfJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InfJumpBtn.Font = Enum.Font.SourceSansBold
InfJumpBtn.TextSize = 16
InfJumpBtn.Parent = Content

InfJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    if infJumpEnabled then
        InfJumpBtn.Text = "Inf Jump: ON"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    else
        InfJumpBtn.Text = "Inf Jump: OFF"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

-------------------------------
-- FIX FPS (HP Kentang)
-------------------------------
local FixFpsBtn = Instance.new("TextButton")
FixFpsBtn.Size = UDim2.new(0, 160, 0, 40)
FixFpsBtn.Position = UDim2.new(0, 10, 0, 220)
FixFpsBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
FixFpsBtn.Text = "Fix FPS"
FixFpsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FixFpsBtn.Font = Enum.Font.SourceSansBold
FixFpsBtn.TextSize = 16
FixFpsBtn.Parent = Content

FixFpsBtn.MouseButton1Click:Connect(function()
    setfpscap(30)
    for _,v in pairs(game.Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") then
            v.Enabled = false
        end
    end
    game.Lighting.GlobalShadows = false
    FixFpsBtn.Text = "FPS Fixed"
    FixFpsBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
end)

-------------------------------
-- Minimize & Close
-------------------------------
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Content.Visible = false
        Frame.Size = UDim2.new(0, 380, 0, 35)
    else
        Content.Visible = true
        Frame.Size = UDim2.new(0, 380, 0, 350)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
