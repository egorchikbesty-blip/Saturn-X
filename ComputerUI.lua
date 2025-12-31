local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Надёжная загрузка
LocalPlayer:WaitForChild("PlayerGui")
repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
local PlayerGui = LocalPlayer.PlayerGui
print("[SaturnX] Запуск успешен")

-- === ТЕМА ===
local MAIN_BG = Color3.fromRGB(8, 12, 30)
local TAB_BG = Color3.fromRGB(12, 18, 45)
local HEADER_FROM = Color3.fromRGB(30, 60, 180)
local HEADER_TO = Color3.fromRGB(60, 20, 140)
local ACCENT_ON = Color3.fromRGB(40, 180, 255)
local TEXT_COLOR = Color3.fromRGB(220, 230, 255)
local TEXT_SECONDARY = Color3.fromRGB(140, 160, 220)

-- === Watermark ===
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
    while task.wait(1) do
        local fps = "--"
        local last = tick()
        RunService.Heartbeat:Wait()
        local delta = tick() - last
        if delta > 0 then fps = math.floor(1 / delta) end
       
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

-- === Kill Aura + HUD (с авто-экипировкой оружия) ===
local killAuraEnabled = false
local killAuraKeybind = Enum.KeyCode.Q
local bindingKey = false
local hasTarget = false

-- Список возможных названий оружия (добавь свои точные имена мечей/оружий)
local weaponNames = {"Sword", "Blade", "Knife", "Katana", "Dagger", "Axe", "Scythe", "Greatsword", "Darkheart", "Venomshank", "Illumina"}

local hud = Instance.new("TextLabel")
hud.Size = UDim2.new(0, 400, 0, 56)
hud.Position = UDim2.new(0.5, -200, 0.5, 130)
hud.BackgroundColor3 = Color3.fromRGB(8, 12, 30)
hud.BackgroundTransparency = 1
hud.TextColor3 = TEXT_COLOR
hud.TextTransparency = 1
hud.TextStrokeTransparency = 0.8
hud.Font = Enum.Font.GothamBlack
hud.TextSize = 28
hud.TextXAlignment = Enum.TextXAlignment.Center
hud.Visible = false
hud.Parent = ScreenGui
Instance.new("UICorner", hud).CornerRadius = UDim.new(0, 14)
local hudGrad = Instance.new("UIGradient", hud)
hudGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, HEADER_FROM),
    ColorSequenceKeypoint.new(1, HEADER_TO)
}

local function getBestWeapon()
    local folders = {LocalPlayer.Backpack, LocalPlayer.Character}
    for _, folder in ipairs(folders) do
        if folder then
            for _, name in ipairs(weaponNames) do
                local tool = folder:FindFirstChild(name)
                if tool and tool:IsA("Tool") then
                    return tool
                end
            end
        end
    end
    return nil
end

local function equipWeapon()
    local weapon = getBestWeapon()
    if not weapon then return false end
    
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    -- Если уже экипировано — пропускаем
    if LocalPlayer.Character:FindFirstChild(weapon.Name) then
        return true
    end
    
    humanoid:UnequipTools()
    task.wait(0.04)
    humanoid:EquipTool(weapon)
    task.wait(0.12)
    
    return LocalPlayer.Character:FindFirstChild(weapon.Name) ~= nil
end

