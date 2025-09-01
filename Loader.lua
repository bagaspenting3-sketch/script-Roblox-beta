-- Loader.lua (test minimal UI)
if game.CoreGui:FindFirstChild("MySimpleUI") then
    game.CoreGui.MySimpleUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MySimpleUI"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = "LOADER LUA OK ✅"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.SourceSansBold
Label.TextSize = 20
Label.Parent = Frame----------------------------------------------------
local AutoClickBtn = Instance.new("TextButton")
AutoClickBtn.Size = UDim2.new(0, 300, 0, 40)
AutoClickBtn.Position = UDim2.new(0.5, -150, 0, 60)
AutoClickBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AutoClickBtn.Text = "AutoClick: OFF"
AutoClickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoClickBtn.Font = Enum.Font.SourceSansBold
AutoClickBtn.TextSize = 18
AutoClickBtn.Parent = Frame

AutoClickBtn.MouseButton1Click:Connect(function()
    autoClick = not autoClick
    AutoClickBtn.Text = autoClick and "AutoClick: ON" or "AutoClick: OFF"
    if autoClick then
        task.spawn(function()
            while autoClick do
                game:GetService("ReplicatedStorage"):FireServer("Click") -- contoh, ganti sesuai game
                task.wait(autoClickSpeed)
            end
        end)
    end
end)

----------------------------------------------------
-- Slider Kecepatan AutoClick
----------------------------------------------------
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0, 300, 0, 40)
SpeedBox.Position = UDim2.new(0.5, -150, 0, 110)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBox.Text = "Speed (detik): " .. autoClickSpeed
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.TextSize = 18
SpeedBox.Parent = Frame

SpeedBox.FocusLost:Connect(function()
    local val = tonumber(SpeedBox.Text:match("%d*%.?%d+"))
    if val and val >= 0.1 and val <= 2 then
        autoClickSpeed = val
    else
        autoClickSpeed = 0.5
    end
    SpeedBox.Text = "Speed (detik): " .. autoClickSpeed
end)

----------------------------------------------------
-- Tombol Infinite Jump
----------------------------------------------------
local InfJumpBtn = Instance.new("TextButton")
InfJumpBtn.Size = UDim2.new(0, 300, 0, 40)
InfJumpBtn.Position = UDim2.new(0.5, -150, 0, 160)
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
InfJumpBtn.Text = "Infinite Jump: OFF"
InfJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InfJumpBtn.Font = Enum.Font.SourceSansBold
InfJumpBtn.TextSize = 18
InfJumpBtn.Parent = Frame

InfJumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    InfJumpBtn.Text = infJump and "Infinite Jump: ON" or "Infinite Jump: OFF"
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

----------------------------------------------------
-- Tombol Fix My FPS
----------------------------------------------------
local FixFPSBtn = Instance.new("TextButton")
FixFPSBtn.Size = UDim2.new(0, 300, 0, 40)
FixFPSBtn.Position = UDim2.new(0.5, -150, 0, 210)
FixFPSBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
FixFPSBtn.Text = "Fix My FPS"
FixFPSBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FixFPSBtn.Font = Enum.Font.SourceSansBold
FixFPSBtn.TextSize = 18
FixFPSBtn.Parent = Frame

FixFPSBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
    setfpscap(60) -- kalau executor supportButton.Font = Enum.Font.SourceSansBold
Button.TextSize = 18
Button.Parent = Frame

-- Fungsi Saat Tombol Diklik
Button.MouseButton1Click:Connect(function()
    print("Hello World button pressed!")
    Button.Text = "Clicked!"
    task.wait(1)
    Button.Text = "Hello World"
end)
