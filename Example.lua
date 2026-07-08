-- ==============================================================================
-- Blue Moon - Universal Hub
-- A fully featured universal script demonstrating K-UI capabilities
-- Features: ESP, Aimbot, Fly, Inf Jump, Spectate, Noclip, Rejoin, and more!
-- ==============================================================================

local K_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/GeceUstasi/BlueMoonUI/65a77f9bbd3a41ad8befa315a474e50779ff3759/K-UI.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- 1. Create the Main Window
local Window = K_UI:CreateWindow("Universal Hub", {
    Accent = Color3.fromRGB(114, 137, 218),
    Ping = true,
    ToggleKey = Enum.KeyCode.RightShift
})

-- TABS
local LocalTab = Window:CreateTab("LocalPlayer", K_UI.GetIcon("lucide-user"))
local CombatTab = Window:CreateTab("Combat", K_UI.GetIcon("lucide-crosshair"))
local VisualsTab = Window:CreateTab("Visuals", K_UI.GetIcon("lucide-eye"))
local MiscTab = Window:CreateTab("Misc", K_UI.GetIcon("lucide-folder-open"))


-- ==========================================
-- LOCALPLAYER TAB
-- ==========================================
local MovementSection = LocalTab:CreateSection("Movement")

local WalkSpeedVal = 16
MovementSection:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Flag = "WalkSpeed",
    Callback = function(val)
        WalkSpeedVal = val
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end
})

local JumpPowerVal = 50
MovementSection:CreateSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 300,
    Default = 50,
    Flag = "JumpPower",
    Callback = function(val)
        JumpPowerVal = val
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = val
        end
    end
})

-- Anti-anticheat override loop
task.spawn(function()
    while task.wait(0.5) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if WalkSpeedVal ~= 16 then LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedVal end
            if JumpPowerVal ~= 50 then 
                LocalPlayer.Character.Humanoid.UseJumpPower = true
                LocalPlayer.Character.Humanoid.JumpPower = JumpPowerVal 
            end
        end
    end
end)

local ModsSection = LocalTab:CreateSection("Character Mods")

local InfJumpEnabled = false
ModsSection:CreateToggle({
    Name = "Infinite Jump",
    Default = false,
    Flag = "InfJump",
    Callback = function(state) InfJumpEnabled = state end
})

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local NoclipEnabled = false
ModsSection:CreateToggle({
    Name = "Noclip",
    Default = false,
    Flag = "Noclip",
    Callback = function(state) NoclipEnabled = state end
})

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- FLY IMPLEMENTATION
local FlyEnabled = false
local FlySpeed = 50

local function RemoveFly()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        LocalPlayer.Character.Humanoid.PlatformStand = false
        if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
        if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
    end
end

ModsSection:CreateToggle({
    Name = "Fly Mode",
    Default = false,
    Flag = "FlyToggle",
    Callback = function(state)
        FlyEnabled = state
        if not state then
            RemoveFly()
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = LocalPlayer.Character.HumanoidRootPart
                LocalPlayer.Character.Humanoid.PlatformStand = true
                
                local bodyVel = Instance.new("BodyVelocity")
                bodyVel.Name = "FlyVelocity"
                bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bodyVel.Velocity = Vector3.zero
                bodyVel.Parent = hrp
                
                local bodyGyro = Instance.new("BodyGyro")
                bodyGyro.Name = "FlyGyro"
                bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro.P = 9e4
                bodyGyro.CFrame = hrp.CFrame
                bodyGyro.Parent = hrp
            end
        end
    end
})

ModsSection:CreateSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 300,
    Default = 50,
    Flag = "FlySpeed",
    Callback = function(val) FlySpeed = val end
})

-- Fly Controls
local W, A, S, D, Space, LCtrl = false, false, false, false, false, false
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then W = true
    elseif input.KeyCode == Enum.KeyCode.A then A = true
    elseif input.KeyCode == Enum.KeyCode.S then S = true
    elseif input.KeyCode == Enum.KeyCode.D then D = true
    elseif input.KeyCode == Enum.KeyCode.Space then Space = true
    elseif input.KeyCode == Enum.KeyCode.LeftControl then LCtrl = true end
end)
UserInputService.InputEnded:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.W then W = false
    elseif input.KeyCode == Enum.KeyCode.A then A = false
    elseif input.KeyCode == Enum.KeyCode.S then S = false
    elseif input.KeyCode == Enum.KeyCode.D then D = false
    elseif input.KeyCode == Enum.KeyCode.Space then Space = false
    elseif input.KeyCode == Enum.KeyCode.LeftControl then LCtrl = false end
end)

