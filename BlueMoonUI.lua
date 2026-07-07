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

function Library:CreateWindow(options)
    options = options or {}
    local Title = options.Title or "Blue Moon"
    local Version = options.Version or "v1.1.2 Alpha"
    local ProfileName = options.ProfileName or Players.LocalPlayer and Players.LocalPlayer.Name or "XxGECEUSTASIxX"
    local Ping = options.Ping or "106 ms"
    local Theme = self.Themes
    
    -- Cleanup
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui.Name == "BlueMoonUI" then gui:Destroy() end
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "BlueMoonUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

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

    -- Smooth Open Animation
    Tween(Main, {GroupTransparency = 0, Position = UDim2.new(0.5, -400, 0.5, -275)}, 0.6, Enum.EasingStyle.Quint)

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

            function SecObj:CreateDropdown(label, options, default, callback)
                local selected = default or options[1] or "None"
                local DropContainer = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30)
                })
                DropContainer.Parent = SecFrame

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Enum.Font.Ubuntu,
                    Text = label,
                    TextColor3 = Theme.TextSecondary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }).Parent = DropContainer

                local ValBtn = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Text = ""
                })
                ValBtn.Parent = DropContainer

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

                Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -15, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    Image = Library.Icons.ChevronDown,
                    ImageColor3 = Theme.Accent
                }).Parent = ValBtn
                
                -- Expand logic would go here
            end

            function SecObj:CreateToggle(label, default, callback)
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
                    Position = UDim2.new(1, -55, 0.5, -12),
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

                TogBtn.MouseButton1Click:Connect(function()
                    state = not state
                    Tween(SwitchTrack, {BackgroundColor3 = state and Theme.Accent or Theme.MainBackground}, 0.3)
                    Tween(SwitchThumb, {Position = UDim2.new(0, state and 22 or 2, 0.5, -10)}, 0.4, Enum.EasingStyle.Back)
                    if callback then callback(state) end
                end)
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

return Library
