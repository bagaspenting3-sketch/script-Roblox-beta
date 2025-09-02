local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScanGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Frame utama (lebih kecil)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 260, 0, 300)
Frame.Position = UDim2.new(0.5, -130, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🌍 World Scanner"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ScrollingFrame
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -80)
Scroll.Position = UDim2.new(0, 5, 0, 35)
Scroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.Parent = Frame

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Fungsi buat bikin baris
local function createLine(text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -5, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(0, 255, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 13
    lbl.Text = text
    lbl.Parent = Scroll
    return lbl
end

-- Tombol Scan
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0.5, -8, 0, 25)
Button.Position = UDim2.new(0, 5, 1, -35)
Button.Text = "🔍 Scan World"
Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 13
Button.Parent = Frame

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.5, -8, 0, 25)
ClearBtn.Position = UDim2.new(0.5, 3, 1, -35)
ClearBtn.Text = "🧹 Clear"
ClearBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearBtn.Font = Enum.Font.SourceSansBold
ClearBtn.TextSize = 13
ClearBtn.Parent = Frame

ClearBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(Scroll:GetChildren()) do
        if v:IsA("TextLabel") then v:Destroy() end
    end
end)

-- Fungsi untuk format count
local function formatCounts(tbl)
    local lines = {}
    local i = 1
    for name, count in pairs(tbl) do
        table.insert(lines, i..". "..name.." x"..count)
        i += 1
    end
    return lines
end

-- Scan Function
local function scanWorld()
    -- Clear dulu
    for _, v in pairs(Scroll:GetChildren()) do
        if v:IsA("TextLabel") then v:Destroy() end
    end

    createLine("🌍 World Scan Result:", Color3.fromRGB(255,255,255))
    createLine("======================", Color3.fromRGB(255,255,255))

    -- Gems dulu
    if Workspace:FindFirstChild("FloatingGems") then
        local gemCount = {}
        for _, gem in pairs(Workspace.FloatingGems:GetChildren()) do
            gemCount[gem.Name] = (gemCount[gem.Name] or 0) + 1
        end
        createLine("💎 Floating Gems:", Color3.fromRGB(0,200,255))
        for _, line in ipairs(formatCounts(gemCount)) do
            createLine(line)
        end
    end

    -- Blocks
    local blockCount = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
            blockCount[obj.Name] = (blockCount[obj.Name] or 0) + 1
        end
    end
    createLine("🟫 Blocks:", Color3.fromRGB(255,200,0))
    for _, line in ipairs(formatCounts(blockCount)) do
        createLine(line)
    end

    -- FloatingObjects (drops)
    if Workspace:FindFirstChild("FloatingObjects") then
        local dropCount = {}
        for _, drop in pairs(Workspace.FloatingObjects:GetChildren()) do
            dropCount[drop.Name] = (dropCount[drop.Name] or 0) + 1
        end
        createLine("📦 Dropped Items:", Color3.fromRGB(0,255,0))
        for _, line in ipairs(formatCounts(dropCount)) do
            createLine(line)
        end
    end

    -- Update canvas biar bisa discroll
    Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y)
end

-- Event
Button.MouseButton1Click:Connect(scanWorld)
