local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Ждём полной загрузки
repeat task.wait() until LocalPlayer.Character
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 15)
if not PlayerGui then
    warn("[SaturnX] PlayerGui не найден!")
    return
end

print("[SaturnX] Запуск успешен")

-- === ТЕМА ===
local MAIN_BG = Color3.fromRGB(8, 12, 30)
local TAB_BG = Color3.fromRGB(12, 18, 45)
local HEADER_FROM = Color3.fromRGB(30, 60, 180)
local HEADER_TO = Color3.fromRGB(60, 20, 140)
local ACCENT_ON = Color3.fromRGB(40, 180, 255)
local TEXT_COLOR = Color3.fromRGB(220, 230, 255)
local TEXT_SECONDARY = Color3.fromRGB(140, 160, 220)

-- === Watermark (с лимитом FPS 240) ===
local watermarkGui = Instance.new("ScreenGui")
watermarkGui.Name = "SaturnX_Watermark"
watermarkGui.ResetOnSpawn = false
watermarkGui.DisplayOrder = 999999
watermarkGui.Parent = PlayerGui

local watermarkFrame = Instance.new("Frame")
watermarkFrame.Size = UDim2.new(0, 300, 0, 50)
watermarkFrame.Position = UDim2.new(0, 20, 0, 20)
watermarkFrame.BackgroundColor3 = MAIN_BG
watermarkFrame.BackgroundTransparency = 0.5
watermarkFrame.BorderSizePixel = 0
watermarkFrame.Parent = watermarkGui
Instance.new("UICorner", watermarkFrame).CornerRadius = UDim.new(0, 10)

local watermarkLabel = Instance.new("TextLabel")
watermarkLabel.Size = UDim2.new(1, -20, 1, 0)
watermarkLabel.Position = UDim2.new(0, 20, 0, 0)
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Text = "Saturn-X • FPS: -- • PING: -- ms"
watermarkLabel.TextColor3 = TEXT_COLOR
watermarkLabel.TextSize = 16
watermarkLabel.Font = Enum.Font.GothamBold
watermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
watermarkLabel.Parent = watermarkFrame

task.spawn(function()
    local FPS_LIMIT = 240
    while task.wait(1) do
        local fps = "--"
        local last = tick()
        RunService.Heartbeat:Wait()
        local delta = tick() - last
        if delta > 0 then 
            local rawFps = math.floor(1 / delta)
            if rawFps >= FPS_LIMIT then
                fps = FPS_LIMIT .. "+"
            else
                fps = tostring(rawFps)
            end
        end
        
        local ping = "--"
        pcall(function()
            if Stats.Network and Stats.Network.ServerStatsItem["Data Ping"] then
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end
        end)
        
        watermarkLabel.Text = string.format("Saturn-X • FPS: %s • PING: %s ms", fps, ping)
    end
end)

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SaturnX_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9998
ScreenGui.Parent = PlayerGui

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = Lighting

-- Создание табов
local function CreateTab(title, xOffset)
    local Tab = Instance.new("Frame")
    Tab.Size = UDim2.new(0, 260, 0, 560)
    Tab.Position = UDim2.new(0.5, xOffset - 130, 0.5, -280)
    Tab.BackgroundColor3 = TAB_BG
    Tab.BackgroundTransparency = 1
    Tab.Visible = false
    Tab.Parent = ScreenGui
    Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 16)

    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.new(0,0,0)
    Shadow.ImageTransparency = 0.8
    Shadow.ZIndex = 0
    Shadow.Parent = Tab

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundTransparency = 1
    Header.Parent = Tab
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)

    local HeaderGradient = Instance.new("UIGradient")
    HeaderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, HEADER_FROM),
        ColorSequenceKeypoint.new(1, HEADER_TO)
    }
    HeaderGradient.Rotation = 90
    HeaderGradient.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.TextTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 26
    TitleLabel.Parent = Header

    local dragging = false
    local dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Tab.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Tab.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local List = Instance.new("ScrollingFrame")
    List.Size = UDim2.new(1, -24, 1, -80)
    List.Position = UDim2.new(0, 12, 0, 70)
    List.BackgroundTransparency = 1
    List.ScrollBarThickness = 4
    List.ScrollBarImageColor3 = Color3.fromRGB(80, 140, 255)
    List.AutomaticCanvasSize = Enum.AutomaticSize.Y
    List.Parent = Tab

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 10)
    Layout.Parent = List

    return {Tab = Tab, Header = Header, Title = TitleLabel, Shadow = Shadow, List = List}
end

local tabs = {
    CreateTab("Rage", -600),
    CreateTab("Movement", -300),
    CreateTab("Visuals", 0),
    CreateTab("Player", 300),
    CreateTab("Utility", 600)
}

