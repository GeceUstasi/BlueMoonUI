-- ==============================================================================
-- K-UI Full & Exhaustive Showcase Script
-- Demonstrates EVERY SINGLE MODULE and API FEATURE available in the library!
-- ==============================================================================

local K_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/GeceUstasi/BlueMoonUI/7e9db95f310d27a0dfb4b7e8b3c323aaff445135/K-UI.lua"))()

-- 1. Create the Main Window (Acrylic Effect/Blur is enabled!)
local Window = K_UI:CreateWindow("K-UI Full API Showcase", {
    Accent = Color3.fromRGB(114, 137, 218),
    Acrylic = true -- Enables background blur when UI is open!
})

-- 2. Executor Detection
print("Successfully initialized on Executor:", K_UI.GetExecutor())

-- 3. Create Tabs
local ModuleTab = Window:CreateTab("All Modules")
local ApiTab = Window:CreateTab("API Showcase")
local EspTab = Window:CreateTab("ESP Example")
local SettingTab = Window:CreateTab("Settings")

-- ==========================================
-- TAB 1: ALL MODULES (Features)
-- ==========================================
local BasicSection = ModuleTab:CreateSection("Basic Elements")

-- Line Breaker (Divider)
BasicSection:CreateDivider("Status Panel")

-- Label
local statusLabel = BasicSection:CreateLabel("Aimbot is currently OFF")

-- Toggle
local aimbotToggle = BasicSection:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Tooltip = "Turn the Aimbot on or off.",
    Flag = "AimbotState",
    Callback = function(state)
        statusLabel.SetTitle("Aimbot is currently " .. (state and "ON" or "OFF"))
    end
})

-- Button
local panicButton = BasicSection:CreateButton("Panic Button (Disable Aimbot)", function()
    aimbotToggle.SetValue(false)
end)

BasicSection:CreateDivider("Adjustments")

-- Slider
local speedSlider = BasicSection:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Tooltip = "Adjusts your character's walking speed.",
    Flag = "WalkSpeed",
    Callback = function(value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

-- Keep the walkspeed applied even if they die and respawn!
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = speedSlider.GetValue()
    end
end)

local AdvSection = ModuleTab:CreateSection("Advanced Elements")

-- Dropdown
local priorityDropdown = AdvSection:CreateDropdown({
    Name = "Target Priority (Searchable)",
    Options = {"Distance", "Health", "Threat", "Crosshair"},
    Default = "Distance",
    Searchable = true, -- Adds a search bar to the dropdown!
    Tooltip = "Select which body part the aimbot should lock onto.",
    Flag = "TargetPriority",
    Callback = function(selected)
        print("Priority set to:", selected)
    end
})

-- Multi-Dropdown
local filterMultiDropdown = AdvSection:CreateMultiDropdown({
    Name = "ESP Filters",
    Options = {"Players", "NPCs", "Items", "Vehicles", "Chests"},
    Default = {"Players", "NPCs"},
    Tooltip = "Select multiple entities to draw ESP boxes around.",
    Flag = "ESPFilters",
    Callback = function(selectedArray)
        print("Selected ESP Filters:", unpack(selectedArray))
    end
})

AdvSection:CreateDivider("Visuals & Misc")

-- Color Picker
local espColorPicker = AdvSection:CreateColorPicker({
    Name = "ESP Box Color",
    Default = Color3.fromRGB(255, 0, 0),
    Tooltip = "Choose the color for the ESP boxes.",
    Flag = "ESPBoxColor",
    Callback = function(color)
        print("ESP Color changed to:", color)
    end
})

-- Keybind
local triggerBind = AdvSection:CreateKeybind({
    Name = "Triggerbot Key (Hold Mode)",
    Default = Enum.KeyCode.E,
    Tooltip = "Hold this key to automatically shoot.",
    Flag = "TriggerKey",
    OnBind = function(key)
        print("Triggerbot Key bound to:", key.Name)
    end,
    Callback = function(state)
        print("Triggerbot Hold State:", state)
    end
})

-- TextBox
local targetTextBox = AdvSection:CreateTextBox({
    Name = "Player to Target",
    Placeholder = "Enter username...",
    Tooltip = "Type a player's exact username here.",
    Flag = "TargetUsername",
    Callback = function(text)
        print("Now targeting player:", text)
    end
})

-- Clipboard
AdvSection:CreateClipboard("Copy Discord Invite", "https://discord.gg/invite")

-- ==========================================
-- TAB 2: API SHOWCASE (Magically alter TAB 1)
-- ==========================================
local ActionSection = ApiTab:CreateSection("Action Controls")

ActionSection:CreateLabel("The buttons below use SetValue() to change elements.")

ActionSection:CreateButton("Set Walkspeed to 100", function()
    -- SetValue() - Changes value from code
    speedSlider.SetValue(100) 
end)

