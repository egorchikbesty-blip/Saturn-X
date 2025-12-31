local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Ждём персонажа
while not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
    task.wait(0.5)
end

-- Главный GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SaturnX_Tabs"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Тема
local MAIN_BG = Color3.fromRGB(8, 12, 30)
local TAB_BG = Color3.fromRGB(12, 18, 45)
local HEADER_FROM = Color3.fromRGB(30, 60, 180)
local HEADER_TO = Color3.fromRGB(60, 20, 140)
local TEXT_COLOR = Color3.fromRGB(220, 230, 255)
local ACCENT_ON = Color3.fromRGB(40, 180, 255)
local HOVER_COLOR = Color3.fromRGB(20, 25, 55)

-- Watermark
local watermarkFrame = Instance.new("Frame")
watermarkFrame.Size = UDim2.new(0, 200, 0, 36)
watermarkFrame.Position = UDim2.new(0, 12, 0, 12)
watermarkFrame.BackgroundColor3 = MAIN_BG
watermarkFrame.BackgroundTransparency = 0.5
watermarkFrame.Parent = ScreenGui
Instance.new("UICorner", watermarkFrame).CornerRadius = UDim.new(0, 8)

local watermarkLabel = Instance.new("TextLabel")
watermarkLabel.Size = UDim2.new(1, -16, 1, 0)
watermarkLabel.Position = UDim2.new(0, 16, 0, 0)
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Text = "Saturn-X • FPS: -- • PING: -- ms"
watermarkLabel.TextColor3 = TEXT_COLOR
watermarkLabel.TextSize = 13
watermarkLabel.Font = Enum.Font.GothamBold
watermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
watermarkLabel.Parent = watermarkFrame

task.spawn(function()
    while task.wait(1) do
        local last = tick()
        RunService.Heartbeat:Wait()
        local delta = tick() - last
        local fps = delta > 0 and math.floor(1 / delta) or "--"

        local ping = "--"
        pcall(function()
            if Stats.Network and Stats.Network.ServerStatsItem["Data Ping"] then
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end
        end)

        watermarkLabel.Text = string.format("Saturn-X • FPS: %s • PING: %s ms", fps, ping)
    end
end)

-- Кнопка SX
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 80, 0, 80)
ToggleButton.Position = UDim2.new(1, -100, 1, -250)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 60, 180)
ToggleButton.Text = "SX"
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.TextSize = 36
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui
ToggleButton.ZIndex = 10
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 20)

-- Драг SX (Mouse + Touch)
local draggingSX = false
local dragStartSX, startPosSX
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSX = true
        dragStartSX = input.Position
        startPosSX = ToggleButton.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingSX and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartSX
        ToggleButton.Position = UDim2.new(startPosSX.X.Scale, startPosSX.X.Offset + delta.X, startPosSX.Y.Scale, startPosSX.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSX = false
    end
end)

-- Создание табов
local function CreateTab(title, xOffset)
    local Tab = Instance.new("Frame")
    Tab.Size = UDim2.new(0, 140, 0, 300)
    Tab.Position = UDim2.new(0.5, xOffset - 70, 0.5, -150)
    Tab.BackgroundColor3 = TAB_BG
    Tab.BackgroundTransparency = 1
    Tab.Visible = false
    Tab.Parent = ScreenGui
    Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 12)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundTransparency = 1
    Header.Parent = Tab
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, HEADER_FROM), ColorSequenceKeypoint.new(1, HEADER_TO)}
    Gradient.Rotation = 90
    Gradient.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.new(1,1,1)
    TitleLabel.TextTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.Parent = Header

    local List = Instance.new("ScrollingFrame")
    List.Size = UDim2.new(1, -10, 1, -50)
    List.Position = UDim2.new(0, 5, 0, 45)
    List.BackgroundTransparency = 1
    List.ScrollBarThickness = 3
    List.ScrollBarImageColor3 = Color3.fromRGB(80, 140, 255)
    List.AutomaticCanvasSize = Enum.AutomaticSize.Y
    List.Parent = Tab

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = List

    return List, Tab, Header, TitleLabel
end

local rageList, rageTab, rageHeader, rageTitle = CreateTab("Rage", -300)
local movementList, movementTab, movementHeader, movementTitle = CreateTab("Movement", -150)
local visualsList, visualsTab, visualsHeader, visualsTitle = CreateTab("Visuals", 0)
local playerList, playerTab, playerHeader, playerTitle = CreateTab("Player", 150)
local utilityList, utilityTab, utilityHeader, utilityTitle = CreateTab("Utility", 300)

