-- Modern Utility UI dengan AutoClicker Ultra Fast + Speed Hack

-- Hapus UI lama kalau ada
if game.CoreGui:FindFirstChild("ModernUI") then
    game.CoreGui.ModernUI:Destroy()
end

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Frame Utama
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 380, 0, 320)
Frame.Position = UDim2.new(0.5, -190, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Topbar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = Frame

-- Title
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

-- Kontainer isi
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = Frame

-- Variabel Global
local autoClickEnabled = false
local clickDelay = 0.1
local minimized = false

-- === AUTOCLICKER ===
task.spawn(function()
    while true do
        if autoClickEnabled then
            mouse1click()
        end
        task.wait(clickDelay)
    end
end)

-- Tombol AutoClick
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

-- Slider AutoClick Speed
local SliderFrame1 = Instance.new("Frame")
SliderFrame1.Size = UDim2.new(0, 280, 0, 20)
SliderFrame1.Position = UDim2.new(0, 10, 0, 70)
SliderFrame1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderFrame1.Parent = Content

local SliderBar1 = Instance.new("Frame")
SliderBar1.Size = UDim2.new(0.3, 0, 1, 0) -- default 30%
SliderBar1.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
SliderBar1.Parent = SliderFrame1

local SpeedLabel1 = Instance.new("TextLabel")
SpeedLabel1.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel1.Position = UDim2.new(0, 0, 0, -25)
SpeedLabel1.BackgroundTransparency = 1
SpeedLabel1.Text = "Click Delay: 0.10s"
SpeedLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel1.Font = Enum.Font.SourceSans
SpeedLabel1.TextSize = 16
SpeedLabel1.Parent = SliderFrame1

local dragging1 = false
SliderFrame1.InputBegan:Connect(function(input)
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
        local relativeX = math.clamp((input.Position.X - SliderFrame1.AbsolutePosition.X) / SliderFrame1.AbsoluteSize.X, 0, 1)
        SliderBar1.Size = UDim2.new(relativeX, 0, 1, 0)
        -- Konversi slider ke delay (0.01s - 0.5s)
        clickDelay = 0.5 - (relativeX * 0.49)
        clickDelay = math.max(0.01, clickDelay)
        SpeedLabel1.Text = string.format("Click Delay: %.2fs", clickDelay)
    end
end)

-- === SPEED HACK ===
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 120)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "WalkSpeed"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextSize = 16
SpeedLabel.Parent = Content

local SliderFrame2 = Instance.new("Frame")
SliderFrame2.Size = UDim2.new(0, 280, 0, 20)
SliderFrame2.Position = UDim2.new(0, 10, 0, 150)
SliderFrame2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderFrame2.Parent = Content

local SliderBar2 = Instance.new("Frame")
SliderBar2.Size = UDim2.new(0.2, 0, 1, 0) -- default 20%
SliderBar2.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
SliderBar2.Parent = SliderFrame2

local SpeedValueLabel = Instance.new("TextLabel")
SpeedValueLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedValueLabel.Position = UDim2.new(0, 0, 0, -25)
SpeedValueLabel.BackgroundTransparency = 1
SpeedValueLabel.Text = "WalkSpeed: 16"
SpeedValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedValueLabel.Font = Enum.Font.SourceSans
SpeedValueLabel.TextSize = 16
SpeedValueLabel.Parent = SliderFrame2

local dragging2 = false
SliderFrame2.InputBegan:Connect(function(input)
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
        local relativeX = math.clamp((input.Position.X - SliderFrame2.AbsolutePosition.X) / SliderFrame2.AbsoluteSize.X, 0, 1)
        SliderBar2.Size = UDim2.new(relativeX, 0, 1, 0)
        -- Konversi slider ke WalkSpeed (16 - 200)
        local speed = math.floor(16 + (relativeX * 184))
        SpeedValueLabel.Text = "WalkSpeed: " .. speed
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
        end
    end
end)

-- Fungsi Minimize
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Content.Visible = false
        Frame.Size = UDim2.new(0, 380, 0, 35)
    else
        Content.Visible = true
        Frame.Size = UDim2.new(0, 380, 0, 320)
    end
end)

-- Fungsi Close
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
