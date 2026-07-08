local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {
    Themes = {
        MainBackground = Color3.fromRGB(15, 18, 35),
        SectionBackground = Color3.fromRGB(11, 13, 26),
        Border = Color3.fromRGB(32, 37, 64),
        Accent = Color3.fromRGB(58, 108, 243),
        ButtonBackground = Color3.fromRGB(43, 66, 141),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(159, 162, 186),
        TextDark = Color3.fromRGB(75, 82, 125),
        Ping = Color3.fromRGB(211, 158, 51),
        IconColor = Color3.fromRGB(255, 255, 255),
        HeaderButtonBackground = Color3.fromRGB(20, 24, 45),
        HighlightLine = Color3.fromRGB(70, 85, 135) -- Simple, clean, but bright highlight
    },
    Icons = {
        Moon = "rbxassetid://7733911828",
        Settings = "rbxassetid://7059346373", -- Fixed Gear icon
        EyeSlash = "rbxassetid://7733774602",
        Power = "rbxassetid://7734053495",
        ChevronDown = "rbxassetid://7733749065",
        Farm = "rbxassetid://7733964719", -- Link
        Fishing = "rbxassetid://7743875329", -- Fish/Anchor
        Microwave = "rbxassetid://7733779610", -- Flame
        Player = "rbxassetid://7734068321", -- User
        Teleports = "rbxassetid://7733964719", -- Map
        Other = "rbxassetid://7743867623" -- Zap
    }
}

-- Utilities
local function Create(className, properties, children)
    local instance = Instance.new(className)
    for k, v in pairs(properties or {}) do
        instance[k] = v
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

local function Tween(instance, properties, duration, easingStyle, easingDirection)
    local style = easingStyle or Enum.EasingStyle.Quart
    local direction = easingDirection or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration or 0.3, style, direction)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

Library.Flags = {}

local HttpService = game:GetService("HttpService")

function Library:SaveConfig(folderName, fileName)
    if not isfolder or not writefile then return false end
    if not isfolder(folderName) then makefolder(folderName) end
    local data = {}
    for flag, api in pairs(Library.Flags) do
        data[flag] = api.GetValue()
    end
    writefile(folderName .. "/" .. fileName .. ".json", HttpService:JSONEncode(data))
    return true
end

function Library:LoadConfig(folderName, fileName)
    if not isfile or not readfile then return false end
    local path = folderName .. "/" .. fileName .. ".json"
    if isfile(path) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        if success and type(data) == "table" then
            for flag, val in pairs(data) do
                if Library.Flags[flag] then
                    Library.Flags[flag].Set(val)
                end
            end
            return true
        end
    end
    return false
end