RunService.Heartbeat:Connect(function()
    if not killAuraEnabled then
        if hasTarget then
            hasTarget = false
            TweenService:Create(hud, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            task.delay(0.3, function() hud.Visible = false end)
        end
        return
    end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    local closest = nil
    local bestDist = 13

    for _, p in Players:GetPlayers() do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    closest = p
                end
            end
        end
    end

    if closest then
        -- Авто-экипировка оружия при обнаружении цели
        equipWeapon()

        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            if tool:FindFirstChild("ToolScripts") and tool.ToolScripts:FindFirstChild("MobileSwing") then
                tool.ToolScripts.MobileSwing:Fire()
            end
            pcall(function() tool.Activated:FireServer() end)
        end

        local tRoot = closest.Character.HumanoidRootPart
        root.CFrame = root.CFrame:Lerp(CFrame.new(tRoot.Position - (tRoot.Position - root.Position).Unit * 3.2, tRoot.Position), 0.22)

        local tHum = closest.Character:FindFirstChildOfClass("Humanoid")
        if tHum then
            hud.Text = string.format("%s • HP: %d • Hits: %d", closest.DisplayName, math.floor(tHum.Health), math.ceil(tHum.Health / 35))
            if not hasTarget then
                hasTarget = true
                hud.Visible = true
                TweenService:Create(hud, TweenInfo.new(0.4), {BackgroundTransparency = 0.35, TextTransparency = 0}):Play()
            end
        end
    else
        if hasTarget then
            hasTarget = false
            TweenService:Create(hud, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            task.delay(0.3, function() hud.Visible = false end)
        end
    end
end)

-- === КНОПКА KILL AURA ===
local rageList = tabs[1].List
local kaContainer = Instance.new("Frame")
kaContainer.Size = UDim2.new(1, -20, 0, 48)
kaContainer.BackgroundColor3 = Color3.fromRGB(12, 18, 45)
kaContainer.BackgroundTransparency = 0.4
kaContainer.Parent = rageList
local kaCorner = Instance.new("UICorner", kaContainer)
kaCorner.CornerRadius = UDim.new(0, 12)
local kaLabel = Instance.new("TextLabel")
kaLabel.Size = UDim2.new(1, -140, 1, 0)
kaLabel.Position = UDim2.new(0, 16, 0, 0)
kaLabel.BackgroundTransparency = 1
kaLabel.Text = "Kill Aura"
kaLabel.TextColor3 = TEXT_COLOR
kaLabel.Font = Enum.Font.GothamBold
kaLabel.TextSize = 20
kaLabel.TextXAlignment = Enum.TextXAlignment.Left
kaLabel.Parent = kaContainer
local kaKeybindText = Instance.new("TextLabel")
kaKeybindText.Size = UDim2.new(0, 80, 0, 32)
kaKeybindText.Position = UDim2.new(1, -90, 0.5, -16)
kaKeybindText.BackgroundTransparency = 1
kaKeybindText.Text = "[" .. killAuraKeybind.Name .. "]"
kaKeybindText.TextColor3 = Color3.fromRGB(120, 160, 255)
kaKeybindText.Font = Enum.Font.Gotham
kaKeybindText.TextSize = 18
kaKeybindText.TextXAlignment = Enum.TextXAlignment.Center
kaKeybindText.Parent = kaContainer
local function updateKAVisual()
    local isOn = killAuraEnabled
    TweenService:Create(kaLabel, TweenInfo.new(0.4), {TextColor3 = isOn and ACCENT_ON or TEXT_COLOR}):Play()
    TweenService:Create(kaKeybindText, TweenInfo.new(0.4), {TextColor3 = isOn and ACCENT_ON or Color3.fromRGB(120, 160, 255)}):Play()
end
updateKAVisual()
kaContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not bindingKey then
        killAuraEnabled = not killAuraEnabled
        updateKAVisual()
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        bindingKey = true
        kaKeybindText.Text = "[...]"
        kaKeybindText.TextColor3 = Color3.new(1, 1, 0)
    end
end)
AddToSearch(kaContainer, {"kill aura", "killaura", "killora", "auto attack", "auto hit", "combat", "rage", "target"})

-- === TP SPEED (в Movement) ===
local TPSpeed = {
    Enabled = false,
    Delay = 1.1,     -- ~7 studs/sec — безопасно для Knightmare
    Distance = 8
}

local lastTPSpeed = 0
local tpConnection = nil

local function startTPSpeed()
    if tpConnection then tpConnection:Disconnect() end
    
    tpConnection = RunService.Heartbeat:Connect(function()
        if not TPSpeed.Enabled then return end
        
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        if not character:FindFirstChild("Humanoid") then return end
        
        local humanoid = character.Humanoid
        local root = character.HumanoidRootPart
        
        -- Тепаем ТОЛЬКО если игрок реально идёт (WASD)
        if humanoid.MoveDirection.Magnitude == 0 then
            return  -- Стоим → ничего не делаем
        end
        
        local now = tick()
        if now - lastTPSpeed < TPSpeed.Delay then return end
        
        local moveDir = Vector3.new(humanoid.MoveDirection.X, 0, humanoid.MoveDirection.Z)
        
        root.CFrame = root.CFrame + moveDir * TPSpeed.Distance
        
        lastTPSpeed = now
    end)
end

-- === КНОПКА TP SPEED в Movement ===
local movementList = tabs[2].List
local tpSpeedContainer = Instance.new("Frame")
tpSpeedContainer.Size = UDim2.new(1, -20, 0, 48)
tpSpeedContainer.BackgroundColor3 = Color3.fromRGB(12, 18, 45)
tpSpeedContainer.BackgroundTransparency = 0.4
tpSpeedContainer.Parent = movementList
local tpSpeedCorner = Instance.new("UICorner", tpSpeedContainer)
tpSpeedCorner.CornerRadius = UDim.new(0, 12)
local tpSpeedLabel = Instance.new("TextLabel")
tpSpeedLabel.Size = UDim2.new(1, -140, 1, 0)
tpSpeedLabel.Position = UDim2.new(0, 16, 0, 0)
tpSpeedLabel.BackgroundTransparency = 1
tpSpeedLabel.Text = "TP Speed"
tpSpeedLabel.TextColor3 = TEXT_COLOR
tpSpeedLabel.Font = Enum.Font.GothamBold
tpSpeedLabel.TextSize = 20
tpSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
tpSpeedLabel.Parent = tpSpeedContainer
local tpSpeedKeybindText = Instance.new("TextLabel")
tpSpeedKeybindText.Size = UDim2.new(0, 80, 0, 32)
tpSpeedKeybindText.Position = UDim2.new(1, -90, 0.5, -16)
tpSpeedKeybindText.BackgroundTransparency = 1
tpSpeedKeybindText.Text = "[V]"
tpSpeedKeybindText.TextColor3 = Color3.fromRGB(120, 160, 255)
tpSpeedKeybindText.Font = Enum.Font.Gotham
tpSpeedKeybindText.TextSize = 18
tpSpeedKeybindText.TextXAlignment = Enum.TextXAlignment.Center
tpSpeedKeybindText.Parent = tpSpeedContainer

local tpSpeedKeybind = Enum.KeyCode.V
local tpSpeedBinding = false

local function updateTPSpeedVisual()
    local isOn = TPSpeed.Enabled
    TweenService:Create(tpSpeedLabel, TweenInfo.new(0.4), {TextColor3 = isOn and ACCENT_ON or TEXT_COLOR}):Play()
    TweenService:Create(tpSpeedKeybindText, TweenInfo.new(0.4), {TextColor3 = isOn and ACCENT_ON or Color3.fromRGB(120, 160, 255)}):Play()
end
updateTPSpeedVisual()

tpSpeedContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not tpSpeedBinding then
        TPSpeed.Enabled = not TPSpeed.Enabled
        if TPSpeed.Enabled then 
            startTPSpeed() 
        else 
            if tpConnection then tpConnection:Disconnect() end 
        end
        updateTPSpeedVisual()
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        tpSpeedBinding = true
        tpSpeedKeybindText.Text = "[...]"
        tpSpeedKeybindText.TextColor3 = Color3.new(1, 1, 0)
    end
end)
AddToSearch(tpSpeedContainer, {"tp speed", "teleport speed", "speed", "movement", "teleport forward"})