-- Постоянные кнопки от стрелки
local floatingButtons = {}
local buttonIndex = 0

local function createFloatingButton(text, toggleFunc, getStateFunc)
    if floatingButtons[text] then return end

    buttonIndex = buttonIndex + 1
    local shortText = text:sub(1,2):upper()

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 0, 70)
    btn.Position = UDim2.new(1, -90, 0, 20 + (buttonIndex - 1) * 80)
    btn.BackgroundColor3 = Color3.fromRGB(20, 25, 55)
    btn.Text = shortText
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 24
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = ScreenGui
    btn.ZIndex = 15

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = btn

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, HEADER_FROM), ColorSequenceKeypoint.new(1, HEADER_TO)}
    gradient.Rotation = 90
    gradient.Enabled = false
    gradient.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = ACCENT_ON
    stroke.Thickness = 3
    stroke.Transparency = 1
    stroke.Parent = btn

    -- Драг (Mouse + Touch)
    local dragging = false
    local dragStart, startPos
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local function updateVisual()
        local state = getStateFunc()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = state and ACCENT_ON or Color3.fromRGB(20, 25, 55)}):Play()
        gradient.Enabled = state
        TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = state and 0 or 1}):Play()
    end

    btn.MouseButton1Click:Connect(function()
        toggleFunc()
        updateVisual()
    end)

    updateVisual()
    floatingButtons[text] = {btn = btn, update = updateVisual}
end

-- Кнопка в меню (красивая, драгаемая, поддержка Touch)
local function CreateFeatureButton(parent, text)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 50)
    Button.BackgroundColor3 = TAB_BG
    Button.BackgroundTransparency = 0.4
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = Button

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -80, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = TEXT_COLOR
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 18
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    local ArrowVisual = Instance.new("TextLabel")
    ArrowVisual.Size = UDim2.new(0, 35, 0, 35)
    ArrowVisual.Position = UDim2.new(1, -45, 0.5, -17.5)
    ArrowVisual.BackgroundTransparency = 1
    ArrowVisual.Text = "▶"
    ArrowVisual.TextColor3 = Color3.fromRGB(140, 160, 220)
    ArrowVisual.TextSize = 30
    ArrowVisual.Font = Enum.Font.GothamBold
    ArrowVisual.Rotation = -90
    ArrowVisual.Parent = Button

    local ArrowButton = Instance.new("TextButton")
    ArrowButton.Size = UDim2.new(0, 70, 1, 0)
    ArrowButton.Position = UDim2.new(1, -70, 0, 0)
    ArrowButton.BackgroundTransparency = 1
    ArrowButton.Text = ""
    ArrowButton.ZIndex = 30
    ArrowButton.Parent = Button

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, HEADER_FROM), ColorSequenceKeypoint.new(1, HEADER_TO)}
    gradient.Rotation = 90
    gradient.Enabled = false
    gradient.Parent = Button

    local stroke = Instance.new("UIStroke")
    stroke.Color = ACCENT_ON
    stroke.Thickness = 2
    stroke.Transparency = 1
    stroke.Parent = Button

    local state = false

    local function updateVisual()
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundTransparency = state and 0.2 or 0.4}):Play()
        TweenService:Create(Label, TweenInfo.new(0.3), {TextColor3 = state and Color3.new(1,1,1) or TEXT_COLOR}):Play()
        TweenService:Create(ArrowVisual, TweenInfo.new(0.3), {
            Rotation = state and 0 or -90,
            TextColor3 = state and ACCENT_ON or Color3.fromRGB(140, 160, 220)
        }):Play()
        gradient.Enabled = state
        TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = state and 0 or 1}):Play()
    end

    local function toggle()
        state = not state
        updateVisual()
        if floatingButtons[text] then
            floatingButtons[text].update()
        end
    end

    local function getState()
        return state
    end

    -- Клик по всей кнопке — переключает
    Button.MouseButton1Click:Connect(toggle)

    -- Hover (для мыши)
    Button.MouseEnter:Connect(function()
        if not state then
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end
    end)
    Button.MouseLeave:Connect(function()
        if not state then
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
        end
    end)

    -- ДРАГ КНОПКИ (Mouse + Touch)
    local dragging = false
    local dragStart, startPos
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local localX = (input.Position - Button.AbsolutePosition).X
            if localX >= Button.AbsoluteSize.X - 70 then
                return -- клик по стрелке — не драгим
            end
            dragging = true
            dragStart = input.Position
            startPos = Button.Position
            Button.ZIndex = 50
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            Button.ZIndex = 10
        end
    end)

    -- Стрелка — создаёт постоянную кнопку
    ArrowButton.MouseButton1Click:Connect(function()
        createFloatingButton(text, toggle, getState)
    end)

    return getState
