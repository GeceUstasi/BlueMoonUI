-- K-UI Full Showcase Script
-- This script demonstrates every single feature available in the K-UI Library.

local K_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/GeceUstasi/BlueMoonUI/master/K-UI.lua"))()

-- 1. Create the Main Window
local Window = K_UI:CreateWindow("K-UI Showcase", {
    Accent = Color3.fromRGB(255, 90, 90) -- Red accent color
})

-- 2. Create Tabs
local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local SettingsTab = Window:CreateTab("Settings")

-- ==========================================
-- COMBAT TAB
-- ==========================================
local AimbotSection = CombatTab:CreateSection("Aimbot Settings")

-- Paragraph (Information text)
AimbotSection:CreateParagraph("Welcome to K-UI! This is a paragraph. It's great for showing instructions, warnings, or general information to the user.")

-- Toggle
AimbotSection:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Tooltip = "Turns the aimbot on or off.",
    Flag = "AimbotEnabled",
    Callback = function(state)
        print("Aimbot enabled:", state)
    end
})

-- Slider
AimbotSection:CreateSlider({
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

-- Dropdown
AimbotSection:CreateDropdown({
    Name = "Target Part (Searchable)",
    Options = {"Head", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg"},
    Default = "Head",
    Tooltip = "Select which body part the aimbot should lock onto. You can type to search!",
    Flag = "TargetPart",
    Callback = function(selected)
        print("Target Part set to:", selected)
    end
})

-- Button
AimbotSection:CreateButton({
    Name = "Reset Aimbot Target",
    Tooltip = "Clears your current aimbot target immediately.",
    Callback = function()
        print("Aimbot target reset!")
    end
})


-- ==========================================
-- VISUALS TAB
-- ==========================================
local ESPSection = VisualsTab:CreateSection("ESP Options")

-- Multi-Dropdown
ESPSection:CreateMultiDropdown({
    Name = "ESP Filters",
    Options = {"Players", "NPCs", "Items", "Vehicles", "Chests"},
    Default = {"Players", "NPCs"},
    Tooltip = "Select multiple entities to draw ESP boxes around.",
    Flag = "ESPFilters",
    Callback = function(selectedArray)
        print("ESP Filters updated:")
        for _, v in pairs(selectedArray) do
            print("-", v)
        end
    end
})

-- Color Picker
ESPSection:CreateColorPicker({
    Name = "ESP Box Color (Alpha)",
    Default = Color3.fromRGB(255, 0, 0),
    Tooltip = "Choose the color and transparency (Alpha) for the ESP boxes.",
    Flag = "ESPBoxColor",
    Callback = function(color)
        print("ESP Color changed to:", color.R, color.G, color.B)
    end
})


-- ==========================================
-- SETTINGS TAB
-- ==========================================
local MiscSection = SettingsTab:CreateSection("Miscellaneous")

-- Keybind
MiscSection:CreateKeybind({
    Name = "Triggerbot Key (Hold Mode)",
    Default = Enum.KeyCode.E,
    Tooltip = "Hold this key to automatically shoot when aiming at an enemy.",
    Flag = "TriggerKey",
    Callback = function(key)
        print("Triggerbot Key set to:", key.Name)
    end
})

-- TextBox
MiscSection:CreateTextBox({
    Name = "Player to Target",
    Placeholder = "Enter username...",
    Tooltip = "Type a player's exact username here to exclusively target them.",
    Flag = "TargetUsername",
    Callback = function(text)
        print("Now targeting player:", text)
    end
})

local ConfigSection = SettingsTab:CreateSection("Configuration System")

ConfigSection:CreateButton({
    Name = "Save Config",
    Tooltip = "Saves your current settings to your workspace folder.",
    Callback = function()
        -- Saves all elements that have a 'Flag' assigned to them.
        Window:SaveConfig("K_UI_Configs", "MyShowcaseConfig")
        print("Config saved!")
    end
})

ConfigSection:CreateButton({
    Name = "Load Config",
    Tooltip = "Loads your settings from your workspace folder.",
    Callback = function()
        Window:LoadConfig("K_UI_Configs", "MyShowcaseConfig")
        print("Config loaded!")
    end
})

-- Finally, switch to the first tab when the UI loads.
Window:SelectTab("Combat")