function Library:CreateWindow(options)
    options = options or {}
    local Title = options.Title or "Blue Moon"
    local Version = options.Version or "v1.1.2 Alpha"
    local ProfileName = options.ProfileName or Players.LocalPlayer and Players.LocalPlayer.Name or "XxGECEUSTASIxX"
    local Ping = options.Ping or "106 ms"
    local Theme = self.Themes
    
    -- Cleanup
    if CoreGui:FindFirstChild("K-UI") then
        CoreGui:FindFirstChild("K-UI"):Destroy()
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "K-UI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    -- Intro Animation
    local IntroFrame = Create("Frame", {
        BackgroundColor3 = Theme.MainBackground,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        ZIndex = 9999,
        Parent = ScreenGui
    })
    
    local IntroText = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -30),
        Font = Enum.Font.Ubuntu,
        Text = "K-UI",
        TextColor3 = Theme.Accent,
        TextSize = 60,
        TextTransparency = 1,
        ZIndex = 10000,
        Parent = IntroFrame
    })

    local IntroCredit = Create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 40),
        Font = Enum.Font.Ubuntu,
        Text = "by ijosephk",
        TextColor3 = Theme.TextSecondary,
        TextSize = 20,
        TextTransparency = 1,
        ZIndex = 10000,
        Parent = IntroFrame
    })
    
    Tween(IntroText, {TextTransparency = 0}, 1)
    Tween(IntroCredit, {TextTransparency = 0}, 1)
    
    -- Main Frame (CanvasGroup for smooth fades)
    local Main = Create("CanvasGroup", {
        Name = "Main",
        BackgroundColor3 = Theme.MainBackground,
        Position = UDim2.new(0.5, -400, 0.5, -260), -- Start slightly lower
        Size = UDim2.new(0, 800, 0, 550),
        GroupTransparency = 1, -- Start invisible
        Active = true
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
        Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
    })
    Main.Parent = ScreenGui

    -- Finish intro animation asynchronously
    task.spawn(function()
        task.wait(1.5)
        local t1 = Tween(IntroText, {TextTransparency = 1, Position = UDim2.new(0, 0, -0.1, 0)}, 0.5)
        local t2 = Tween(IntroCredit, {TextTransparency = 1, Position = UDim2.new(0, 0, 0.1, 40)}, 0.5)
        local t3 = Tween(IntroFrame, {BackgroundTransparency = 1}, 0.5)
        t3.Completed:Wait()
        IntroFrame:Destroy()
        
        -- Pop in animation for Main
        Main.Size = UDim2.new(0, 600, 0, 400)
        Main.Position = UDim2.new(0.5, -300, 0.5, -200)
        Tween(Main, {GroupTransparency = 0, Size = UDim2.new(0, 800, 0, 550), Position = UDim2.new(0.5, -400, 0.5, -260)}, 0.4)
    end)

    -- Open Button (Hidden initially)
    local OpenBtn = Create("TextButton", {
        Name = "OpenBtn",
        BackgroundColor3 = Theme.MainBackground,
        Position = UDim2.new(0.5, -20, 0, -60), -- Hidden above screen
        Size = UDim2.new(0, 40, 0, 40),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
        Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
    })
    Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -12, 0.5, -12),
        Size = UDim2.new(0, 24, 0, 24),
        Image = Library.Icons.Moon,
        ImageColor3 = Theme.Accent
    }).Parent = OpenBtn
    OpenBtn.Parent = ScreenGui

    OpenBtn.MouseEnter:Connect(function() Tween(OpenBtn, {BackgroundColor3 = Theme.Border}, 0.2) end)
    OpenBtn.MouseLeave:Connect(function() Tween(OpenBtn, {BackgroundColor3 = Theme.MainBackground}, 0.2) end)

    -- Smooth Open Animation
    Tween(Main, {GroupTransparency = 0, Position = UDim2.new(0.5, -400, 0.5, -275)}, 0.6, Enum.EasingStyle.Quint)

    local NotifyContainer = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -320, 1, -20),
        Size = UDim2.new(0, 300, 1, 0),
        AnchorPoint = Vector2.new(0, 1)
    }, {
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 10)
        })
    })
    NotifyContainer.Parent = ScreenGui

    function Library:Notify(title, text, duration)
        local time = duration or 3
        local Notif = Create("CanvasGroup", {
            BackgroundColor3 = Theme.MainBackground,
            Size = UDim2.new(1, 50, 0, 0), -- Start shifted right for slide effect
            AutomaticSize = Enum.AutomaticSize.Y,
            GroupTransparency = 1
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
            Create("UIPadding", { PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15) })
        })
        
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Font = Enum.Font.Ubuntu,
            Text = title,
            TextColor3 = Theme.Accent,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        }).Parent = Notif
        
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 25),
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Font = Enum.Font.Ubuntu,
            Text = text,
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left
        }).Parent = Notif
        
        Notif.Parent = NotifyContainer
        
        -- Slide and fade in
        Tween(Notif, {GroupTransparency = 0, Size = UDim2.new(1, 0, 0, 0)}, 0.4, Enum.EasingStyle.Quint)
        
        task.spawn(function()
            task.wait(time)
            local fade = Tween(Notif, {GroupTransparency = 1}, 0.4)
            fade.Completed:Wait()
            Notif:Destroy()
        end)
    end

    -- Header
    local Header = Create("Frame", {
        Name = "Header",
        BackgroundColor3 = Theme.MainBackground,
        Size = UDim2.new(1, 0, 0, 50),
        Active = true,
        ZIndex = 5
    })
    Header.Parent = Main
    
    -- Header Separator (Horizontal Highlight)
    Create("Frame", {
        BackgroundColor3 = Theme.HighlightLine,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1),
        ZIndex = 6
    }).Parent = Header

    -- Header Content: Left
    local MoonIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0.5, -15),
        Size = UDim2.new(0, 30, 0, 30),
        Image = Library.Icons.Moon,
        ImageColor3 = Theme.Accent
    })
    MoonIcon.Parent = Header

    local TitleLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 60, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.Ubuntu,
        Text = Title,
        TextColor3 = Theme.TextPrimary,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    TitleLabel.Parent = Header

    local VersionLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 60 + TitleLabel.TextBounds.X + 60, 0, 0), -- Roughly estimating position next to title
        Size = UDim2.new(0, 100, 1, 0),
        Font = Enum.Font.Ubuntu,
        Text = Version,
        TextColor3 = Theme.TextDark,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    VersionLabel.Parent = Header
    
    -- Fix version label position dynamically
    TitleLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        VersionLabel.Position = UDim2.new(0, TitleLabel.Position.X.Offset + TitleLabel.TextBounds.X + 10, 0, 0)
    end)

    -- Header Content: Right
    local PingLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -230, 0, 0),
        Size = UDim2.new(0, 80, 1, 0),
        Font = Enum.Font.Ubuntu,
        Text = Ping,
        TextColor3 = Theme.Ping,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    PingLabel.Parent = Header

    -- Canlı Ping Döngüsü
    task.spawn(function()
        while PingLabel.Parent do
            local success, pingVal = pcall(function()
                -- GetNetworkPing returns seconds, multiply by 1000 for ms
                return math.round(Players.LocalPlayer:GetNetworkPing() * 1000)
            end)
            if success and pingVal then
                PingLabel.Text = tostring(pingVal) .. " ms"
            end
            task.wait(1)
        end
    end)

    local HeaderRight = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -145, 0, 0),
        Size = UDim2.new(0, 130, 1, 0),
    }, {
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
    })
    HeaderRight.Parent = Header

    local function CreateHeaderBtn(icon, colorOverride, layoutOrder)
        local Btn = Create("TextButton", {
            BackgroundColor3 = Theme.HeaderButtonBackground,
            Size = UDim2.new(0, 32, 0, 32),
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = layoutOrder
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
            Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
        })
        Create("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -9, 0.5, -9),
            Size = UDim2.new(0, 18, 0, 18),
            Image = icon,
            ImageColor3 = colorOverride or Theme.TextSecondary
        }).Parent = Btn
        
        Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.Border}, 0.2) end)
        Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.HeaderButtonBackground}, 0.2) end)
        return Btn
    end

    local SettingsBtn = CreateHeaderBtn("rbxassetid://11293977610", nil, 1) -- Proper Lucide Gear
    local HideBtn = CreateHeaderBtn("rbxassetid://11293977196", nil, 2) -- Proper Lucide Eye
    local CloseBtn = CreateHeaderBtn("rbxassetid://11293978393", Color3.fromRGB(220, 60, 60), 3) -- Proper Lucide Power
    
    SettingsBtn.Parent = HeaderRight
    HideBtn.Parent = HeaderRight
    CloseBtn.Parent = HeaderRight

    CloseBtn.MouseButton1Click:Connect(function()
        local closeTween = Tween(Main, {GroupTransparency = 1, Position = UDim2.new(0.5, -400, 0.5, -260)}, 0.4, Enum.EasingStyle.Quint)
        closeTween.Completed:Wait()
        ScreenGui:Destroy()
    end)

    -- Hide / Show Logic
    local isHidden = false

    HideBtn.MouseButton1Click:Connect(function()
        if not isHidden then
            isHidden = true
            local hideTween = Tween(Main, {GroupTransparency = 1, Position = UDim2.new(0.5, -400, 0.5, -250)}, 0.4, Enum.EasingStyle.Quint)
            Tween(OpenBtn, {Position = UDim2.new(0.5, -20, 0, 20)}, 0.5, Enum.EasingStyle.Back)
            hideTween.Completed:Wait()
            if isHidden then Main.Visible = false end
        end
    end)

    OpenBtn.MouseButton1Click:Connect(function()
        if isHidden then
            isHidden = false
            Main.Visible = true
            Tween(OpenBtn, {Position = UDim2.new(0.5, -20, 0, -60)}, 0.4, Enum.EasingStyle.Quint)
            Tween(Main, {GroupTransparency = 0, Position = UDim2.new(0.5, -400, 0.5, -275)}, 0.5, Enum.EasingStyle.Quint)
        end
    end)

    -- Draggable Logic (Smooth Lerp)
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    local targetPos = Main.Position

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            targetPos = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    RunService.RenderStepped:Connect(function(dt)
        if Main and Main.Parent then
            Main.Position = Main.Position:Lerp(targetPos, math.clamp(dt * 12, 0, 1))
        end
    end)

    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.MainBackground,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(0, 180, 1, -50),
        ZIndex = 2
    })
    Sidebar.Parent = Main
    
    -- Sidebar Separator (Vertical Highlight)
    Create("Frame", {
        BackgroundColor3 = Theme.HighlightLine,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        ZIndex = 6
    }).Parent = Sidebar

    -- Profile Area
    local ProfileArea = Create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 100)
    })
    ProfileArea.Parent = Sidebar

    local AvatarCircle = Create("Frame", {
        BackgroundColor3 = Theme.MainBackground,
        Position = UDim2.new(0.5, -25, 0, 20),
        Size = UDim2.new(0, 50, 0, 50)
    }, {
        Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        Create("UIStroke", { Color = Theme.Accent, Thickness = 2 })
    })
    AvatarCircle.Parent = ProfileArea

    -- Get real avatar
    local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or 1
    local avatarImage = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    pcall(function()
        avatarImage = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)

    local AvatarIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Image = avatarImage
    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    AvatarIcon.Parent = AvatarCircle

    local OnlineDot = Create("Frame", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0, 45, 0, 85),
        Size = UDim2.new(0, 8, 0, 8)
    }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    OnlineDot.Parent = ProfileArea

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 60, 0, 80),
        Size = UDim2.new(0, 100, 0, 18),
        Font = Enum.Font.Ubuntu,
        Text = ProfileName,
        TextColor3 = Theme.TextDark,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }).Parent = ProfileArea

    -- Info Header
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 25, 0, 120),
        Size = UDim2.new(1, -25, 0, 20),
        Font = Enum.Font.Ubuntu,
        Text = "Info",
        TextColor3 = Theme.TextPrimary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }).Parent = Sidebar

    -- Tabs Container
    local TabsContainer = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 150),
        Size = UDim2.new(1, 0, 1, -150),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0
    }, {
        Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) }),
        Create("UIPadding", { PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15) })
    })
    TabsContainer.Parent = Sidebar

    -- Main Content Area
    local ContentArea = Create("Frame", {
        BackgroundColor3 = Theme.MainBackground,
        Position = UDim2.new(0, 180, 0, 50),
        Size = UDim2.new(1, -180, 1, -50),
        BorderSizePixel = 0
    })
    ContentArea.Parent = Main

    local WindowObj = { CurrentTab = nil }

    function WindowObj:CreateTab(name, iconId)
        local TabBtn = Create("TextButton", {
            BackgroundColor3 = Theme.MainBackground,
            Size = UDim2.new(1, 0, 0, 38),
            Text = "",
            AutoButtonColor = false
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0, 8) })
        })
        TabBtn.Parent = TabsContainer

        local TabIcon = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0.5, -9),
            Size = UDim2.new(0, 18, 0, 18),
            Image = iconId or "",
            ImageColor3 = Theme.TextSecondary
        })
        TabIcon.Parent = TabBtn

        local TabLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 45, 0, 0),
            Size = UDim2.new(1, -45, 1, 0),
            Font = Enum.Font.Ubuntu,
            Text = name,
            TextColor3 = Theme.TextPrimary,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        TabLabel.Parent = TabBtn

        local TabContent = Create("ScrollingFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Border,
            Visible = false
        }, {
            Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 15) }),
            Create("UIPadding", { PaddingTop = UDim.new(0, 20), PaddingBottom = UDim.new(0, 20), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20) })
        })
        TabContent.Parent = ContentArea

        TabContent.ChildAdded:Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 40)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            if WindowObj.CurrentTab == name then return end
            
            for _, child in pairs(TabsContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    Tween(child, {BackgroundColor3 = Theme.MainBackground}, 0.2)
                    Tween(child.ImageLabel, {ImageColor3 = Theme.TextSecondary}, 0.2)
                end
            end
            Tween(TabBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
            Tween(TabIcon, {ImageColor3 = Theme.TextPrimary}, 0.2)

            for _, child in pairs(ContentArea:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            TabContent.Visible = true
            WindowObj.CurrentTab = name
        end)

        if not WindowObj.CurrentTab then
            WindowObj.CurrentTab = name
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Theme.Accent
            TabIcon.ImageColor3 = Theme.TextPrimary
        end

        local TabObj = {}

        function TabObj:CreateSection(title)
            local SecFrame = Create("Frame", {
                BackgroundColor3 = Theme.SectionBackground,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
                Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
                Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) }),
                Create("UIPadding", { PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15) })
            })
            SecFrame.Parent = TabContent

            local TitleLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.Ubuntu,
                Text = title,
                TextColor3 = Theme.TextPrimary,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            TitleLabel.Parent = SecFrame

            Create("Frame", {
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 1)
            }).Parent = SecFrame

            SecFrame.ChildAdded:Connect(function()
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 40)
            end)


                local function AddTooltip(parent, text)
                    if not text then return end
                    local InfoIcon = Create("Frame", {
                        BackgroundColor3 = Theme.HeaderButtonBackground,
                        Position = UDim2.new(1, -18, 0.5, -9),
                        Size = UDim2.new(0, 18, 0, 18),
                        Parent = parent,
                        ZIndex = parent.ZIndex + 1
                    }, {
                        Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                        Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
                    })
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Font = Enum.Font.Ubuntu,
                        Text = "?",
                        TextColor3 = Theme.TextSecondary,
                        TextSize = 11,
                        Parent = InfoIcon,
                        ZIndex = InfoIcon.ZIndex + 1
                    })
                    local TipFrame = Create("Frame", {
                        BackgroundColor3 = Theme.HeaderButtonBackground,
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(0, -5, 0.5, 0), -- 5 pixels to the left of the ? icon
                        Size = UDim2.new(0, 0, 0, 26),
                        AutomaticSize = Enum.AutomaticSize.X,
                        Visible = false,
                        Parent = InfoIcon,
                        ZIndex = 1000
                    }, {
                        Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                        Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
                        Create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
                    })
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 0, 1, 0), -- Width is 0 so AutomaticSize controls it
                        AutomaticSize = Enum.AutomaticSize.X,
                        Font = Enum.Font.Ubuntu,
                        Text = text,
                        TextColor3 = Theme.TextPrimary,
                        TextSize = 12,
                        Parent = TipFrame,
                        ZIndex = 1001
                    })
                    InfoIcon.MouseEnter:Connect(function() TipFrame.Visible = true end)
                    InfoIcon.MouseLeave:Connect(function() TipFrame.Visible = false end)
                end

            local SecObj = {}

            function SecObj:CreateSeparator()
                local SepContainer = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 10) -- Padding around separator
                })
                SepContainer.Parent = SecFrame
                
                Create("Frame", {
                    BackgroundColor3 = Theme.Border,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 0, 1)
                }).Parent = SepContainer
            end

            function SecObj:CreateDropdown(configOrLabel, optionsList, defaultVal, callbackFunc)
                local config = type(configOrLabel) == "table" and configOrLabel or {Name = configOrLabel, Options = optionsList, Default = defaultVal, Callback = callbackFunc}
                local label = config.Name or "Dropdown"
                local options = config.Options or {}
                local default = config.Default
                local callback = config.Callback
                local tooltip = config.Tooltip
                local flag = config.Flag
                local searchable = config.Searchable == nil and true or config.Searchable

                local selected = default or options[1] or "None"
                local isExpanded = false

                local DropContainer = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }, {
                    Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) })
                })
                DropContainer.Parent = SecFrame

                local TopBar = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30)
                })
                TopBar.Parent = DropContainer
                AddTooltip(TopBar, tooltip)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.Ubuntu,
                    Text = label,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }).Parent = TopBar

                local ValBtn = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, -28, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Text = ""
                })
                ValBtn.Parent = TopBar

                local ValLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -25, 1, 0),
                    Font = Enum.Font.Ubuntu,
                    Text = selected,
                    TextColor3 = Theme.Accent,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                ValLabel.Parent = ValBtn

                local Chevron = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -15, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    Image = Library.Icons.ChevronDown,
                    ImageColor3 = Theme.Accent
                })
                Chevron.Parent = ValBtn


                local SearchBox
                if searchable then
                    SearchBox = Create("TextBox", {
                        BackgroundColor3 = Theme.MainBackground,
                        Size = UDim2.new(1, 0, 0, 30),
                        Visible = false,
                        Font = Enum.Font.Ubuntu,
                        PlaceholderText = "Search...",
                        Text = "",
                        TextColor3 = Theme.TextPrimary,
                        TextSize = 13,
                        ClearTextOnFocus = false
                    }, {
                        Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                        Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
                        Create("UIPadding", { PaddingLeft = UDim.new(0, 5) })
                    })
                    SearchBox.Parent = DropContainer
                end
                

                local DropList = Create("Frame", {
                    BackgroundColor3 = Theme.HeaderButtonBackground,
                    Size = UDim2.new(1, 0, 0, 0),
                    Visible = false,
                    ClipsDescendants = true
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
                    Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
                    Create("UIPadding", { PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5) })
                })
                DropList.Parent = DropContainer

                local function UpdateHeight()
                    if isExpanded then
                        local btnCount = 0
                        for _, child in pairs(DropList:GetChildren()) do
                            if child:IsA("TextButton") and child.Visible then btnCount = btnCount + 1 end
                        end
                        local targetH = (btnCount * 25) + 10
                        Tween(DropList, {Size = UDim2.new(1, 0, 0, targetH)}, 0.2)
                    end
                end

                local function UpdateOptions(newOptions)
                    for _, child in pairs(DropList:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    for k, v in pairs(newOptions) do
                        local opt = type(k) == "number" and tostring(v) or tostring(k)
                        local OptBtn = Create("TextButton", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 25),
                            Font = Enum.Font.Ubuntu,
                            Text = opt,
                            TextColor3 = (opt == selected) and Theme.Accent or Theme.TextPrimary,
                            TextSize = 13
                        })
                        OptBtn.Parent = DropList
                        
                        OptBtn.MouseEnter:Connect(function() if opt ~= selected then Tween(OptBtn, {TextColor3 = Theme.TextSecondary}, 0.2) end end)
                        OptBtn.MouseLeave:Connect(function() if opt ~= selected then Tween(OptBtn, {TextColor3 = Theme.TextPrimary}, 0.2) end end)
                        
                        OptBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            ValLabel.Text = selected
                            isExpanded = false
                            local tween = Tween(DropList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                            tween.Completed:Connect(function() if not isExpanded then DropList.Visible = false end end)
                            Tween(Chevron, {Rotation = 0}, 0.3)
                            UpdateOptions(newOptions)
                            if callback then callback(selected) end
                            task.delay(0.2, function() TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 40) end)
                        end)
                    end
                    UpdateHeight()
                end

                if searchable then
                    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                        local filter = string.lower(SearchBox.Text)
                        for _, child in pairs(DropList:GetChildren()) do
                            if child:IsA("TextButton") then
                                if filter == "" then
                                    child.Visible = true
                                else
                                    child.Visible = string.find(string.lower(child.Text), filter, 1, true) ~= nil
                                end
                            end
                        end
                        UpdateHeight()
                    end)
                end

                UpdateOptions(options)

                ValBtn.MouseButton1Click:Connect(function()
                    isExpanded = not isExpanded
                    if isExpanded then
                        if searchable then SearchBox.Visible = true end
                        DropList.Visible = true
                        UpdateHeight()
                    else
                        if searchable then
                            SearchBox.Visible = false
                            SearchBox.Text = ""
                        end
                        local tween = Tween(DropList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        tween.Completed:Connect(function() if not isExpanded then DropList.Visible = false end end)
                    end
                    Tween(Chevron, {Rotation = isExpanded and 180 or 0}, 0.3)
                    task.delay(0.2, function() TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 40) end)
                end)
                
                local API = {}
                API.Set = function(arg1, arg2)
                    local newVal = (arg1 == API) and arg2 or arg1
                    selected = newVal
                    ValLabel.Text = selected
                    UpdateOptions(options)
                    if callback then callback(selected) end
                end
                API.Refresh = function(arg1, arg2, arg3)
                    local newOpts = (arg1 == API) and arg2 or arg1
                    local newDefault = (arg1 == API) and arg3 or arg2
                    
                    -- Safeguard: If they passed the UI component itself as the options table
                    if type(newOpts) == "table" and newOpts.Refresh then
                        newOpts = newDefault
                        newDefault = nil
                    end
                    
                    if type(newOpts) ~= "table" then return end
                    options = newOpts
                    selected = newDefault or newOpts[1] or "None"
                    ValLabel.Text = selected
                    UpdateOptions(newOpts)
                end
                API.GetValue = function() return selected end
                if flag then Library.Flags[flag] = API end
                return API
            end

            function SecObj:CreateMultiDropdown(configOrLabel, optionsList, defaultSelectedArray, callbackFunc)
                local config = type(configOrLabel) == "table" and configOrLabel or {Name = configOrLabel, Options = optionsList, Default = defaultSelectedArray, Callback = callbackFunc}
                local label = config.Name or "MultiDropdown"
                local options = config.Options or {}
                local defaultArray = config.Default or {}
                local callback = config.Callback
                local tooltip = config.Tooltip
                local flag = config.Flag
                local searchable = config.Searchable == nil and true or config.Searchable

                local selectedDict = {}
                if defaultArray then
                    for _, v in ipairs(defaultArray) do
                        selectedDict[v] = true
                    end
                end
                
                local isExpanded = false

                local DropContainer = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }, {
                    Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) })
                })
                DropContainer.Parent = SecFrame

                local TopBar = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30)
                })
                TopBar.Parent = DropContainer
                AddTooltip(TopBar, tooltip)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.Ubuntu,
                    Text = label,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }).Parent = TopBar

                local ValBtn = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, -28, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Text = ""
                })
                ValBtn.Parent = TopBar
                
                local function GetSelectedString()
                    local count = 0
                    local first = nil
                    for k, v in pairs(selectedDict) do
                        if v then
                            count = count + 1
                            if not first then first = k end
                        end
                    end
                    if count == 0 then return "None" end
                    if count == 1 then return first end
                    return count .. " Selected"
                end

                local ValLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -25, 1, 0),
                    Font = Enum.Font.Ubuntu,
                    Text = GetSelectedString(),
                    TextColor3 = Theme.Accent,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                ValLabel.Parent = ValBtn

                local Chevron = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -15, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    Image = Library.Icons.ChevronDown,
                    ImageColor3 = Theme.Accent
                })
                Chevron.Parent = ValBtn


                local SearchBox
                if searchable then
                    SearchBox = Create("TextBox", {
                        BackgroundColor3 = Theme.MainBackground,
                        Size = UDim2.new(1, 0, 0, 30),
                        Visible = false,
                        Font = Enum.Font.Ubuntu,
                        PlaceholderText = "Search...",
                        Text = "",
                        TextColor3 = Theme.TextPrimary,
                        TextSize = 13,
                        ClearTextOnFocus = false
                    }, {
                        Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                        Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
                        Create("UIPadding", { PaddingLeft = UDim.new(0, 5) })
                    })
                    SearchBox.Parent = DropContainer
                end
                
                local DropList = Create("Frame", {
                    BackgroundColor3 = Theme.HeaderButtonBackground,
                    Size = UDim2.new(1, 0, 0, 0),
                    Visible = false,
                    ClipsDescendants = true
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
                    Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
                    Create("UIPadding", { PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5) })
                })
                DropList.Parent = DropContainer
                
                local function GetSelectedArray()
                    local arr = {}
                    for k, v in pairs(selectedDict) do
                        if v then table.insert(arr, k) end
                    end
                    return arr
                end

                local function UpdateHeight()
                    if isExpanded then
                        local btnCount = 0
                        for _, child in pairs(DropList:GetChildren()) do
                            if child:IsA("TextButton") and child.Visible then btnCount = btnCount + 1 end
                        end
                        local targetH = (btnCount * 25) + 10
                        Tween(DropList, {Size = UDim2.new(1, 0, 0, targetH)}, 0.2)
                    end
                end

                local function UpdateOptions(newOptions)
                    for _, child in pairs(DropList:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    for k, v in pairs(newOptions) do
                        local opt = type(k) == "number" and tostring(v) or tostring(k)
                        local isSel = selectedDict[opt] == true
                        local OptBtn = Create("TextButton", {
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 25),
                            Font = Enum.Font.Ubuntu,
                            Text = opt,
                            TextColor3 = isSel and Theme.Accent or Theme.TextPrimary,
                            TextSize = 13
                        })
                        OptBtn.Parent = DropList
                        
                        OptBtn.MouseEnter:Connect(function() if not selectedDict[opt] then Tween(OptBtn, {TextColor3 = Theme.TextSecondary}, 0.2) end end)
                        OptBtn.MouseLeave:Connect(function() if not selectedDict[opt] then Tween(OptBtn, {TextColor3 = Theme.TextPrimary}, 0.2) end end)
                        
                        OptBtn.MouseButton1Click:Connect(function()
                            selectedDict[opt] = not selectedDict[opt]
                            ValLabel.Text = GetSelectedString()
                            local isSelState = selectedDict[opt] == true
                            Tween(OptBtn, {TextColor3 = isSelState and Theme.Accent or Theme.TextPrimary}, 0.2)
                            if callback then callback(GetSelectedArray()) end
                        end)
                    end
                    UpdateHeight()
                end
                
                if searchable then
                    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                        local filter = string.lower(SearchBox.Text)
                        for _, child in pairs(DropList:GetChildren()) do
                            if child:IsA("TextButton") then
                                if filter == "" then
                                    child.Visible = true
                                else
                                    child.Visible = string.find(string.lower(child.Text), filter, 1, true) ~= nil
                                end
                            end
                        end
                        UpdateHeight()
                    end)
                end


                UpdateOptions(options)

                ValBtn.MouseButton1Click:Connect(function()
                    isExpanded = not isExpanded
                    if isExpanded then
                        if searchable then SearchBox.Visible = true end
                        DropList.Visible = true
                        UpdateHeight()
                    else
                        if searchable then
                            SearchBox.Visible = false
                            SearchBox.Text = ""
                        end
                        local tween = Tween(DropList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        tween.Completed:Connect(function() if not isExpanded then DropList.Visible = false end end)
                    end
                    Tween(Chevron, {Rotation = isExpanded and 180 or 0}, 0.3)
                    task.delay(0.2, function() TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 40) end)
                end)
                
                local API = {}
                API.Set = function(arg1, arg2)
                    local newArray = (arg1 == API) and arg2 or arg1
                    selectedDict = {}
                    if newArray and type(newArray) == "table" then
                        for _, v in pairs(newArray) do selectedDict[v] = true end
                    end
                    ValLabel.Text = GetSelectedString()
                    UpdateOptions(options)
                    if callback then callback(GetSelectedArray()) end
                end
                API.Refresh = function(arg1, arg2, arg3)
                    local newOpts = (arg1 == API) and arg2 or arg1
                    local newDefaultArray = (arg1 == API) and arg3 or arg2
                    
                    -- Safeguard: If they passed the UI component itself as the options table
                    if type(newOpts) == "table" and newOpts.Refresh then
                        newOpts = newDefaultArray
                        newDefaultArray = nil
                    end
                    
                    if type(newOpts) ~= "table" then return end
                    options = newOpts
                    selectedDict = {}
                    if newDefaultArray and type(newDefaultArray) == "table" then
                        for _, v in pairs(newDefaultArray) do selectedDict[v] = true end
                    end
                    ValLabel.Text = GetSelectedString()
                    UpdateOptions(newOpts)
                end
                API.GetValue = function() return GetSelectedArray() end
                if flag then Library.Flags[flag] = API end
                return API
            end

            function SecObj:CreateSlider(configOrLabel, minVal, maxVal, defaultVal, callbackFunc)
                local config = type(configOrLabel) == "table" and configOrLabel or {Name = configOrLabel, Min = minVal, Max = maxVal, Default = defaultVal, Callback = callbackFunc}
                local label = config.Name or "Slider"
                local min = config.Min or 0
                local max = config.Max or 100
                local default = config.Default or min
                local callback = config.Callback
                local tooltip = config.Tooltip
                local flag = config.Flag

                local value = math.clamp(default or min, min, max)
                local SliderContainer = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 45)
                })
                SliderContainer.Parent = SecFrame
                AddTooltip(SliderContainer, tooltip)

                local TitleLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -50, 0, 20),
                    Font = Enum.Font.Ubuntu,
                    Text = label,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                TitleLabel.Parent = SliderContainer

                local ValLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -78, 0, 0),
                    Size = UDim2.new(0, 50, 0, 20),
                    Font = Enum.Font.Ubuntu,
                    Text = tostring(value),
                    TextColor3 = Theme.Accent,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                ValLabel.Parent = SliderContainer

                local Track = Create("Frame", {
                    BackgroundColor3 = Theme.MainBackground,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, -28, 0, 6)
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
                })
                Track.Parent = SliderContainer

                local Fill = Create("Frame", {
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })
                Fill.Parent = Track

                local dragging = false
                local function updateSlider(input)
                    local percent = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    local newValue = math.floor(min + (max - min) * percent)
                    if value ~= newValue then
                        value = newValue
                        ValLabel.Text = tostring(value)
                        Tween(Fill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                        if callback then callback(value) end
                    end
                end

                Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateSlider(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)
                
                local API = {}
                API.Set = function(arg1, arg2)
                    local newVal = (arg1 == API) and arg2 or arg1
                    value = math.clamp(tonumber(newVal) or min, min, max)
                    ValLabel.Text = tostring(value)
                    Tween(Fill, {Size = UDim2.new((value - min) / (max - min), 0, 1, 0)}, 0.2)
                    if callback then callback(value) end
                end
                API.GetValue = function() return value end
                if flag then Library.Flags[flag] = API end
                return API
            end

            function SecObj:CreateTextBox(configOrLabel, placeholderText, callbackFunc)
                local config = type(configOrLabel) == "table" and configOrLabel or {Name = configOrLabel, Placeholder = placeholderText, Callback = callbackFunc}
                local label = config.Name or "TextBox"
                local placeholder = config.Placeholder or "Type here..."
                local callback = config.Callback
                local tooltip = config.Tooltip
                local flag = config.Flag

                local TxtContainer = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30)
                })
                TxtContainer.Parent = SecFrame
                AddTooltip(TxtContainer, tooltip)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.Ubuntu,
                    Text = label,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }).Parent = TxtContainer

                local BoxBg = Create("Frame", {
                    BackgroundColor3 = Theme.MainBackground,
                    Position = UDim2.new(0.5, -28, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0)
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
                })
                BoxBg.Parent = TxtContainer

                local TextBox = Create("TextBox", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Font = Enum.Font.Ubuntu,
                    PlaceholderText = placeholder or "Type here...",
                    PlaceholderColor3 = Theme.TextDark,
                    Text = "",
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ClearTextOnFocus = false
                })
                TextBox.Parent = BoxBg

                TextBox.FocusLost:Connect(function(enterPressed)
                    if callback then callback(TextBox.Text) end
                end)
                
                local API = {}
                API.Set = function(arg1, arg2)
                    local txt = (arg1 == API) and arg2 or arg1
                    TextBox.Text = tostring(txt)
                    if callback then callback(TextBox.Text) end
                end
                API.GetValue = function() return TextBox.Text end
                if flag then Library.Flags[flag] = API end
                return API
            end

            function SecObj:CreateKeybind(configOrLabel, defaultKeyVal, callbackFunc)
                local config = type(configOrLabel) == "table" and configOrLabel or {Name = configOrLabel, Default = defaultKeyVal, Callback = callbackFunc}
                local label = config.Name or "Keybind"
                local defaultKey = config.Default or Enum.KeyCode.Unknown
                local callback = config.Callback
                local tooltip = config.Tooltip
                local flag = config.Flag
                local mode = config.Mode or "Toggle" -- Toggle, Hold, Always

                local currentKey = defaultKey or Enum.KeyCode.Unknown
                local binding = false

                local BindContainer = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30)
                })
                BindContainer.Parent = SecFrame
                AddTooltip(BindContainer, tooltip)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.Ubuntu,
                    Text = label,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }).Parent = BindContainer

                local BindBtn = Create("TextButton", {
                    BackgroundColor3 = Theme.HeaderButtonBackground,
                    Position = UDim2.new(0.5, -28, 0, 2),
                    Size = UDim2.new(0.5, 0, 1, -4),
                    Text = "",
                    AutoButtonColor = false
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
                })
                BindBtn.Parent = BindContainer

                local BindLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.Ubuntu,
                    Text = currentKey == Enum.KeyCode.Unknown and "None" or currentKey.Name,
                    TextColor3 = Theme.Accent,
                    TextSize = 13
                })
                BindLabel.Parent = BindBtn

                BindBtn.MouseButton1Click:Connect(function()
                    binding = true
                    BindLabel.Text = "..."
                end)

                local keyState = false
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not binding then
                        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey and not gameProcessed then
                            if mode == "Toggle" then
                                keyState = not keyState
                                if callback then callback(keyState) end
                            elseif mode == "Hold" then
                                keyState = true
                                if callback then callback(true) end
                            elseif mode == "Always" then
                                if callback then callback(true) end
                            else
                                if callback then callback() end
                            end
                        end
                        return
                    end
                    
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        local key = input.KeyCode
                        if key == Enum.KeyCode.Backspace or key == Enum.KeyCode.Escape then
                            currentKey = Enum.KeyCode.Unknown
                            BindLabel.Text = "None"
                        else
                            currentKey = key
                            BindLabel.Text = key.Name
                        end
                        binding = false
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input, gameProcessed)
                    if not binding and mode == "Hold" and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey and not gameProcessed then
                        keyState = false
                        if callback then callback(false) end
                    end
                end)

                
                local API = {}
                API.Set = function(arg1, arg2)
                    local key = (arg1 == API) and arg2 or arg1
                    currentKey = key
                    BindLabel.Text = key == Enum.KeyCode.Unknown and "None" or key.Name
                end
                API.GetValue = function() return currentKey end
                if flag then Library.Flags[flag] = API end
                return API
            end

            function SecObj:CreateColorPicker(configOrLabel, defaultColorVal, callbackFunc)
                local config = type(configOrLabel) == "table" and configOrLabel or {Name = configOrLabel, Default = defaultColorVal, Callback = callbackFunc}
                local label = config.Name or "Color Picker"
                local defaultColor = config.Default or Color3.new(1, 1, 1)
                local callback = config.Callback
                local tooltip = config.Tooltip
                local flag = config.Flag

                local currentColor = defaultColor or Color3.new(1, 1, 1)
                local hue, sat, val = Color3.toHSV(currentColor)
                local isExpanded = false

                local CPContainer = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }, {
                    Create("UIListLayout", { 
                        SortOrder = Enum.SortOrder.LayoutOrder, 
                        Padding = UDim.new(0, 5)
                    })
                })
                CPContainer.Parent = SecFrame

                local TopBar = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30)
                })
                TopBar.Parent = CPContainer
                AddTooltip(TopBar, tooltip)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.Ubuntu,
                    Text = label,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }).Parent = TopBar

                local ColorDisplayBtn = Create("TextButton", {
                    BackgroundColor3 = Theme.HeaderButtonBackground,
                    Position = UDim2.new(0.8, -28, 0, 2),
                    Size = UDim2.new(0.2, 0, 1, -4),
                    Text = "",
                    AutoButtonColor = false
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
                })
                ColorDisplayBtn.Parent = TopBar

                local ColorPreview = Create("Frame", {
                    BackgroundColor3 = currentColor,
                    Position = UDim2.new(0, 2, 0, 2),
                    Size = UDim2.new(1, -4, 1, -4)
                }, { Create("UICorner", { CornerRadius = UDim.new(0, 4) }) })
                ColorPreview.Parent = ColorDisplayBtn

                local DropList = Create("Frame", {
                    BackgroundColor3 = Theme.HeaderButtonBackground,
                    Size = UDim2.new(1, 0, 0, 90),
                    Visible = false,
                    ClipsDescendants = true
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
                })
                DropList.Parent = CPContainer

                local Wheel = Create("ImageButton", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0, 5),
                    Size = UDim2.new(0, 80, 0, 80),
                    Image = "rbxassetid://6020299385" -- HSV wheel
                })
                Wheel.Parent = DropList

                local WheelRing = Create("Frame", {
                    BackgroundColor3 = Color3.new(1,1,1),
                    Size = UDim2.new(0, 8, 0, 8),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                }, { Create("UICorner", { CornerRadius = UDim.new(1, 0) }), Create("UIStroke", { Thickness = 1 }) })
                WheelRing.Parent = Wheel

                local alpha = 1
                local ValueSlider = Create("TextButton", {
                    BackgroundColor3 = Color3.new(1,1,1),
                    Position = UDim2.new(0, 95, 0, 5),
                    Size = UDim2.new(0.5, -55, 0, 80),
                    Text = "",
                    AutoButtonColor = false
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
                    Create("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
                            ColorSequenceKeypoint.new(1, Color3.new(0,0,0))
                        }),
                        Rotation = 90
                    })
                })
                ValueSlider.Parent = DropList

                local ValueLine = Create("Frame", {
                    BackgroundColor3 = Color3.new(1,1,1),
                    Size = UDim2.new(1, 4, 0, 2),
                    Position = UDim2.new(0, -2, 0, 0),
                    AnchorPoint = Vector2.new(0, 0.5)
                }, { Create("UIStroke", { Thickness = 1 }) })
                ValueLine.Parent = ValueSlider
                
                local AlphaSlider = Create("TextButton", {
                    BackgroundColor3 = Color3.new(1,1,1),
                    Position = UDim2.new(0.5, 45, 0, 5),
                    Size = UDim2.new(0.5, -55, 0, 80),
                    Text = "",
                    AutoButtonColor = false
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 4) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
                    Create("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
                            ColorSequenceKeypoint.new(1, Color3.new(1,1,1))
                        }),
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(1, 1)
                        }),
                        Rotation = 90
                    })
                })
                AlphaSlider.Parent = DropList

                local AlphaLine = Create("Frame", {
                    BackgroundColor3 = Color3.new(1,1,1),
                    Size = UDim2.new(1, 4, 0, 2),
                    Position = UDim2.new(0, -2, 0, 0),
                    AnchorPoint = Vector2.new(0, 0.5)
                }, { Create("UIStroke", { Thickness = 1 }) })
                AlphaLine.Parent = AlphaSlider

                local function UpdateColor()
                    currentColor = Color3.fromHSV(hue, sat, val)
                    ColorPreview.BackgroundColor3 = currentColor
                    ColorPreview.BackgroundTransparency = 1 - alpha
                    ValueSlider.UIGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, 1)),
                        ColorSequenceKeypoint.new(1, Color3.new(0,0,0))
                    })
                    AlphaSlider.UIGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, currentColor),
                        ColorSequenceKeypoint.new(1, currentColor)
                    })
                    if callback then callback(currentColor, alpha) end
                end

                local function SetWheelPositionFromColor()
                    local center = Wheel.AbsoluteSize / 2
                    local r = sat * center.X
                    local theta = math.rad(hue * 360)
                    local x = r * math.cos(theta)
                    local y = r * math.sin(theta)
                    WheelRing.Position = UDim2.new(0, center.X + x, 0, center.Y + y)
                    ValueLine.Position = UDim2.new(0, -2, 1 - val, 0)
                    AlphaLine.Position = UDim2.new(0, -2, 1 - alpha, 0)
                end

                local wheelDragging, valDragging, alphaDragging = false, false, false

                local function UpdateWheel(input)
                    local center = Wheel.AbsolutePosition + (Wheel.AbsoluteSize / 2)
                    local mousePos = input.Position
                    local delta = Vector2.new(mousePos.X - center.X, mousePos.Y - center.Y)
                    local distance = math.min(delta.Magnitude, Wheel.AbsoluteSize.X / 2)
                    
                    sat = distance / (Wheel.AbsoluteSize.X / 2)
                    hue = (math.atan2(delta.Y, delta.X) / (math.pi * 2)) % 1
                    
                    local x = distance * math.cos(math.atan2(delta.Y, delta.X))
                    local y = distance * math.sin(math.atan2(delta.Y, delta.X))
                    WheelRing.Position = UDim2.new(0, (Wheel.AbsoluteSize.X / 2) + x, 0, (Wheel.AbsoluteSize.Y / 2) + y)
                    
                    UpdateColor()
                end

                local function UpdateValue(input)
                    local y = math.clamp(input.Position.Y - ValueSlider.AbsolutePosition.Y, 0, ValueSlider.AbsoluteSize.Y)
                    val = 1 - (y / ValueSlider.AbsoluteSize.Y)
                    ValueLine.Position = UDim2.new(0, -2, 0, y)
                    UpdateColor()
                end
                
                local function UpdateAlpha(input)
                    local y = math.clamp(input.Position.Y - AlphaSlider.AbsolutePosition.Y, 0, AlphaSlider.AbsoluteSize.Y)
                    alpha = 1 - (y / AlphaSlider.AbsoluteSize.Y)
                    AlphaLine.Position = UDim2.new(0, -2, 0, y)
                    UpdateColor()
                end

                Wheel.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        wheelDragging = true
                        UpdateWheel(input)
                    end
                end)
                ValueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        valDragging = true
                        UpdateValue(input)
                    end
                end)
                AlphaSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        alphaDragging = true
                        UpdateAlpha(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        wheelDragging, valDragging, alphaDragging = false, false, false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if wheelDragging then UpdateWheel(input) end
                        if valDragging then UpdateValue(input) end
                        if alphaDragging then UpdateAlpha(input) end
                    end
                end)

                ColorDisplayBtn.MouseButton1Click:Connect(function()
                    isExpanded = not isExpanded
                    if isExpanded then
                        DropList.Visible = true
                        DropList.Size = UDim2.new(1, 0, 0, 0)
                        Tween(DropList, {Size = UDim2.new(1, 0, 0, 90)}, 0.2)
                    else
                        local tween = Tween(DropList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        tween.Completed:Connect(function()
                            if not isExpanded then DropList.Visible = false end
                        end)
                    end
                    TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 40)
                    if isExpanded then
                        SetWheelPositionFromColor()
                        UpdateColor()
                    end
                end)
                
                local API = {}
                API.Set = function(arg1, arg2)
                    local newColor = (arg1 == API) and arg2 or arg1
                    if typeof(newColor) == "Color3" then
                        hue, sat, val = Color3.toHSV(newColor)
                        SetWheelPositionFromColor()
                        UpdateColor()
                    end
                end
                API.GetValue = function() return currentColor end
                if flag then Library.Flags[flag] = API end
                return API
            end

            function SecObj:CreateToggle(configOrLabel, defaultVal, callbackFunc)
                local config = type(configOrLabel) == "table" and configOrLabel or {Name = configOrLabel, Default = defaultVal, Callback = callbackFunc}
                local label = config.Name or "Toggle"
                local default = config.Default or false
                local callback = config.Callback
                local tooltip = config.Tooltip
                local flag = config.Flag

                local state = default or false
                local TogBtn = Create("TextButton", {
                    BackgroundColor3 = Theme.MainBackground,
                    Size = UDim2.new(1, 0, 0, 42),
                    Text = "",
                    AutoButtonColor = false
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
                })
                TogBtn.Parent = SecFrame
                AddTooltip(TogBtn, tooltip)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(1, -70, 1, 0),
                    Font = Enum.Font.Ubuntu,
                    Text = label,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }).Parent = TogBtn

                local SwitchTrack = Create("Frame", {
                    BackgroundColor3 = state and Theme.Accent or Theme.MainBackground,
                    Position = UDim2.new(1, -75, 0.5, -12),
                    Size = UDim2.new(0, 44, 0, 24)
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })
                SwitchTrack.Parent = TogBtn

                local SwitchThumb = Create("Frame", {
                    BackgroundColor3 = Theme.TextPrimary,
                    Position = UDim2.new(0, state and 22 or 2, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20)
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })
                SwitchThumb.Parent = SwitchTrack
                
                local function SetState(newState)
                    state = newState
                    Tween(SwitchTrack, {BackgroundColor3 = state and Theme.Accent or Theme.MainBackground}, 0.3)
                    Tween(SwitchThumb, {Position = UDim2.new(0, state and 22 or 2, 0.5, -10)}, 0.3)
                    if callback then callback(state) end
                end

                TogBtn.MouseButton1Click:Connect(function()
                    SetState(not state)
                end)
                
                local API = {}
                API.Set = function(arg1, arg2)
                    local newState = (arg1 == API) and arg2 or arg1
                    SetState(newState)
                end
                API.GetValue = function() return state end
                if flag then Library.Flags[flag] = API end
                return API
            end

            function SecObj:CreateButton(label, callback)
                local Btn = Create("TextButton", {
                    BackgroundColor3 = Theme.ButtonBackground,
                    Size = UDim2.new(1, 0, 0, 38),
                    Font = Enum.Font.Ubuntu,
                    Text = label,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    AutoButtonColor = false
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 6) })
                })
                Btn.Parent = SecFrame

                Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Color3.fromRGB(Theme.ButtonBackground.R * 255 + 10, Theme.ButtonBackground.G * 255 + 10, Theme.ButtonBackground.B * 255 + 10)}, 0.1) end)
                Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = Theme.ButtonBackground}, 0.1) end)
                Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
            end

            function SecObj:CreateLabel(text)
                local Lbl = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Font = Enum.Font.Ubuntu,
                    Text = text,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 13,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                Lbl.Parent = SecFrame
                
                local API = {}
                API.Set = function(arg1, arg2)
                    local newTxt = (arg1 == API) and arg2 or arg1
                    Lbl.Text = tostring(newTxt)
                end
                API.GetValue = function() return Lbl.Text end
                return API
            end

            function SecObj:CreateInfo(title, text)
                local InfoBox = Create("Frame", {
                    BackgroundColor3 = Theme.MainBackground,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
                    Create("UIPadding", { PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15) }),
                    Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) })
                })
                InfoBox.Parent = SecFrame

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 15),
                    Font = Enum.Font.Ubuntu,
                    Text = title,
                    TextColor3 = Theme.TextPrimary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }).Parent = InfoBox

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Font = Enum.Font.Ubuntu,
                    Text = text,
                    TextColor3 = Theme.TextDark,
                    TextSize = 12,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextXAlignment.Top
                }).Parent = InfoBox
            end

            return SecObj
        end

        return TabObj
    end

    return WindowObj
