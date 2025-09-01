-- GUI Buatan Sendiri (Tanpa OrionLib)
if game.CoreGui:FindFirstChild("MySimpleUI") then
    game.CoreGui.MySimpleUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MySimpleUI"
ScreenGui.Parent = game.CoreGui

-- Frame Utama
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "My Custom UI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = Frame

-- Tombol Tes
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 200, 0, 50)
Button.Position = UDim2.new(0.5, -100, 0.5, -25)
Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Button.Text = "Hello World"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 18
Button.Parent = Frame

-- Fungsi Saat Tombol Diklik
Button.MouseButton1Click:Connect(function()
    print("Hello World button pressed!")
    Button.Text = "Clicked!"
    task.wait(1)
    Button.Text = "Hello World"
end)