-- === TRACERS ===
local tracersEnabled = false
local tracersKeybind = Enum.KeyCode.Home
local tracersBinding = false
local tracersConnection
local tracersTable = {}
local tracersGlobalTime = 0

local function getSoftColor(offset)
    local t = tracersGlobalTime + offset
    local hue = (t * 28) % 360
    local saturation = 0.45 + 0.20 * math.sin(t * 1.6)
    local brightness = 0.85 + 0.15 * math.sin(t * 2.1 + 1.2)
    return Color3.fromHSV(hue / 360, saturation, brightness)
end

local function createTracer()
    local core = Drawing.new("Line")
    core.Thickness = 1.8
    local glow1 = Drawing.new("Line")
    glow1.Thickness = 4
    local glow2 = Drawing.new("Line")
    glow2.Thickness = 7
    local label = Drawing.new("Text")
    label.Size = 19
    label.Center = true
    label.Outline = true
    label.Font = Drawing.Fonts.Plex
    label.Color = Color3.new(1, 1, 1)
    return { Core = core, Glow1 = glow1, Glow2 = glow2, Label = label }
end

local function hideTracer(tracer)
    tracer.Core.Visible = false
    tracer.Glow1.Visible = false
    tracer.Glow2.Visible = false
    tracer.Label.Visible = false
end

local function clearAllTracers()
    for _, t in pairs(tracersTable) do hideTracer(t) end