end

local getKA = CreateFeatureButton(rageList, "Kill Aura")
local getTP = CreateFeatureButton(movementList, "TP Speed")
local getTR = CreateFeatureButton(visualsList, "Tracers")
local getAH = CreateFeatureButton(playerList, "Auto Heal")
local getTE = CreateFeatureButton(visualsList, "Trap ESP")

-- Открытие/закрытие меню
local guiOpen = false
ToggleButton.MouseButton1Click:Connect(function()
    guiOpen = not guiOpen
    local tween = TweenInfo.new(0.6, Enum.EasingStyle.Quint)

    local tabs = {rageTab, movementTab, visualsTab, playerTab, utilityTab}
    local headers = {rageHeader, movementHeader, visualsHeader, playerHeader, utilityHeader}
    local titles = {rageTitle, movementTitle, visualsTitle, playerTitle, utilityTitle}

    if guiOpen then
        for i = 1, #tabs do
            tabs[i].Visible = true
            TweenService:Create(tabs[i], tween, {BackgroundTransparency = 0.4}):Play()
            TweenService:Create(headers[i], tween, {BackgroundTransparency = 0}):Play()
            TweenService:Create(titles[i], tween, {TextTransparency = 0}):Play()
        end
        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = ACCENT_ON}):Play()
    else
        for i = 1, #tabs do
            TweenService:Create(tabs[i], tween, {BackgroundTransparency = 1}):Play()
            TweenService:Create(headers[i], tween, {BackgroundTransparency = 1}):Play()
            TweenService:Create(titles[i], tween, {TextTransparency = 1}):Play()
        end
        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 60, 180)}):Play()
        task.delay(0.6, function()
            for _, tab in tabs do tab.Visible = false end
        end)
    end
end)

-- HUD для Kill Aura
local hud = Instance.new("TextLabel")
hud.Size = UDim2.new(0, 400, 0, 56)
hud.Position = UDim2.new(0.5, -200, 0.5, 130)
hud.BackgroundColor3 = MAIN_BG
hud.BackgroundTransparency = 1
hud.TextColor3 = TEXT_COLOR
hud.TextTransparency = 1
hud.Font = Enum.Font.GothamBlack
hud.TextSize = 28
hud.TextXAlignment = Enum.TextXAlignment.Center
hud.Parent = ScreenGui
Instance.new("UICorner", hud).CornerRadius = UDim.new(0, 14)

-- === ЧИТЫ ===
local killAuraEnabled = false
local hasTarget = false
local weaponNames = {"Sword", "Blade", "Knife", "Katana", "Dagger", "Axe", "Scythe", "Greatsword", "Darkheart", "Venomshank", "Illumina"}

local function getBestWeapon()
    for _, folder in {LocalPlayer.Backpack, LocalPlayer.Character} do
        if folder then
            for _, name in weaponNames do
                local tool = folder:FindFirstChild(name)
                if tool and tool:IsA("Tool") then return tool end
            end
        end
    end
    return nil
end

local function equipWeapon()
    local weapon = getBestWeapon()
    if not weapon then return false end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    if LocalPlayer.Character:FindFirstChild(weapon.Name) then return true end
    humanoid:UnequipTools()
    task.wait(0.04)
    humanoid:EquipTool(weapon)
    task.wait(0.12)
    return LocalPlayer.Character:FindFirstChild(weapon.Name) ~= nil
end

local TPSpeed = { Enabled = false, Delay = 1.1, Distance = 8 }
local lastTPSpeed = 0
local tpConnection = nil

local function startTPSpeed()
    if tpConnection then tpConnection:Disconnect() end
    tpConnection = RunService.Heartbeat:Connect(function()
        if not TPSpeed.Enabled then return end
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
        local humanoid = char.Humanoid
        if humanoid.MoveDirection.Magnitude == 0 then return end
        local now = tick()
        if now - lastTPSpeed < TPSpeed.Delay then return end
        local moveDir = Vector3.new(humanoid.MoveDirection.X, 0, humanoid.MoveDirection.Z)
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + moveDir * TPSpeed.Distance
        lastTPSpeed = now
    end)
end

local tracersConnection = nil
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

local autoHealEnabled = false
local healing = false
local equippedTool = nil
local foodPriority = {"Pizza", "Cake", "Cookie", "Apple"}
local autoHealConnection = nil

