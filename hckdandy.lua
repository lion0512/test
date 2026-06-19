-- Danny World Enhanced Hack Script (English)
-- Save as "dandysworld.lua" and upload to GitHub raw.
-- Splash screen shows "Script by LanAnh" with a loading bar below it.
-- The bar fills over exactly 16 seconds. When full, "Done" appears, then the main GUI opens.
-- Features: God mode, speed hack, teleport, item locator (real in-game names), auto-lighting, camera zoom, free camera.
-- GUI has X button to minimize/restore.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")

-- =============================================
-- SPLASH SCREEN WITH 16-SECOND LOADING BAR
-- =============================================
local splash = Instance.new("ScreenGui")
splash.Parent = game.CoreGui
splash.Name = "SplashGui"
splash.ResetOnSpawn = false

local splashFrame = Instance.new("Frame")
splashFrame.Parent = splash
splashFrame.Size = UDim2.new(0, 350, 0, 150)
splashFrame.Position = UDim2.new(0.5, -175, 0.5, -75)
splashFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
splashFrame.BorderSizePixel = 0

-- "Script by LanAnh" label
local splashLabel = Instance.new("TextLabel")
splashLabel.Parent = splashFrame
splashLabel.Size = UDim2.new(1, 0, 0, 50)
splashLabel.Position = UDim2.new(0, 0, 0, 20)
splashLabel.Text = "Script by LanAnh"
splashLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
splashLabel.BackgroundTransparency = 1
splashLabel.Font = Enum.Font.SourceSansBold
splashLabel.TextSize = 28

-- Loading bar background
local barBackground = Instance.new("Frame")
barBackground.Parent = splashFrame
barBackground.Size = UDim2.new(0.8, 0, 0, 25)
barBackground.Position = UDim2.new(0.1, 0, 0, 85)
barBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
barBackground.BorderSizePixel = 0

-- Loading bar fill
local barFill = Instance.new("Frame")
barFill.Parent = barBackground
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
barFill.BorderSizePixel = 0

-- "Done" label (hidden until complete)
local doneLabel = Instance.new("TextLabel")
doneLabel.Parent = splashFrame
doneLabel.Size = UDim2.new(1, 0, 0, 30)
doneLabel.Position = UDim2.new(0, 0, 0, 115)
doneLabel.Text = "Done"
doneLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
doneLabel.BackgroundTransparency = 1
doneLabel.Font = Enum.Font.SourceSansBold
doneLabel.TextSize = 20
doneLabel.Visible = false

-- Loading logic: 16 seconds
spawn(function()
    local duration = 16
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
    local tween = tweenService:Create(barFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    
    tween.Completed:Connect(function()
        doneLabel.Visible = true
        wait(1.5)
        -- Fade out splash
        local fadeTweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
        local fadeTween = tweenService:Create(splashFrame, fadeTweenInfo, {BackgroundTransparency = 1})
        local textFadeTween = tweenService:Create(splashLabel, fadeTweenInfo, {TextTransparency = 1})
        local barFadeTween = tweenService:Create(barBackground, fadeTweenInfo, {BackgroundTransparency = 1})
        local barFillFadeTween = tweenService:Create(barFill, fadeTweenInfo, {BackgroundTransparency = 1})
        local doneFadeTween = tweenService:Create(doneLabel, fadeTweenInfo, {TextTransparency = 1})
        fadeTween:Play()
        textFadeTween:Play()
        barFadeTween:Play()
        barFillFadeTween:Play()
        doneFadeTween:Play()
        wait(0.8)
        splash:Destroy()
    end)
end)

-- =============================================
-- MAIN GUI (appears after splash)
-- =============================================
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "DannyEnhancedHackGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 280, 0, 310)
frame.Position = UDim2.new(0.5, -140, 0.5, -155)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = false -- Hidden until splash finishes

local titleBar = Instance.new("Frame")
titleBar.Parent = frame
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Parent = titleBar
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "Danny World Enhanced Hack"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeButton = Instance.new("TextButton")
minimizeButton.Parent = titleBar
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -30, 0, 0)
minimizeButton.Text = "X"
minimizeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 16
minimizeButton.BorderSizePixel = 0

local minimized = false
local restoreButton = nil