end

local function startTracers()
    if tracersConnection then tracersConnection:Disconnect() end
    clearAllTracers()
    tracersGlobalTime = 0
    tracersConnection = RunService.Heartbeat:Connect(function(dt)
        tracersGlobalTime += dt
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local count = 0
        for _, plr in Players:GetPlayers() do
            if count >= 40 then break end
            if plr == LocalPlayer or not plr.Character then continue end
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChild("Humanoid")
            if not root or not hum or hum.Health <= 0 then continue end
            local dist = (root.Position - myPos).Magnitude
            if dist > 2000 then continue end
            count += 1
            local fade = math.clamp(1 - dist / 2000, 0.4, 1)
            local breathe = 0.94 + 0.06 * math.sin(tracersGlobalTime * 3.5)
            local foot = root.Position - Vector3.new(0, 3, 0)
            local scr, onScreen = Camera:WorldToViewportPoint(foot)
            local pos2D = Vector2.new(scr.X, scr.Y)
            if not onScreen or scr.Z < 0 then
                local dir = (pos2D - center).Unit
                pos2D = center + dir * math.min(center.X, center.Y) * 0.92
            end
            local mid = center + (pos2D - center) * 0.70
            local tracer = tracersTable[plr] or createTracer()
            tracersTable[plr] = tracer
            tracer.Core.From = center
            tracer.Core.To = mid
            tracer.Core.Color = Color3.new(1, 1, 1)
            tracer.Core.Transparency = fade * breathe
            tracer.Core.Visible = true
            tracer.Glow1.From = center
            tracer.Glow1.To = mid
            tracer.Glow1.Color = getSoftColor(tracersGlobalTime)
            tracer.Glow1.Transparency = fade * 0.42
            tracer.Glow1.Visible = true
            tracer.Glow2.From = center
            tracer.Glow2.To = mid
            tracer.Glow2.Color = getSoftColor(tracersGlobalTime + 1.4)
            tracer.Glow2.Transparency = fade * 0.22
            tracer.Glow2.Visible = true
            tracer.Label.Position = mid + Vector2.new(0, -18)
            tracer.Label.Text = string.format("%s • %dm", plr.DisplayName or plr.Name, math.floor(dist))
            tracer.Label.Transparency = fade * breathe
            tracer.Label.Visible = true
        end
    end)
end

-- === КНОПКА TRACERS ===
local visualsList = tabs[3].List
local tracersContainer = Instance.new("Frame")
tracersContainer.Size = UDim2.new(1, -20, 0, 48)
tracersContainer.BackgroundColor3 = Color3.fromRGB(12, 18, 45)
tracersContainer.BackgroundTransparency = 0.4
tracersContainer.Parent = visualsList
local tracersCorner = Instance.new("UICorner", tracersContainer)
tracersCorner.CornerRadius = UDim.new(0, 12)
local tracersLabel = Instance.new("TextLabel")
tracersLabel.Size = UDim2.new(1, -140, 1, 0)
tracersLabel.Position = UDim2.new(0, 16, 0, 0)
tracersLabel.BackgroundTransparency = 1
tracersLabel.Text = "Tracers"
tracersLabel.TextColor3 = TEXT_COLOR
tracersLabel.Font = Enum.Font.GothamBold
tracersLabel.TextSize = 20
tracersLabel.TextXAlignment = Enum.TextXAlignment.Left
tracersLabel.Parent = tracersContainer
local tracersKeybindText = Instance.new("TextLabel")
tracersKeybindText.Size = UDim2.new(0, 80, 0, 32)
tracersKeybindText.Position = UDim2.new(1, -90, 0.5, -16)
tracersKeybindText.BackgroundTransparency = 1
tracersKeybindText.Text = "[" .. tracersKeybind.Name .. "]"
tracersKeybindText.TextColor3 = Color3.fromRGB(120, 160, 255)
tracersKeybindText.Font = Enum.Font.Gotham
tracersKeybindText.TextSize = 18
tracersKeybindText.TextXAlignment = Enum.TextXAlignment.Center
tracersKeybindText.Parent = tracersContainer
local function updateTracersVisual()
    local isOn = tracersEnabled
    TweenService:Create(tracersLabel, TweenInfo.new(0.4), {TextColor3 = isOn and ACCENT_ON or TEXT_COLOR}):Play()
    TweenService:Create(tracersKeybindText, TweenInfo.new(0.4), {TextColor3 = isOn and ACCENT_ON or Color3.fromRGB(120, 160, 255)}):Play()
