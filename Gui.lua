-- Hapus GUI lama jika ada
if game.CoreGui:FindFirstChild("MyModernUI") then
    game.CoreGui.MyModernUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyModernUI"
ScreenGui.Parent = game.CoreGui

-- Frame Utama
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 300)
Frame.Position = UDim2.new(0.5, -175, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ My Custom Exploit UI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Tombol Minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -65, 0, 2)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 20
MinBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
MinBtn.Parent = TitleBar

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20
CloseBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
CloseBtn.Parent = TitleBar

-- Isi Konten
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -10, 1, -45)
Content.Position = UDim2.new(0, 5, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = Frame

-- ===== TOGGLE FUNCTION =====
function createToggle(name, order, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 35)
    Button.Position = UDim2.new(0, 10, 0, (order-1)*40)
    Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Button.Text = name.." [OFF]"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 16
    Button.Parent = Content

    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            Button.Text = name.." [ON]"
        else
            Button.BackgroundColor3 = Color3.fromRGB(70,70,70)
            Button.Text = name.." [OFF]"
        end
        callback(enabled)
    end)
end

-- ===== SLIDER (Fake dengan Button) =====
function createSlider(name, order, min, max, default, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, (order-1)*40)
    Label.BackgroundTransparency = 1
    Label.Text = name.." : "..default
    Label.TextColor3 = Color3.fromRGB(255,255,255)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Content

    local current = default
    Label.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            current = current + 1
            if current > max then current = min end
            Label.Text = name.." : "..current
            callback(current)
        end
    end)
end

-- ============ FUNGSI CHEAT ============
local autoClick = false
local clickDelay = 0.1
local speedHack = false
local speedValue = 16

-- Auto Click Loop
task.spawn(function()
    while true do
        if autoClick then
            mouse1click()
        end
        task.wait(clickDelay)
    end
end)

-- Infinite Jump
local infJump = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- Speed Hack
task.spawn(function()
    while true do
        if speedHack then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = speedValue
            end
        end
        task.wait(0.2)
    end
end)

-- ============ BUAT TOGGLE ============
createToggle("Auto Click", 1, function(val) autoClick = val end)
createSlider("Click Speed", 2, 1, 10, 5, function(val) clickDelay = 1/val end)

createToggle("Speed Hack", 3, function(val) speedHack = val end)
createSlider("Speed Value", 4, 16, 100, 16, function(val) speedValue = val end)

createToggle("Infinite Jump", 5, function(val) infJump = val end)

createToggle("Fix My FPS", 6, function(val)
    if val then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        workspace.GlobalShadows = false
        game:GetService("Lighting").FogEnd = 9e9
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").GlobalShadows = false
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        workspace.GlobalShadows = true
    end
end)

-- ============ MINIMIZE DAN CLOSE ============
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