-- === SEARCH BAR ===
local SearchBar = Instance.new("Frame")
SearchBar.Size = UDim2.new(0, 440, 0, 60)
SearchBar.Position = UDim2.new(0.5, -220, 0.5, 300)
SearchBar.BackgroundColor3 = Color3.fromRGB(12, 18, 45)
SearchBar.BackgroundTransparency = 0.45
SearchBar.Visible = false
SearchBar.BorderSizePixel = 0
SearchBar.Parent = ScreenGui

local searchCorner = Instance.new("UICorner", SearchBar)
searchCorner.CornerRadius = UDim.new(0, 16)

local searchStroke = Instance.new("UIStroke", SearchBar)
searchStroke.Color = Color3.fromRGB(80, 140, 255)
searchStroke.Thickness = 1.5
searchStroke.Transparency = 1

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 36, 0, 36)
SearchIcon.Position = UDim2.new(0, 18, 0.5, -18)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔎"
SearchIcon.TextColor3 = Color3.fromRGB(140, 180, 255)
SearchIcon.Font = Enum.Font.GothamBold
SearchIcon.TextSize = 34
SearchIcon.Parent = SearchBar

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -80, 1, -20)
SearchBox.Position = UDim2.new(0, 70, 0, 10)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "Search features..."
SearchBox.PlaceholderColor3 = TEXT_SECONDARY
SearchBox.Text = ""
SearchBox.TextColor3 = TEXT_COLOR
SearchBox.TextTransparency = 1
SearchBox.Font = Enum.Font.GothamSemibold
SearchBox.TextSize = 21
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchBar

SearchBox.Focused:Connect(function()
    TweenService:Create(SearchBar, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.25}):Play()
    TweenService:Create(searchStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Transparency = 0.3, Color = Color3.fromRGB(80, 180, 255)}):Play()
    TweenService:Create(SearchIcon, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {TextColor3 = Color3.fromRGB(120, 220, 255)}):Play()
    TweenService:Create(SearchIcon, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextSize = 42}):Play()
end)

SearchBox.FocusLost:Connect(function()
    TweenService:Create(SearchBar, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.45}):Play()
    TweenService:Create(searchStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(SearchIcon, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {TextColor3 = Color3.fromRGB(140, 180, 255)}):Play()
    TweenService:Create(SearchIcon, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextSize = 34}):Play()
end)

local searchableElements = {}
local function AddToSearch(element, keywords)
    table.insert(searchableElements, {Element = element, Keywords = type(keywords) == "table" and keywords or {keywords}})
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(SearchBox.Text)
    for _, item in ipairs(searchableElements) do
        local matches = query == ""
        if not matches then
            for _, kw in ipairs(item.Keywords) do
                if string.find(string.lower(kw), query, 1, true) then
                    matches = true
                    break
                end
            end
        end
        item.Element.Visible = matches
    end
end)

-- === АНИМАЦИИ GUI ===
local opened = false

local function OpenGUI()
    opened = true
    print("[SaturnX] GUI открывается...")
    
    for _, t in tabs do
        t.Tab.Visible = true
        TweenService:Create(t.Shadow, TweenInfo.new(0.6), {ImageTransparency = 0.5}):Play()
    end
    SearchBar.Visible = true
    TweenService:Create(BlurEffect, TweenInfo.new(0.5), {Size = 16}):Play()

    local tween = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    for _, t in tabs do
        TweenService:Create(t.Tab, tween, {BackgroundTransparency = 0.25}):Play()
        TweenService:Create(t.Header, tween, {BackgroundTransparency = 0}):Play()
        TweenService:Create(t.Title, tween, {TextTransparency = 0}):Play()
    end
    TweenService:Create(SearchBar, tween, {BackgroundTransparency = 0.45}):Play()
    TweenService:Create(SearchBox, tween, {TextTransparency = 0}):Play()
end

local function CloseGUI()
    opened = false
    print("[SaturnX] GUI закрывается...")
    
    for _, t in tabs do
        TweenService:Create(t.Tab, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        TweenService:Create(t.Header, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        TweenService:Create(t.Title, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
        TweenService:Create(t.Shadow, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {ImageTransparency = 1}):Play()
    end
    
    TweenService:Create(SearchBar, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    TweenService:Create(SearchBox, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Size = 0}):Play()

    task.delay(0.4, function()
        for _, t in tabs do t.Tab.Visible = false end
        SearchBar.Visible = false
    end)
end

-- === Input ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        print("[SaturnX] RightShift нажат")
        if opened then CloseGUI() else OpenGUI() end
    end
end)

print("[SaturnX] Скрипт полностью загружен (ПК-версия с лимитом FPS 240, без Kill Aura)")