end
updateTracersVisual()
tracersContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not tracersBinding then
        tracersEnabled = not tracersEnabled
        if tracersEnabled then startTracers() else if tracersConnection then tracersConnection:Disconnect() end clearAllTracers() end
        updateTracersVisual()
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        tracersBinding = true
        tracersKeybindText.Text = "[...]"
        tracersKeybindText.TextColor3 = Color3.new(1, 1, 0)
    end
end)
AddToSearch(tracersContainer, {"tracers", "ethereal tracers", "lines", "esp", "visuals", "player lines"})

-- === УЛУЧШЕННЫЙ AUTO HEAL (АДАПТИВНАЯ ЗАДЕРЖКА) ===
local autoHealEnabled = false
local autoHealKeybind = Enum.KeyCode.C
local autoHealBinding = false
local healing = false
local equippedTool = nil
local foodPriority = {"Pizza", "Cake", "Cookie", "Apple"}
local autoHealConnection

local function hasFood()
    local searchFolders = {LocalPlayer.Backpack, LocalPlayer:FindFirstChild("StarterPack"), LocalPlayer.Character}
    for _, folder in ipairs(searchFolders) do
        if folder then
            for _, name in ipairs(foodPriority) do
                if folder:FindFirstChild(name) and folder:FindFirstChild(name):IsA("Tool") then
                    return true
                end
            end
        end
    end
    return false
end

local function getBestFood()
    local searchFolders = {LocalPlayer.Backpack, LocalPlayer:FindFirstChild("StarterPack"), LocalPlayer.Character}
    for _, folder in ipairs(searchFolders) do
        if folder then
            for _, name in ipairs(foodPriority) do
                local tool = folder:FindFirstChild(name)
                if tool and tool:IsA("Tool") then
                    return tool
                end
            end
        end
    end
    return nil
end

local function equipAndHeal()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    local bestFood = getBestFood()
    if not bestFood then return false end
    
    humanoid:UnequipTools()
    task.wait(0.02)
    humanoid:EquipTool(bestFood)
    task.wait(0.06)
    
    equippedTool = LocalPlayer.Character:FindFirstChild(bestFood.Name)
    return equippedTool ~= nil
end

local function eatFood()
    if not equippedTool then return end
    
    pcall(function()
        if equippedTool:FindFirstChild("Activated") then
            fireclickdetector(equippedTool:FindFirstChildWhichIsA("ClickDetector")) -- иногда помогает
        end
        equippedTool.Activated:Fire()
    end)
    
    local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("GameEvents") or ReplicatedStorage:FindFirstChild("Events")
    if remotes then
        local eatRemote = remotes:FindFirstChild("EatFood") or remotes:FindFirstChild("UseFood") or remotes:FindFirstChild("Eat") or remotes:FindFirstChild("Consume")
        if eatRemote then
            eatRemote:FireServer(equippedTool.Name)
        end
    end
    
    pcall(mouse1click)
end

local function startAutoHeal()
    if autoHealConnection then autoHealConnection:Disconnect() end
    autoHealConnection = RunService.Heartbeat:Connect(function()
        if not autoHealEnabled or not LocalPlayer.Character then return end
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health >= 100 or humanoid.Health <= 0 then return end
        
        if humanoid.Health <= 80 and not healing and hasFood() then
            healing = true
            if equipAndHeal() then
                task.spawn(function()
                    local attempts = 0
                    while humanoid.Health < 100 and equippedTool and equippedTool.Parent == LocalPlayer.Character and attempts < 250 do
                        eatFood()
                        -- Адаптивная задержка: яблоки быстро, остальное с запасом
                        if equippedTool.Name == "Apple" then
                            task.wait(0.03) -- ультра-быстро
                        else
                            task.wait(0.09) -- надёжно для тяжёлой еды
                        end
                        attempts += 1
                    end
                    humanoid:UnequipTools()
                    equippedTool = nil
                    healing = false
                end)
            else
                healing = false
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if autoHealEnabled then
        task.wait(1)
        startAutoHeal()
    end
end)

