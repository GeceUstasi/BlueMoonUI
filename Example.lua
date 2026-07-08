-- ==============================================================================
-- K-UI Full & Exhaustive Showcase Script
-- Demonstrates EVERY SINGLE MODULE and API FEATURE available in the library!
-- ==============================================================================

local K_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/GeceUstasi/BlueMoonUI/master/K-UI.lua"))()

-- 1. Create the Main Window
local Window = K_UI:CreateWindow("Blue Moon - Full Showcase", {
    Accent = Color3.fromRGB(114, 137, 218),
    Acrylic = true -- Enables background blur when UI is open!
})

-- 2. Create Tabs
local ModuleTab = Window:CreateTab("All Modules", "lucide-layout-list")
local ApiTab = Window:CreateTab("API Showcase", "lucide-code-xml")
local DisableTab = Window:CreateTab("Toggle Control (Özel)", "lucide-power-off")
local EspTab = Window:CreateTab("Live Updates", "lucide-eye")
local SettingTab = Window:CreateTab("Settings", "lucide-settings")

-- ==========================================
-- TAB 1: ALL MODULES (Features)
-- ==========================================
local BasicSection = ModuleTab:CreateSection("Basic Elements")

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
local panicButton = BasicSection:CreateButton("Panic Button (Force Aimbot OFF)", function()
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
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = value
        end
    end
})

local AdvSection = ModuleTab:CreateSection("Advanced Elements")

-- Dropdown
local priorityDropdown = AdvSection:CreateDropdown({
    Name = "Target Priority",
    Options = {"Distance", "Health", "Threat"},
    Default = "Distance",
    Searchable = true,
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
    Flag = "ESPBoxColor",
    Callback = function(color)
        print("ESP Color changed to:", color)
    end
})

-- Keybind
local triggerBind = AdvSection:CreateKeybind({
    Name = "Triggerbot Key",
    Default = Enum.KeyCode.E,
    Flag = "TriggerKey",
    Callback = function(state)
        print("Triggerbot Hold State:", state)
    end
})

-- TextBox
local targetTextBox = AdvSection:CreateTextBox({
    Name = "Player to Target",
    Placeholder = "Enter username...",
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

ActionSection:CreateButton("Set Walkspeed to 100", function()
    speedSlider.SetValue(100) 
end)

ActionSection:CreateButton("Morph 'Target Priority' Dropdown", function()
    priorityDropdown.SetTitle("Select Target Method (Updated!)")
    priorityDropdown.SetDescription("This tooltip was changed by the API!")
    priorityDropdown.SetOptions({"Closest", "Lowest HP", "Highest Level", "Random"})
end)

ActionSection:CreateButton("Morph TextBox", function()
    targetTextBox.SetTitle("Enter Target ID (Changed)")
    targetTextBox.SetDescription("Now enter an ID instead of a Username.")
end)

-- ==========================================
-- TAB 3: TOGGLE KONTROLÜ (Toggle Kaldırma/Kapatma)
-- ==========================================
local ControlSection = DisableTab:CreateSection("Toggle'ı Yönetme (Aimbot Toggle'ı)")

ControlSection:CreateLabel("Aşağıdaki butonlar 'All Modules' sekmesindeki Aimbot Toggle'ını kontrol eder.")

-- 1. YÖNTEM: Kod ile kapalı hale getirmek (İşlevini Kapatmak)
ControlSection:CreateButton("1. Toggle'ı ZORLA KAPAT (Değerini False Yap)", function()
    aimbotToggle.SetValue(false) -- Bu, kullanıcının Toggle'a tıklamasıyla aynı şeydir, işlevi kapatır.
    K_UI:Notify("Başarılı", "Aimbot Toggle'ı zorla kapatıldı!", 3)
end)

-- 2. YÖNTEM: Tıklanmasını engellemek (Disable yapmak)
local isToggleDisabled = false
ControlSection:CreateButton("2. Toggle'ı DEVRE DIŞI BIRAK / AÇ (Tıklanamaz Yap)", function()
    isToggleDisabled = not isToggleDisabled
    aimbotToggle.SetDisabled(isToggleDisabled) 
    if isToggleDisabled then
        K_UI:Notify("Kilitlendi", "Artık Aimbot Toggle'ına TIKLANAMAZ!", 3)
    else
        K_UI:Notify("Açıldı", "Artık Aimbot Toggle'ına Tıklanabilir!", 3)
    end
end)

-- 3. YÖNTEM: Tamamen gözden kaybetmek (Kaldırmak / Hide)
local isToggleHidden = false
ControlSection:CreateButton("3. Toggle'ı TAMAMEN KALDIR / GERİ GETİR (Görünmez Yap)", function()
    isToggleHidden = not isToggleHidden
    aimbotToggle.SetVisible(not isToggleHidden)
    if isToggleHidden then
        K_UI:Notify("Kaldırıldı", "Aimbot Toggle'ı GUI'den tamamen silindi!", 3)
    else
        K_UI:Notify("Geri Geldi", "Aimbot Toggle'ı tekrar görünür oldu!", 3)
    end
end)


-- ==========================================
-- TAB 4: ESP EXAMPLE (Live Player Updates)
-- ==========================================
local EspSection = EspTab:CreateSection("Target Selector")
EspSection:CreateLabel("Dropdown automatically updates with live players!")

local function GetPlayerNames()
    local names = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        table.insert(names, p.Name)
    end
    return names
end

local PlayerDropdown = EspSection:CreateDropdown({
    Name = "Select Player to Spectate",
    Options = GetPlayerNames(),
    Default = game.Players.LocalPlayer.Name,
    Searchable = true,
    Callback = function(selected)
        print("Spectating:", selected)
    end
})

local EspRefreshButton = EspSection:CreateButton("Refresh Player List", function()
    PlayerDropdown.SetOptions(GetPlayerNames())
    K_UI:Notify("Refreshed", "Player list has been successfully updated!", 2)
end)

-- ==========================================
-- TAB 5: SETTINGS
-- ==========================================
K_UI:BuildSettingsTab(SettingTab)

-- Notification Example
K_UI:Notify("Welcome!", "K-UI has successfully loaded the Full Showcase.", 5)
