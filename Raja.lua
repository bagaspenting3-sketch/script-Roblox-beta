--[[
    Script by Raja GT | Minimalist Cheat UI
    Auto Click, Speed Hack, Auto Collect Particles, Anti-AFK
]]

-- Hapus UI lama
if game.CoreGui:FindFirstChild("RajaGTCheatUI") then
    game.CoreGui.RajaGTCheatUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RajaGTCheatUI"
ScreenGui.Parent = game.CoreGui

-- Frame utama
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 180)
Frame.Position = UDim2.new(0.5, -110, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,25)
TopBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
TopBar.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50,1,0)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "Raja GT"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = TopBar

-- Tombol Minimize
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0,25,1,0)
MinimizeButton.Position = UDim2.new(1,-50,0,0)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100,100,100)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 18
MinimizeButton.Parent = TopBar

-- Tombol Close
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0,25,1,0)
CloseButton.Position = UDim2.new(1,-25,0,0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.BackgroundColor3 = Color3.fromRGB(180,0,0)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.Parent = TopBar

-- Tombol Open (TextButton sederhana, bisa digeser)
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0,100,0,25)
OpenButton.Position = UDim2.new(0.5,-50,0.5,-12)
OpenButton.Text = "Open Cheat"
OpenButton.TextColor3 = Color3.fromRGB(255,255,255)
OpenButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
OpenButton.Font = Enum.Font.SourceSansBold
OpenButton.TextSize = 16
OpenButton.Parent = ScreenGui
OpenButton.Visible = false
OpenButton.ZIndex = 10
OpenButton.Active = true
OpenButton.Draggable = true  -- Bisa digeser

-- Fungsi tombol
CloseButton.MouseButton1Click:Connect(function()
    Frame:Destroy()
    OpenButton:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    Frame.Visible = true
    OpenButton.Visible = false
end)

-- Fungsi membuat tombol cheat
local function createButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,200,0,30)
    btn.Position = UDim2.new(0.5,-100,0,posY)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Parent = Frame
    return btn
end

-- Auto Click
local autoClick = false
local ClickButton = createButton("Auto Click",35)
ClickButton.MouseButton1Click:Connect(function()
    autoClick = not autoClick
    if autoClick then
        ClickButton.Text = "Auto Click: ON"
        ClickButton.BackgroundColor3 = Color3.fromRGB(0,180,0)
        spawn(function()
            while autoClick do
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.ClickForSize:InvokeServer()
                end)
                task.wait(0.01)
            end
        end)
    else
        ClickButton.Text = "Auto Click: OFF"
        ClickButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end
end)

-- Speed Hack
local speedHack = false
local SpeedButton = createButton("Speed Hack",70)
SpeedButton.MouseButton1Click:Connect(function()
    speedHack = not speedHack
    local player = game.Players.LocalPlayer
    if speedHack then
        SpeedButton.Text = "Speed Hack: ON"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(0,180,0)
        spawn(function()
            while speedHack do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = 50
                end
                task.wait(0.1)
            end
        end)
    else
        SpeedButton.Text = "Speed Hack: OFF"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- Auto Collect
local autoCollect = false
local CollectButton = createButton("Auto Collect",105)
CollectButton.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    if autoCollect then
        CollectButton.Text = "Auto Collect: ON"
        CollectButton.BackgroundColor3 = Color3.fromRGB(0,180,0)
        spawn(function()
            while autoCollect do
                for _, item in pairs(workspace.Food:GetChildren()) do
                    if item:IsA("BasePart") then
                        pcall(function()
                            item.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        end)
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        CollectButton.Text = "Auto Collect: OFF"
        CollectButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end
end)

-- Anti-AFK
local antiAFK = false
local AFKButton = createButton("Anti-AFK",140)
local vu = game:GetService("VirtualUser")
local afkConnection
AFKButton.MouseButton1Click:Connect(function()
    antiAFK = not antiAFK
    if antiAFK then
        AFKButton.Text = "Anti-AFK: ON"
        AFKButton.BackgroundColor3 = Color3.fromRGB(0,180,0)
        afkConnection = game.Players.LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    else
        AFKButton.Text = "Anti-AFK: OFF"
        AFKButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
        if afkConnection then
            afkConnection:Disconnect()
        end
    end
end)
