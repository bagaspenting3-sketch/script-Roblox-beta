-- Modern UI (Android-friendly) with working AutoClick + Speed Hack + combined sliders
if game.CoreGui:FindFirstChild("ModernUI_v2") then
    game.CoreGui.ModernUI_v2:Destroy()
end

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = pcall(function() return game:GetService("VirtualUser") end) and game:GetService("VirtualUser") or nil

local LocalPlayer = Players.LocalPlayer

-- State
local state = {
    autoClick = false,
    clickDelay = 0.1,        -- seconds (default)
    walkSpeed = 16,          -- default walk speed
    speedHack = false,
    infJump = false,
}

-- Helper: safe parent (some executors)
local function getParent()
    local ok, gethui = pcall(function() return gethui() end)
    if ok and gethui then return gethui end
    return game.CoreGui
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUI_v2"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = getParent()

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 420, 0, 360)
Frame.Position = UDim2.new(0.5, -210, 0.5, -180)
Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Titlebar
local TitleBar = Instance.new("Frame", Frame)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(34, 34, 34)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Modern Utility UI (Mobile Friendly)"
Title.TextColor3 = Color3.fromRGB(230,230,230)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 36, 0, 28)
MinBtn.Position = UDim2.new(1, -80, 0.5, -14)
MinBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
MinBtn.Text = "–"
MinBtn.Font = Enum.Font.Gotham
MinBtn.TextSize = 18
MinBtn.TextColor3 = Color3.fromRGB(240,240,240)

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 36, 0, 28)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180,60,60)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- Content container
local Content = Instance.new("Frame", Frame)
Content.Size = UDim2.new(1, -24, 1, -60)
Content.Position = UDim2.new(0, 12, 0, 44)
Content.BackgroundTransparency = 1

-- Reusable: create toggle (button) that calls callback(state)
local function createToggle(text, y, default)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(0, 190, 0, 42)
    btn.Position = UDim2.new(0, 12 + ((y-1)%2)*200, 0, 12 + math.floor((y-1)/2)*60)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(245,245,245)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = text .. ": OFF"
    btn.AutoButtonColor = false
    btn.AnchorPoint = Vector2.new(0,0)
    return btn
end

