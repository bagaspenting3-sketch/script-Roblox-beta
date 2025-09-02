-- Raja GT Executor (FINAL) - All-in-one
-- Features:
-- 1) Auto Collect (workspace.FloatingObjects / FloatingGems)
-- 2) ESP + Arrow/Name (toggle)
-- 3) Anti Respawn (toggle) - note: "must spam jump" shown when ON
-- 4) Auto Spam Chat (toggle + delay 1-30s + message)
-- 5) GrowScan (opens scanner panel)
-- UI: draggable, minimize, close, small and tidy
-- Default: all OFF

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ====== Configurable remote names (change if game uses different names) ======
local REMOTES = {
    CollectItem = {"Events", "CollectItem"},         -- path: ReplicatedStorage.Events.CollectItem
    ChatRemote  = {"Events", "ChatRemote"},          -- path: ReplicatedStorage.Events.ChatRemote
}
-- helper to safely get remote (returns nil if not found)
local function getRemote(pathParts)
    local node = ReplicatedStorage
    for _, part in ipairs(pathParts) do
        if node and node:FindFirstChild(part) then
            node = node[part]
        else
            return nil
        end
    end
    return node
end

local CollectRemote = getRemote(REMOTES.CollectItem)
local ChatRemote = getRemote(REMOTES.ChatRemote)

-- ====== State variables ======
local autoCollectEnabled = false
local espEnabled = false -- default off
local antiRespawnEnabled = false
local autoSpamEnabled = false

local chatMessage = "Raja GT Here!"
local chatDelay = 1 -- 1..30

-- store ESP objects
local espTable = {}

-- Anti-respawn tracker
local lastCFrame = nil
local trackingConn -- heartbeat conn tracking last position
local respawnRestoreConn -- conn that teleports on respawn

-- Utility: safe pcall fire
local function safeFire(remote, ...)
    if not remote then return false end
    local ok, err = pcall(function()
        -- RemoteEvent or RemoteFunction / Bindable vary; we'll use :FireServer or :InvokeServer or :Fire
        if typeof(remote) == "Instance" then
            if remote:IsA("RemoteEvent") and remote.FireServer then
                remote:FireServer(...)
            elseif remote:IsA("RemoteFunction") and remote.InvokeServer then
                remote:InvokeServer(...)
            elseif remote:IsA("BindableEvent") and remote.Fire then
                remote:Fire(...)
            end
        end
    end)
    if not ok then
        -- ignore errors
        return false
    end
    return true
end

-- ====== Create Main GUI ======
if PlayerGui:FindFirstChild("RajaGT_Executor") then
    PlayerGui.RajaGT_Executor:Destroy()
    task.wait(0.05)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RajaGT_Executor"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 340)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(24,24,24)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true

-- Draggable (manual) so works on mobile
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        dragInput = input
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input == dragInput then
        input.Changed:Connect(function()
            if dragging and input.UserInputState == Enum.UserInputState.Change then
                updateDrag(input)
            end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Top bar: title + minimize + close
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(18,18,18)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(230,230,230)
Title.Text = "Raja GT Executor (Beta) - by Raja GT"
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 24)
MinBtn.Position = UDim2.new(1, -70, 0, 4)
MinBtn.Text = "▾"
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 24)
CloseBtn.Position = UDim2.new(1, -34, 0, 4)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(170,50,50)

-- Content holder
local Content = Instance.new("Frame", MainFrame)
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -32)
Content.Position = UDim2.new(0, 0, 0, 32)
Content.BackgroundTransparency = 1

-- UI Layout
local UIList = Instance.new("UIListLayout", Content)
UIList.Padding = UDim.new(0,8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Top

-- Helper to create labeled toggle button
local function makeToggleLabel(text)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 46)
    container.BackgroundTransparency = 1
    container.Parent = Content

    local lbl = Instance.new("TextLabel", container)
    lbl.Size = UDim2.new(0.67, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.SourceSansSemibold
    lbl.TextColor3 = Color3.fromRGB(240,240,240)
    lbl.TextSize = 15
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(0.28, -10, 0, 30)
    btn.Position = UDim2.new(0.72, 0, 0.15, 0)
    btn.Text = "OFF"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(255,255,255)

    return container, lbl, btn
end

-- 1) Auto Collect toggle
local autoCollectFrame, autoCollectLabel, autoCollectBtn = makeToggleLabel("Auto Collect")
autoCollectLabel.TextXAlignment = Enum.TextXAlignment.Left
autoCollectBtn.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    autoCollectBtn.Text = autoCollectEnabled and "ON" or "OFF"
    autoCollectBtn.BackgroundColor3 = autoCollectEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70,70,70)