end

function Library:SaveConfig(folderName, fileName, configTable)
    if not writefile then
        Library:Notify("Error", "Your executor does not support writefile!", 3)
        return
    end
    if not isfolder(folderName) then makefolder(folderName) end
    
    local success, err = pcall(function()
        local json = game:GetService("HttpService"):JSONEncode(configTable)
        writefile(folderName .. "/" .. fileName .. ".json", json)
    end)
    if success then
        Library:Notify("Config Saved", "Successfully saved config to " .. fileName .. ".json", 3)
    else
        Library:Notify("Config Error", "Failed to save config: " .. tostring(err), 5)
    end
end

function Library:LoadConfig(folderName, fileName)
    if not readfile or not isfile then
        Library:Notify("Error", "Your executor does not support readfile/isfile!", 3)
        return nil
    end
    local path = folderName .. "/" .. fileName .. ".json"
    
    if isfile(path) then
        local success, result = pcall(function()
            local content = readfile(path)
            return game:GetService("HttpService"):JSONDecode(content)
        end)
        if success then
            Library:Notify("Config Loaded", "Successfully loaded config from " .. fileName .. ".json", 3)
            return result
        else
            Library:Notify("Config Error", "Failed to decode config file!", 5)
            return nil
        end
    else
        Library:Notify("Config Error", "Config file not found!", 5)
        return nil
    end
