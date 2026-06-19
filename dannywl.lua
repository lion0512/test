-- Danny World Enhanced Hack Script (English)
-- Save as "dandysworld.lua" and upload to GitHub raw.
-- Features: God mode, speed hack, teleport, item ESP (red names), auto-lighting, camera zoom, free camera movement.
-- Shows "Script by LanAnh" on load, then fades to GUI. GUI has X button to minimize/restore.
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local tweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")

-- Splash Screen: "Script by LanAnh"
local splash = Instance.new("ScreenGui")
splash.Parent = game.CoreGui
splash.Name = "SplashGui"

local splashFrame = Instance.new("Frame")
splashFrame.Parent = splash
splashFrame.Size = UDim2.new(0, 300, 0, 100)
splashFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
splashFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
splashFrame.BorderSizePixel = 0
splashFrame.BackgroundTransparency = 0

local splashLabel = Instance.new("TextLabel")
splashLabel.Parent = splashFrame
splashLabel.Size = UDim2.new(1, 0, 1, 0)
splashLabel.Text = "Script by LanAnh"
splashLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
splashLabel.BackgroundTransparency = 1
splashLabel.Font = Enum.Font.SourceSansBold
splashLabel.TextSize = 30
splashLabel.TextTransparency = 0

spawn(function()
    wait(2)
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
    local fadeGoal = {BackgroundTransparency = 1}
    local textFadeGoal = {TextTransparency = 1}
    local fadeTween = tweenService:Create(splashFrame, tweenInfo, fadeGoal)
    local textFadeTween = tweenService:Create(splashLabel, tweenInfo, textFadeGoal)
    fadeTween:Play()
    textFadeTween:Play()
    wait(1)
    splash:Destroy()
end)

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "DannyEnhancedHackGUI"

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 280, 0, 310)
frame.Position = UDim2.new(0.5, -140, 0.5, -155)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = true

-- Title Bar
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

-- Minimize Button (X)
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

-- Content Frame
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

-- Item Locator ESP (Red Names)
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
local espObjects = {}
local espBillboardFolder = Instance.new("Folder")
espBillboardFolder.Name = "ESP_Billboards"
espBillboardFolder.Parent = game.CoreGui

local itemKeywords = {
    "item", "key", "tool", "gear", "battery", "fuse", "lever",
    "crank", "valve", "tape", "medkit", "bandage", "potion",
    "scroll", "gem", "crystal", "part", "fragment", "core",
    "collect", "pickup", "objective", "quest", "machine",
    "panel", "button", "switch", "door", "gate", "chest",
    "locker", "safe", "box", "crate", "barrel"
}

local function isItem(obj)
    local name = string.lower(obj.Name)
    for _, keyword in ipairs(itemKeywords) do
        if string.find(name, keyword) then
            return true
        end
    end
    if obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChildOfClass("ClickDetector") then
        return true
    end
    if obj:IsA("Tool") then
        return true
    end
    return false
end

local function createBillboard(obj)
    if espBillboardFolder:FindFirstChild(obj.Name .. "_ESP") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = obj.Name .. "_ESP"
    billboard.Parent = espBillboardFolder
    billboard.Adornee = obj
    billboard.Size = UDim2.new(0, 200, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 500
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red color
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Text = obj.Name
    
    -- Update distance text
    spawn(function()
        while obj and obj.Parent and espEnabled do
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = math.floor((character.HumanoidRootPart.Position - obj.Position).Magnitude)
                textLabel.Text = obj.Name .. " [" .. distance .. "m]"
            end
            wait(0.5)
        end
    end)
    
    table.insert(espObjects, obj)
end

local function clearESP()
    espBillboardFolder:ClearAllChildren()
    espObjects = {}
end

local function scanForItems()
    clearESP()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("BasePart") or descendant:IsA("Model") or descendant:IsA("Tool") then
            if isItem(descendant) then
                local target = descendant
                if descendant:IsA("BasePart") then
                    target = descendant.Parent or descendant
                elseif descendant:IsA("Model") then
                    target = descendant
                elseif descendant:IsA("Tool") then
                    target = descendant
                end
                if target and target ~= workspace then
                    local adornee = target:IsA("Model") and (target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")) or target
                    if adornee and adornee:IsA("BasePart") then
                        createBillboard(adornee)
                    elseif target:IsA("BasePart") then
                        createBillboard(target)
                    end
                end
            end
        end
    end
end

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "Item Locator: ON" or "Item Locator: OFF"
    if espEnabled then
        scanForItems()
        spawn(function()
            while espEnabled do
                wait(5)
                scanForItems()
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
        -- Apply full bright settings
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
        
        -- Remove any fog or atmosphere effects
        for _, child in pairs(lighting:GetChildren()) do
            if child:IsA("Atmosphere") then
                child:Destroy()
            end
            if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("ColorCorrectionEffect") then
                child.Enabled = false
            end
        end
        
        -- Add point light to player for extra visibility
        spawn(function()
            while autoLightEnabled do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local root = player.Character.HumanoidRootPart
                    local existingLight = root:FindFirstChild("PlayerLight")
                    if not existingLight then
                        local pointLight = Instance.new("PointLight")
                        pointLight.Name = "PlayerLight"
                        pointLight.Parent = root
                        pointLight.Brightness = 1
                        pointLight.Range = 50
                        pointLight.Color = Color3.fromRGB(255, 255, 255)
                        pointLight.Shadows = false
                    end
                end
                wait(1)
            end
            -- Remove light when disabled
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local light = player.Character.HumanoidRootPart:FindFirstChild("PlayerLight")
                if light then light:Destroy() end
            end
        end)
    else
        -- Restore original lighting
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

-- Camera Zoom Label
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