end)

-- 2) ESP + Arrow/Name toggle
local espFrame, espLabel, espBtn = makeToggleLabel("ESP + Arrow/Name")
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ON" or "OFF"
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70,70,70)
    -- toggle visibility for existing ESP objects
    for plr, obj in pairs(espTable) do
        if obj and obj.billboard then obj.billboard.Enabled = espEnabled end
        if obj and obj.box then obj.box.Visible = espEnabled end
    end
end)

-- 3) Anti Respawn toggle (with small "must spam jump" note)
local antiFrame, antiLabel, antiBtn = makeToggleLabel("Anti Respawn")
local antiNote = Instance.new("TextLabel", antiFrame)
antiNote.Size = UDim2.new(1, -20, 0, 14)
antiNote.Position = UDim2.new(0, 10, 0, 30)
antiNote.BackgroundTransparency = 1
antiNote.Text = "(must spam jump after respawn)"
antiNote.Font = Enum.Font.SourceSans
antiNote.TextSize = 12
antiNote.TextColor3 = Color3.fromRGB(200,200,200)
antiNote.TextXAlignment = Enum.TextXAlignment.Left
antiNote.Visible = false

antiBtn.MouseButton1Click:Connect(function()
    antiRespawnEnabled = not antiRespawnEnabled
    antiBtn.Text = antiRespawnEnabled and "ON" or "OFF"
    antiBtn.BackgroundColor3 = antiRespawnEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(70,70,70)
    antiNote.Visible = antiRespawnEnabled
    -- enable/disable anti-respawn logic
    if antiRespawnEnabled then
        -- start tracking current character if exists
        if trackingConn == nil then
            trackingConn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char and char.Parent and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                    local hum = char:FindFirstChild("Humanoid")
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if hum.Health > 0 then
                        lastCFrame = root.CFrame
                    end
                end
            end)
        end
    else
        if trackingConn then
            trackingConn:Disconnect()
            trackingConn = nil
        end
    end
end)

-- Respawn handler (always present but only active when antiRespawnEnabled)
LocalPlayer.CharacterAdded:Connect(function(char)
    if not antiRespawnEnabled then return end
    -- wait for root
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if not root then return end

    -- attempt to spam-teleport to lastCFrame for 3 seconds
    if lastCFrame then
        local start = tick()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if tick() - start < 3 then
                if root and root.Parent then
                    -- attempt to set position
                    root.CFrame = lastCFrame
                end
            else
                conn:Disconnect()
            end
        end)
    end
end)

-- 4) Spam Chat (toggle + inputs)
local spamFrame = Instance.new("Frame", Content)
spamFrame.Size = UDim2.new(1, -20, 0, 108)
spamFrame.BackgroundTransparency = 1

local spamLabel = Instance.new("TextLabel", spamFrame)
spamLabel.Size = UDim2.new(0.6, 0, 0, 24)
spamLabel.Position = UDim2.new(0,10,0,0)
spamLabel.BackgroundTransparency = 1
spamLabel.Text = "Auto Spam Chat"
spamLabel.Font = Enum.Font.SourceSansSemibold
spamLabel.TextSize = 15
spamLabel.TextColor3 = Color3.fromRGB(230,230,230)
spamLabel.TextXAlignment = Enum.TextXAlignment.Left

local spamToggle = Instance.new("TextButton", spamFrame)
spamToggle.Size = UDim2.new(0.28, -10, 0, 30)
spamToggle.Position = UDim2.new(0.72, 0, 0, 0)
spamToggle.Text = "OFF"
spamToggle.Font = Enum.Font.SourceSansBold
spamToggle.TextSize = 14
spamToggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
spamToggle.TextColor3 = Color3.fromRGB(255,255,255)