RunService.RenderStepped:Connect(function()
    if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local bodyVel = hrp:FindFirstChild("FlyVelocity")
        local bodyGyro = hrp:FindFirstChild("FlyGyro")
        
        if bodyVel and bodyGyro then
            local moveDir = Vector3.zero
            if W then moveDir = moveDir + Camera.CFrame.LookVector end
            if S then moveDir = moveDir - Camera.CFrame.LookVector end
            if A then moveDir = moveDir - Camera.CFrame.RightVector end
            if D then moveDir = moveDir + Camera.CFrame.RightVector end
            if Space then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if LCtrl then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            bodyVel.Velocity = moveDir * FlySpeed
            bodyGyro.CFrame = Camera.CFrame
        end
    end
end)


-- ==========================================
-- COMBAT TAB
-- ==========================================
local AimbotSection = CombatTab:CreateSection("Aimbot")

local AimbotState = false
local AimbotTargetPart = "Head"
local AimbotSmoothness = 1
local ShowFOV = false
local FOVRadius = 100

AimbotSection:CreateToggle({
    Name = "Enable Aimbot (Right Click)",
    Default = false,
    Flag = "AimbotToggle",
    Callback = function(state) AimbotState = state end
})

AimbotSection:CreateToggle({
    Name = "Show FOV Circle",
    Default = false,
    Flag = "AimbotFOVToggle",
    Callback = function(state) ShowFOV = state end
})

AimbotSection:CreateSlider({
    Name = "FOV Radius",
    Min = 10,
    Max = 500,
    Default = 100,
    Flag = "AimbotFOVRadius",
    Callback = function(val) FOVRadius = val end
})

AimbotSection:CreateSlider({
    Name = "Smoothness",
    Min = 1,
    Max = 10,
    Default = 1,
    Flag = "AimbotSmoothness",
    Callback = function(val) AimbotSmoothness = val end
})

AimbotSection:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "HumanoidRootPart"},
    Default = "Head",
    Flag = "AimbotTargetPart",
    Callback = function(val) AimbotTargetPart = val end
})

-- FOV Circle Drawing
local FOVCircle = nil
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Color = Color3.new(1, 1, 1)
    FOVCircle.Thickness = 1
    FOVCircle.Filled = false
    FOVCircle.Transparency = 1
end)

local function GetClosestPlayer()
    local closestDist = FOVRadius
    local target = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(AimbotTargetPart) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character[AimbotTargetPart].Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    target = p
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if FOVCircle then
        FOVCircle.Radius = FOVRadius
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        FOVCircle.Visible = ShowFOV
    end

    if AimbotState and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(AimbotTargetPart) then
            local targetPos = target.Character[AimbotTargetPart].Position
            local camCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            if AimbotSmoothness == 1 then
                Camera.CFrame = camCFrame
            else
                Camera.CFrame = Camera.CFrame:Lerp(camCFrame, 0.5 / AimbotSmoothness)
            end
        end
    end
end)


-- ==========================================
-- VISUALS TAB
-- ==========================================
local ESPSection = VisualsTab:CreateSection("ESP Options")

local ESPEnabled = false
local ESPBoxes = false
local ESPNames = false
local ESPTracers = false
local ESPColor = Color3.fromRGB(255, 255, 255)

ESPSection:CreateToggle({
    Name = "Master ESP Switch",
    Default = false,
    Flag = "MasterESP",
    Callback = function(state) ESPEnabled = state end
})

ESPSection:CreateToggle({
    Name = "Show Boxes",
    Default = false,
    Flag = "ESPBoxes",
    Callback = function(state) ESPBoxes = state end
})

ESPSection:CreateToggle({
    Name = "Show Names",
    Default = false,
    Flag = "ESPNames",
    Callback = function(state) ESPNames = state end
})

ESPSection:CreateToggle({
    Name = "Show Tracers",
    Default = false,
    Flag = "ESPTracers",
    Callback = function(state) ESPTracers = state end
})

ESPSection:CreateColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 255, 255),
    Flag = "ESPColor",
    Callback = function(val) ESPColor = val end
})

-- Drawing ESP Logic
local ESPCache = {}
local function CreateESP(player)
    local esp = {}
    pcall(function()
        esp.Box = Drawing.new("Square")
        esp.Box.Visible = false
        esp.Box.Filled = false
        esp.Box.Thickness = 1
        
        esp.Name = Drawing.new("Text")
        esp.Name.Visible = false
        esp.Name.Center = true
        esp.Name.Outline = true
        esp.Name.Size = 16
        
        esp.Tracer = Drawing.new("Line")
        esp.Tracer.Visible = false
        esp.Tracer.Thickness = 1
    end)
    return esp
end

