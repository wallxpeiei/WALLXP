--[[
    ╔══════════════════════════════════════════════════════╗
    ║                 WALLXP UI LIBRARY                   ║
    ║              Liquid Glass • v1.7                    ║
    ╚══════════════════════════════════════════════════════╝

    UI ONLY VERSION
    - Liquid Glass design
    - Rounded glass borders
    - Double border
    - Top highlight
    - Smooth animations
    - Tabs
    - Search
    - Settings
    - Profile
    - Button
    - Toggle
    - Slider
    - Dropdown
    - Input
    - Keybind
    - Notification
    - Minimize / Restore
    - Mouse + Touch drag
    - Mobile ready

    No external require()
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local WALLXP = {}

------------------------------------------------------------
-- CONFIG
------------------------------------------------------------

local CONFIG = {
    Name = "WALLXP",
    Subtitle = "Liquid Glass",

    Width = 630,
    Height = 405,

    SidebarWidth = 145,
    TopbarHeight = 76,

    Corner = 20,
    SmallCorner = 14,

    Animation = 0.22,

    Accent = Color3.fromRGB(78, 155, 255),

    Background = Color3.fromRGB(18, 20, 27),
    Glass = Color3.fromRGB(255, 255, 255),

    Text = Color3.fromRGB(248, 249, 255),
    SubText = Color3.fromRGB(170, 175, 190),

    Border = Color3.fromRGB(255, 255, 255),

    Card = Color3.fromRGB(255, 255, 255)
}

------------------------------------------------------------
-- UTILITIES
------------------------------------------------------------

local function New(class, props)
    local obj = Instance.new(class)

    for property, value in pairs(props or {}) do
        obj[property] = value
    end

    return obj
end

local function Corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or CONFIG.Corner)
    c.Parent = obj
    return c
end

local function Stroke(obj, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or CONFIG.Border
    s.Transparency = transparency or 0.75
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function Gradient(obj, color1, color2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    g.Rotation = rotation or 90
    g.Parent = obj
    return g
end

local function Padding(obj, left, right, top, bottom)
    local p = Instance.new("UIPadding")

    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)

    p.Parent = obj

    return p
end

local function Tween(obj, info, props)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(
            info or CONFIG.Animation,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        props
    )

    tween:Play()

    return tween
end

local function AddGlass(obj, radius)
    Corner(obj, radius or CONFIG.Corner)

    Stroke(
        obj,
        Color3.fromRGB(255, 255, 255),
        0.68,
        1
    )

    local inner = New("Frame", {
        Name = "InnerGlassBorder",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -2, 1, -2),
        Position = UDim2.new(0, 1, 0, 1),
        ZIndex = obj.ZIndex + 1,
        Parent = obj
    })

    Corner(inner, math.max((radius or CONFIG.Corner) - 1, 1))

    Stroke(
        inner,
        Color3.fromRGB(255, 255, 255),
        0.90,
        1
    )

    return obj
end

------------------------------------------------------------
-- SCREEN GUI
------------------------------------------------------------

local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

if not PlayerGui then
    return WALLXP
end

local ScreenGui = New("ScreenGui", {
    Name = "WALLXP_LiquidGlass",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = PlayerGui
})

------------------------------------------------------------
-- NOTIFICATION HOLDER
------------------------------------------------------------

local NotificationHolder = New("Frame", {
    Name = "Notifications",
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -24, 0, 24),
    Size = UDim2.new(0, 330, 1, -48),
    ZIndex = 100,
    Parent = ScreenGui
})

local NotificationLayout = New("UIListLayout", {
    Padding = UDim.new(0, 10),
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    Parent = NotificationHolder
})

------------------------------------------------------------
-- WINDOW
------------------------------------------------------------