local chatBox = Instance.new("TextBox", spamFrame)
chatBox.Size = UDim2.new(0.94, 0, 0, 28)
chatBox.Position = UDim2.new(0.03, 0, 0, 34)
chatBox.PlaceholderText = "Chat message..."
chatBox.Text = chatMessage
chatBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
chatBox.TextColor3 = Color3.fromRGB(240,240,240)
chatBox.TextSize = 14
chatBox.Font = Enum.Font.SourceSans

local delayLabel = Instance.new("TextLabel", spamFrame)
delayLabel.Size = UDim2.new(0.5, 0, 0, 18)
delayLabel.Position = UDim2.new(0.03, 0, 0, 64)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "Delay (1-30s):"
delayLabel.Font = Enum.Font.SourceSans
delayLabel.TextSize = 13
delayLabel.TextColor3 = Color3.fromRGB(200,200,200)
delayLabel.TextXAlignment = Enum.TextXAlignment.Left

local delayBox = Instance.new("TextBox", spamFrame)
delayBox.Size = UDim2.new(0.44, 0, 0, 22)
delayBox.Position = UDim2.new(0.52, 0, 0, 62)
delayBox.PlaceholderText = "1 - 30"
delayBox.Text = tostring(chatDelay)
delayBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
delayBox.TextColor3 = Color3.fromRGB(240,240,240)
delayBox.TextSize = 14
delayBox.Font = Enum.Font.SourceSans

spamToggle.MouseButton1Click:Connect(function()
    autoSpamEnabled = not autoSpamEnabled
    spamToggle.Text = autoSpamEnabled and "ON" or "OFF"
    spamToggle.BackgroundColor3 = autoSpamEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(70,70,70)
end)

chatBox.FocusLost:Connect(function(enter)
    chatMessage = chatBox.Text ~= "" and chatBox.Text or chatMessage
    chatBox.Text = chatMessage
end)

delayBox.FocusLost:Connect(function()
    local v = tonumber(delayBox.Text)
    if v and v >= 1 and v <= 30 then
        chatDelay = math.floor(v)
        delayBox.Text = tostring(chatDelay)
    else
        delayBox.Text = tostring(chatDelay)
    end
end)

-- 5) GrowScan button (opens scanner UI)
local scanBtn = Instance.new("TextButton", Content)
scanBtn.Size = UDim2.new(1, -20, 0, 34)
scanBtn.Text = "GrowScan (Open Scanner)"
scanBtn.Font = Enum.Font.SourceSansBold
scanBtn.TextSize = 14
scanBtn.BackgroundColor3 = Color3.fromRGB(65,65,65)
scanBtn.TextColor3 = Color3.fromRGB(255,255,255)
scanBtn.Position = UDim2.new(0, 10, 0, 0)

