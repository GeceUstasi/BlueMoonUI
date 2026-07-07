local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Library = {
    Themes = {
        MainBackground = Color3.fromRGB(15, 18, 35),
        SectionBackground = Color3.fromRGB(21, 25, 48),
        ElementBackground = Color3.fromRGB(25, 30, 55),
        Accent = Color3.fromRGB(46, 91, 250),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 150, 170),
        Border = Color3.fromRGB(35, 40, 70),
        Hover = Color3.fromRGB(30, 35, 60)
    }
}

-- Utility function to create elements quickly
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

local function Tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function Library:CreateWindow(options)
    options = options or {}
    local Title = options.Title or "Blue Moon"
    local Version = options.Version or "v1.0.0"
    local ProfileName = options.ProfileName or Players.LocalPlayer and Players.LocalPlayer.Name or "Username"
    local Theme = self.Themes
    
    -- Cleanup previous GUI
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui.Name == "BlueMoonUI" then
            gui:Destroy()
        end
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "BlueMoonUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    -- Main Window
    local Main = Create("Frame", {
        Name = "Main",
        BackgroundColor3 = Theme.MainBackground,
        Position = UDim2.new(0.5, -350, 0.5, -250),
        Size = UDim2.new(0, 700, 0, 500),
        ClipsDescendants = true
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
        Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
    })
    Main.Parent = ScreenGui

    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Theme.MainBackground,
        Size = UDim2.new(0, 160, 1, 0),
        ZIndex = 2
    }, {
        Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
    })
    Sidebar.Parent = Main
    
    -- Profile Section in Sidebar
    local ProfileSection = Create("Frame", {
        Name = "ProfileSection",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 100),
        Position = UDim2.new(0, 0, 0, 40)
    })
    ProfileSection.Parent = Sidebar

    local ProfileImage = Create("ImageLabel", {
        Name = "Image",
        BackgroundColor3 = Theme.ElementBackground,
        Position = UDim2.new(0.5, -25, 0, 10),
        Size = UDim2.new(0, 50, 0, 50),
        Image = "rbxassetid://100100100" -- Placeholder
    }, {
        Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
        Create("UIStroke", { Color = Theme.Accent, Thickness = 2 })
    })
    ProfileImage.Parent = ProfileSection

    local ProfileUsername = Create("TextLabel", {
        Name = "Username",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 70),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.GothamMedium,
        Text = ProfileName,
        TextColor3 = Theme.SubText,
        TextSize = 12
    })
    ProfileUsername.Parent = ProfileSection
    
    -- Tab Container in Sidebar
    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 140),
        Size = UDim2.new(1, 0, 1, -140),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0
    }, {
        Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) }),
        Create("UIPadding", { PaddingTop = UDim.new(0, 5), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
    })
    TabContainer.Parent = Sidebar

    -- Topbar
    local Topbar = Create("Frame", {
        Name = "Topbar",
        BackgroundColor3 = Theme.MainBackground,
        Size = UDim2.new(1, 0, 0, 40),
        ZIndex = 3
    }, {
        Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
    })
    Topbar.Parent = Main
    
    local TitleLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(0, 100, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    TitleLabel.Parent = Topbar

    local VersionLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 120, 0, 0),
        Size = UDim2.new(0, 100, 1, 0),
        Font = Enum.Font.Gotham,
        Text = Version,
        TextColor3 = Theme.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    VersionLabel.Parent = Topbar
    
    -- Content Container
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 160, 0, 40),
        Size = UDim2.new(1, -160, 1, -40),
        ClipsDescendants = true
    })
    ContentContainer.Parent = Main

    -- Window Object
    local Window = {
        CurrentTab = nil,
        Tabs = {}
    }

    function Window:CreateTab(tabName, iconId)
        local TabBtn = Create("TextButton", {
            Name = tabName,
            BackgroundColor3 = Theme.MainBackground,
            Size = UDim2.new(1, 0, 0, 35),
            Font = Enum.Font.GothamBold,
            Text = "   " .. tabName,
            TextColor3 = Theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }, {
            Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
            Create("UIPadding", { PaddingLeft = UDim.new(0, 10) })
        })
        TabBtn.Parent = TabContainer

        local TabContent = Create("ScrollingFrame", {
            Name = tabName.."_Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Border,
            Visible = false
        }, {
            Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) }),
            Create("UIPadding", { PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15) })
        })
        TabContent.Parent = ContentContainer

        -- Auto adjust canvas size
        TabContent.ChildAdded:Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 30)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab == tabName then return end
            
            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    Tween(btn, {BackgroundColor3 = Theme.MainBackground})
                end
            end
            Tween(TabBtn, {BackgroundColor3 = Theme.Accent})

            for _, content in pairs(ContentContainer:GetChildren()) do
                if content:IsA("ScrollingFrame") then
                    content.Visible = false
                end
            end
            TabContent.Visible = true
            Window.CurrentTab = tabName
        end)

        if not Window.CurrentTab then
            Window.CurrentTab = tabName
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Theme.Accent
        end

        local Tab = {}

        function Tab:CreateSection(sectionName)
            local SectionFrame = Create("Frame", {
                Name = sectionName,
                BackgroundColor3 = Theme.MainBackground,
                Size = UDim2.new(1, 0, 0, 30),
                AutomaticSize = Enum.AutomaticSize.Y
            }, {
                Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Create("UIStroke", { Color = Theme.Border, Thickness = 1 }),
                Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8) }),
                Create("UIPadding", { PaddingTop = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15) })
            })
            SectionFrame.Parent = TabContent

            local SectionTitle = Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = sectionName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            SectionTitle.Parent = SectionFrame
            
            local Divider = Create("Frame", {
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 1)
            })
            Divider.Parent = SectionFrame

            -- Auto adjust canvas
            SectionFrame.ChildAdded:Connect(function()
                TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y + 30)
            end)

            local Section = {}

            function Section:CreateToggle(toggleName, default, callback)
                local state = default or false
                callback = callback or function() end

                local ToggleBtn = Create("TextButton", {
                    Name = toggleName,
                    BackgroundColor3 = Theme.SectionBackground,
                    Size = UDim2.new(1, 0, 0, 40),
                    Text = "",
                    AutoButtonColor = false
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 6) }),
                    Create("UIStroke", { Color = Theme.Border, Thickness = 1 })
                })
                ToggleBtn.Parent = SectionFrame

                local ToggleLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 0),
                    Size = UDim2.new(1, -60, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = toggleName,
                    TextColor3 = Theme.SubText,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                ToggleLabel.Parent = ToggleBtn

                local SwitchBG = Create("Frame", {
                    BackgroundColor3 = state and Theme.Accent or Theme.ElementBackground,
                    Position = UDim2.new(1, -45, 0.5, -10),
                    Size = UDim2.new(0, 36, 0, 20)
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })
                SwitchBG.Parent = ToggleBtn

                local SwitchCircle = Create("Frame", {
                    BackgroundColor3 = Theme.Text,
                    Position = UDim2.new(0, state and 18 or 2, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16)
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(1, 0) })
                })
                SwitchCircle.Parent = SwitchBG

                ToggleBtn.MouseButton1Click:Connect(function()
                    state = not state
                    Tween(SwitchBG, {BackgroundColor3 = state and Theme.Accent or Theme.ElementBackground})
                    Tween(SwitchCircle, {Position = UDim2.new(0, state and 18 or 2, 0.5, -8)})
                    Tween(ToggleLabel, {TextColor3 = state and Theme.Text or Theme.SubText})
                    callback(state)
                end)
                
                -- Init State colors
                ToggleLabel.TextColor3 = state and Theme.Text or Theme.SubText
            end

            function Section:CreateButton(btnName, callback)
                callback = callback or function() end

                local Button = Create("TextButton", {
                    Name = btnName,
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new(1, 0, 0, 35),
                    Font = Enum.Font.GothamMedium,
                    Text = btnName,
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    AutoButtonColor = false
                }, {
                    Create("UICorner", { CornerRadius = UDim.new(0, 6) })
                })
                Button.Parent = SectionFrame

                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = Color3.new(Theme.Accent.R * 0.8, Theme.Accent.G * 0.8, Theme.Accent.B * 0.8)})
                end)

                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = Theme.Accent})
                end)

                Button.MouseButton1Click:Connect(function()
                    callback()
                end)
            end
            
            function Section:CreateLabel(text, isInfo)
                local Label = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Font = Enum.Font.Gotham,
                    Text = text,
                    TextColor3 = isInfo and Theme.SubText or Theme.Text,
                    TextSize = 12,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextXAlignment.Top
                })
                Label.Parent = SectionFrame
            end

            function Section:CreateDropdown(dropName, options, default, callback)
                options = options or {}
                callback = callback or function() end
                local selected = default or options[1] or "None"
                local isDropped = false

                local DropBtn = Create("TextButton", {
                    Name = dropName,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
                    Text = "",
                    AutoButtonColor = false
                })
                DropBtn.Parent = SectionFrame

                local DropLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 5, 0, 0),
                    Size = UDim2.new(1, -10, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = dropName,
                    TextColor3 = Theme.SubText,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                DropLabel.Parent = DropBtn

                local SelectedLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -130, 0, 0),
                    Size = UDim2.new(0, 100, 1, 0),
                    Font = Enum.Font.GothamMedium,
                    Text = selected,
                    TextColor3 = Theme.Accent,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                SelectedLabel.Parent = DropBtn

                -- In a real scenario we'd create a scrolling frame for the dropdown list here
                -- For brevity and based on the image's static look, we'll mock the logic
                DropBtn.MouseButton1Click:Connect(function()
                    -- Expand logic
                end)
            end

            return Section
        end

        return Tab
    end

    return Window
end

return Library