local function getBestFood()
    for _, folder in {LocalPlayer.Backpack, LocalPlayer.Character} do
        if folder then
            for _, name in foodPriority do
                local tool = folder:FindFirstChild(name)
                if tool and tool:IsA("Tool") then return tool end
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
    if equippedTool then
        pcall(function() equippedTool:Activate() end)
    end
end

local function startAutoHeal()
    if autoHealConnection then autoHealConnection:Disconnect() end
    autoHealConnection = RunService.Heartbeat:Connect(function()
        if not autoHealEnabled or not LocalPlayer.Character then return end
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health >= 100 or humanoid.Health <= 0 then return end
        if humanoid.Health <= 80 and not healing and getBestFood() then
            healing = true
            if equipAndHeal() then
                task.spawn(function()
                    local attempts = 0
                    while humanoid.Health < 100 and equippedTool and equippedTool.Parent == LocalPlayer.Character and attempts < 250 do
                        eatFood()
                        task.wait(equippedTool.Name == "Apple" and 0.03 or 0.09)
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

local trapEspEnabled = false
local espCircles = {}
local trapCache = {}
local lastCacheUpdate = 0
local trapEspConnection = nil

local function createCircle(model)
    local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not primary then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = primary
    billboard.Size = UDim2.new(0, 120, 0, 120)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = primary

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
    text.Font = Enum.Font.GothamBold
    text.TextSize = 18
    text.Parent = circle

    return billboard
end

local function updateTrapCache()
    trapCache = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if #trapCache >= 100 then break end
        if obj:IsA("Model") or obj:IsA("Folder") then
            local name = obj.Name:lower()
            if name:find("trap") or name:find("beartrap") or name:find("thorn") then
                table.insert(trapCache, obj)
            end
        end
    end
end

local function scanTraps()
    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    if tick() - lastCacheUpdate > 5 then
        updateTrapCache()
        lastCacheUpdate = tick()
    end

    for model, gui in pairs(espCircles) do
        if not model.Parent then
            gui:Destroy()
            espCircles[model] = nil
        end
    end

    for _, model in pairs(trapCache) do
        local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
        if primary and (primary.Position - rootPart.Position).Magnitude < 200 then
            if trapEspEnabled and not espCircles[model] then
                espCircles[model] = createCircle(model)
            end
        end
    end
end

local function startTrapEsp()
    if trapEspConnection then trapEspConnection:Disconnect() end
    updateTrapCache()
    trapEspConnection = RunService.Stepped:Connect(scanTraps)
end

-- Синхронизация читов
RunService.RenderStepped:Connect(function()
    killAuraEnabled = getKA()

    if getTP() then
        TPSpeed.Enabled = true
        if not tpConnection or not tpConnection.Connected then startTPSpeed() end
    else
        TPSpeed.Enabled = false
    end

    if getTR() then
        if not tracersConnection or not tracersConnection.Connected then startTracers() end
    else
        clearAllTracers()
        if tracersConnection then tracersConnection:Disconnect() end
    end

    if getAH() then
        autoHealEnabled = true
        if not autoHealConnection or not autoHealConnection.Connected then startAutoHeal() end
    else
        autoHealEnabled = false
    end

    if getTE() then
        trapEspEnabled = true
        if not trapEspConnection or not trapEspConnection.Connected then startTrapEsp() end
    else
        trapEspEnabled = false
        for _, gui in pairs(espCircles) do gui:Destroy() end
        espCircles = {}
    end

    -- Обновляем постоянные кнопки
    for text, data in pairs(floatingButtons) do
        data.update()
    end
end)

-- Kill Aura цикл
RunService.Heartbeat:Connect(function()
    if not killAuraEnabled then
        if hasTarget then
            hasTarget = false
            TweenService:Create(hud, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
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
        equipWeapon()
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function() tool:Activate() end)
        end

        local tRoot = closest.Character.HumanoidRootPart
        root.CFrame = root.CFrame:Lerp(CFrame.new(tRoot.Position - (tRoot.Position - root.Position).Unit * 3.2, tRoot.Position), 0.22)

        local tHum = closest.Character:FindFirstChildOfClass("Humanoid")
        if tHum then
            hud.Text = string.format("%s • HP: %d", closest.DisplayName, math.floor(tHum.Health))
            if not hasTarget then
                hasTarget = true
                TweenService:Create(hud, TweenInfo.new(0.4), {BackgroundTransparency = 0.35, TextTransparency = 0}):Play()
            end
        end
    else
        if hasTarget then
            hasTarget = false
            TweenService:Create(hud, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        end
    end
end)

print("[SaturnX] Хаб полностью загружен. Полная поддержка мобильных устройств и драг пальцем/мышкой. Готово!")