-- Scanner UI (hidden by default)
local function createScanner()
    if PlayerGui:FindFirstChild("RajaGT_Scanner") then
        return PlayerGui.RajaGT_Scanner
    end

    local sg = Instance.new("ScreenGui")
    sg.Name = "RajaGT_Scanner"
    sg.Parent = PlayerGui
    sg.ResetOnSpawn = false

    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 260, 0, 300)
    frame.Position = UDim2.new(0.5, 120, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.BorderSizePixel = 0
    frame.Active = true

    -- manual drag for scanner
    local dragging2, dragInput2, dragStart2, startPos2
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging2 = true
            dragStart2 = input.Position
            startPos2 = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging2 = false
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging2 and dragStart2 then
            local delta = input.Position - dragStart2
            frame.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
        end
    end)

    local top = Instance.new("Frame", frame)
    top.Size = UDim2.new(1,0,0,30)
    top.BackgroundColor3 = Color3.fromRGB(22,22,22)

    local title = Instance.new("TextLabel", top)
    title.Size = UDim2.new(1, -40, 1,0)
    title.Position = UDim2.new(0,10,0,0)
    title.BackgroundTransparency = 1
    title.Text = "🌍 GrowScan"
    title.Font = Enum.Font.SourceSansSemibold
    title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(230,230,230)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeS = Instance.new("TextButton", top)
    closeS.Size = UDim2.new(0,28,0,24)
    closeS.Position = UDim2.new(1,-34,0,3)
    closeS.Text = "X"
    closeS.Font = Enum.Font.SourceSansBold
    closeS.TextColor3 = Color3.fromRGB(255,255,255)
    closeS.BackgroundColor3 = Color3.fromRGB(160,50,50)
    closeS.MouseButton1Click:Connect(function() sg:Destroy() end)

    -- Scrolling content
    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -10, 1, -50)
    scroll.Position = UDim2.new(0,5,0,35)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6

    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,4)

    -- small helper to add permanent (non-editable) lines
    local function addLine(txt, color)
        local t = Instance.new("TextLabel", scroll)
        t.Size = UDim2.new(1, -8, 0, 20)
        t.BackgroundTransparency = 1
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Font = Enum.Font.Code
        t.TextSize = 13
        t.Text = txt
        t.TextColor3 = color or Color3.fromRGB(200,200,200)
        t.Active = false
        t.Selectable = false
        return t
    end

    -- Scan function (same logic you had)
    local function doScan()
        for _,c in pairs(scroll:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() end
        end

        addLine("🌍 World Scan Result:", Color3.fromRGB(255,255,255))
        addLine("-----------------------------", Color3.fromRGB(255,255,255))

        -- Gems top
        if Workspace:FindFirstChild("FloatingGems") then
            local gemCount = {}
            for _, gem in pairs(Workspace.FloatingGems:GetChildren()) do
                gemCount[gem.Name] = (gemCount[gem.Name] or 0) + 1
            end
            addLine("💎 Floating Gems:", Color3.fromRGB(0,200,255))
            local idx = 1
            for name, cnt in pairs(gemCount) do
                addLine(tostring(idx) .. ". " .. name .. " x" .. tostring(cnt))
                idx = idx + 1
            end
        end

        -- FloatingObjects drops
        if Workspace:FindFirstChild("FloatingObjects") then
            local dropCount = {}
            for _, item in pairs(Workspace.FloatingObjects:GetChildren()) do
                dropCount[item.Name] = (dropCount[item.Name] or 0) + 1
            end
            addLine("📦 Dropped Items:", Color3.fromRGB(0,255,0))
            local idx = 1
            for name, cnt in pairs(dropCount) do
                addLine(tostring(idx) .. ". " .. name .. " x" .. tostring(cnt))
                idx = idx + 1
            end
        end

        -- Blocks (summary, limited)
        local blockCount = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                blockCount[obj.Name] = (blockCount[obj.Name] or 0) + 1
            end
        end
        addLine("🟫 Blocks:", Color3.fromRGB(255,200,0))
        local idx = 1
        for name, cnt in pairs(blockCount) do
            addLine(tostring(idx) .. ". " .. name .. " x" .. tostring(cnt))
            idx = idx + 1
        end
    end

    local scanButton = Instance.new("TextButton", frame)
    scanButton.Size = UDim2.new(0.48, -6, 0, 26)
    scanButton.Position = UDim2.new(0,5,1,-30)
    scanButton.Text = "Scan"
    scanButton.Font = Enum.Font.SourceSansBold
    scanButton.TextColor3 = Color3.fromRGB(255,255,255)
    scanButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
    scanButton.MouseButton1Click:Connect(doScan)

    local clearButton = Instance.new("TextButton", frame)
    clearButton.Size = UDim2.new(0.48, -6, 0, 26)
    clearButton.Position = UDim2.new(0.52, 1, 1, -30)
    clearButton.Text = "Clear"
    clearButton.Font = Enum.Font.SourceSansBold
    clearButton.TextColor3 = Color3.fromRGB(255,255,255)
    clearButton.BackgroundColor3 = Color3.fromRGB(100,50,50)
    clearButton.MouseButton1Click:Connect(function()
        for _,c in pairs(scroll:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() end
        end
    end)

    return sg
end

scanBtn.MouseButton1Click:Connect(function()
    local sg = createScanner()
    if sg then
        sg.Enabled = true
    end
end)

-- Minimize behavior: hide content area
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    MainFrame.Size = minimized and UDim2.new(0, 200, 0, 36) or UDim2.new(0, 360, 0, 340)
end)

-- Close destroy everything
CloseBtn.MouseButton1Click:Connect(function()
    -- cleanup optional
    for _, v in pairs(espTable) do
        if v.billboard then pcall(function() v.billboard:Destroy() end) end
        if v.box then pcall(function() v.box:Destroy() end) end
    end
    if PlayerGui:FindFirstChild("RajaGT_Scanner") then
        PlayerGui.RajaGT_Scanner:Destroy()
    end
    ScreenGui:Destroy()
end)

-- ====== Auto Collect loop ======
spawn(function()
    while true do
        if autoCollectEnabled then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            -- collect floating gems
            if root then
                -- prioritize FloatingGems then FloatingObjects
                local function collectFrom(container)
                    if not container then return end
                    for _, item in ipairs(container:GetChildren()) do
                        if item and item:IsA("BasePart") then
                            -- teleport near item then call remote if available
                            pcall(function()
                                -- move root safely near item
                                root.CFrame = CFrame.new(item.Position) + Vector3.new(0,2,0)
                                if CollectRemote then
                                    safeFire(CollectRemote, item)
                                end
                            end)
                            task.wait(.05)
                        end
                    end
                end
                -- gems first
                collectFrom(Workspace:FindFirstChild("FloatingGems"))
                collectFrom(Workspace:FindFirstChild("FloatingObjects"))
            end
        end
        task.wait(0.12)
    end
end)

-- ====== ESP functions ======
local function createESPForPlayer(plr)
    if espTable[plr] then return end
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char:FindFirstChild("HumanoidRootPart")

    -- billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = root
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 120, 0, 24)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = ScreenGui

    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1,0,1,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.TextColor3 = Color3.fromRGB(255,0,0)
    nameLabel.Text = plr.Name

    -- body box
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = root
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Size = Vector3.new(2, 5, 1)
    -- BoxHandleAdornment must be parented to the CoreGui to render in some clients. We'll parent to ScreenGui.
    box.Parent = ScreenGui

    espTable[plr] = {billboard = billboard, box = box}
    -- initialize visibility
    billboard.Enabled = espEnabled
    box.Visible = espEnabled