minimizeButton.MouseButton1Click:Connect(function()
    minimized = true
    frame.Visible = false
    restoreButton = Instance.new("TextButton")
    restoreButton.Parent = gui
    restoreButton.Size = UDim2.new(0, 40, 0, 40)
    restoreButton.Position = UDim2.new(0, 10, 0, 10)
    restoreButton.Text = "🔽"
    restoreButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    restoreButton.TextColor3 = Color3.new(1, 1, 1)
    restoreButton.Font = Enum.Font.SourceSansBold
    restoreButton.TextSize = 18
    restoreButton.BorderSizePixel = 0
    restoreButton.Active = true
    restoreButton.Draggable = true
    restoreButton.MouseButton1Click:Connect(function()
        minimized = false
        frame.Visible = true
        restoreButton:Destroy()
        restoreButton = nil
    end)
end)

local contentFrame = Instance.new("Frame")
contentFrame.Parent = frame
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1

-- God Mode
local godButton = Instance.new("TextButton")
godButton.Parent = contentFrame
godButton.Size = UDim2.new(1, -10, 0, 30)
godButton.Position = UDim2.new(0, 5, 0, 5)
godButton.Text = "God Mode: OFF"
godButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
godButton.TextColor3 = Color3.new(1, 1, 1)
godButton.Font = Enum.Font.SourceSans
godButton.TextSize = 14

local godEnabled = false
godButton.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    godButton.Text = godEnabled and "God Mode: ON" or "God Mode: OFF"
end)

local function godMode(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.HealthChanged:Connect(function()
        if godEnabled and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

player.CharacterAdded:Connect(godMode)
if player.Character then godMode(player.Character) end

-- Speed
local speedButton = Instance.new("TextButton")
speedButton.Parent = contentFrame
speedButton.Size = UDim2.new(1, -10, 0, 30)
speedButton.Position = UDim2.new(0, 5, 0, 40)
speedButton.Text = "Speed: 16"
speedButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedButton.TextColor3 = Color3.new(1, 1, 1)
speedButton.Font = Enum.Font.SourceSans
speedButton.TextSize = 14

local speeds = {16, 32, 64, 100, 150}
local speedIndex = 1
speedButton.MouseButton1Click:Connect(function()
    speedIndex = speedIndex % #speeds + 1
    local newSpeed = speeds[speedIndex]
    speedButton.Text = "Speed: " .. newSpeed
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = newSpeed
    end
end)

-- Teleport
local tpButton = Instance.new("TextButton")
tpButton.Parent = contentFrame
tpButton.Size = UDim2.new(1, -10, 0, 30)
tpButton.Position = UDim2.new(0, 5, 0, 75)
tpButton.Text = "Teleport: Right Click (ON)"
tpButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.Font = Enum.Font.SourceSans
tpButton.TextSize = 14

local teleportEnabled = true
tpButton.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    tpButton.Text = teleportEnabled and "Teleport: Right Click (ON)" or "Teleport: OFF"
end)

mouse.Button2Down:Connect(function()
    if teleportEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p)
    end
end)

-- Item Locator ESP
local espButton = Instance.new("TextButton")
espButton.Parent = contentFrame
espButton.Size = UDim2.new(1, -10, 0, 30)
espButton.Position = UDim2.new(0, 5, 0, 110)
espButton.Text = "Item Locator: OFF"
espButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
espButton.TextColor3 = Color3.new(1, 1, 1)
espButton.Font = Enum.Font.SourceSans
espButton.TextSize = 14

local espEnabled = false
local espBillboardFolder = Instance.new("Folder")
espBillboardFolder.Name = "ESP_Billboards"
espBillboardFolder.Parent = game.CoreGui

local function getItemDisplayName(obj)
    local displayNameAttr = obj:GetAttribute("DisplayName")
    if displayNameAttr and displayNameAttr ~= "" then return tostring(displayNameAttr) end
    local nameAttr = obj:GetAttribute("Name")
    if nameAttr and nameAttr ~= "" then return tostring(nameAttr) end
    for _, child in pairs(obj:GetChildren()) do
        if child:IsA("StringValue") then
            if child.Name == "ItemName" or child.Name == "DisplayName" or child.Name == "Name" then
                if child.Value ~= "" then return child.Value end
            end
        end
        if child:IsA("Folder") or child:IsA("Configuration") then
            for _, subChild in pairs(child:GetChildren()) do
                if subChild:IsA("StringValue") and (subChild.Name == "ItemName" or subChild.Name == "DisplayName" or subChild.Name == "Name") then
                    if subChild.Value ~= "" then return subChild.Value end
                end
            end
        end
    end
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        if prompt.ActionText and prompt.ActionText ~= "" then return prompt.ActionText end
        if prompt.ObjectText and prompt.ObjectText ~= "" then return prompt.ObjectText end
    end
    local click = obj:FindFirstChildOfClass("ClickDetector")
    if click then
        local clickName = click:GetAttribute("DisplayName") or click:GetAttribute("Name")
        if clickName and clickName ~= "" then return tostring(clickName) end
    end
    if obj:IsA("Tool") and obj.ToolTip ~= "" then return obj.ToolTip end
    local cleanName = obj.Name:gsub("_", " "):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
    return cleanName