-- === КНОПКА AUTO HEAL ===
local playerList = tabs[4].List
local autoHealContainer = Instance.new("Frame")
autoHealContainer.Size = UDim2.new(1, -20, 0, 48)
autoHealContainer.BackgroundColor3 = Color3.fromRGB(12, 18, 45)
autoHealContainer.BackgroundTransparency = 0.4
autoHealContainer.Parent = playerList
local autoHealCorner = Instance.new("UICorner", autoHealContainer)
autoHealCorner.CornerRadius = UDim.new(0, 12)
local autoHealLabel = Instance.new("TextLabel")
autoHealLabel.Size = UDim2.new(1, -140, 1, 0)
autoHealLabel.Position = UDim2.new(0, 16, 0, 0)
autoHealLabel.BackgroundTransparency = 1
autoHealLabel.Text = "Auto Heal"
autoHealLabel.TextColor3 = TEXT_COLOR
autoHealLabel.Font = Enum.Font.GothamBold
autoHealLabel.TextSize = 20
autoHealLabel.TextXAlignment = Enum.TextXAlignment.Left
autoHealLabel.Parent = autoHealContainer
local autoHealKeybindText = Instance.new("TextLabel")
autoHealKeybindText.Size = UDim2.new(0, 80, 0, 32)
autoHealKeybindText.Position = UDim2.new(1, -90, 0.5, -16)
autoHealKeybindText.BackgroundTransparency = 1
autoHealKeybindText.Text = "[" .. autoHealKeybind.Name .. "]"
autoHealKeybindText.TextColor3 = Color3.fromRGB(120, 160, 255)
autoHealKeybindText.Font = Enum.Font.Gotham
autoHealKeybindText.TextSize = 18
autoHealKeybindText.TextXAlignment = Enum.TextXAlignment.Center
autoHealKeybindText.Parent = autoHealContainer
local function updateAutoHealVisual()
    local isOn = autoHealEnabled
    TweenService:Create(autoHealLabel, TweenInfo.new(0.4), {TextColor3 = isOn and ACCENT_ON or TEXT_COLOR}):Play()
    TweenService:Create(autoHealKeybindText, TweenInfo.new(0.4), {TextColor3 = isOn and ACCENT_ON or Color3.fromRGB(120, 160, 255)}):Play()
end
updateAutoHealVisual()
autoHealContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not autoHealBinding then
        autoHealEnabled = not autoHealEnabled
        if autoHealEnabled then startAutoHeal() else 
            if autoHealConnection then autoHealConnection:Disconnect() end 
            healing = false 
            equippedTool = nil 
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
                LocalPlayer.Character.Humanoid:UnequipTools() 
            end 
        end
        updateAutoHealVisual()
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        autoHealBinding = true
        autoHealKeybindText.Text = "[...]"
        autoHealKeybindText.TextColor3 = Color3.new(1, 1, 0)
    end
end)
AddToSearch(autoHealContainer, {"auto heal", "heal", "food", "hp", "auto eat", "health"})

-- === ESP TRAPS ===
local trapEspEnabled = false
local trapEspKeybind = Enum.KeyCode.F
local trapEspBinding = false
local espCircles = {}
local trapCache = {}
local alertSound = Instance.new("Sound")
alertSound.SoundId = "rbxassetid://2767090"
alertSound.Volume = 0.5
alertSound.Parent = Workspace
local lastAlertTime = 0
local lastCacheUpdate = 0
local trapEspConnection

local function createCircle(model)
    local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not primary then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = primary
    billboard.Size = UDim2.new(0, 120, 0, 120)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.Parent = primary
    billboard.AlwaysOnTop = true

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.BackgroundTransparency = 1
    circle.Parent = billboard

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(1, 0, 0)
    stroke.Thickness = 4
    stroke.Parent = circle

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "TRAP"
    text.TextColor3 = Color3.new(1, 0.2, 0.2)
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.new(0, 0, 0)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 18
    text.Parent = circle

    return billboard
end

local function isInFOV(part)
    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen then return false end
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
    return dist <= 400
end

local function isPlayerPart(model)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and model:IsDescendantOf(p.Character) then return true end
    end
    return false
end

local function updateTrapCache()
    trapCache = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("Folder")) and #trapCache < 100 then
            local name = obj.Name:lower()
            local parentName = obj.Parent and obj.Parent.Name:lower() or ""
            if name:find("trap") or name:find("beartrap") or name:find("thorn") or parentName:find("trap") then
                if not isPlayerPart(obj) then
                    table.insert(trapCache, obj)
                end
            end
        end
    end
