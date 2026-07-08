-- ==============================================================================
-- K-UI Full Showcase & API Testing Script
-- Demonstrates every single feature and API method available in the K-UI Library.
-- ==============================================================================

local K_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/GeceUstasi/BlueMoonUI/aeca21a14444693fdee3ecb1408e99342e2c3b94/K-UI.lua"))()

-- 1. Create the Main Window (Notice the Acrylic parameter!)
local Window = K_UI:CreateWindow("K-UI Full Showcase", {
    Accent = Color3.fromRGB(58, 108, 243),
    Acrylic = true -- Enables background blur when UI is open!
})

print("Injected successfully via:", K_UI.GetExecutor())

-- 2. Create Tabs
local MainTab = Window:CreateTab("Main Features")
local ApiTab = Window:CreateTab("API Testing")
local SettingsTab = Window:CreateTab("Settings")

-- ==========================================
-- MAIN FEATURES TAB
-- ==========================================
local BasicSection = MainTab:CreateSection("Basic Elements")

-- Label
local infoLabel = BasicSection:CreateLabel("Welcome! This tab shows standard UI elements.")

-- Toggle
local aimbotToggle = BasicSection:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Tooltip = "Turn the Aimbot on or off.",
    Flag = "AimbotToggle",
    Callback = function(state)
        print("Aimbot is now:", state)
    end
})

BasicSection:CreateDivider("Adjustments")

-- Slider
local fovSlider = BasicSection:CreateSlider({
    Name = "Aimbot FOV",
    Min = 0,
    Max = 360,
    Default = 90,
    Tooltip = "Adjusts the field of view for the aimbot.",
    Flag = "AimbotFOV",
    Callback = function(value)
        print("Aimbot FOV set to:", value)
    end
})

-- Button
BasicSection:CreateButton("Reset FOV to 90", function()
    fovSlider.SetValue(90)
    print("FOV Reset via script!")
end)

local AdvSection = MainTab:CreateSection("Advanced Elements")

-- Dropdown
local priorityDropdown = AdvSection:CreateDropdown({
    Name = "Target Priority (Searchable)",
    Options = {"Distance", "Health", "Threat", "Crosshair"},
    Default = "Distance",
    Searchable = true,
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
        print("ESP Filters updated! Selected count:", #selectedArray)
    end
})

AdvSection:CreateDivider()

-- Color Picker
local espColorPicker = AdvSection:CreateColorPicker({
    Name = "ESP Box Color (Alpha)",
    Default = Color3.fromRGB(255, 0, 0),
    Tooltip = "Choose the color and transparency (Alpha) for the ESP boxes.",
    Flag = "ESPBoxColor",
    Callback = function(color)
        print("ESP Color changed to:", color.R, color.G, color.B)
    end
})

-- Keybind
local triggerBind = AdvSection:CreateKeybind({
    Name = "Triggerbot Key (Hold Mode)",
    Default = Enum.KeyCode.E,
    Tooltip = "Hold this key to automatically shoot when aiming at an enemy.",
    Flag = "TriggerKey",
    OnBind = function(key)
        print("Triggerbot Key set to:", key.Name)
    end,
    Callback = function(state)
        print("Triggerbot Active:", state)
    end
})

-- TextBox
local targetTextBox = AdvSection:CreateTextBox({
    Name = "Player to Target",
    Placeholder = "Enter username...",
    Tooltip = "Type a player's exact username here to exclusively target them.",
    Flag = "TargetUsername",
    Callback = function(text)
        print("Now targeting player:", text)
    end
})

-- Clipboard
AdvSection:CreateClipboard("Copy Discord Invite", "https://discord.gg/invite")


-- ==========================================
-- API TESTING TAB
-- ==========================================
local DynamicSection = ApiTab:CreateSection("Dynamic API Controls")

DynamicSection:CreateLabel("Use the buttons below to magically alter the elements in the 'Main Features' tab using the new K-UI API!")

DynamicSection:CreateDivider("Visibility API")

DynamicSection:CreateToggle({
    Name = "Hide FOV Slider",
    Default = false,
    Callback = function(state)
        fovSlider.SetVisible(not state) -- If true, Visible becomes false
    end
})

DynamicSection:CreateToggle({
    Name = "Hide ESP Filters",
    Default = false,
    Callback = function(state)
        filterMultiDropdown.SetVisible(not state)
    end
})

DynamicSection:CreateDivider("Disable API")

DynamicSection:CreateToggle({
    Name = "Disable Aimbot Toggle",
    Default = false,
    Tooltip = "Makes the toggle unclickable and greyed out.",
    Callback = function(state)
        aimbotToggle.SetDisabled(state)
    end
})

DynamicSection:CreateToggle({
    Name = "Disable Target Priority",
    Default = false,
    Callback = function(state)
        priorityDropdown.SetDisabled(state)
    end
})

DynamicSection:CreateDivider("Modification API")

DynamicSection:CreateButton("Change Toggle Title & Description", function()
    aimbotToggle.SetTitle("Super Aimbot (PRO)")
    aimbotToggle.SetDescription("This description was dynamically updated via API.SetDescription!")
end)

DynamicSection:CreateButton("Set FOV to 360", function()
    fovSlider.SetValue(360)
end)

DynamicSection:CreateButton("Update Priority Options (Dropdown)", function()
    priorityDropdown.SetOptions({"Closest", "Lowest HP", "Highest Level", "Random"})
    priorityDropdown.SetTitle("Target Priority (Updated Options)")
    print("Dropdown options updated via API!")
end)

DynamicSection:CreateButton("Change Textbox Title", function()
    targetTextBox.SetTitle("Target by User ID instead")
    targetTextBox.SetValue("123456789")
end)

-- ==========================================
-- SETTINGS TAB (Configs)
-- ==========================================
local ConfigSection = SettingsTab:CreateSection("Configuration System")

ConfigSection:CreateButton("Save Config", function()
    -- Saves all elements that have a 'Flag' assigned to them.
    Window:SaveConfig("K_UI_Configs", "MyShowcaseConfig")
    print("Config saved!")
end)

ConfigSection:CreateButton("Load Config", function()
    Window:LoadConfig("K_UI_Configs", "MyShowcaseConfig")
    print("Config loaded!")
end)

-- The first tab is selected automatically.