local function RemoveESP(player)
    if ESPCache[player] then
        pcall(function()
            if ESPCache[player].Box then ESPCache[player].Box:Remove() end
            if ESPCache[player].Name then ESPCache[player].Name:Remove() end
            if ESPCache[player].Tracer then ESPCache[player].Tracer:Remove() end
        end)
        ESPCache[player] = nil
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then ESPCache[player] = CreateESP(player) end
end
Players.PlayerAdded:Connect(function(player) ESPCache[player] = CreateESP(player) end)
Players.PlayerRemoving:Connect(function(player) RemoveESP(player) end)

RunService.RenderStepped:Connect(function()
    for player, esp in pairs(ESPCache) do
        if ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local hrp = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head") or hrp
            
            local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
            
            if onScreen then
                local boxHeight = math.abs(headPos.Y - legPos.Y)
                local boxWidth = boxHeight * 0.65
                
                if ESPBoxes and esp.Box then
                    esp.Box.Size = Vector2.new(boxWidth, boxHeight)
                    esp.Box.Position = Vector2.new(hrpPos.X - boxWidth/2, headPos.Y)
                    esp.Box.Color = ESPColor
                    esp.Box.Visible = true
                elseif esp.Box then esp.Box.Visible = false end
                
                if ESPNames and esp.Name then
                    local dist = math.floor((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 0)
                    esp.Name.Text = player.Name .. " [" .. tostring(dist) .. "]"
                    esp.Name.Position = Vector2.new(hrpPos.X, headPos.Y - 18)
                    esp.Name.Color = ESPColor
                    esp.Name.Visible = true
                elseif esp.Name then esp.Name.Visible = false end
                
                if ESPTracers and esp.Tracer then
                    esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    esp.Tracer.To = Vector2.new(hrpPos.X, hrpPos.Y)
                    esp.Tracer.Color = ESPColor
                    esp.Tracer.Visible = true
                elseif esp.Tracer then esp.Tracer.Visible = false end
            else
                if esp.Box then esp.Box.Visible = false end
                if esp.Name then esp.Name.Visible = false end
                if esp.Tracer then esp.Tracer.Visible = false end
            end
        else
            if esp.Box then esp.Box.Visible = false end
            if esp.Name then esp.Name.Visible = false end
            if esp.Tracer then esp.Tracer.Visible = false end
        end
    end
end)


local SpectateSection = VisualsTab:CreateSection("Spectator")
local function GetSpectatePlayers()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return names
end

local SpectateDropdown = SpectateSection:CreateDropdown({
    Name = "Select Target",
    Options = GetSpectatePlayers(),
    Default = "",
    Searchable = true,
    Callback = function(val) end
})

SpectateSection:CreateButton("Refresh List", function()
    SpectateDropdown.SetOptions(GetSpectatePlayers())
end)

SpectateSection:CreateToggle({
    Name = "Spectate Target",
    Default = false,
    Flag = "Spectate",
    Callback = function(state)
        if state then
            local targetName = SpectateDropdown.GetValue()
            local p = Players:FindFirstChild(targetName)
            if p and p.Character and p.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = p.Character.Humanoid
            end
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character.Humanoid
            end
        end
    end
})

-- ==========================================
-- MISC TAB
-- ==========================================
local UtilitySection = MiscTab:CreateSection("Utility")

UtilitySection:CreateButton("Rejoin Server", function()
    Window:CreateDialog({
        Title = "Rejoin Server",
        Message = "Are you sure you want to leave and rejoin this server? Your current progress might not be saved if you are in combat.",
        Buttons = {
            {
                Name = "Yes, Rejoin",
                Callback = function()
                    if #Players:GetPlayers() <= 1 then
                        LocalPlayer:Kick("\nRejoining...")
                        task.wait()
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    else
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                    end
                end
            },
            {
                Name = "Cancel"
            }
        }
    })
end)

UtilitySection:CreateButton("Server Hop", function()
    local HttpService = game:GetService("HttpService")
    local req = request or http_request or (syn and syn.request)
    if req then
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local success, res = pcall(function() return req({Url = url, Method = "GET"}) end)
        if success and res.Body then
            local data = HttpService:JSONDecode(res.Body)
            if data and data.data then
                for _, server in ipairs(data.data) do
                    if type(server) == "table" and server.id ~= game.JobId and server.playing < server.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                        break
                    end
                end
            end
        end
    else
        K_UI:Notify("Error", "Executor doesn't support request function.", 3)
    end
end)

local WorldSection = MiscTab:CreateSection("World")
local Lighting = game:GetService("Lighting")

WorldSection:CreateToggle({
    Name = "Fullbright",
    Default = false,
    Flag = "Fullbright",
    Callback = function(state)
        if state then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        else
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        end
    end
})

K_UI:Notify("Universal Hub", "Loaded successfully! Enjoy.", 5)