end

local function scanTraps()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = LocalPlayer.Character.HumanoidRootPart

    local nearTrap = false

    if tick() - lastCacheUpdate > 5 then
        updateTrapCache()
        lastCacheUpdate = tick()
    end

    local activeESP = 0
    for model, gui in pairs(espCircles) do
        if activeESP > 30 then
            gui:Destroy()
            espCircles[model] = nil
        else
            activeESP += 1
        end
        if not model.Parent then
            gui:Destroy()
            espCircles[model] = nil
        end
    end

    for _, model in pairs(trapCache) do
        local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
        if primary and isInFOV(primary) then
            if trapEspEnabled then
                if not espCircles[model] then
                    espCircles[model] = createCircle(model)
                end
                local dist = (primary.Position - rootPart.Position).Magnitude
                if dist < 25 then nearTrap = true end
            end
        end
    end

    if nearTrap and tick() - lastAlertTime > 2 then
        alertSound:Play()
        lastAlertTime = tick()
    end
end

local function startTrapEsp()
    if trapEspConnection then trapEspConnection:Disconnect() end
    updateTrapCache()
    trapEspConnection = RunService.Stepped:Connect(scanTraps)
end

-- === КНОПКА ESP TRAPS ===
local trapEspContainer = Instance.new("Frame")
trapEspContainer.Size = UDim2.new(1, -20, 0, 48)
trapEspContainer.BackgroundColor3 = Color3.fromRGB(12, 18, 45)
trapEspContainer.BackgroundTransparency = 0.4
trapEspContainer.Parent = visualsList
local trapEspCorner = Instance.new("UICorner", trapEspContainer)
trapEspCorner.CornerRadius = UDim.new(0, 12)
local trapEspLabel = Instance.new("TextLabel")
trapEspLabel.Size = UDim2.new(1, -140, 1, 0)
trapEspLabel.Position = UDim2.new(0, 16, 0, 0)
trapEspLabel.BackgroundTransparency = 1
trapEspLabel.Text = "Esp Traps"
trapEspLabel.TextColor3 = TEXT_COLOR
trapEspLabel.Font = Enum.Font.GothamBold
trapEspLabel.TextSize = 20
trapEspLabel.TextXAlignment = Enum.TextXAlignment.Left
trapEspLabel.Parent = trapEspContainer
local trapEspKeybindText = Instance.new("TextLabel")
trapEspKeybindText.Size = UDim2.new(0, 80, 0, 32)
trapEspKeybindText.Position = UDim2.new(1, -90, 0.5, -16)
trapEspKeybindText.BackgroundTransparency = 1
trapEspKeybindText.Text = "[" .. trapEspKeybind.Name .. "]"
trapEspKeybindText.TextColor3 = Color3.fromRGB(120, 160, 255)
trapEspKeybindText.Font = Enum.Font.Gotham
trapEspKeybindText.TextSize = 18
trapEspKeybindText.TextXAlignment = Enum.TextXAlignment.Center
trapEspKeybindText.Parent = trapEspContainer
local function updateTrapEspVisual()
    local isOn = trapEspEnabled
    TweenService:Create(trapEspLabel, TweenInfo.new(0.4), {TextColor3 = isOn and ACCENT_ON or TEXT_COLOR}):Play()
    TweenService:Create(trapEspKeybindText, TweenInfo.new(0.4), {TextColor3 = isOn and ACCENT_ON or Color3.fromRGB(120, 160, 255)}):Play()
end
updateTrapEspVisual()
trapEspContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not trapEspBinding then
        trapEspEnabled = not trapEspEnabled
        if trapEspEnabled then startTrapEsp() else if trapEspConnection then trapEspConnection:Disconnect() end for _, gui in pairs(espCircles) do gui:Destroy() end espCircles = {} end
        updateTrapEspVisual()
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        trapEspBinding = true
        trapEspKeybindText.Text = "[...]"
        trapEspKeybindText.TextColor3 = Color3.new(1, 1, 0)
    end
end)
AddToSearch(trapEspContainer, {"esp traps", "traps esp", "trap esp", "beartrap", "thorn", "visuals", "esp"})