end

function Library:CreateKeySystem(options)
    options = options or {}
    local Theme = self.Themes
    local keyUrl = options.KeyUrl or ""
    local title = options.Title or "Blue Moon Key System"
    local expectedKey = options.Key or ""

    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "BlueMoonKey"
    KeyGui.Parent = CoreGui
    
    local KeyMain = Create("Frame", {
        BackgroundColor3 = Theme.MainBackground,
        Position = UDim2.new(0.5, -150, 0.5, -100),
        Size = UDim2.new(0, 300, 0, 200),
        Active = true,
        Draggable = true
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 8) }),
        Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
    })
    KeyMain.Parent = KeyGui
    
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.Ubuntu,
        Text = title,
        TextColor3 = Theme.Accent,
        TextSize = 18
    }).Parent = KeyMain
    
    local KeyBox = Create("TextBox", {
        BackgroundColor3 = Theme.SectionBackground,
        Position = UDim2.new(0.1, 0, 0.4, 0),
        Size = UDim2.new(0.8, 0, 0, 35),
        Font = Enum.Font.Ubuntu,
        PlaceholderText = "Enter Key Here...",
        Text = "",
        TextColor3 = Theme.TextPrimary,
        TextSize = 14
    }, { Create("UICorner", { CornerRadius = UDim.new(0, 6) }), Create("UIStroke", { Color = Theme.Border, Thickness = 1 }) })
    KeyBox.Parent = KeyMain
    
    local StatusLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.65, 0),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.Ubuntu,
        Text = "Waiting for key...",
        TextColor3 = Theme.TextSecondary,
        TextSize = 12
    })
    StatusLabel.Parent = KeyMain
    
    local CheckBtn = Create("TextButton", {
        BackgroundColor3 = Theme.Accent,
        Position = UDim2.new(0.1, 0, 0.8, 0),
        Size = UDim2.new(0.35, 0, 0, 30),
        Font = Enum.Font.Ubuntu,
        Text = "Check Key",
        TextColor3 = Theme.MainBackground,
        TextSize = 14
    }, { Create("UICorner", { CornerRadius = UDim.new(0, 6) }) })
    CheckBtn.Parent = KeyMain
    
    local GetBtn = Create("TextButton", {
        BackgroundColor3 = Theme.HeaderButtonBackground,
        Position = UDim2.new(0.55, 0, 0.8, 0),
        Size = UDim2.new(0.35, 0, 0, 30),
        Font = Enum.Font.Ubuntu,
        Text = "Get Key",
        TextColor3 = Theme.TextPrimary,
        TextSize = 14
    }, { Create("UICorner", { CornerRadius = UDim.new(0, 6) }), Create("UIStroke", { Color = Theme.Border, Thickness = 1 }) })
    GetBtn.Parent = KeyMain
    
    GetBtn.MouseButton1Click:Connect(function()
        if setclipboard and options.GetKeyUrl then
            setclipboard(options.GetKeyUrl)
            StatusLabel.Text = "Copied link to clipboard!"
        else
            StatusLabel.Text = "Your executor doesn't support setclipboard!"
        end
    end)
    
    CheckBtn.MouseButton1Click:Connect(function()
        StatusLabel.Text = "Checking..."
        local inputKey = KeyBox.Text
        local realKey = expectedKey
        
        if keyUrl ~= "" then
            local success, result = pcall(function()
                return game:HttpGet(keyUrl)
            end)
            if success then
                realKey = result:gsub("\n", ""):gsub("\r", "") -- Clean string
            else
                StatusLabel.Text = "Failed to fetch key from URL!"
                return
            end
        end
        
        if inputKey == realKey then
            StatusLabel.Text = "Success! Loading UI..."
            StatusLabel.TextColor3 = Color3.fromRGB(50, 200, 50)
            task.wait(1)
            KeyGui:Destroy()
            if options.OnComplete then options.OnComplete() end
        else
            StatusLabel.Text = "Invalid Key!"
            StatusLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
            task.wait(1.5)
            StatusLabel.TextColor3 = Theme.TextSecondary
            StatusLabel.Text = "Waiting for key..."
        end
    end)
end

return Library
