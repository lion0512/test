```lua
-- Danny World Enhanced Hack Script (English)
-- Save as "dandysworld.lua" and upload to GitHub raw.
-- Features: God mode, speed hack, teleport, auto-solve machines, camera zoom, free camera movement.
-- Shows "Script by LanAnh" on load, then fades to GUI. GUI has X button to minimize/restore.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera
local tweenService = game:GetService("TweenService")

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

-- Fade out splash after 2 seconds
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

-- Main GUI Creation
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "DannyEnhancedHackGUI"

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 250, 0, 280)
frame.Position = UDim2.new(0.5, -125, 0.5, -140)
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
    
    -- Create restore button (small floating button)
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

-- Content Frame (holds all buttons)
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

-- Auto-Solve Machines
local autoSolveButton = Instance.new("TextButton")
autoSolveButton.Parent = contentFrame
autoSolveButton.Size = UDim2.new(1, -10, 0, 30)
autoSolveButton.Position = UDim2.new(0, 5, 0, 110)
autoSolveButton.Text = "Auto Solve Machines: OFF"
autoSolveButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
autoSolveButton.TextColor3 = Color3.new(1, 1, 1)
autoSolveButton.Font = Enum.Font.SourceSans
autoSolveButton.TextSize = 14

local autoSolveEnabled = false
autoSolveButton.MouseButton1Click:Connect(function()
    autoSolveEnabled = not autoSolveEnabled
    autoSolveButton.Text = autoSolveEnabled and "Auto Solve Machines: ON" or "Auto Solve Machines: OFF"
end)

spawn(function()
    while true do
        if autoSolveEnabled then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                for _, descendant in pairs(workspace:GetDescendants()) do
                    if descendant:IsA("ProximityPrompt") and descendant.Enabled then
                        local distance = (root.Position - descendant.Parent.Position).Magnitude
                        if distance < 20 then
                            fireproximityprompt(descendant)
                        end
                    end
                    if descendant:IsA("ClickDetector") then
                        local distance = (root.Position - descendant.Parent.Position).Magnitude
                        if distance < 20 then
                            fireclickdetector(descendant)
                        end
                    end
                    if descendant:IsA("SurfaceGui") then
                        for _, button in pairs(descendant:GetDescendants()) do
                            if button:IsA("TextButton") or button:IsA("ImageButton") then
                                local distance = (root.Position - descendant.Parent.Position).Magnitude
                                if distance < 20 then
                                    local lowerText = string.lower(button.Text or "")
                                    if string.find(lowerText, "start") or string.find(lowerText, "solve") or string.find(lowerText, "complete") or string.find(lowerText, "activate") then
                                        for _, event in pairs(getconnections(button.MouseButton1Click)) do
                                            event:Fire()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(0.5)
    end
end)

-- Camera Zoom Label
local zoomLabel = Instance.new("TextLabel")
zoomLabel.Parent = contentFrame
zoomLabel.Size = UDim2.new(1, -10, 0, 20)
zoomLabel.Position = UDim2.new(0, 5, 0, 145)
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
freeCamButton.Position = UDim2.new(0, 5, 0, 170)
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
resetCamButton.Position = UDim2.new(0, 5, 0, 205)
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
```