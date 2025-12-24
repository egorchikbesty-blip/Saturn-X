local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
local TEXT_COLOR = Color3.fromRGB(220, 230, 255)

-- === WATERMARK (FPS лимит 240) ===
local watermarkGui = Instance.new("ScreenGui")
watermarkGui.Name = "SaturnX_Watermark"
watermarkGui.ResetOnSpawn = false
watermarkGui.DisplayOrder = 999999
watermarkGui.Parent = PlayerGui

local watermarkFrame = Instance.new("Frame")
watermarkFrame.Size = UDim2.new(0, 200, 0, 36)
watermarkFrame.Position = UDim2.new(0, 12, 0, 12)
watermarkFrame.BackgroundColor3 = MAIN_BG
watermarkFrame.BackgroundTransparency = 0.5
watermarkFrame.BorderSizePixel = 0
watermarkFrame.Parent = watermarkGui
Instance.new("UICorner", watermarkFrame).CornerRadius = UDim.new(0, 8)

local watermarkLabel = Instance.new("TextLabel")
watermarkLabel.Size = UDim2.new(1, -16, 1, 0)
watermarkLabel.Position = UDim2.new(0, 16, 0, 0)
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Text = "Saturn-X • FPS: -- • PING: -- ms"
watermarkLabel.TextColor3 = TEXT_COLOR
watermarkLabel.TextTransparency = 0
watermarkLabel.TextSize = 13
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
    Tab.Size = UDim2.new(0, 130, 0, 270)
    Tab.Position = UDim2.new(0.5, xOffset - 65, 0.5, -135)
    Tab.BackgroundColor3 = TAB_BG
    Tab.BackgroundTransparency = 1
    Tab.Visible = true
    Tab.Parent = ScreenGui
    Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 8)

    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 22, 1, 22)
    Shadow.Position = UDim2.new(0, -11, 0, -11)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.new(0,0,0)
    Shadow.ImageTransparency = 1
    Shadow.ZIndex = 0
    Shadow.Parent = Tab

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 38)
    Header.BackgroundTransparency = 1
    Header.Parent = Tab
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

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
    TitleLabel.TextSize = 17
    TitleLabel.Parent = Header

    local List = Instance.new("ScrollingFrame")
    List.Size = UDim2.new(1, -12, 1, -45)
    List.Position = UDim2.new(0, 6, 0, 40)
    List.BackgroundTransparency = 1
    List.ScrollBarThickness = 2
    List.ScrollBarImageColor3 = Color3.fromRGB(80, 140, 255)
    List.AutomaticCanvasSize = Enum.AutomaticSize.Y
    List.Parent = Tab

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 4)
    Layout.Parent = List

    return {Tab = Tab, Header = Header, Title = TitleLabel, Shadow = Shadow, List = List}
end

-- Расстояние между табами
local tabs = {
    CreateTab("Rage", -300),
    CreateTab("Movement", -150),
    CreateTab("Visuals", 0),
    CreateTab("Player", 150),
    CreateTab("Utility", 300)
}

-- === ПЛАВНОЕ ПОЯВЛЕНИЕ ===
task.spawn(function()
    task.wait(0.3)

    TweenService:Create(BlurEffect, TweenInfo.new(0.8), {Size = 10}):Play()

    local tween = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    for _, t in tabs do
        TweenService:Create(t.Shadow, TweenInfo.new(0.9), {ImageTransparency = 0.5}):Play()
        TweenService:Create(t.Tab, tween, {BackgroundTransparency = 0.4}):Play()
        TweenService:Create(t.Header, tween, {BackgroundTransparency = 0}):Play()
        TweenService:Create(t.Title, tween, {TextTransparency = 0}):Play()
    end
end)

print("[SaturnX] Поисковая панель удалена — GUI максимально чистый!")