ActionSection:CreateKeybind({
    Name = "Press X to Set WalkSpeed to 200",
    Default = Enum.KeyCode.X,
    Tooltip = "Press X on your keyboard to magically change the slider's value to 200!",
    Flag = "WalkSpeedTrigger",
    Callback = function(state)
        if state then
            speedSlider.SetValue(200)
            print("Walkspeed forced to 200 via Keybind!")
        end
    end
})

ActionSection:CreateButton("Enable Aimbot & ESP Filters", function()
    -- SetValue() - Changes value from code
    aimbotToggle.SetValue(true)
    filterMultiDropdown.SetValue({"Players", "Vehicles", "Chests"})
end)

local VisSection = ApiTab:CreateSection("Visibility Controls")

VisSection:CreateLabel("Use SetVisible() to hide/show elements.")

local isHidden = false
VisSection:CreateButton("Toggle Slider Visibility", function()
    isHidden = not isHidden
    -- SetVisible() - Show/Hide
    speedSlider.SetVisible(not isHidden) 
end)

local DisableSection = ApiTab:CreateSection("Disabling Controls")

DisableSection:CreateLabel("Use SetDisabled() to make elements un-interactable.")

local isDisabled = false
DisableSection:CreateButton("Toggle Aimbot Interactability", function()
    isDisabled = not isDisabled
    -- SetDisabled() - Disable/Enable element interaction
    aimbotToggle.SetDisabled(isDisabled)
    panicButton.SetDisabled(isDisabled)
end)

local ModSection = ApiTab:CreateSection("Modification Controls")

ModSection:CreateLabel("Use SetTitle, SetDescription, and SetOptions.")

ModSection:CreateButton("Morph 'Target Priority' Dropdown", function()
    -- SetTitle() - Change Title
    priorityDropdown.SetTitle("Select Target Method (Updated!)")
    
    -- SetDescription() - Change Tooltip
    priorityDropdown.SetDescription("This tooltip was changed by the API!")
    
    -- SetOptions() (or Refresh()) - Change Dropdown Options
    priorityDropdown.SetOptions({"Closest", "Lowest HP", "Highest Level", "Random"})
end)

ModSection:CreateButton("Morph TextBox", function()
    targetTextBox.SetTitle("Enter Target ID (Changed)")
    targetTextBox.SetDescription("Now enter an ID instead of a Username.")
end)

local InfoSection = ApiTab:CreateSection("Data Reading")

InfoSection:CreateButton("Print Current Aimbot State", function()
    -- GetValue() - Read value without callback
    local state = aimbotToggle.GetValue()
    print("Aimbot is currently:", state)
end)

InfoSection:CreateButton("Print Executor Name", function()
    -- Executor Detection
    print("Your Executor is:", K_UI.GetExecutor())
end)

-- ==========================================
-- TAB 3: ESP EXAMPLE (Live Player Updates)
-- ==========================================
local EspSection = EspTab:CreateSection("Target Selector")

EspSection:CreateLabel("Demonstrates updating a dropdown with live players in the game!")

-- Create the dropdown with initial players
local function GetPlayerNames()
    local names = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        table.insert(names, p.Name)
    end
    if #names == 0 then table.insert(names, "No Players Found") end
    return names
end

local playerTargetDropdown = EspSection:CreateDropdown({
    Name = "Select Player to ESP",
    Options = GetPlayerNames(),
    Default = "Select...",
    Searchable = true,
    Tooltip = "Choose a player from the server.",
    Flag = "EspTargetPlayer",
    Callback = function(selected)
        print("ESP Target changed to:", selected)
    end
})

EspSection:CreateButton("Refresh Player List", function()
    -- Get the freshest list of players
    local freshNames = GetPlayerNames()
    
    -- Update the dropdown dynamically using SetOptions!
    playerTargetDropdown.SetOptions(freshNames)
    print("Player list refreshed! Total players:", #freshNames)
end)


-- ==========================================
-- TAB 4: SETTINGS (Config System)
-- ==========================================
local ConfigSection = SettingTab:CreateSection("Configuration")

ConfigSection:CreateLabel("Values Depolama Sistemi (Flags)")
ConfigSection:CreateLabel("Any element with a 'Flag' property is saved here.")

ConfigSection:CreateButton("Save Config", function()
    Window:SaveConfig("K_UI_Configs", "FullShowcaseConfig")
    print("Config saved!")
end)

ConfigSection:CreateButton("Load Config", function()
    Window:LoadConfig("K_UI_Configs", "FullShowcaseConfig")
    print("Config loaded!")
end)

-- ==========================================
-- EVENT LISTENERS SHOWCASE (OnChanged)
-- ==========================================
-- You can attach an event AFTER creating an element!
speedSlider.OnChanged(function(newVal)
    print("[API LOG] Speed slider was moved to:", newVal)
end)

-- The first tab is selected automatically.