end

local function isRealItem(obj)
    if obj:IsA("Tool") then return true end
    if obj:FindFirstChildOfClass("ProximityPrompt") then return true end
    if obj:FindFirstChildOfClass("ClickDetector") then return true end
    if obj:IsA("Model") then
        for _, child in pairs(obj:GetDescendants()) do
            if child:IsA("ProximityPrompt") or child:IsA("ClickDetector") then return true end
        end
    end
    return false
end

local function createBillboard(obj, adorneePart)
    local identifier = obj:GetFullName():gsub("[%c%p%s]", "_") .. "_ESP"
    if espBillboardFolder:FindFirstChild(identifier) then return end
    local displayName = getItemDisplayName(obj)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = identifier
    billboard.Parent = espBillboardFolder
    billboard.Adornee = adorneePart
    billboard.Size = UDim2.new(0, 250, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 800
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Text = displayName
    spawn(function()
        while obj and obj.Parent and espEnabled and adorneePart and adorneePart.Parent do
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = math.floor((character.HumanoidRootPart.Position - adorneePart.Position).Magnitude)
                textLabel.Text = displayName .. " [" .. distance .. "m]"
            end
            wait(0.3)
        end
        billboard:Destroy()
    end)
end

local function clearESP()
    espBillboardFolder:ClearAllChildren()
end

local function scanForRealItems()
    clearESP()
    local found = {}
    for _, descendant in pairs(workspace:GetDescendants()) do
        if found[descendant] then continue end
        if isRealItem(descendant) then
            found[descendant] = true
            local adorneePart = nil
            if descendant:IsA("BasePart") then
                adorneePart = descendant
            elseif descendant:IsA("Tool") then
                adorneePart = descendant:FindFirstChild("Handle") or descendant.PrimaryPart
            elseif descendant:IsA("Model") then
                adorneePart = descendant.PrimaryPart or descendant:FindFirstChildWhichIsA("BasePart")
            end
            if adorneePart then
                createBillboard(descendant, adorneePart)
            end
        end
    end
end

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "Item Locator: ON" or "Item Locator: OFF"
    if espEnabled then
        scanForRealItems()
        spawn(function()
            while espEnabled do
                wait(4)
                scanForRealItems()
            end
        end)
    else
        clearESP()
    end
end)

-- Auto-Lighting
local lightButton = Instance.new("TextButton")
lightButton.Parent = contentFrame
lightButton.Size = UDim2.new(1, -10, 0, 30)
lightButton.Position = UDim2.new(0, 5, 0, 145)
lightButton.Text = "Auto-Light: OFF"
lightButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
lightButton.TextColor3 = Color3.new(1, 1, 1)
lightButton.Font = Enum.Font.SourceSans
lightButton.TextSize = 14

local autoLightEnabled = false
local originalLighting = {
    Brightness = lighting.Brightness,
    Ambient = lighting.Ambient,
    OutdoorAmbient = lighting.OutdoorAmbient,
    ColorShift_Top = lighting.ColorShift_Top,
    ColorShift_Bottom = lighting.ColorShift_Bottom,
    FogEnd = lighting.FogEnd,
    FogStart = lighting.FogStart,
    ExposureCompensation = lighting.ExposureCompensation,
    ClockTime = lighting.ClockTime,
    GeographicLatitude = lighting.GeographicLatitude
}

