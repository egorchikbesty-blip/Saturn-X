local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Saturn-X Watermark
local watermarkGui = Instance.new("ScreenGui")
watermarkGui.Name = "SaturnX_Watermark"
watermarkGui.ResetOnSpawn = false
watermarkGui.DisplayOrder = 999999
watermarkGui.Parent = PlayerGui

local watermarkFrame = Instance.new("Frame")
watermarkFrame.Size = UDim2.new(0, 280, 0, 44)
watermarkFrame.Position = UDim2.new(0, 15, 0, 15)
watermarkFrame.BackgroundTransparency = 0.35
watermarkFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 40)
watermarkFrame.BorderSizePixel = 0
watermarkFrame.Parent = watermarkGui

local watermarkCorner = Instance.new("UICorner")
watermarkCorner.CornerRadius = UDim.new(0, 12)
watermarkCorner.Parent = watermarkFrame

local watermarkGradient = Instance.new("UIGradient")
watermarkGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 25, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 80, 180))
}
watermarkGradient.Rotation = 60
watermarkGradient.Parent = watermarkFrame

local watermarkPadding = Instance.new("UIPadding")
watermarkPadding.PaddingLeft = UDim.new(0, 12)
watermarkPadding.PaddingRight = UDim.new(0, 12)
watermarkPadding.PaddingTop = UDim.new(0, 4)
watermarkPadding.PaddingBottom = UDim.new(0, 4)
watermarkPadding.Parent = watermarkFrame

local watermarkLabel = Instance.new("TextLabel")
watermarkLabel.Size = UDim2.new(1, 0, 1, 0)
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Text = "Saturn-X | FPS: -- | PING: --"
watermarkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
watermarkLabel.TextSize = 18
watermarkLabel.Font = Enum.Font.GothamBold
watermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
watermarkLabel.TextYAlignment = Enum.TextYAlignment.Center
watermarkLabel.Parent = watermarkFrame

-- FPS с лимитом 240
local function getFPS()
    local lastTime = tick()
    RunService.Heartbeat:Wait()
    local delta = tick() - lastTime
    local rawFps = delta > 0 and math.floor(1 / delta) or 60
    return math.min(rawFps, 240)  -- Вернул min 240 как ты просил
end

local function getPing()
    local ping = 0
    pcall(function()
        if Stats.Network and Stats.Network.ServerStatsItem["Data Ping"] then
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end
    end)
    if ping <= 0 and LocalPlayer.GetNetworkPing then
        pcall(function()
            ping = math.floor(LocalPlayer:GetNetworkPing() * 2000)
        end)
    end
    if ping <= 0 then
        local perfStats = Stats:FindFirstChild("PerformanceStats")
        if perfStats and perfStats:FindFirstChild("Ping") then
            ping = math.floor(perfStats.Ping:GetValue())
        end
    end
    return ping > 0 and ping or "--"
end

spawn(function()
    while task.wait(1) do
        local fps = getFPS()
        local ping = getPing()
        watermarkLabel.Text = string.format("Saturn-X | FPS: %s | PING: %s", fps, ping)
    end
end)

-- TribeHub GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TribeHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local BlurOverlay = Instance.new("Frame")
BlurOverlay.Size = UDim2.new(1, 0, 1, 0)
BlurOverlay.BackgroundTransparency = 1
BlurOverlay.Visible = false
BlurOverlay.Parent = ScreenGui

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = game.Lighting

local function CreatePanel(title, xOffset)
    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(0, 250, 0, 480)
    Panel.Position = UDim2.new(0.5, xOffset - 125, 0.5, -240)
    Panel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Panel.BackgroundTransparency = 1
    Panel.Visible = true
    Panel.Parent = ScreenGui

    local PanelCorner = Instance.new("UICorner")
    PanelCorner.CornerRadius = UDim.new(0, 14)
    PanelCorner.Parent = Panel

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 55)
    Header.BackgroundColor3 = Color3.fromRGB(90, 0, 180)
    Header.BackgroundTransparency = 1
    Header.Parent = Panel

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 14)
    HeaderCorner.Parent = Header

    local HeaderGradient = Instance.new("UIGradient")
    HeaderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 160))
    }
    HeaderGradient.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.TextTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 22
    TitleLabel.Parent = Header

    local dragging = false
    local dragStart = nil
    local startPos = nil

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Panel.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local List = Instance.new("ScrollingFrame")
    List.Size = UDim2.new(1, 0, 1, -55)
    List.Position = UDim2.new(0, 0, 0, 55)
    List.BackgroundTransparency = 1
    List.ScrollBarThickness = 8
    List.CanvasSize = UDim2.new(0, 0, 0, 0)
    List.Parent = Panel

    return {Panel = Panel, Header = Header, Title = TitleLabel, List = List}
end

local panels = {
    CreatePanel("Combat", -400),
    CreatePanel("Movement", -140),
    CreatePanel("Visuals", 120),
    CreatePanel("Others", 380)
}

local SearchBar = Instance.new("Frame")
SearchBar.Size = UDim2.new(0, 800, 0, 50)
SearchBar.Position = UDim2.new(0.5, -400, 0.5, 260)
SearchBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SearchBar.BackgroundTransparency = 1
SearchBar.Visible = true
SearchBar.Parent = ScreenGui

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 12)
SearchCorner.Parent = SearchBar

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -20, 1, -16)
SearchBox.Position = UDim2.new(0, 10, 0, 8)
SearchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = "Поиск функций..."
SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchBox.TextTransparency = 1
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 18
SearchBox.ClearTextOnFocus = true
SearchBox.Parent = SearchBar

local SearchBoxCorner = Instance.new("UICorner")
SearchBoxCorner.CornerRadius = UDim.new(0, 10)
SearchBoxCorner.Parent = SearchBox

local opened = false

local function OpenGUI()
    BlurOverlay.Visible = true
    TweenService:Create(BlurEffect, TweenInfo.new(0.4), {Size = 20}):Play()

    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    for _, p in ipairs(panels) do
        TweenService:Create(p.Panel, tweenInfo, {BackgroundTransparency = 0}):Play()
        TweenService:Create(p.Header, tweenInfo, {BackgroundTransparency = 0}):Play()
        TweenService:Create(p.Title, tweenInfo, {TextTransparency = 0}):Play()
    end

    TweenService:Create(SearchBar, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(SearchBox, tweenInfo, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
end

local function CloseGUI()
    TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()

    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    for _, p in ipairs(panels) do
        TweenService:Create(p.Panel, tweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(p.Header, tweenInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(p.Title, tweenInfo, {TextTransparency = 1}):Play()
    end

    TweenService:Create(SearchBar, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(SearchBox, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()

    task.delay(0.4, function()
        BlurOverlay.Visible = false
    end)
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        opened = not opened
        if opened then
            OpenGUI()
        else
            CloseGUI()
        end
    end
end)
