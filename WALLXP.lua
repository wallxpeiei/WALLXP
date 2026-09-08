--[[
    WALLXP v1.5
    Modern UI Library
    Single-file / loadstring compatible
    UI-only library
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local WALLXP = {}

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
    WindowSize = Vector2.new(620, 370),

    Background = Color3.fromRGB(18, 18, 21),
    Sidebar = Color3.fromRGB(22, 22, 26),
    Topbar = Color3.fromRGB(20, 20, 23),
    Card = Color3.fromRGB(27, 27, 32),
    CardHover = Color3.fromRGB(34, 34, 40),

    Text = Color3.fromRGB(245, 245, 248),
    SubText = Color3.fromRGB(155, 155, 165),

    Accent = Color3.fromRGB(70, 130, 255),
    AccentDark = Color3.fromRGB(45, 95, 210),

    Border = Color3.fromRGB(42, 42, 48),

    ToggleOff = Color3.fromRGB(55, 55, 62),

    Corner = 10,

    Tween = TweenInfo.new(
        0.18,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
}

--==================================================
-- UTILITY
--==================================================

local function New(className, properties)
    local obj = Instance.new(className)

    for property, value in pairs(properties or {}) do
        obj[property] = value
    end

    return obj
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or CONFIG.Corner)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or CONFIG.Border
    s.Transparency = transparency or 0
    s.Thickness = 1
    s.Parent = parent
    return s
end

local function Padding(parent, left, right, top, bottom)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.Parent = parent
    return p
end

local function Tween(object, properties, info)
    local t = TweenService:Create(
        object,
        info or CONFIG.Tween,
        properties
    )

    t:Play()
    return t
end

local function MakeDraggable(handle, object)
    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - dragStart

            object.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

--==================================================
-- GUI
--==================================================

local oldGui = nil

pcall(function()
    oldGui = game:GetService("CoreGui"):FindFirstChild("WALLXP_UI")
end)

if oldGui then
    oldGui:Destroy()
end

local ScreenGui = New("ScreenGui", {
    Name = "WALLXP_UI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local function ProtectGui(gui)
    local success = pcall(function()
        gui.Parent = game:GetService("CoreGui")
    end)

    if not success then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

ProtectGui(ScreenGui)

--==================================================
-- NOTIFICATION SYSTEM
--==================================================

local NotificationHolder = New("Frame", {
    Name = "Notifications",
    Parent = ScreenGui,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -15, 1, -15),
    Size = UDim2.new(0, 300, 0, 300)
})

local NotificationLayout = New("UIListLayout", {
    Parent = NotificationHolder,
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDim.new(0, 8)
})

function WALLXP:Notify(data)
    data = data or {}

    local title = data.Title or "WALLXP"
    local content = data.Content or ""
    local duration = data.Duration or 3

    local Notification = New("Frame", {
        Parent = NotificationHolder,
        BackgroundColor3 = CONFIG.Card,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 280, 0, 70),
        BackgroundTransparency = 1
    })

    Corner(Notification, 10)
    Stroke(Notification, CONFIG.Border)

    local Title = New("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -30, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = CONFIG.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1
    })

    local Content = New("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 33),
        Size = UDim2.new(1, -30, 0, 25),
        Font = Enum.Font.Gotham,
        Text = content,
        TextColor3 = CONFIG.SubText,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1
    })

    Tween(Notification, {
        BackgroundTransparency = 0
    })

    Tween(Title, {
        TextTransparency = 0
    })

    Tween(Content, {
        TextTransparency = 0
    })

    task.delay(duration, function()
        if Notification and Notification.Parent then
            Tween(Notification, {
                BackgroundTransparency = 1
            })

            Tween(Title, {
                TextTransparency = 1
            })

            Tween(Content, {
                TextTransparency = 1
            })

            task.wait(0.2)

            if Notification then
                Notification:Destroy()
            end
        end
    end)
end

--==================================================
-- CREATE WINDOW
--==================================================