lightButton.MouseButton1Click:Connect(function()
    autoLightEnabled = not autoLightEnabled
    lightButton.Text = autoLightEnabled and "Auto-Light: ON" or "Auto-Light: OFF"
    if autoLightEnabled then
        lighting.Brightness = 2
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
        lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
        lighting.FogEnd = 100000
        lighting.FogStart = 0
        lighting.ExposureCompensation = 1
        lighting.ClockTime = 14
        lighting.GeographicLatitude = 45
        for _, child in pairs(lighting:GetChildren()) do
            if child:IsA("Atmosphere") then child:Destroy() end
            if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("ColorCorrectionEffect") then child.Enabled = false end
        end
        spawn(function()
            while autoLightEnabled do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = player.Character.HumanoidRootPart
                    if not root:FindFirstChild("PlayerLight") then
                        local pointLight = Instance.new("PointLight")
                        pointLight.Name = "PlayerLight"
                        pointLight.Parent = root
                        pointLight.Brightness = 1
                        pointLight.Range = 60
                        pointLight.Color = Color3.fromRGB(255, 255, 255)
                        pointLight.Shadows = false
                    end
                end
                wait(1)
            end
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local light = player.Character.HumanoidRootPart:FindFirstChild("PlayerLight")
                if light then light:Destroy() end
            end
        end)
    else
        lighting.Brightness = originalLighting.Brightness
        lighting.Ambient = originalLighting.Ambient
        lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        lighting.ColorShift_Top = originalLighting.ColorShift_Top
        lighting.ColorShift_Bottom = originalLighting.ColorShift_Bottom
        lighting.FogEnd = originalLighting.FogEnd
        lighting.FogStart = originalLighting.FogStart
        lighting.ExposureCompensation = originalLighting.ExposureCompensation
        lighting.ClockTime = originalLighting.ClockTime
        lighting.GeographicLatitude = originalLighting.GeographicLatitude
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local light = player.Character.HumanoidRootPart:FindFirstChild("PlayerLight")
            if light then light:Destroy() end
        end
    end
end)

-- Camera Zoom
local zoomLabel = Instance.new("TextLabel")
zoomLabel.Parent = contentFrame
zoomLabel.Size = UDim2.new(1, -10, 0, 20)
zoomLabel.Position = UDim2.new(0, 5, 0, 180)
zoomLabel.Text = "Camera Zoom: Scroll Wheel"
zoomLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
zoomLabel.TextColor3 = Color3.new(1, 1, 1)
zoomLabel.Font = Enum.Font.SourceSans
zoomLabel.TextSize = 12

local currentZoom = 70
camera.FieldOfView = currentZoom
userInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        currentZoom = math.clamp(currentZoom - input.Position.Z * 5, 20, 120)
        camera.FieldOfView = currentZoom
    end
end)

-- Free Camera
local freeCamButton = Instance.new("TextButton")
freeCamButton.Parent = contentFrame
freeCamButton.Size = UDim2.new(1, -10, 0, 30)
freeCamButton.Position = UDim2.new(0, 5, 0, 205)
freeCamButton.Text = "Free Cam: OFF (Hold MMB)"
freeCamButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
freeCamButton.TextColor3 = Color3.new(1, 1, 1)
freeCamButton.Font = Enum.Font.SourceSans
freeCamButton.TextSize = 14

local freeCamEnabled = false
freeCamButton.MouseButton1Click:Connect(function()
    freeCamEnabled = not freeCamEnabled
    freeCamButton.Text = freeCamEnabled and "Free Cam: ON (Hold MMB)" or "Free Cam: OFF (Hold MMB)"
end)

local freeCamActive = false
local freeCamStartPos = nil
local freeCamStartCFrame = nil

userInputService.InputBegan:Connect(function(input)
    if freeCamEnabled and input.UserInputType == Enum.UserInputType.MouseButton3 then
        freeCamActive = true
        freeCamStartPos = userInputService:GetMouseLocation()
        freeCamStartCFrame = camera.CFrame
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Anchored = true
        end
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton3 then
        freeCamActive = false
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Anchored = false
        end
    end
end)

runService.RenderStepped:Connect(function()
    if freeCamActive and freeCamEnabled then
        local currentPos = userInputService:GetMouseLocation()
        local delta = currentPos - freeCamStartPos
        local sensitivity = 0.5
        local rotation = CFrame.Angles(0, math.rad(-delta.X * sensitivity), 0) * CFrame.Angles(math.rad(-delta.Y * sensitivity), 0, 0)
        camera.CFrame = freeCamStartCFrame * rotation
    end
end)

-- Reset Camera
local resetCamButton = Instance.new("TextButton")
resetCamButton.Parent = contentFrame
resetCamButton.Size = UDim2.new(1, -10, 0, 30)
resetCamButton.Position = UDim2.new(0, 5, 0, 240)
resetCamButton.Text = "Reset Camera"
resetCamButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
resetCamButton.TextColor3 = Color3.new(1, 1, 1)
resetCamButton.Font = Enum.Font.SourceSans
resetCamButton.TextSize = 14

resetCamButton.MouseButton1Click:Connect(function()
    freeCamActive = false
    camera.FieldOfView = 70
    currentZoom = 70
    camera.CameraType = Enum.CameraType.Custom
    camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid")
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Anchored = false
    end
end)

-- =============================================
-- WAIT FOR SPLASH TO FINISH, THEN SHOW GUI
-- =============================================
spawn(function()
    wait(18.3) -- 16 sec load + 1.5 sec "Done" display + 0.8 sec fade
    frame.Visible = true
end)