function WALLXP:CreateWindow(options)

    options = options or {}

    local WindowObject = {}

    local WindowName = options.Name or CONFIG.Name
    local WindowSubtitle = options.Subtitle or CONFIG.Subtitle

    --------------------------------------------------------
    -- MAIN WINDOW
    --------------------------------------------------------

    local Shadow = New("Frame", {
        Name = "Shadow",
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.72,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(
            0,
            CONFIG.Width + 20,
            0,
            CONFIG.Height + 20
        ),
        ZIndex = 1,
        Parent = ScreenGui
    })

    Corner(Shadow, CONFIG.Corner + 4)

    local Window = New("Frame", {
        Name = "Window",
        BackgroundColor3 = CONFIG.Background,
        BackgroundTransparency = 0.18,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, CONFIG.Width, 0, CONFIG.Height),
        ClipsDescendants = true,
        ZIndex = 5,
        Parent = ScreenGui
    })

    Corner(Window, CONFIG.Corner)

    Stroke(
        Window,
        Color3.fromRGB(255, 255, 255),
        0.55,
        1.3
    )

    --------------------------------------------------------
    -- WINDOW GLASS GRADIENT
    --------------------------------------------------------

    Gradient(
        Window,
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(130, 150, 180),
        135
    ).Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.93),
        NumberSequenceKeypoint.new(0.45, 0.97),
        NumberSequenceKeypoint.new(1, 0.91)
    })

    --------------------------------------------------------
    -- TOP GLASS HIGHLIGHT
    --------------------------------------------------------

    local TopHighlight = New("Frame", {
        Name = "TopHighlight",
        BackgroundTransparency = 0.82,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 0, 2),
        ZIndex = 30,
        Parent = Window
    })

    Corner(TopHighlight, 2)

    --------------------------------------------------------
    -- TOP BAR
    --------------------------------------------------------

    local Topbar = New("Frame", {
        Name = "Topbar",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, CONFIG.TopbarHeight),
        ZIndex = 10,
        Parent = Window
    })

    --------------------------------------------------------
    -- TITLE
    --------------------------------------------------------

    local Title = New("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = CONFIG.Text,
        TextSize = 25,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 24, 0, 22),
        Size = UDim2.new(0, 260, 0, 28),
        ZIndex = 20,
        Parent = Topbar
    })

    local Subtitle = New("TextLabel", {
        Name = "Subtitle",
        BackgroundTransparency = 1,
        Text = WindowSubtitle,
        TextColor3 = CONFIG.SubText,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 24, 0, 48),
        Size = UDim2.new(0, 260, 0, 18),
        ZIndex = 20,
        Parent = Topbar
    })

    --------------------------------------------------------
    -- HEADER BUTTON CREATOR
    --------------------------------------------------------

    local function HeaderButton(text, position)
        local Button = New("TextButton", {
            Name = "HeaderButton",
            AutoButtonColor = false,
            Text = text,
            TextColor3 = Color3.fromRGB(205, 210, 225),
            TextSize = 22,
            Font = Enum.Font.GothamMedium,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.92,
            BorderSizePixel = 0,
            Position = position,
            Size = UDim2.new(0, 58, 0, 48),
            ZIndex = 25,
            Parent = Topbar
        })

        Corner(Button, 15)

        Stroke(
            Button,
            Color3.fromRGB(255, 255, 255),
            0.92,
            1
        )

        return Button
    end

    --------------------------------------------------------
    -- SEARCH
    --------------------------------------------------------

    local SearchButton = HeaderButton(
        "⌕",
        UDim2.new(1, -190, 0, 14)
    )

    --------------------------------------------------------
    -- SETTINGS
    --------------------------------------------------------

    local SettingsButton = HeaderButton(
        "⚙",
        UDim2.new(1, -126, 0, 14)
    )

    --------------------------------------------------------
    -- MINIMIZE
    --------------------------------------------------------

    local MinimizeButton = HeaderButton(
        "—",
        UDim2.new(1, -62, 0, 14)
    )

    --------------------------------------------------------
    -- HEADER DIVIDER
    --------------------------------------------------------

    local Divider = New("Frame", {
        Name = "Divider",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, CONFIG.TopbarHeight - 1),
        Size = UDim2.new(1, 0, 0, 1),
        ZIndex = 20,
        Parent = Window
    })

    --------------------------------------------------------
    -- SIDEBAR
    --------------------------------------------------------

    local Sidebar = New("Frame", {
        Name = "Sidebar",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.955,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, CONFIG.TopbarHeight),
        Size = UDim2.new(
            0,
            CONFIG.SidebarWidth,
            1,
            -CONFIG.TopbarHeight
        ),
        ZIndex = 8,
        Parent = Window
    })

    local SidebarDivider = New("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.91,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        ZIndex = 12,
        Parent = Sidebar
    })

    --------------------------------------------------------
    -- PROFILE
    --------------------------------------------------------

    local Profile = New("Frame", {
        Name = "Profile",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 1, -65),
        Size = UDim2.new(1, -24, 0, 50),
        ZIndex = 15,
        Parent = Sidebar
    })

    local Avatar = New("ImageLabel", {
        Name = "Avatar",
        BackgroundColor3 = CONFIG.Card,
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 3),
        Size = UDim2.new(0, 42, 0, 42),
        Image = "",
        ZIndex = 16,
        Parent = Profile
    })

    Corner(Avatar, 14)

    Stroke(
        Avatar,
        Color3.fromRGB(255, 255, 255),
        0.72,
        1
    )

    pcall(function()
        local image = Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )

        Avatar.Image = image
    end)

    local ProfileName = New("TextLabel", {
        BackgroundTransparency = 1,
        Text = LocalPlayer.DisplayName,
        TextColor3 = CONFIG.Text,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 52, 0, 7),
        Size = UDim2.new(1, -52, 0, 18),
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 16,
        Parent = Profile
    })

    local ProfileUser = New("TextLabel", {
        BackgroundTransparency = 1,
        Text = "@" .. LocalPlayer.Name,
        TextColor3 = CONFIG.SubText,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 52, 0, 26),
        Size = UDim2.new(1, -52, 0, 15),
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 16,
        Parent = Profile
    })

    --------------------------------------------------------
    -- TAB HOLDER
    --------------------------------------------------------

    local TabHolder = New("ScrollingFrame", {
        Name = "Tabs",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 14),
        Size = UDim2.new(1, -20, 1, -88),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 14,
        Parent = Sidebar
    })

    local TabLayout = New("UIListLayout", {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabHolder
    })

    --------------------------------------------------------
    -- CONTENT
    --------------------------------------------------------

    local Content = New("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(
            0,
            CONFIG.SidebarWidth,
            0,
            CONFIG.TopbarHeight
        ),
        Size = UDim2.new(
            1,
            -CONFIG.SidebarWidth,
            1,
            -CONFIG.TopbarHeight
        ),
        ZIndex = 10,
        Parent = Window
    })

    local Pages = New("Frame", {
        Name = "Pages",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 11,
        Parent = Content
    })

    --------------------------------------------------------
    -- DATA
    --------------------------------------------------------

    local Tabs = {}
    local PagesData = {}

    local CurrentTab = nil
    local CurrentPage = nil

    --------------------------------------------------------
    -- CREATE PAGE
    --------------------------------------------------------

    local function CreatePage(tabName)

        local Page = New("ScrollingFrame", {
            Name = tabName .. "_Page",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = CONFIG.Accent,
            ScrollBarImageTransparency = 0.45,
            Visible = false,
            ZIndex = 12,
            Parent = Pages
        })

        Padding(Page, 28, 28, 25, 30)

        local Layout = New("UIListLayout", {
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Page
        })

        PagesData[tabName] = {
            Page = Page,
            Items = {}
        }

        return Page
    end

    --------------------------------------------------------
    -- SELECT TAB
    --------------------------------------------------------

    local function SelectTab(tabName)

        local tabData = Tabs[tabName]

        if not tabData then
            return
        end

        if CurrentTab == tabName then
            return
        end

        if CurrentTab and Tabs[CurrentTab] then

            local old = Tabs[CurrentTab]

            Tween(
                old.Button,
                CONFIG.Animation,
                {
                    BackgroundTransparency = 0.96,
                    TextColor3 = CONFIG.SubText
                }
            )

            Tween(
                old.Icon,
                CONFIG.Animation,
                {
                    TextColor3 = CONFIG.SubText
                }
            )
        end

        CurrentTab = tabName

        for name, data in pairs(PagesData) do
            data.Page.Visible = false
        end

        tabData.Page.Visible = true

        Tween(
            tabData.Button,
            CONFIG.Animation,
            {
                BackgroundTransparency = 0.84,
                TextColor3 = CONFIG.Text
            }
        )

        Tween(
            tabData.Icon,
            CONFIG.Animation,
            {
                TextColor3 = CONFIG.Accent
            }
        )

        CurrentPage = tabData.Page
    end

    --------------------------------------------------------
    -- CREATE TAB
    --------------------------------------------------------

    function WindowObject:CreateTab(name)

        local Page = CreatePage(name)

        local Button = New("TextButton", {
            Name = name .. "_Tab",
            AutoButtonColor = false,
            Text = "",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.96,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 44),
            ZIndex = 15,
            Parent = TabHolder
        })

        Corner(Button, 13)

        Stroke(
            Button,
            Color3.fromRGB(255, 255, 255),
            0.94,
            1
        )

        local Icon = New("TextLabel", {
            BackgroundTransparency = 1,
            Text = "•",
            TextColor3 = CONFIG.SubText,
            TextSize = 22,
            Font = Enum.Font.GothamBold,
            Position = UDim2.new(0, 13, 0, 0),
            Size = UDim2.new(0, 20, 1, 0),
            ZIndex = 16,
            Parent = Button
        })

        local Text = New("TextLabel", {
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = CONFIG.SubText,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 40, 0, 0),
            Size = UDim2.new(1, -48, 1, 0),
            ZIndex = 16,
            Parent = Button
        })

        local Tab = {
            Button = Button,
            Icon = Icon,
            Text = Text,
            Page = Page,
            Name = name
        }

        Tabs[name] = Tab

        Button.MouseEnter:Connect(function()

            if CurrentTab ~= name then
                Tween(
                    Button,
                    0.15,
                    {
                        BackgroundTransparency = 0.91
                    }
                )
            end
        end)

        Button.MouseLeave:Connect(function()

            if CurrentTab ~= name then
                Tween(
                    Button,
                    0.15,
                    {
                        BackgroundTransparency = 0.96
                    }
                )
            end
        end)

        Button.MouseButton1Click:Connect(function()
            SelectTab(name)
        end)

        ----------------------------------------------------
        -- TAB API
        ----------------------------------------------------

        function Tab:CreateSection(sectionName)

            local Section = New("TextLabel", {
                Name = "Section",
                BackgroundTransparency = 1,
                Text = sectionName,
                TextColor3 = CONFIG.SubText,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, 0, 0, 25),
                ZIndex = 13,
                Parent = Page
            })

            Padding(Section, 3, 0, 6, 0)

            return Section
        end

        ----------------------------------------------------
        -- BUTTON
        ----------------------------------------------------

        function Tab:CreateButton(data)

            data = data or {}

            local Button = New("TextButton", {
                Name = "Button",
                AutoButtonColor = false,
                Text = data.Name or "Button",
                TextColor3 = CONFIG.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 48),
                ZIndex = 14,
                Parent = Page
            })

            Corner(Button, CONFIG.SmallCorner)

            Stroke(
                Button,
                Color3.fromRGB(255, 255, 255),
                0.91,
                1
            )

            Button.MouseEnter:Connect(function()
                Tween(
                    Button,
                    0.16,
                    {
                        BackgroundTransparency = 0.84
                    }
                )
            end)

            Button.MouseLeave:Connect(function()
                Tween(
                    Button,
                    0.16,
                    {
                        BackgroundTransparency = 0.92
                    }
                )
            end)

            Button.MouseButton1Click:Connect(function()

                Tween(
                    Button,
                    0.08,
                    {
                        BackgroundTransparency = 0.76
                    }
                )

                task.delay(0.08, function()
                    if Button.Parent then
                        Tween(
                            Button,
                            0.15,
                            {
                                BackgroundTransparency = 0.92
                            }
                        )
                    end
                end)

                if data.Callback then
                    task.spawn(data.Callback)
                end
            end)

            return Button
        end

        ----------------------------------------------------
        -- TOGGLE
        ----------------------------------------------------

        function Tab:CreateToggle(data)

            data = data or {}

            local Value = data.Default or false

            local Holder = New("TextButton", {
                Name = "Toggle",
                AutoButtonColor = false,
                Text = "",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 58),
                ZIndex = 14,
                Parent = Page
            })

            Corner(Holder, CONFIG.SmallCorner)

            Stroke(
                Holder,
                Color3.fromRGB(255, 255, 255),
                0.91,
                1
            )

            local Label = New("TextLabel", {
                BackgroundTransparency = 1,
                Text = data.Name or "Toggle",
                TextColor3 = CONFIG.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(1, -90, 1, 0),
                ZIndex = 16,
                Parent = Holder
            })

            local Switch = New("Frame", {
                BackgroundColor3 = Color3.fromRGB(90, 94, 105),
                BorderSizePixel = 0,
                Position = UDim2.new(1, -61, 0.5, -11),
                Size = UDim2.new(0, 43, 0, 22),
                ZIndex = 16,
                Parent = Holder
            })

            Corner(Switch, 20)

            local Knob = New("Frame", {
                BackgroundColor3 = Color3.fromRGB(235, 237, 242),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 3, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                ZIndex = 17,
                Parent = Switch
            })

            Corner(Knob, 20)

            local function SetValue(newValue)

                Value = newValue

                if Value then

                    Tween(
                        Switch,
                        CONFIG.Animation,
                        {
                            BackgroundColor3 = CONFIG.Accent
                        }
                    )

                    Tween(
                        Knob,
                        CONFIG.Animation,
                        {
                            Position = UDim2.new(1, -19, 0.5, -8)
                        }
                    )

                else

                    Tween(
                        Switch,
                        CONFIG.Animation,
                        {
                            BackgroundColor3 = Color3.fromRGB(90, 94, 105)
                        }
                    )

                    Tween(
                        Knob,
                        CONFIG.Animation,
                        {
                            Position = UDim2.new(0, 3, 0.5, -8)
                        }
                    )
                end

                if data.Callback then
                    task.spawn(data.Callback, Value)
                end
            end

            Holder.MouseButton1Click:Connect(function()
                SetValue(not Value)
            end)

            SetValue(Value)

            return {
                Set = SetValue,
                Get = function()
                    return Value
                end
            }
        end

        ----------------------------------------------------
        -- SLIDER
        ----------------------------------------------------

        function Tab:CreateSlider(data)

            data = data or {}

            local Range = data.Range or {0, 100}
            local Minimum = Range[1]
            local Maximum = Range[2]

            local Value = data.CurrentValue or Minimum
            local Increment = data.Increment or 1

            local Holder = New("Frame", {
                Name = "Slider",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 70),
                ZIndex = 14,
                Parent = Page
            })

            Corner(Holder, CONFIG.SmallCorner)

            Stroke(
                Holder,
                Color3.fromRGB(255, 255, 255),
                0.91,
                1
            )

            local Label = New("TextLabel", {
                BackgroundTransparency = 1,
                Text = data.Name or "Slider",
                TextColor3 = CONFIG.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 16, 0, 10),
                Size = UDim2.new(0.7, 0, 0, 20),
                ZIndex = 16,
                Parent = Holder
            })

            local ValueLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Text = tostring(Value),
                TextColor3 = CONFIG.Accent,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2.new(0.7, 0, 0, 10),
                Size = UDim2.new(0.3, -16, 0, 20),
                ZIndex = 16,
                Parent = Holder
            })

            local Bar = New("Frame", {
                BackgroundColor3 = Color3.fromRGB(70, 74, 85),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 16, 1, -24),
                Size = UDim2.new(1, -32, 0, 6),
                ZIndex = 16,
                Parent = Holder
            })

            Corner(Bar, 10)

            local Fill = New("Frame", {
                BackgroundColor3 = CONFIG.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 17,
                Parent = Bar
            })

            Corner(Fill, 10)

            local function SetValue(newValue)

                newValue = math.clamp(
                    newValue,
                    Minimum,
                    Maximum
                )

                newValue =
                    math.floor(
                        newValue / Increment + 0.5
                    ) * Increment

                Value = newValue

                local percent =
                    (Value - Minimum) /
                    (Maximum - Minimum)

                Tween(
                    Fill,
                    0.12,
                    {
                        Size = UDim2.new(
                            percent,
                            0,
                            1,
                            0
                        )
                    }
                )

                ValueLabel.Text = tostring(Value)

                if data.Callback then
                    task.spawn(data.Callback, Value)
                end
            end

            local dragging = false

            local function Update(input)

                local percent =
                    math.clamp(
                        (input.Position.X - Bar.AbsolutePosition.X)
                        / Bar.AbsoluteSize.X,
                        0,
                        1
                    )

                SetValue(
                    Minimum +
                    (Maximum - Minimum) * percent
                )
            end

            Bar.InputBegan:Connect(function(input)

                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                    or
                    input.UserInputType ==
                    Enum.UserInputType.Touch then

                    dragging = true
                    Update(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)

                if dragging then

                    if input.UserInputType ==
                        Enum.UserInputType.MouseMovement
                        or
                        input.UserInputType ==
                        Enum.UserInputType.Touch then

                        Update(input)
                    end
                end
            end)

            UserInputService.InputEnded:Connect(function(input)

                if input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                    or
                    input.UserInputType ==
                    Enum.UserInputType.Touch then

                    dragging = false
                end
            end)

            SetValue(Value)

            return {
                Set = SetValue,
                Get = function()
                    return Value
                end
            }
        end

        ----------------------------------------------------
        -- DROPDOWN
        ----------------------------------------------------

        function Tab:CreateDropdown(data)

            data = data or {}

            local Options = data.Options or {}
            local Current = data.CurrentOption or Options[1]

            local Holder = New("Frame", {
                Name = "Dropdown",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 52),
                ClipsDescendants = true,
                ZIndex = 18,
                Parent = Page
            })

            Corner(Holder, CONFIG.SmallCorner)

            Stroke(
                Holder,
                Color3.fromRGB(255, 255, 255),
                0.91,
                1
            )

            local MainButton = New("TextButton", {
                AutoButtonColor = false,
                Text = "",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 52),
                ZIndex = 20,
                Parent = Holder
            })

            local Label = New("TextLabel", {
                BackgroundTransparency = 1,
                Text = data.Name or "Dropdown",
                TextColor3 = CONFIG.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(0.55, 0, 0, 52),
                ZIndex = 21,
                Parent = MainButton
            })

            local CurrentLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Text = tostring(Current or ""),
                TextColor3 = CONFIG.Accent,
                TextSize = 12,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2.new(0.55, 0, 0, 0),
                Size = UDim2.new(0.38, 0, 0, 52),
                ZIndex = 21,
                Parent = MainButton
            })

            local Arrow = New("TextLabel", {
                BackgroundTransparency = 1,
                Text = "⌄",
                TextColor3 = CONFIG.SubText,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                Position = UDim2.new(1, -30, 0, 0),
                Size = UDim2.new(0, 20, 0, 52),
                ZIndex = 21,
                Parent = MainButton
            })

            local OptionHolder = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 55),
                Size = UDim2.new(1, -20, 0, 0),
                ZIndex = 22,
                Parent = Holder
            })

            local OptionLayout = New("UIListLayout", {
                Padding = UDim.new(0, 5),
                Parent = OptionHolder
            })

            local Open = false

            local function RefreshHeight()

                local count = #Options

                local height = Open
                    and (60 + count * 37)
                    or 52

                Tween(
                    Holder,
                    CONFIG.Animation,
                    {
                        Size = UDim2.new(
                            1,
                            0,
                            0,
                            height
                        )
                    }
                )
            end

            local function SetOption(option)

                Current = option
                CurrentLabel.Text = tostring(option)

                if data.Callback then
                    task.spawn(data.Callback, option)
                end
            end

            for _, option in ipairs(Options) do

                local OptionButton = New("TextButton", {
                    AutoButtonColor = false,
                    Text = tostring(option),
                    TextColor3 = CONFIG.SubText,
                    TextSize = 12,
                    Font = Enum.Font.GothamMedium,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.94,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 32),
                    ZIndex = 23,
                    Parent = OptionHolder
                })

                Corner(OptionButton, 10)

                OptionButton.MouseEnter:Connect(function()

                    Tween(
                        OptionButton,
                        0.12,
                        {
                            BackgroundTransparency = 0.87,
                            TextColor3 = CONFIG.Text
                        }
                    )
                end)

                OptionButton.MouseLeave:Connect(function()

                    Tween(
                        OptionButton,
                        0.12,
                        {
                            BackgroundTransparency = 0.94,
                            TextColor3 = CONFIG.SubText
                        }
                    )
                end)

                OptionButton.MouseButton1Click:Connect(function()

                    SetOption(option)

                    Open = false

                    Arrow.Text = "⌄"

                    RefreshHeight()
                end)
            end

            MainButton.MouseButton1Click:Connect(function()

                Open = not Open

                Arrow.Text = Open and "⌃" or "⌄"

                RefreshHeight()
            end)

            return {
                Set = SetOption,
                Get = function()
                    return Current
                end
            }
        end

        ----------------------------------------------------
        -- INPUT
        ----------------------------------------------------

        function Tab:CreateInput(data)

            data = data or {}

            local Holder = New("Frame", {
                Name = "Input",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 64),
                ZIndex = 14,
                Parent = Page
            })

            Corner(Holder, CONFIG.SmallCorner)

            Stroke(
                Holder,
                Color3.fromRGB(255, 255, 255),
                0.91,
                1
            )

            local Label = New("TextLabel", {
                BackgroundTransparency = 1,
                Text = data.Name or "Input",
                TextColor3 = CONFIG.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 15, 0, 8),
                Size = UDim2.new(1, -30, 0, 18),
                ZIndex = 16,
                Parent = Holder
            })

            local Box = New("TextBox", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.95,
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                PlaceholderText = data.PlaceholderText or "Type here...",
                PlaceholderColor3 = Color3.fromRGB(125, 130, 145),
                Text = data.CurrentValue or "",
                TextColor3 = CONFIG.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 12, 0, 31),
                Size = UDim2.new(1, -24, 0, 26),
                ZIndex = 16,
                Parent = Holder
            })

            Corner(Box, 9)

            Padding(Box, 9, 9, 0, 0)

            Box.FocusLost:Connect(function()

                if data.Callback then
                    task.spawn(data.Callback, Box.Text)
                end
            end)

            return Box
        end

        ----------------------------------------------------
        -- KEYBIND
        ----------------------------------------------------

        function Tab:CreateKeybind(data)

            data = data or {}

            local CurrentKey =
                data.CurrentKeybind
                or Enum.KeyCode.RightShift

            local Holder = New("TextButton", {
                Name = "Keybind",
                AutoButtonColor = false,
                Text = "",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 52),
                ZIndex = 14,
                Parent = Page
            })

            Corner(Holder, CONFIG.SmallCorner)

            Stroke(
                Holder,
                Color3.fromRGB(255, 255, 255),
                0.91,
                1
            )

            local Label = New("TextLabel", {
                BackgroundTransparency = 1,
                Text = data.Name or "Keybind",
                TextColor3 = CONFIG.Text,
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                ZIndex = 16,
                Parent = Holder
            })

            local KeyLabel = New("TextLabel", {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.91,
                Text = CurrentKey.Name,
                TextColor3 = CONFIG.Accent,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                Position = UDim2.new(1, -95, 0.5, -13),
                Size = UDim2.new(0, 78, 0, 26),
                ZIndex = 16,
                Parent = Holder
            })

            Corner(KeyLabel, 9)

            local Listening = false

            Holder.MouseButton1Click:Connect(function()

                if Listening then
                    return
                end

                Listening = true
                KeyLabel.Text = "Press key"

                local connection

                connection = UserInputService.InputBegan:Connect(function(
                    input,
                    processed
                )

                    if processed then
                        return
                    end

                    if input.UserInputType ==
                        Enum.UserInputType.Keyboard then

                        CurrentKey = input.KeyCode

                        KeyLabel.Text = CurrentKey.Name

                        Listening = false

                        connection:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(
                input,
                processed
            )

                if processed then
                    return
                end

                if input.KeyCode == CurrentKey then

                    if data.Callback then
                        task.spawn(
                            data.Callback,
                            CurrentKey
                        )
                    end
                end
            end)

            return {
                Set = function(key)
                    CurrentKey = key
                    KeyLabel.Text = key.Name
                end,

                Get = function()
                    return CurrentKey
                end
            }
        end

        return Tab
    end

    --------------------------------------------------------
    -- HOME PAGE
    --------------------------------------------------------

    local Home = WindowObject:CreateTab("Home")

    local Welcome = New("TextLabel", {
        BackgroundTransparency = 1,
        Text = "Welcome",
        TextColor3 = CONFIG.Text,
        TextSize = 28,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 0, 34),
        ZIndex = 15,
        Parent = Home.Page
    })

    local WelcomeSub = New("TextLabel", {
        BackgroundTransparency = 1,
        Text = "Your interface is ready.",
        TextColor3 = CONFIG.SubText,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 0, 22),
        ZIndex = 15,
        Parent = Home.Page
    })

    --------------------------------------------------------
    -- HOME GLASS CARD
    --------------------------------------------------------

    local HomeCard = New("Frame", {
        Name = "GlassCard",
        BackgroundColor3 = Color3.fromRGB(180, 200, 230),
        BackgroundTransparency = 0.84,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 190),
        ZIndex = 14,
        Parent = Home.Page
    })

    Corner(HomeCard, 20)

    Stroke(
        HomeCard,
        Color3.fromRGB(255, 255, 255),
        0.60,
        1.2
    )

    Gradient(
        HomeCard,
        Color3.fromRGB(215, 230, 255),
        Color3.fromRGB(255, 255, 255),
        130
    ).Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.80),
        NumberSequenceKeypoint.new(0.55, 0.94),
        NumberSequenceKeypoint.new(1, 0.86)
    })

    local CardHighlight = New("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.84,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 20, 0, 1),
        Size = UDim2.new(1, -40, 0, 2),
        ZIndex = 20,
        Parent = HomeCard
    })

    Corner(CardHighlight, 5)

    local CardTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = CONFIG.Text,
        TextSize = 23,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 30, 0, 34),
        Size = UDim2.new(1, -60, 0, 30),
        ZIndex = 20,
        Parent = HomeCard
    })

    local CardText = New("TextLabel", {
        BackgroundTransparency = 1,
        Text = "Liquid Glass interface  •  Smooth animations  •  Mobile ready",
        TextColor3 = CONFIG.SubText,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 30, 0, 82),
        Size = UDim2.new(1, -60, 0, 25),
        ZIndex = 20,
        Parent = HomeCard
    })

    local CardLine = New("Frame", {
        BackgroundColor3 = CONFIG.Accent,
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 30, 1, -34),
        Size = UDim2.new(0, 80, 0, 3),
        ZIndex = 20,
        Parent = HomeCard
    })

    Corner(CardLine, 10)

    --------------------------------------------------------
    -- SETTINGS TAB
    --------------------------------------------------------

    local Settings = WindowObject:CreateTab("Settings")

    Settings:CreateSection("Interface")

    local ProfileToggle = Settings:CreateToggle({
        Name = "Show profile",
        Default = true,
        Callback = function(Value)

            Profile.Visible = Value

        end
    })

    local KeepScreenToggle = Settings:CreateToggle({
        Name = "Keep window on screen",
        Default = true,
        Callback = function(Value)

            WindowObject.KeepOnScreen = Value

        end
    })

    Settings:CreateButton({
        Name = "Reset Window Position",
        Callback = function()

            Tween(
                Window,
                0.35,
                {
                    Position = UDim2.fromScale(0.5, 0.5)
                }
            )

            Tween(
                Shadow,
                0.35,
                {
                    Position = UDim2.fromScale(0.5, 0.5)
                }
            )
        end
    })

    --------------------------------------------------------
    -- PROFILE TAB
    --------------------------------------------------------

    local ProfileTab = WindowObject:CreateTab("Profile")

    ProfileTab:CreateSection("Account")

    ProfileTab:CreateButton({
        Name = LocalPlayer.DisplayName,
        Callback = function()
            WindowObject:Notify({
                Title = "Profile",
                Content = "@" .. LocalPlayer.Name,
                Duration = 2.5
            })
        end
    })

    ProfileTab:CreateInput({
        Name = "Display text",
        PlaceholderText = "Enter text...",
        Callback = function(Text)

            WindowObject:Notify({
                Title = "Profile",
                Content = Text,
                Duration = 2.5
            })

        end
    })

    --------------------------------------------------------
    -- SEARCH
    --------------------------------------------------------

    local SearchFrame = New("Frame", {
        Name = "Search",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.91,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -250, 0, 13),
        Size = UDim2.new(0, 230, 0, 50),
        Visible = false,
        ZIndex = 40,
        Parent = Topbar
    })

    Corner(SearchFrame, 15)

    Stroke(
        SearchFrame,
        Color3.fromRGB(255, 255, 255),
        0.78,
        1
    )

    local SearchBox = New("TextBox", {
        BackgroundTransparency = 1,
        ClearTextOnFocus = false,
        PlaceholderText = "Search all pages",
        PlaceholderColor3 = CONFIG.SubText,
        Text = "",
        TextColor3 = CONFIG.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        ZIndex = 41,
        Parent = SearchFrame
    })

    --------------------------------------------------------
    -- SEARCH LOGIC
    --------------------------------------------------------

    local function Search(text)

        text = string.lower(text or "")

        if not CurrentTab then
            return
        end

        local pageData = PagesData[CurrentTab]

        if not pageData then
            return
        end

        for _, item in ipairs(pageData.Items) do

            if item:IsA("GuiObject") then

                local itemText = ""

                for _, child in ipairs(item:GetDescendants()) do

                    if child:IsA("TextLabel")
                        or child:IsA("TextButton") then

                        itemText =
                            itemText ..
                            " " ..
                            string.lower(child.Text)
                    end
                end

                item.Visible =
                    text == ""
                    or string.find(itemText, text, 1, true) ~= nil
            end
        end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        Search(SearchBox.Text)
    end)

    SearchButton.MouseButton1Click:Connect(function()

        SearchFrame.Visible = not SearchFrame.Visible

        if SearchFrame.Visible then

            SearchFrame.Size =
                UDim2.new(0, 20, 0, 50)

            Tween(
                SearchFrame,
                0.22,
                {
                    Size = UDim2.new(0, 230, 0, 50)
                }
            )

            task.defer(function()
                SearchBox:CaptureFocus()
            end)

        else
            SearchBox:ReleaseFocus()
        end
    end)

    --------------------------------------------------------
    -- SETTINGS BUTTON
    --------------------------------------------------------

    SettingsButton.MouseButton1Click:Connect(function()

        SelectTab("Settings")

    end)

    --------------------------------------------------------
    -- BUTTON HOVER EFFECT
    --------------------------------------------------------

    local function HeaderHover(button)

        button.MouseEnter:Connect(function()

            Tween(
                button,
                0.15,
                {
                    BackgroundTransparency = 0.82,
                    TextColor3 = CONFIG.Text
                }
            )

        end)

        button.MouseLeave:Connect(function()

            Tween(
                button,
                0.15,
                {
                    BackgroundTransparency = 0.92,
                    TextColor3 = Color3.fromRGB(205, 210, 225)
                }
            )

        end)

    end

    HeaderHover(SearchButton)
    HeaderHover(SettingsButton)
    HeaderHover(MinimizeButton)

    --------------------------------------------------------
    -- DRAG SYSTEM
    --------------------------------------------------------

    local dragging = false
    local dragStart
    local startPosition

    local function ClampPosition(position)

        if not WindowObject.KeepOnScreen then
            return position
        end

        local viewport =
            workspace.CurrentCamera.ViewportSize

        local halfW = CONFIG.Width / 2
        local halfH = CONFIG.Height / 2

        local minX = halfW + 10
        local maxX = viewport.X - halfW - 10

        local minY = halfH + 10
        local maxY = viewport.Y - halfH - 10

        return Vector3.new(
            math.clamp(position.X, minX, maxX),
            math.clamp(position.Y, minY, maxY),
            0
        )
    end

    local function StartDrag(input)

        dragging = true
        dragStart = input.Position
        startPosition = Window.Position
    end

    local function UpdateDrag(input)

        if not dragging then
            return
        end

        local delta =
            input.Position - dragStart

        local newPosition = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )

        Window.Position = newPosition
        Shadow.Position = newPosition
    end

    local function EndDrag()
        dragging = false
    end

    Topbar.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch then

            StartDrag(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or
            input.UserInputType ==
            Enum.UserInputType.Touch then

            UpdateDrag(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or
            input.UserInputType ==
            Enum.UserInputType.Touch then

            EndDrag()
        end
    end)

    --------------------------------------------------------
    -- NOTIFICATION
    --------------------------------------------------------

    function WindowObject:Notify(data)

        data = data or {}

        local Notification = New("Frame", {
            Name = "Notification",
            BackgroundColor3 = CONFIG.Background,
            BackgroundTransparency = 0.12,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 310, 0, 78),
            ZIndex = 100,
            Parent = NotificationHolder
        })

        Corner(Notification, 18)

        Stroke(
            Notification,
            Color3.fromRGB(255, 255, 255),
            0.62,
            1.2
        )

        Gradient(
            Notification,
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(120, 150, 190),
            130
        ).Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.92),
            NumberSequenceKeypoint.new(1, 0.96)
        })

        local NTitle = New("TextLabel", {
            BackgroundTransparency = 1,
            Text = data.Title or "WALLXP",
            TextColor3 = CONFIG.Text,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 17, 0, 13),
            Size = UDim2.new(1, -34, 0, 20),
            ZIndex = 102,
            Parent = Notification
        })

        local NContent = New("TextLabel", {
            BackgroundTransparency = 1,
            Text = data.Content or "",
            TextColor3 = CONFIG.SubText,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 17, 0, 36),
            Size = UDim2.new(1, -34, 0, 30),
            ZIndex = 102,
            Parent = Notification
        })

        Notification.Position =
            UDim2.new(1, 30, 0, 0)

        Tween(
            Notification,
            0.28,
            {
                Position = UDim2.new(0, 0, 0, 0)
            }
        )

        task.delay(
            data.Duration or 3,
            function()

                if Notification.Parent then

                    Tween(
                        Notification,
                        0.25,
                        {
                            Position =
                                UDim2.new(1, 30, 0, 0)
                        }
                    )

                    task.wait(0.28)

                    Notification:Destroy()
                end
            end
        )

        return Notification
    end

    --------------------------------------------------------
    -- FLOATING RESTORE BUTTON
    --------------------------------------------------------

    local Floating = New("TextButton", {
        Name = "FloatingRestore",
        AutoButtonColor = false,
        Text = "",
        BackgroundColor3 = CONFIG.Background,
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 20),
        Size = UDim2.new(0, 150, 0, 48),
        Visible = false,
        ZIndex = 90,
        Parent = ScreenGui
    })

    Corner(Floating, 24)

    Stroke(
        Floating,
        Color3.fromRGB(255, 255, 255),
        0.62,
        1.2
    )

    local FloatingTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = CONFIG.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Position = UDim2.new(0, 14, 0, 4),
        Size = UDim2.new(1, -28, 0, 20),
        ZIndex = 92,
        Parent = Floating
    })

    local FloatingSub = New("TextLabel", {
        BackgroundTransparency = 1,
        Text = "Tap to show",
        TextColor3 = CONFIG.SubText,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        Position = UDim2.new(0, 14, 0, 24),
        Size = UDim2.new(1, -28, 0, 16),
        ZIndex = 92,
        Parent = Floating
    })

    --------------------------------------------------------
    -- MINIMIZE
    --------------------------------------------------------

    local Minimized = false

    local function Minimize()

        if Minimized then
            return
        end

        Minimized = true

        Tween(
            Window,
            0.28,
            {
                Size = UDim2.new(
                    0,
                    CONFIG.Width,
                    0,
                    70
                )
            }
        )

        Tween(
            Shadow,
            0.28,
            {
                Size = UDim2.new(
                    0,
                    CONFIG.Width + 20,
                    0,
                    90
                )
            }
        )

        task.delay(0.28, function()

            if Window.Parent then
                Window.Visible = false
                Shadow.Visible = false
                Floating.Visible = true

                Floating.Size =
                    UDim2.new(0, 20, 0, 20)

                Tween(
                    Floating,
                    0.28,
                    {
                        Size =
                            UDim2.new(0, 150, 0, 48)
                    }
                )
            end
        end)
    end

    local function Restore()

        if not Minimized then
            return
        end

        Minimized = false

        Floating.Visible = false

        Window.Visible = true
        Shadow.Visible = true

        Window.Size =
            UDim2.new(
                0,
                CONFIG.Width,
                0,
                70
            )

        Shadow.Size =
            UDim2.new(
                0,
                CONFIG.Width + 20,
                0,
                90
            )

        Tween(
            Window,
            0.30,
            {
                Size =
                    UDim2.new(
                        0,
                        CONFIG.Width,
                        0,
                        CONFIG.Height
                    )
            }
        )

        Tween(
            Shadow,
            0.30,
            {
                Size =
                    UDim2.new(
                        0,
                        CONFIG.Width + 20,
                        0,
                        CONFIG.Height + 20
                    )
            }
        )
    end

    MinimizeButton.MouseButton1Click:Connect(Minimize)
    Floating.MouseButton1Click:Connect(Restore)

    --------------------------------------------------------
    -- PUBLIC WINDOW API
    --------------------------------------------------------

    function WindowObject:Minimize()
        Minimize()
    end

    function WindowObject:Restore()
        Restore()
    end

    function WindowObject:SelectTab(name)
        SelectTab(name)
    end

    function WindowObject:Destroy()
        ScreenGui:Destroy()
    end

    function WindowObject:GetGui()
        return ScreenGui
    end

    WindowObject.KeepOnScreen = true

    --------------------------------------------------------
    -- OPEN ANIMATION
    --------------------------------------------------------

    Window.Size =
        UDim2.new(
            0,
            CONFIG.Width - 45,
            0,
            CONFIG.Height - 45
        )

    Shadow.Size =
        UDim2.new(
            0,
            CONFIG.Width - 20,
            0,
            CONFIG.Height - 20
        )

    Window.BackgroundTransparency = 1
    Shadow.BackgroundTransparency = 1

    Tween(
        Window,
        0.38,
        {
            Size =
                UDim2.new(
                    0,
                    CONFIG.Width,
                    0,
                    CONFIG.Height
                ),
            BackgroundTransparency = 0.18
        }
    )

    Tween(
        Shadow,
        0.38,
        {
            Size =
                UDim2.new(
                    0,
                    CONFIG.Width + 20,
                    0,
                    CONFIG.Height + 20
                ),
            BackgroundTransparency = 0.72
        }
    )

    --------------------------------------------------------
    -- DEFAULT TAB
    --------------------------------------------------------

    task.defer(function()

        SelectTab("Home")

        WindowObject:Notify({
            Title = WindowName,
            Content = "Liquid Glass interface ready.",
            Duration = 2.5
        })

    end)

    return WindowObject
end

------------------------------------------------------------
-- RETURN LIBRARY
------------------------------------------------------------

return WALLXP