function WALLXP:CreateWindow(options)

    options = options or {}

    local WindowObject = {}

    local WindowName = options.Name or "WALLXP"
    local WindowSubtitle = options.Subtitle or "UI Library"

    local Window = New("Frame", {
        Name = "Window",
        Parent = ScreenGui,
        BackgroundColor3 = CONFIG.Background,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(
            CONFIG.WindowSize.X,
            CONFIG.WindowSize.Y
        ),
        Position = UDim2.new(
            0.5,
            -CONFIG.WindowSize.X / 2,
            0.5,
            -CONFIG.WindowSize.Y / 2
        )
    })

    Corner(Window, 12)
    Stroke(Window, CONFIG.Border)

    --==================================================
    -- TOPBAR
    --==================================================

    local Topbar = New("Frame", {
        Name = "Topbar",
        Parent = Window,
        BackgroundColor3 = CONFIG.Topbar,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 62)
    })

    Corner(Topbar, 12)

    local TopbarCover = New("Frame", {
        Parent = Topbar,
        BackgroundColor3 = CONFIG.Topbar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12)
    })

    -- Icon

    local Logo = New("Frame", {
        Parent = Topbar,
        BackgroundColor3 = CONFIG.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0.5, -18),
        Size = UDim2.fromOffset(36, 36)
    })

    Corner(Logo, 9)

    local LogoText = New("TextLabel", {
        Parent = Logo,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Font = Enum.Font.GothamBold,
        Text = "W",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 19
    })

    -- Title

    local Title = New("TextLabel", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 61, 0, 12),
        Size = UDim2.new(0, 260, 0, 21),
        Font = Enum.Font.GothamBold,
        Text = WindowName,
        TextColor3 = CONFIG.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Subtitle = New("TextLabel", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 61, 0, 33),
        Size = UDim2.new(0, 260, 0, 17),
        Font = Enum.Font.Gotham,
        Text = WindowSubtitle,
        TextColor3 = CONFIG.SubText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Header Buttons

    local SearchButton = New("TextButton", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -130, 0.5, -17),
        Size = UDim2.fromOffset(34, 34),
        Font = Enum.Font.GothamBold,
        Text = "⌕",
        TextColor3 = CONFIG.SubText,
        TextSize = 24,
        AutoButtonColor = false
    })

    local SettingsButton = New("TextButton", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -91, 0.5, -17),
        Size = UDim2.fromOffset(34, 34),
        Font = Enum.Font.GothamBold,
        Text = "⚙",
        TextColor3 = CONFIG.SubText,
        TextSize = 17,
        AutoButtonColor = false
    })

    local MinimizeButton = New("TextButton", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -52, 0.5, -17),
        Size = UDim2.fromOffset(34, 34),
        Font = Enum.Font.GothamBold,
        Text = "—",
        TextColor3 = CONFIG.SubText,
        TextSize = 18,
        AutoButtonColor = false
    })

    --==================================================
    -- BODY
    --==================================================

    local Body = New("Frame", {
        Name = "Body",
        Parent = Window,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 62),
        Size = UDim2.new(1, 0, 1, -62)
    })

    --==================================================
    -- SIDEBAR
    --==================================================

    local Sidebar = New("Frame", {
        Name = "Sidebar",
        Parent = Body,
        BackgroundColor3 = CONFIG.Sidebar,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 145, 1, 0)
    })

    local SidebarLine = New("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = CONFIG.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -1, 0, 0),
        Size = UDim2.new(0, 1, 1, 0)
    })

    local TabHolder = New("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 9, 0, 12),
        Size = UDim2.new(1, -18, 1, -78),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new()
    })

    local TabLayout = New("UIListLayout", {
        Parent = TabHolder,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    -- Profile

    local Profile = New("Frame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 1, -60),
        Size = UDim2.new(1, -20, 0, 50)
    })

    local Avatar = New("ImageLabel", {
        Parent = Profile,
        BackgroundColor3 = CONFIG.Card,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, -17),
        Size = UDim2.fromOffset(34, 34),
        Image = ""
    })

    Corner(Avatar, 17)

    pcall(function()
        Avatar.Image = Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)

    local ProfileName = New("TextLabel", {
        Parent = Profile,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 43, 0, 7),
        Size = UDim2.new(1, -43, 0, 17),
        Font = Enum.Font.GothamSemibold,
        Text = LocalPlayer.DisplayName,
        TextColor3 = CONFIG.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ProfileUser = New("TextLabel", {
        Parent = Profile,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 43, 0, 25),
        Size = UDim2.new(1, -43, 0, 15),
        Font = Enum.Font.Gotham,
        Text = "@" .. LocalPlayer.Name,
        TextColor3 = CONFIG.SubText,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    --==================================================
    -- CONTENT
    --==================================================

    local Content = New("Frame", {
        Name = "Content",
        Parent = Body,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 145, 0, 0),
        Size = UDim2.new(1, -145, 1, 0)
    })

    local Pages = New("Frame", {
        Parent = Content,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0)
    })

    --==================================================
    -- SEARCH
    --==================================================

    local SearchContainer = New("Frame", {
        Parent = Content,
        BackgroundColor3 = CONFIG.Card,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0, 12),
        Size = UDim2.new(1, -30, 0, 36),
        Visible = false
    })

    Corner(SearchContainer, 8)
    Stroke(SearchContainer, CONFIG.Border)

    local SearchIcon = New("TextLabel", {
        Parent = SearchContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.fromOffset(25, 36),
        Font = Enum.Font.GothamBold,
        Text = "⌕",
        TextColor3 = CONFIG.SubText,
        TextSize = 20
    })

    local SearchBox = New("TextBox", {
        Parent = SearchContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 36, 0, 0),
        Size = UDim2.new(1, -45, 1, 0),
        Font = Enum.Font.Gotham,
        Text = "",
        PlaceholderText = "Search all pages",
        PlaceholderColor3 = CONFIG.SubText,
        TextColor3 = CONFIG.Text,
        TextSize = 11,
        ClearTextOnFocus = false
    })

    --==================================================
    -- DATA
    --==================================================

    local Tabs = {}
    local CurrentTab = nil

    local SettingsPage
    local HomePage

    local ShowProfile = true
    local KeepOnScreen = true

    local NormalPosition = Window.Position
    local IsMinimized = false

    local Floating = New("TextButton", {
        Parent = ScreenGui,
        BackgroundColor3 = CONFIG.Card,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -15, 0, 15),
        Size = UDim2.fromOffset(145, 48),
        Visible = false,
        AutoButtonColor = false,
        Text = ""
    })

    Corner(Floating, 12)
    Stroke(Floating, CONFIG.Border)

    local FloatingTitle = New("TextLabel", {
        Parent = Floating,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 13, 0, 7),
        Size = UDim2.new(1, -26, 0, 16),
        Font = Enum.Font.GothamBold,
        Text = "WALLXP",
        TextColor3 = CONFIG.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local FloatingSub = New("TextLabel", {
        Parent = Floating,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 13, 0, 25),
        Size = UDim2.new(1, -26, 0, 14),
        Font = Enum.Font.Gotham,
        Text = "Tap to show",
        TextColor3 = CONFIG.SubText,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    --==================================================
    -- PAGE CREATOR
    --==================================================

    local function CreatePage()
        local Page = New("ScrollingFrame", {
            Parent = Pages,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = CONFIG.Accent,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false
        })

        Padding(Page, 15, 15, 15, 15)

        local Layout = New("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        })

        return Page
    end

    --==================================================
    -- HOME
    --==================================================

    HomePage = CreatePage()

    local HomeHeader = New("Frame", {
        Parent = HomePage,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 52)
    })

    local HomeTitle = New("TextLabel", {
        Parent = HomeHeader,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = "Home",
        TextColor3 = CONFIG.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local HomeDesc = New("TextLabel", {
        Parent = HomeHeader,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 26),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = "Welcome to your WALLXP interface",
        TextColor3 = CONFIG.SubText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local HomeCard = New("Frame", {
        Parent = HomePage,
        BackgroundColor3 = CONFIG.Card,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 82)
    })

    Corner(HomeCard, 9)
    Stroke(HomeCard, CONFIG.Border)

    local HomeCardTitle = New("TextLabel", {
        Parent = HomeCard,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 14),
        Size = UDim2.new(1, -30, 0, 20),
        Font = Enum.Font.GothamSemibold,
        Text = "WALLXP v1.5",
        TextColor3 = CONFIG.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local HomeCardText = New("TextLabel", {
        Parent = HomeCard,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 37),
        Size = UDim2.new(1, -30, 0, 30),
        Font = Enum.Font.Gotham,
        Text = "Modern interface with tabs, search, settings and smooth controls.",
        TextColor3 = CONFIG.SubText,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    --==================================================
    -- SETTINGS
    --==================================================

    SettingsPage = CreatePage()

    local SettingsHeader = New("Frame", {
        Parent = SettingsPage,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 52)
    })

    local SettingsTitle = New("TextLabel", {
        Parent = SettingsHeader,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = "Settings",
        TextColor3 = CONFIG.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local SettingsDesc = New("TextLabel", {
        Parent = SettingsHeader,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 26),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = "Customize your WALLXP interface",
        TextColor3 = CONFIG.SubText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local SettingsItems = {}

    local function CreateSettingToggle(name, description, default, callback)

        local Holder = New("Frame", {
            Parent = SettingsPage,
            BackgroundColor3 = CONFIG.Card,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 62)
        })

        Corner(Holder, 9)
        Stroke(Holder, CONFIG.Border)

        local Name = New("TextLabel", {
            Parent = Holder,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 11),
            Size = UDim2.new(1, -80, 0, 18),
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = CONFIG.Text,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local Desc = New("TextLabel", {
            Parent = Holder,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 31),
            Size = UDim2.new(1, -80, 0, 18),
            Font = Enum.Font.Gotham,
            Text = description,
            TextColor3 = CONFIG.SubText,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local Toggle = New("TextButton", {
            Parent = Holder,
            BackgroundColor3 = default and CONFIG.Accent or CONFIG.ToggleOff,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -54, 0.5, -11),
            Size = UDim2.fromOffset(40, 22),
            Text = "",
            AutoButtonColor = false
        })

        Corner(Toggle, 11)

        local Circle = New("Frame", {
            Parent = Toggle,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            Position = default
                and UDim2.new(1, -19, 0.5, -7)
                or UDim2.new(0, 5, 0.5, -7),
            Size = UDim2.fromOffset(14, 14)
        })

        Corner(Circle, 7)

        local Value = default

        local function Set(v)
            Value = v

            Tween(Toggle, {
                BackgroundColor3 = v
                    and CONFIG.Accent
                    or CONFIG.ToggleOff
            })

            Tween(Circle, {
                Position = v
                    and UDim2.new(1, -19, 0.5, -7)
                    or UDim2.new(0, 5, 0.5, -7)
            })

            if callback then
                callback(v)
            end
        end

        Toggle.MouseButton1Click:Connect(function()
            Set(not Value)
        end)

        return {
            Set = Set,
            Get = function()
                return Value
            end
        }
    end

    local ProfileSetting = CreateSettingToggle(
        "Show profile",
        "Show your profile at the bottom of the sidebar",
        true,
        function(value)
            ShowProfile = value
            Profile.Visible = value
        end
    )

    local ScreenSetting = CreateSettingToggle(
        "Keep window on screen",
        "Keep the interface inside the screen",
        true,
        function(value)
            KeepOnScreen = value
        end
    )

    local ResetHolder = New("Frame", {
        Parent = SettingsPage,
        BackgroundColor3 = CONFIG.Card,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 62)
    })

    Corner(ResetHolder, 9)
    Stroke(ResetHolder, CONFIG.Border)

    local ResetTitle = New("TextLabel", {
        Parent = ResetHolder,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 11),
        Size = UDim2.new(1, -150, 0, 18),
        Font = Enum.Font.GothamSemibold,
        Text = "Reset Window Position",
        TextColor3 = CONFIG.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ResetDesc = New("TextLabel", {
        Parent = ResetHolder,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 31),
        Size = UDim2.new(1, -150, 0, 18),
        Font = Enum.Font.Gotham,
        Text = "Move the window back to the center",
        TextColor3 = CONFIG.SubText,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ResetButton = New("TextButton", {
        Parent = ResetHolder,
        BackgroundColor3 = CONFIG.CardHover,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -115, 0.5, -15),
        Size = UDim2.fromOffset(100, 30),
        Font = Enum.Font.GothamSemibold,
        Text = "Reset",
        TextColor3 = CONFIG.Text,
        TextSize = 10,
        AutoButtonColor = false
    })

    Corner(ResetButton, 7)

    ResetButton.MouseButton1Click:Connect(function()
        NormalPosition = UDim2.new(
            0.5,
            -CONFIG.WindowSize.X / 2,
            0.5,
            -CONFIG.WindowSize.Y / 2
        )

        Tween(Window, {
            Position = NormalPosition
        })

        WALLXP:Notify({
            Title = "WALLXP",
            Content = "Window position reset.",
            Duration = 2
        })
    end)

    --==================================================
    -- TAB API
    --==================================================

    function WindowObject:CreateTab(name)

        local TabObject = {}

        local Page = CreatePage()

        local TabButton = New("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = CONFIG.Sidebar,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 37),
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = CONFIG.SubText,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        })

        Corner(TabButton, 7)

        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 12)
        TabPadding.Parent = TabButton

        local TabAccent = New("Frame", {
            Parent = TabButton,
            BackgroundColor3 = CONFIG.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, -9),
            Size = UDim2.fromOffset(3, 18),
            Visible = false
        })

        Corner(TabAccent, 2)

        local Items = {}

        local function UpdateTabState(active)
            if active then
                Tween(TabButton, {
                    BackgroundColor3 = CONFIG.Card
                })

                Tween(TabButton, {
                    TextColor3 = CONFIG.Text
                })

                TabAccent.Visible = true
            else
                Tween(TabButton, {
                    BackgroundColor3 = CONFIG.Sidebar
                })

                Tween(TabButton, {
                    TextColor3 = CONFIG.SubText
                })

                TabAccent.Visible = false
            end
        end

        function TabObject:Select()

            for _, tab in pairs(Tabs) do
                if tab ~= TabObject then
                    tab._SetActive(false)
                end
            end

            TabObject._SetActive(true)

            if CurrentTab and CurrentTab.Page then
                CurrentTab.Page.Visible = false
            end

            Page.Visible = true
            CurrentTab = TabObject

        end

        function TabObject._SetActive(active)
            UpdateTabState(active)
        end

        TabButton.MouseButton1Click:Connect(function()
            TabObject:Select()
        end)

        --==================================================
        -- SECTION
        --==================================================

        function TabObject:CreateSection(sectionName)

            local Section = New("TextLabel", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 27),
                Font = Enum.Font.GothamBold,
                Text = sectionName,
                TextColor3 = CONFIG.Text,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            return Section
        end

        --==================================================
        -- BUTTON
        --==================================================

        function TabObject:CreateButton(data)

            data = data or {}

            local Holder = New("TextButton", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Card,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 48),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Button",
                TextColor3 = CONFIG.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            })

            Corner(Holder, 8)
            Stroke(Holder, CONFIG.Border)

            Padding(Holder, 15, 15, 0, 0)

            Holder.MouseEnter:Connect(function()
                Tween(Holder, {
                    BackgroundColor3 = CONFIG.CardHover
                })
            end)

            Holder.MouseLeave:Connect(function()
                Tween(Holder, {
                    BackgroundColor3 = CONFIG.Card
                })
            end)

            Holder.MouseButton1Click:Connect(function()
                if data.Callback then
                    task.spawn(data.Callback)
                end
            end)

            table.insert(Items, {
                Object = Holder,
                Name = string.lower(data.Name or "button")
            })

            return {
                Instance = Holder
            }
        end

        --==================================================
        -- TOGGLE
        --==================================================

        function TabObject:CreateToggle(data)

            data = data or {}

            local Value = data.Default or false

            local Holder = New("Frame", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Card,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 58)
            })

            Corner(Holder, 8)
            Stroke(Holder, CONFIG.Border)

            local Name = New("TextLabel", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 9),
                Size = UDim2.new(1, -85, 0, 19),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Toggle",
                TextColor3 = CONFIG.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Toggle = New("TextButton", {
                Parent = Holder,
                BackgroundColor3 = Value
                    and CONFIG.Accent
                    or CONFIG.ToggleOff,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -55, 0.5, -11),
                Size = UDim2.fromOffset(40, 22),
                Text = "",
                AutoButtonColor = false
            })

            Corner(Toggle, 11)

            local Circle = New("Frame", {
                Parent = Toggle,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                Position = Value
                    and UDim2.new(1, -19, 0.5, -7)
                    or UDim2.new(0, 5, 0.5, -7),
                Size = UDim2.fromOffset(14, 14)
            })

            Corner(Circle, 7)

            local function Set(v)

                Value = v

                Tween(Toggle, {
                    BackgroundColor3 = v
                        and CONFIG.Accent
                        or CONFIG.ToggleOff
                })

                Tween(Circle, {
                    Position = v
                        and UDim2.new(1, -19, 0.5, -7)
                        or UDim2.new(0, 5, 0.5, -7)
                })

                if data.Callback then
                    task.spawn(data.Callback, v)
                end
            end

            Toggle.MouseButton1Click:Connect(function()
                Set(not Value)
            end)

            table.insert(Items, {
                Object = Holder,
                Name = string.lower(data.Name or "toggle")
            })

            return {
                Set = Set,
                Get = function()
                    return Value
                end,
                Instance = Holder
            }
        end

        --==================================================
        -- SLIDER
        --==================================================

        function TabObject:CreateSlider(data)

            data = data or {}

            local Range = data.Range or {0, 100}
            local Min = Range[1]
            local Max = Range[2]
            local Increment = data.Increment or 1
            local Value = data.CurrentValue or Min

            local Holder = New("Frame", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Card,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 70)
            })

            Corner(Holder, 8)
            Stroke(Holder, CONFIG.Border)

            local Name = New("TextLabel", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 9),
                Size = UDim2.new(0.65, 0, 0, 18),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Slider",
                TextColor3 = CONFIG.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ValueLabel = New("TextLabel", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.65, 0, 0, 9),
                Size = UDim2.new(0.3, 0, 0, 18),
                Font = Enum.Font.GothamSemibold,
                Text = tostring(Value),
                TextColor3 = CONFIG.Accent,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Bar = New("Frame", {
                Parent = Holder,
                BackgroundColor3 = CONFIG.ToggleOff,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 15, 0, 43),
                Size = UDim2.new(1, -30, 0, 6)
            })

            Corner(Bar, 3)

            local Fill = New("Frame", {
                Parent = Bar,
                BackgroundColor3 = CONFIG.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new(
                    math.clamp((Value - Min) / (Max - Min), 0, 1),
                    0,
                    1,
                    0
                )
            })

            Corner(Fill, 3)

            local Knob = New("Frame", {
                Parent = Bar,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(
                    math.clamp((Value - Min) / (Max - Min), 0, 1),
                    0,
                    0.5,
                    0
                ),
                Size = UDim2.fromOffset(12, 12)
            })

            Corner(Knob, 6)

            local Sliding = false

            local function RoundValue(v)
                local stepped = math.floor(
                    ((v - Min) / Increment) + 0.5
                ) * Increment + Min

                return math.clamp(stepped, Min, Max)
            end

            local function Set(v)

                Value = RoundValue(v)

                local Percent = math.clamp(
                    (Value - Min) / (Max - Min),
                    0,
                    1
                )

                Tween(Fill, {
                    Size = UDim2.new(Percent, 0, 1, 0)
                })

                Tween(Knob, {
                    Position = UDim2.new(
                        Percent,
                        0,
                        0.5,
                        0
                    )
                })

                ValueLabel.Text = tostring(Value)

                if data.Callback then
                    task.spawn(data.Callback, Value)
                end
            end

            local function UpdateFromInput(input)

                local x = input.Position.X
                local start = Bar.AbsolutePosition.X
                local width = Bar.AbsoluteSize.X

                local percent = math.clamp(
                    (x - start) / width,
                    0,
                    1
                )

                Set(Min + ((Max - Min) * percent))
            end

            Bar.InputBegan:Connect(function(input)

                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    Sliding = true
                    UpdateFromInput(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)

                if not Sliding then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then

                    UpdateFromInput(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)

                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    Sliding = false
                end
            end)

            table.insert(Items, {
                Object = Holder,
                Name = string.lower(data.Name or "slider")
            })

            return {
                Set = Set,
                Get = function()
                    return Value
                end,
                Instance = Holder
            }
        end

        --==================================================
        -- DROPDOWN
        --==================================================

        function TabObject:CreateDropdown(data)

            data = data or {}

            local Options = data.Options or {}
            local Current = data.CurrentOption or Options[1]
            local Opened = false

            local Holder = New("Frame", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Card,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 58),
                ClipsDescendants = true
            })

            Corner(Holder, 8)
            Stroke(Holder, CONFIG.Border)

            local Button = New("TextButton", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 58),
                Font = Enum.Font.GothamSemibold,
                Text = "",
                AutoButtonColor = false
            })

            local Name = New("TextLabel", {
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 8),
                Size = UDim2.new(0.45, 0, 0, 18),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Dropdown",
                TextColor3 = CONFIG.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Selected = New("TextLabel", {
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.45, 0, 0, 8),
                Size = UDim2.new(0.45, -15, 0, 18),
                Font = Enum.Font.Gotham,
                Text = tostring(Current or ""),
                TextColor3 = CONFIG.Accent,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Arrow = New("TextLabel", {
                Parent = Button,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -25, 0, 8),
                Size = UDim2.fromOffset(15, 18),
                Font = Enum.Font.GothamBold,
                Text = "⌄",
                TextColor3 = CONFIG.SubText,
                TextSize = 13
            })

            local OptionHolder = New("Frame", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 58),
                Size = UDim2.new(1, -20, 0, 0)
            })

            local OptionLayout = New("UIListLayout", {
                Parent = OptionHolder,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 4)
            })

            local function Set(v)

                Current = v
                Selected.Text = tostring(v)

                if data.Callback then
                    task.spawn(data.Callback, v)
                end
            end

            local function Open()

                Opened = true

                local count = #Options
                local height = count * 32 + math.max(0, count - 1) * 4

                Tween(Holder, {
                    Size = UDim2.new(
                        1,
                        0,
                        0,
                        58 + height + 10
                    )
                })

                Tween(Arrow, {
                    Rotation = 180
                })
            end

            local function Close()

                Opened = false

                Tween(Holder, {
                    Size = UDim2.new(1, 0, 0, 58)
                })

                Tween(Arrow, {
                    Rotation = 0
                })
            end

            for _, option in ipairs(Options) do

                local OptionButton = New("TextButton", {
                    Parent = OptionHolder,
                    BackgroundColor3 = CONFIG.CardHover,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 32),
                    Font = Enum.Font.Gotham,
                    Text = tostring(option),
                    TextColor3 = CONFIG.Text,
                    TextSize = 10,
                    AutoButtonColor = false
                })

                Corner(OptionButton, 6)

                OptionButton.MouseButton1Click:Connect(function()
                    Set(option)
                    Close()
                end)
            end

            Button.MouseButton1Click:Connect(function()
                if Opened then
                    Close()
                else
                    Open()
                end
            end)

            table.insert(Items, {
                Object = Holder,
                Name = string.lower(data.Name or "dropdown")
            })

            return {
                Set = Set,
                Get = function()
                    return Current
                end,
                Instance = Holder
            }
        end

        --==================================================
        -- INPUT
        --==================================================

        function TabObject:CreateInput(data)

            data = data or {}

            local Holder = New("Frame", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Card,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 58)
            })

            Corner(Holder, 8)
            Stroke(Holder, CONFIG.Border)

            local Name = New("TextLabel", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 8),
                Size = UDim2.new(0.35, 0, 0, 18),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Input",
                TextColor3 = CONFIG.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Box = New("TextBox", {
                Parent = Holder,
                BackgroundColor3 = CONFIG.Background,
                BorderSizePixel = 0,
                Position = UDim2.new(0.36, 0, 0.5, -16),
                Size = UDim2.new(0.59, 0, 0, 32),
                Font = Enum.Font.Gotham,
                Text = data.Default or "",
                PlaceholderText = data.PlaceholderText or "Enter text...",
                PlaceholderColor3 = CONFIG.SubText,
                TextColor3 = CONFIG.Text,
                TextSize = 10,
                ClearTextOnFocus = data.ClearTextOnFocus or false
            })

            Corner(Box, 7)
            Stroke(Box, CONFIG.Border)

            local function Set(value)
                Box.Text = tostring(value)
            end

            Box.FocusLost:Connect(function()
                if data.Callback then
                    task.spawn(data.Callback, Box.Text)
                end
            end)

            table.insert(Items, {
                Object = Holder,
                Name = string.lower(data.Name or "input")
            })

            return {
                Set = Set,
                Get = function()
                    return Box.Text
                end,
                Instance = Holder,
                TextBox = Box
            }
        end

        --==================================================
        -- KEYBIND
        --==================================================

        function TabObject:CreateKeybind(data)

            data = data or {}

            local CurrentKey = data.CurrentKeybind or Enum.KeyCode.RightShift
            local Listening = false

            local Holder = New("Frame", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Card,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 58)
            })

            Corner(Holder, 8)
            Stroke(Holder, CONFIG.Border)

            local Name = New("TextLabel", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = data.Name or "Keybind",
                TextColor3 = CONFIG.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local KeyButton = New("TextButton", {
                Parent = Holder,
                BackgroundColor3 = CONFIG.Background,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -105, 0.5, -15),
                Size = UDim2.fromOffset(90, 30),
                Font = Enum.Font.GothamSemibold,
                Text = CurrentKey.Name,
                TextColor3 = CONFIG.Text,
                TextSize = 10,
                AutoButtonColor = false
            })

            Corner(KeyButton, 7)
            Stroke(KeyButton, CONFIG.Border)

            local function Set(key)
                CurrentKey = key
                KeyButton.Text = key.Name
            end

            KeyButton.MouseButton1Click:Connect(function()

                if Listening then
                    return
                end

                Listening = true
                KeyButton.Text = "Press key..."

                local connection

                connection = UserInputService.InputBegan:Connect(function(input)

                    if input.UserInputType == Enum.UserInputType.Keyboard then

                        CurrentKey = input.KeyCode
                        KeyButton.Text = CurrentKey.Name

                        Listening = false

                        connection:Disconnect()

                        if data.Callback then
                            task.spawn(data.Callback, CurrentKey)
                        end
                    end
                end)
            end)

            table.insert(Items, {
                Object = Holder,
                Name = string.lower(data.Name or "keybind")
            })

            return {
                Set = Set,
                Get = function()
                    return CurrentKey
                end,
                Destroy = function()
                    if Holder then
                        Holder:Destroy()
                    end
                end,
                Instance = Holder
            }
        end

        --==================================================
        -- REGISTER
        --==================================================

        TabObject.Page = Page
        TabObject.Button = TabButton

        table.insert(Tabs, TabObject)

        return TabObject
    end

    --==================================================
    -- SETTINGS TAB BUTTON
    --==================================================

    local SettingsTabButton = New("TextButton", {
        Parent = TabHolder,
        BackgroundColor3 = CONFIG.Sidebar,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 37),
        Font = Enum.Font.GothamSemibold,
        Text = "Settings",
        TextColor3 = CONFIG.SubText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })

    Corner(SettingsTabButton, 7)
    Padding(SettingsTabButton, 12, 0, 0, 0)

    SettingsTabButton.MouseButton1Click:Connect(function()

        for _, tab in pairs(Tabs) do
            tab._SetActive(false)
            tab.Page.Visible = false
        end

        HomePage.Visible = false
        SettingsPage.Visible = true

        Tween(SettingsTabButton, {
            BackgroundColor3 = CONFIG.Card,
            TextColor3 = CONFIG.Text
        })
    end)

    --==================================================
    -- SEARCH FUNCTION
    --==================================================

    local SearchVisible = false

    SearchButton.MouseButton1Click:Connect(function()

        SearchVisible = not SearchVisible

        SearchContainer.Visible = SearchVisible

        if SearchVisible then
            SearchBox:CaptureFocus()
        else
            SearchBox.Text = ""

            if CurrentTab then
                for _, item in ipairs(CurrentTab._Items or {}) do
                    item.Object.Visible = true
                end
            end
        end
    end)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()

        local query = string.lower(SearchBox.Text)

        if CurrentTab and CurrentTab._Items then

            for _, item in ipairs(CurrentTab._Items) do

                if query == "" then
                    item.Object.Visible = true
                else
                    item.Object.Visible =
                        string.find(item.Name, query, 1, true) ~= nil
                end
            end
        end
    end)

    --==================================================
    -- SETTINGS BUTTON
    --==================================================

    SettingsButton.MouseButton1Click:Connect(function()

        for _, tab in pairs(Tabs) do
            tab._SetActive(false)
            tab.Page.Visible = false
        end

        HomePage.Visible = false
        SettingsPage.Visible = true

        SettingsTabButton.BackgroundColor3 = CONFIG.Card
        SettingsTabButton.TextColor3 = CONFIG.Text
    end)

    --==================================================
    -- MINIMIZE
    --==================================================

    local function Minimize()

        if IsMinimized then
            return
        end

        IsMinimized = true
        NormalPosition = Window.Position

        Tween(Window, {
            Size = UDim2.fromOffset(CONFIG.WindowSize.X, 62)
        })

        Body.Visible = false

        task.delay(0.1, function()
            if Window then
                Window.Visible = false
            end

            Floating.Visible = true
        end)
    end

    local function Restore()

        if not IsMinimized then
            return
        end

        IsMinimized = false

        Floating.Visible = false

        Window.Visible = true
        Body.Visible = true

        Window.Size = UDim2.fromOffset(
            CONFIG.WindowSize.X,
            62
        )

        Tween(Window, {
            Size = UDim2.fromOffset(
                CONFIG.WindowSize.X,
                CONFIG.WindowSize.Y
            )
        })
    end

    MinimizeButton.MouseButton1Click:Connect(Minimize)

    Floating.MouseButton1Click:Connect(Restore)

    MakeDraggable(Topbar, Window)
    MakeDraggable(Floating, Floating)

    --==================================================
    -- CLOSE
    --==================================================

    local CloseButton = New("TextButton", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -15, 0.5, -17),
        Size = UDim2.fromOffset(34, 34),
        Font = Enum.Font.Gotham,
        Text = "×",
        TextColor3 = CONFIG.SubText,
        TextSize = 22,
        AutoButtonColor = false
    })

    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {
            TextColor3 = Color3.fromRGB(255, 100, 100)
        })
    end)

    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {
            TextColor3 = CONFIG.SubText
        })
    end)

    CloseButton.MouseButton1Click:Connect(function()

        Tween(Window, {
            Size = UDim2.fromOffset(
                CONFIG.WindowSize.X,
                0
            )
        })

        task.wait(0.18)

        if ScreenGui then
            ScreenGui:Destroy()
        end
    end)

    --==================================================
    -- KEEP WINDOW ON SCREEN
    --==================================================

    local function ClampWindow()

        if not KeepOnScreen then
            return
        end

        local viewport = workspace.CurrentCamera.ViewportSize

        local size = Window.AbsoluteSize
        local pos = Window.AbsolutePosition

        local x = math.clamp(
            pos.X,
            0,
            viewport.X - size.X
        )

        local y = math.clamp(
            pos.Y,
            0,
            viewport.Y - size.Y
        )

        Window.Position = UDim2.fromOffset(x, y)
    end

    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            task.defer(ClampWindow)
        end
    end)

    --==================================================
    -- HOME
    --==================================================

    local HomeTabButton = New("TextButton", {
        Parent = TabHolder,
        BackgroundColor3 = CONFIG.Card,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 37),
        Font = Enum.Font.GothamSemibold,
        Text = "Home",
        TextColor3 = CONFIG.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })

    Corner(HomeTabButton, 7)
    Padding(HomeTabButton, 12, 0, 0, 0)

    local HomeAccent = New("Frame", {
        Parent = HomeTabButton,
        BackgroundColor3 = CONFIG.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, -9),
        Size = UDim2.fromOffset(3, 18)
    })

    Corner(HomeAccent, 2)

    HomeTabButton.MouseButton1Click:Connect(function()

        for _, tab in pairs(Tabs) do
            tab._SetActive(false)
            tab.Page.Visible = false
        end

        SettingsPage.Visible = false
        HomePage.Visible = true

        HomeTabButton.BackgroundColor3 = CONFIG.Card
        HomeTabButton.TextColor3 = CONFIG.Text

        SettingsTabButton.BackgroundColor3 = CONFIG.Sidebar
        SettingsTabButton.TextColor3 = CONFIG.SubText
    end)

    HomePage.Visible = true

    --==================================================
    -- WINDOW API
    --==================================================

    function WindowObject:Notify(data)
        WALLXP:Notify(data)
    end

    function WindowObject:Minimize()
        Minimize()
    end

    function WindowObject:Restore()
        Restore()
    end

    function WindowObject:Close()
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end

    function WindowObject:SetPosition(position)
        Window.Position = position
    end

    function WindowObject:GetPosition()
        return Window.Position
    end

    function WindowObject:GetInstance()
        return Window
    end

    function WindowObject:SetProfileVisible(value)
        ShowProfile = value
        Profile.Visible = value
        ProfileSetting.Set(value)
    end

    --==================================================
    -- FIX TAB SEARCH REFERENCES
    --==================================================

    for _, tab in ipairs(Tabs) do
        tab._Items = {}
    end

    --==================================================
    -- DEFAULT NOTIFICATION
    --==================================================

    task.defer(function()
        WALLXP:Notify({
            Title = "WALLXP",
            Content = "Interface loaded successfully.",
            Duration = 2.5
        })
    end)

    return WindowObject
end

return WALLXP
