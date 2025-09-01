-- Hapus GUI lama kalau ada
if game.CoreGui:FindFirstChild("ModernUI") then
    game.CoreGui.ModernUI:Destroy()
end

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variabel cheat
local autoClick = false
local clickDelay = 0.1
local speedHack = false
local walkSpeed = 16
local infJump = false

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUI"
ScreenGui.Parent = game.CoreGui

-- Frame utama
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 360, 0, 280)
Frame.Position = UDim2.new(0.5, -180, 0.5, -140)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- TitleBar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ My Cheat Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Tombol minimize
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 30, 0, 25)
Minimize.Position = UDim2.new(1, -65, 0.5, -12)
Minimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Minimize.Text = "_"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 18
Minimize.Parent = TitleBar

-- Tombol close
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 25)
Close.Position = UDim2.new(1, -35, 0.5, -12)
Close.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.Parent = TitleBar

-- Container isi
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = Frame

-- Template tombol toggle
local function createToggle(text, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 320, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (order - 1) * 45)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = Container

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = text .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        else
            btn.Text = text .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
        callback(state)
    end)

    return btn
end

-- Template slider
local function createSlider(text, order, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 50)
    frame.Position = UDim2.new(0, 0, 0, (order - 1) * 55)
    frame.BackgroundTransparency = 1
    frame.Parent = Container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 15)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    bar.Parent = slider

    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            bar.Size = UDim2.new(rel, 0, 1, 0)
            local val = math.floor(min + (max - min) * rel)
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)

    return frame
end

-- Fitur
createToggle("Auto Click", 1, function(state)
    autoClick = state
end)

createSlider("Click Speed (ms)", 2, 10, 500, 100, function(val)
    clickDelay = val / 1000
end)

createToggle("Speed Hack", 3, function(state)
    speedHack = state
    if not state then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

createSlider("WalkSpeed", 4, 16, 200, 16, function(val)
    walkSpeed = val
    if speedHack and LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

createToggle("Infinite Jump", 5, function(state)
    infJump = state
end)

createToggle("Fix My FPS", 6, function(state)
    if state then
        setfpscap(30)
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    else
        setfpscap(60)
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end
end)

-- AutoClick loop
task.spawn(function()
    while task.wait() do
        if autoClick then
            pcall(function()
                mouse1click()
            end)
            task.wait(clickDelay)
        end
    end
end)

-- Speed Hack loop
task.spawn(function()
    while task.wait(0.2) do
        if speedHack and LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
        end
    end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Tombol minimize & close
local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    Container.Visible = not minimized
    if minimized then
        Frame.Size = UDim2.new(0, 360, 0, 35)
    else
        Frame.Size = UDim2.new(0, 360, 0, 280)
    end
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