-- Reusable: create combined slider (label + bar) -> callback(value)
local function createSlider(text, y, min, max, default)
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(0, 380, 0, 54)
    frame.Position = UDim2.new(0, 12, 0, 12 + (y-1)*60)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = string.format("%s: %s", text, tostring(default))
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(230,230,230)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left

    local slider = Instance.new("Frame", frame)
    slider.Size = UDim2.new(1, 0, 0, 18)
    slider.Position = UDim2.new(0, 0, 0, 28)
    slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
    slider.BorderSizePixel = 0

    local bar = Instance.new("Frame", slider)
    local ratio = (default - min) / (max - min)
    bar.Size = UDim2.new(math.clamp(ratio,0,1), 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(100,200,100)
    bar.BorderSizePixel = 0

    -- Drag handling (supports Mouse & Touch)
    local dragging = false
    slider.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            -- immediate update on press:
            local rel = math.clamp((inp.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            bar.Size = UDim2.new(rel, 0, 1, 0)
            local val = min + (max - min) * rel
            label.Text = string.format("%s: %s", text, (type(default)=="number" and math.floor(val*100)/100 or tostring(val)))
            return
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((inp.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            bar.Size = UDim2.new(rel, 0, 1, 0)
            local val = min + (max - min) * rel
            label.Text = string.format("%s: %s", text, (type(default)=="number" and math.floor(val*100)/100 or tostring(val)))
            if frame._callback then
                pcall(frame._callback, val)
            end
        end
    end)

    -- API to set callback
    frame.SetCallback = function(self, cb) self._callback = cb end
    -- API to set value programmatically
    frame.SetValue = function(self, v)
        local r = (v - min) / (max - min)
        r = math.clamp(r,0,1)
        bar.Size = UDim2.new(r,0,1,0)
        label.Text = string.format("%s: %s", text, math.floor(v*100)/100)
    end

    return frame
end

-- Create UI controls (layout: two columns)
-- Row indexes chosen so sliders stack nicely

-- AutoClick toggle (left)
local autoBtn = createToggle("Auto Click", 1)
autoBtn.Parent = Content
autoBtn.MouseButton1Click:Connect(function()
    state.autoClick = not state.autoClick
    if state.autoClick then
        autoBtn.Text = "Auto Click: ON"
        autoBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)
    else
        autoBtn.Text = "Auto Click: OFF"
        autoBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    end
end)

-- Click Speed slider (right, combined)
local clickSlider = createSlider("Click Delay (s)", 1, 0.01, 1, state.clickDelay)
clickSlider:SetCallback(function(val)
    -- convert to seconds with 2 decimal
    state.clickDelay = math.max(0.01, math.floor(val*100)/100)
    clickSlider:SetValue(state.clickDelay)
end)
clickSlider.Parent = Content
clickSlider.Position = UDim2.new(0, 200, 0, 12) -- place to the right column

-- Speed Hack toggle (left, second row)
local speedBtn = createToggle("Speed Hack", 3)
speedBtn.Parent = Content
speedBtn.MouseButton1Click:Connect(function()
    state.speedHack = not state.speedHack
    if not state.speedHack then
        -- reset to default
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
        end)
    end
end)

-- WalkSpeed slider (combined, right)
local speedSlider = createSlider("WalkSpeed", 3, 16, 200, state.walkSpeed)
speedSlider:SetCallback(function(val)
    state.walkSpeed = math.floor(val)
    speedSlider:SetValue(state.walkSpeed)
    if state.speedHack then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = state.walkSpeed
            end
        end)
    end
end)
speedSlider.Parent = Content
speedSlider.Position = UDim2.new(0, 200, 0, 132)

-- Infinite Jump toggle (left, third row)
local infBtn = createToggle("Infinite Jump", 5)
infBtn.Parent = Content
infBtn.MouseButton1Click:Connect(function()
    state.infJump = not state.infJump
end)

-- Fix FPS toggle (right, third row; acts as button)
local fixBtn = createToggle("Fix My FPS", 5)
fixBtn.Parent = Content
fixBtn.MouseButton1Click:Connect(function()
    -- toggle apply once; turning off will not restore every single visual but attempt some restores
    local applied = pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        game.Lighting.GlobalShadows = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
    end)
    if applied then
        fixBtn.Text = "Fix My FPS: ON"
        fixBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)
    else
        fixBtn.Text = "Fix My FPS: ERR"
        fixBtn.BackgroundColor3 = Color3.fromRGB(180,60,60)
    end
end)

-- Ensure sliders initial positions reflect defaults
clickSlider:SetValue(state.clickDelay)
speedSlider:SetValue(state.walkSpeed)

-- AutoClick implementation (Android-friendly)
-- Strategy:
-- 1) If player has a Tool in character -> call :Activate() (works for many mobile tools)
-- 2) Else fallback to VirtualUser:ClickButton1 if available
-- Loop uses state.clickDelay and state.autoClick
task.spawn(function()
    while true do
        if state.autoClick then
            local worked = false
            -- Try tool activation
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        -- some tools require :Activate()
                        tool:Activate()
                        worked = true
                    end
                end
            end)
            -- If no tool, try VirtualUser
            if not worked and VirtualUser then
                pcall(function()
                    VirtualUser:ClickButton1(Vector2.new()) -- fallback
                end)
            end
        end
        local delay = state.clickDelay or 0.1
        -- clamp delay minimally to avoid too tight looping
        if delay < 0.01 then delay = 0.01 end
        task.wait(delay)
    end
end)

-- Speed enforcement loop (prevents game resetting walkspeed)
RunService.Heartbeat:Connect(function()
    if state.speedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        pcall(function()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = state.walkSpeed
        end)
    end
end)

-- Infinite jump handler
UIS.JumpRequest:Connect(function()
    if state.infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        pcall(function()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end)

-- Minimize & Close behavior
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    if minimized then
        Frame.Size = UDim2.new(0, 420, 0, 40)
    else
        Frame.Size = UDim2.new(0, 420, 0, 360)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Safety: reset WalkSpeed on character respawn if speedHack disabled
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if not state.speedHack then
        pcall(function()
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
        end)
    end
end)

-- Notification helper (small print)
print("ModernUI_v2 loaded — AutoClick/Sliders are touch-friendly. Tips: use tool-based click games for best AutoClick reliability.")