end

local function removeESPForPlayer(plr)
    local data = espTable[plr]
    if not data then return end
    if data.billboard and data.billboard.Parent then pcall(function() data.billboard:Destroy() end) end
    if data.box and data.box.Parent then pcall(function() data.box:Destroy() end) end
    espTable[plr] = nil
end

-- monitor players
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(0.2)
            createESPForPlayer(plr)
        end
    end)
end)
Players.PlayerRemoving:Connect(function(plr)
    removeESPForPlayer(plr)
end)

-- initial create existing players' ESP (but default off)
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function()
            if espEnabled then
                task.wait(0.2)
                createESPForPlayer(plr)
            end
        end)
    end
end

-- per-frame update: ensure esp created/destroyed as players appear/disappear
RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not espTable[plr] then
                createESPForPlayer(plr)
            end
            -- sync visibility
            if espTable[plr] then
                if espTable[plr].billboard then espTable[plr].billboard.Enabled = espEnabled end
                if espTable[plr].box then espTable[plr].box.Visible = espEnabled end
            end
        else
            removeESPForPlayer(plr)
        end
    end
end)

-- ====== Auto Spam Chat loop ======
spawn(function()
    while true do
        if autoSpamEnabled and ChatRemote then
            pcall(function()
                -- attempt to fire ChatRemote; support RemoteEvent or BindableEvent
                safeFire(ChatRemote, chatMessage)
            end)
        end
        task.wait(chatDelay)
    end
end)

-- ensure chat UI updates variables when user edits boxes
chatBox.FocusLost:Connect(function()
    chatMessage = chatBox.Text ~= "" and chatBox.Text or chatMessage
    chatBox.Text = chatMessage
end)

delayBox.FocusLost:Connect(function()
    local v = tonumber(delayBox.Text)
    if v and v >= 1 and v <= 30 then
        chatDelay = math.floor(v)
        delayBox.Text = tostring(chatDelay)
    else
        delayBox.Text = tostring(chatDelay)
    end
end)

-- Final: simple notification prints
print("[RajaGT] Executor loaded. Toggles default OFF.")
