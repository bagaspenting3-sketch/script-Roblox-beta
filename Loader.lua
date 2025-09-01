-- OrionLib Loader
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Buat Window
local Window = OrionLib:MakeWindow({
    Name = "My Test Hub",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "MyTestHub"
})

-- Buat Tab
local Tab = Window:MakeTab({
    Name = "Main Features",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- =========================
-- Variabel
-- =========================
local autoClick = false
local clickDelay = 0.2
local infJump = false

-- =========================
-- Auto Click
-- =========================
Tab:AddToggle({
    Name = "Auto Click",
    Default = false,
    Callback = function(Value)
        autoClick = Value
        if autoClick then
            task.spawn(function()
                while autoClick do
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                    task.wait(clickDelay)
                end
            end)
        end
    end
})

Tab:AddSlider({
    Name = "Auto Click Speed",
    Min = 0.05, -- lebih kecil = lebih cepat
    Max = 1,    -- lebih besar = lebih lambat
    Default = 0.2,
    Increment = 0.05,
    Callback = function(Value)
        clickDelay = Value
    end
})

-- =========================
-- Infinite Jump
-- =========================
Tab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        infJump = Value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- =========================
-- Fix My FPS
-- =========================
Tab:AddButton({
    Name = "Fix My FPS (Potato Mode)",
    Callback = function()
        setfpscap(60) -- batasi fps ke 60
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 0
                v.BlastRadius = 0
            elseif v:IsA("Fire") or v:IsA("Smoke") then
                v.Enabled = false
            end
        end
        OrionLib:MakeNotification({
            Name = "FPS Boost",
            Content = "Mode kentang aktif, partikel dimatikan.",
            Time = 3
        })
    end
})

-- =========================
-- Wajib Init biar UI muncul
-- =========================
OrionLib:Init()            end)
        end
    end
})

Tab:AddSlider({
    Name = "Auto Click Speed",
    Min = 0.05,  -- max speed (cepat)
    Max = 1,     -- min speed (lambat)
    Default = 0.2,
    Increment = 0.05,
    Callback = function(Value)
        clickDelay = Value
    end
})

-- === INFINITE JUMP ===
Tab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        infJump = Value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- === FIX FPS ===
Tab:AddButton({
    Name = "Fix My FPS (Potato Mode)",
    Callback = function()
        setfpscap(60) -- batasi fps ke 60 biar stabil
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 0
                v.BlastRadius = 0
            elseif v:IsA("Fire") or v:IsA("Smoke") then
                v.Enabled = false
            end
        end
        OrionLib:MakeNotification({
            Name = "FPS Boost",
            Content = "Mode kentang aktif! Partikel dimatiin.",
            Time = 3
        })
    end
})

-- Init GUI (WAJIB)
OrionLib:Init()        end
    end
})

-- Auto Click Delay Slider
MainTab:AddSlider({
    Name = "Auto Click Delay",
    Min = 0.05,  -- recommended minimum
    Max = 2,     -- recommended maximum
    Default = 0.2,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.05,
    ValueName = "Seconds",
    Callback = function(Value)
        clickDelay = Value
    end
})

-- Infinite Jump
MainTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        infJump = Value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Fix FPS Button
MainTab:AddButton({
    Name = "Fix My FPS",
    Callback = function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            elseif v:IsA("BasePart") and v.Material ~= Enum.Material.Air then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
        game.Lighting.GlobalShadows = false
        game.Lighting.FogEnd = 9e9
        OrionLib:MakeNotification({
            Name = "FPS Booster",
            Content = "FPS berhasil di-fix ✅",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})

-- Init Orion
OrionLib:Init()t = Enum.Font.SourceSansBold
Title.TextSize = 18

-- Minimize Button
MinimizeBtn.Parent = Frame
MinimizeBtn.Size = UDim2.new(0, 150, 0, 25)
MinimizeBtn.Position = UDim2.new(0, 10, 0, 40)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Text = "Minimize"

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Frame.Size = UDim2.new(0, 320, 0, 30)
        MinimizeBtn.Text = "Show"
    else
        Frame.Size = UDim2.new(0, 320, 0, 260)
        MinimizeBtn.Text = "Minimize"
    end
end)

-- Close Button
CloseBtn.Parent = Frame
CloseBtn.Size = UDim2.new(0, 150, 0, 25)
CloseBtn.Position = UDim2.new(0, 160, 0, 40)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "Close GUI"

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Auto Click Button
AutoClickBtn.Parent = Frame
AutoClickBtn.Size = UDim2.new(0, 300, 0, 30)
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

-- Delay Box
DelayBox.Parent = Frame
DelayBox.Size = UDim2.new(0, 300, 0, 25)
DelayBox.Position = UDim2.new(0, 10, 0, 120)
DelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DelayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayBox.Text = "Delay (detik): " .. tostring(clickDelay)
DelayBox.ClearTextOnFocus = true

DelayBox.FocusLost:Connect(function()
    local num = tonumber(DelayBox.Text)
    if num and num >= minDelay and num <= maxDelay then
        clickDelay = num
        DelayBox.Text = "Delay (detik): " .. tostring(clickDelay)
    else
        DelayBox.Text = "Delay harus " .. minDelay .. " - " .. maxDelay .. " (Now: " .. clickDelay .. ")"
    end
end)

-- Infinite Jump Button
InfJumpBtn.Parent = Frame
InfJumpBtn.Size = UDim2.new(0, 300, 0, 30)
InfJumpBtn.Position = UDim2.new(0, 10, 0, 160)
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
InfJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
InfJumpBtn.Text = "Infinite Jump: OFF"

InfJumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    InfJumpBtn.Text = "Infinite Jump: " .. (infJump and "ON" or "OFF")
end)

UserInputService.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Fix My FPS Button
FixFpsBtn.Parent = Frame
FixFpsBtn.Size = UDim2.new(0, 300, 0, 30)
FixFpsBtn.Position = UDim2.new(0, 10, 0, 200)
FixFpsBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
FixFpsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FixFpsBtn.Text = "Fix My FPS"

FixFpsBtn.MouseButton1Click:Connect(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        elseif v:IsA("BasePart") and v.Material ~= Enum.Material.Air then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 9e9
    print("✅ Fix FPS applied!")
end)

-- Draggable Frame
Frame.Active = true
Frame.Draggable = trueckgroundColor3 = Color3.fromRGB(50, 50, 50)
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