-- === АНИМАЦИИ GUI ===
local opened = false
local function OpenGUI()
    opened = true
    print("[SaturnX] GUI открывается...")
    kaContainer.Visible = true
    tpSpeedContainer.Visible = true
    tracersContainer.Visible = true
    autoHealContainer.Visible = true
    trapEspContainer.Visible = true
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
    TweenService:Create(kaContainer, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
    TweenService:Create(tpSpeedContainer, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
    TweenService:Create(tracersContainer, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
    TweenService:Create(autoHealContainer, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
    TweenService:Create(trapEspContainer, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
    for _, t in tabs do
        TweenService:Create(t.Tab, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(t.Header, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(t.Title, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(t.Shadow, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
    end
    TweenService:Create(SearchBar, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(SearchBox, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.4), {Size = 0}):Play()
    task.delay(0.4, function()
        kaContainer.Visible = false
        tpSpeedContainer.Visible = false
        tracersContainer.Visible = false
        autoHealContainer.Visible = false
        trapEspContainer.Visible = false
        for _, t in tabs do t.Tab.Visible = false end
        SearchBar.Visible = false
    end)
end

-- === Input ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if opened then CloseGUI() else OpenGUI() end
        return
    end

    if bindingKey and input.UserInputType == Enum.UserInputType.Keyboard then
        killAuraKeybind = input.KeyCode
        kaKeybindText.Text = "[" .. input.KeyCode.Name .. "]"
        kaKeybindText.TextColor3 = Color3.fromRGB(120, 160, 255)
        bindingKey = false
        return
    end
    if input.KeyCode == killAuraKeybind then
        killAuraEnabled = not killAuraEnabled
        updateKAVisual()
    end

    if tracersBinding and input.UserInputType == Enum.UserInputType.Keyboard then
        tracersKeybind = input.KeyCode
        tracersKeybindText.Text = "[" .. input.KeyCode.Name .. "]"
        tracersKeybindText.TextColor3 = Color3.fromRGB(120, 160, 255)
        tracersBinding = false
        return
    end
    if input.KeyCode == tracersKeybind then
        tracersEnabled = not tracersEnabled
        if tracersEnabled then startTracers() else if tracersConnection then tracersConnection:Disconnect() end clearAllTracers() end
        updateTracersVisual()
    end

    if autoHealBinding and input.UserInputType == Enum.UserInputType.Keyboard then
        autoHealKeybind = input.KeyCode
        autoHealKeybindText.Text = "[" .. input.KeyCode.Name .. "]"
        autoHealKeybindText.TextColor3 = Color3.fromRGB(120, 160, 255)
        autoHealBinding = false
        return
    end
    if input.KeyCode == autoHealKeybind then
        autoHealEnabled = not autoHealEnabled
        if autoHealEnabled then startAutoHeal() else 
            if autoHealConnection then autoHealConnection:Disconnect() end 
            healing = false 
            equippedTool = nil 
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then 
                LocalPlayer.Character.Humanoid:UnequipTools() 
            end 
        end
        updateAutoHealVisual()
    end

    if trapEspBinding and input.UserInputType == Enum.UserInputType.Keyboard then
        trapEspKeybind = input.KeyCode
        trapEspKeybindText.Text = "[" .. input.KeyCode.Name .. "]"
        trapEspKeybindText.TextColor3 = Color3.fromRGB(120, 160, 255)
        trapEspBinding = false
        return
    end
    if input.KeyCode == trapEspKeybind then
        trapEspEnabled = not trapEspEnabled
        if trapEspEnabled then startTrapEsp() else if trapEspConnection then trapEspConnection:Disconnect() end for _, gui in pairs(espCircles) do gui:Destroy() end espCircles = {} end
        updateTrapEspVisual()
    end

    if tpSpeedBinding and input.UserInputType == Enum.UserInputType.Keyboard then
        tpSpeedKeybind = input.KeyCode
        tpSpeedKeybindText.Text = "[" .. input.KeyCode.Name .. "]"
        tpSpeedKeybindText.TextColor3 = Color3.fromRGB(120, 160, 255)
        tpSpeedBinding = false
        return
    end
    if input.KeyCode == tpSpeedKeybind then
        TPSpeed.Enabled = not TPSpeed.Enabled
        if TPSpeed.Enabled then startTPSpeed() else if tpConnection then tpConnection:Disconnect() end end
        updateTPSpeedVisual()
    end
end)

print("[SaturnX] Загружено с Kill Aura + авто-экипировкой оружия + новый TP Speed (только при ходьбе)")
