--[[
    WALLXP v1.8.3
    Liquid Glass UI Library
    UI ONLY
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local WALLXP = {}

----------------------------------------------------------------
-- CONFIG
----------------------------------------------------------------

local CONFIG = {
    Name = "WALLXP",
    Subtitle = "Liquid Glass",

    Width = 630,
    Height = 350,

    MinWidth = 300,
    MinHeight = 240,

    SidebarWidth = 145,
    TopbarHeight = 72,

    Corner = 22,
    SmallCorner = 14,

    Animation = 0.22,

    Accent = Color3.fromRGB(80, 170, 255),

    Background = Color3.fromRGB(12, 14, 18),
    Card = Color3.fromRGB(20, 23, 29),

    Text = Color3.fromRGB(245, 247, 250),
    SubText = Color3.fromRGB(155, 162, 175),
}

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------

local function Tween(object, properties, duration)
    if not object or not object.Parent then
        return
    end

    local info = TweenInfo.new(
        duration or CONFIG.Animation,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )

    TweenService:Create(object, info, properties):Play()
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or CONFIG.SmallCorner)
    c.Parent = parent
    return c
end

local function Stroke(parent, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.new(1, 1, 1)
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
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

local function IsPointer(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

local function IsMoveInput(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
end

local function GetPointerPosition(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        return UserInputService:GetMouseLocation()
    end

    return input.Position
end

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WALLXP_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

----------------------------------------------------------------
-- SHADOW
----------------------------------------------------------------

local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundColor3 = Color3.new(0, 0, 0)
Shadow.BackgroundTransparency = 0.72
Shadow.BorderSizePixel = 0
Shadow.Size = UDim2.fromOffset(
    CONFIG.Width + 18,
    CONFIG.Height + 18
)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.ZIndex = 0
Shadow.Parent = ScreenGui

Corner(Shadow, CONFIG.Corner + 5)

----------------------------------------------------------------
-- WINDOW
----------------------------------------------------------------

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.BackgroundColor3 = CONFIG.Background
Window.BackgroundTransparency = 0.08
Window.BorderSizePixel = 0
Window.Size = UDim2.fromOffset(
    CONFIG.Width,
    CONFIG.Height
)
Window.Position = UDim2.new(0.5, 0, 0.5, 0)
Window.ClipsDescendants = true
Window.ZIndex = 1
Window.Parent = ScreenGui

Corner(Window, CONFIG.Corner)

----------------------------------------------------------------
-- GLASS GRADIENT
----------------------------------------------------------------

local GlassGradient = Instance.new("UIGradient")
GlassGradient.Rotation = 90
GlassGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(
        0,
        Color3.fromRGB(27, 30, 38)
    ),

    ColorSequenceKeypoint.new(
        0.45,
        Color3.fromRGB(13, 15, 20)
    ),

    ColorSequenceKeypoint.new(
        1,
        Color3.fromRGB(8, 10, 14)
    )
})

GlassGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.05),
    NumberSequenceKeypoint.new(0.5, 0.12),
    NumberSequenceKeypoint.new(1, 0.03)
})

GlassGradient.Parent = Window

----------------------------------------------------------------
-- OUTER BORDER
----------------------------------------------------------------

Stroke(
    Window,
    Color3.fromRGB(255, 255, 255),
    0.78,
    1
)

----------------------------------------------------------------
-- INNER BORDER
----------------------------------------------------------------

local InnerBorder = Instance.new("Frame")
InnerBorder.Name = "InnerBorder"
InnerBorder.BackgroundTransparency = 1
InnerBorder.Position = UDim2.fromOffset(2, 2)
InnerBorder.Size = UDim2.new(1, -4, 1, -4)
InnerBorder.ZIndex = 2
InnerBorder.Parent = Window

Corner(
    InnerBorder,
    CONFIG.Corner - 2
)

Stroke(
    InnerBorder,
    Color3.fromRGB(255, 255, 255),
    0.91,
    1
)

----------------------------------------------------------------
-- TOP REFLECTION
----------------------------------------------------------------

local Reflection = Instance.new("Frame")
Reflection.Name = "Reflection"
Reflection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Reflection.BackgroundTransparency = 0.94
Reflection.BorderSizePixel = 0
Reflection.Position = UDim2.fromOffset(1, 1)
Reflection.Size = UDim2.new(1, -2, 0, 80)
Reflection.ZIndex = 2
Reflection.Parent = Window

Corner(
    Reflection,
    CONFIG.Corner
)

local ReflectionGradient = Instance.new("UIGradient")
ReflectionGradient.Rotation = 90

ReflectionGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.1),
    NumberSequenceKeypoint.new(1, 1)
})

ReflectionGradient.Parent = Reflection

----------------------------------------------------------------
-- SIDEBAR
----------------------------------------------------------------

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.BackgroundColor3 = Color3.fromRGB(9, 11, 15)
Sidebar.BackgroundTransparency = 0.17
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(
    0,
    CONFIG.SidebarWidth,
    1,
    0
)
Sidebar.ZIndex = 3
Sidebar.Parent = Window

local SidebarGradient = Instance.new("UIGradient")
SidebarGradient.Rotation = 90

SidebarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(
        0,
        Color3.fromRGB(24, 27, 34)
    ),

    ColorSequenceKeypoint.new(
        1,
        Color3.fromRGB(8, 10, 13)
    )
})

SidebarGradient.Parent = Sidebar

----------------------------------------------------------------
-- SIDEBAR TITLE
----------------------------------------------------------------

local Logo = Instance.new("TextLabel")
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.fromOffset(18, 15)
Logo.Size = UDim2.new(1, -36, 0, 28)
Logo.Font = Enum.Font.GothamBold
Logo.Text = CONFIG.Name
Logo.TextColor3 = CONFIG.Text
Logo.TextSize = 20
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.ZIndex = 5
Logo.Parent = Sidebar

local LogoAccent = Instance.new("Frame")
LogoAccent.BackgroundColor3 = CONFIG.Accent
LogoAccent.BackgroundTransparency = 0.15
LogoAccent.BorderSizePixel = 0
LogoAccent.Position = UDim2.fromOffset(18, 46)
LogoAccent.Size = UDim2.fromOffset(28, 2)
LogoAccent.ZIndex = 5
LogoAccent.Parent = Sidebar

Corner(
    LogoAccent,
    2
)

----------------------------------------------------------------
-- TAB CONTAINER
----------------------------------------------------------------

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "Tabs"
TabContainer.BackgroundTransparency = 1
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.fromOffset(10, 65)
TabContainer.Size = UDim2.new(
    1,
    -20,
    1,
    -130
)
TabContainer.ScrollBarThickness = 0
TabContainer.CanvasSize = UDim2.new()
TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabContainer.ZIndex = 5
TabContainer.Parent = Sidebar

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 7)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabContainer

----------------------------------------------------------------
-- PROFILE
----------------------------------------------------------------

local ProfileCard = Instance.new("Frame")
ProfileCard.Name = "Profile"
ProfileCard.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProfileCard.BackgroundTransparency = 0.94
ProfileCard.BorderSizePixel = 0
ProfileCard.Position = UDim2.new(
    0,
    10,
    1,
    -57
)
ProfileCard.Size = UDim2.new(
    1,
    -20,
    0,
    47
)
ProfileCard.ZIndex = 5
ProfileCard.Parent = Sidebar

Corner(
    ProfileCard,
    12
)

Stroke(
    ProfileCard,
    Color3.fromRGB(255, 255, 255),
    0.93,
    1
)

local Avatar = Instance.new("ImageLabel")
Avatar.BackgroundTransparency = 1
Avatar.Position = UDim2.fromOffset(7, 7)
Avatar.Size = UDim2.fromOffset(33, 33)
Avatar.ZIndex = 6
Avatar.Parent = ProfileCard

Corner(
    Avatar,
    50
)

pcall(function()
    Avatar.Image = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size100x100
    )
end)

local ProfileName = Instance.new("TextLabel")
ProfileName.BackgroundTransparency = 1
ProfileName.Position = UDim2.fromOffset(47, 5)
ProfileName.Size = UDim2.new(
    1,
    -54,
    0,
    18
)
ProfileName.Font = Enum.Font.GothamSemibold
ProfileName.Text = LocalPlayer.DisplayName
ProfileName.TextColor3 = CONFIG.Text
ProfileName.TextSize = 12
ProfileName.TextXAlignment = Enum.TextXAlignment.Left
ProfileName.TextTruncate = Enum.TextTruncate.AtEnd
ProfileName.ZIndex = 6
ProfileName.Parent = ProfileCard

local ProfileUser = Instance.new("TextLabel")
ProfileUser.BackgroundTransparency = 1
ProfileUser.Position = UDim2.fromOffset(47, 22)
ProfileUser.Size = UDim2.new(
    1,
    -54,
    0,
    16
)
ProfileUser.Font = Enum.Font.Gotham
ProfileUser.Text = "@" .. LocalPlayer.Name
ProfileUser.TextColor3 = CONFIG.SubText
ProfileUser.TextSize = 10
ProfileUser.TextXAlignment = Enum.TextXAlignment.Left
ProfileUser.TextTruncate = Enum.TextTruncate.AtEnd
ProfileUser.ZIndex = 6
ProfileUser.Parent = ProfileCard

----------------------------------------------------------------
-- CONTENT
----------------------------------------------------------------

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.Position = UDim2.fromOffset(
    CONFIG.SidebarWidth,
    0
)
Content.Size = UDim2.new(
    1,
    -CONFIG.SidebarWidth,
    1,
    0
)
Content.ZIndex = 3
Content.Parent = Window

----------------------------------------------------------------
-- HEADER
----------------------------------------------------------------

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.BackgroundTransparency = 1
Header.BorderSizePixel = 0
Header.Position = UDim2.fromOffset(0, 0)
Header.Size = UDim2.new(
    1,
    0,
    0,
    CONFIG.TopbarHeight
)
Header.ZIndex = 10
Header.Parent = Content

----------------------------------------------------------------
-- HEADER TITLE
----------------------------------------------------------------

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(22, 13)
Title.Size = UDim2.new(
    1,
    -210,
    0,
    27
)
Title.Font = Enum.Font.GothamBold
Title.Text = CONFIG.Name
Title.TextColor3 = CONFIG.Text
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 11
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.fromOffset(23, 40)
Subtitle.Size = UDim2.new(
    1,
    -210,
    0,
    18
)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = CONFIG.Subtitle
Subtitle.TextColor3 = CONFIG.SubText
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 11
Subtitle.Parent = Header

----------------------------------------------------------------
-- HEADER BUTTON
----------------------------------------------------------------

local function CreateHeaderButton(text, position)

    local Button = Instance.new("TextButton")

    Button.AutoButtonColor = false
    Button.BackgroundColor3 = Color3.fromRGB(
        255,
        255,
        255
    )
    Button.BackgroundTransparency = 0.94
    Button.BorderSizePixel = 0
    Button.Position = position
    Button.Size = UDim2.fromOffset(38, 38)
    Button.Font = Enum.Font.GothamMedium
    Button.Text = text
    Button.TextColor3 = CONFIG.Text
    Button.TextSize = 18
    Button.ZIndex = 12
    Button.Parent = Header

    Corner(
        Button,
        12
    )

    Stroke(
        Button,
        Color3.fromRGB(255, 255, 255),
        0.91,
        1
    )

    Button.MouseEnter:Connect(function()
        Tween(Button, {
            BackgroundTransparency = 0.86
        })
    end)

    Button.MouseLeave:Connect(function()
        Tween(Button, {
            BackgroundTransparency = 0.94
        })
    end)

    return Button
end

----------------------------------------------------------------
-- HEADER BUTTONS
----------------------------------------------------------------

local SearchButton = CreateHeaderButton(
    "⌕",
    UDim2.new(1, -176, 0, 17)
)

local SettingsButton = CreateHeaderButton(
    "⚙",
    UDim2.new(1, -132, 0, 17)
)

local MinimizeButton = CreateHeaderButton(
    "−",
    UDim2.new(1, -88, 0, 17)
)

local CloseButton = CreateHeaderButton(
    "×",
    UDim2.new(1, -44, 0, 17)
)

----------------------------------------------------------------
-- PAGE HOLDER
----------------------------------------------------------------

local PageHolder = Instance.new("Frame")
PageHolder.Name = "Pages"
PageHolder.BackgroundTransparency = 1
PageHolder.BorderSizePixel = 0
PageHolder.Position = UDim2.fromOffset(
    15,
    CONFIG.TopbarHeight
)
PageHolder.Size = UDim2.new(
    1,
    -30,
    1,
    -CONFIG.TopbarHeight - 15
)
PageHolder.ZIndex = 4
PageHolder.Parent = Content

----------------------------------------------------------------
-- SEARCH
----------------------------------------------------------------

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "Search"
SearchBox.BackgroundColor3 = Color3.fromRGB(
    255,
    255,
    255
)
SearchBox.BackgroundTransparency = 1
SearchBox.BorderSizePixel = 0
SearchBox.Position = UDim2.fromOffset(
    CONFIG.SidebarWidth + 15,
    10
)
SearchBox.Size = UDim2.new(
    1,
    -CONFIG.SidebarWidth - 30,
    0,
    40
)
SearchBox.ClearTextOnFocus = false
SearchBox.Font = Enum.Font.Gotham
SearchBox.PlaceholderText = "Search all pages"
SearchBox.PlaceholderColor3 = CONFIG.SubText
SearchBox.Text = ""
SearchBox.TextColor3 = CONFIG.Text
SearchBox.TextSize = 12
SearchBox.Visible = false
SearchBox.ZIndex = 30
SearchBox.Parent = Content

Corner(
    SearchBox,
    13
)

Stroke(
    SearchBox,
    Color3.fromRGB(255, 255, 255),
    0.91,
    1
)

----------------------------------------------------------------
-- TAB SYSTEM
----------------------------------------------------------------

local Pages = {}
local Tabs = {}

local CurrentTab = nil
local CurrentPage = nil

local function SelectTab(name)

    for tabName, data in pairs(Tabs) do

        local selected = tabName == name

        Tween(data.Button, {
            BackgroundTransparency =
                selected and 0.84 or 1,

            TextColor3 =
                selected
                and CONFIG.Text
                or CONFIG.SubText
        })

        Tween(data.Indicator, {
            BackgroundTransparency =
                selected and 0 or 1
        })
    end

    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name
    end

    CurrentTab = name
    CurrentPage = Pages[name]
end

local function CreateTabInternal(name, icon)

    if Tabs[name] then
        return Tabs[name].Wrapper
    end

    ------------------------------------------------------------
    -- TAB BUTTON
    ------------------------------------------------------------

    local Button = Instance.new("TextButton")

    Button.Name = name
    Button.AutoButtonColor = false
    Button.BackgroundColor3 = Color3.fromRGB(
        255,
        255,
        255
    )
    Button.BackgroundTransparency = 1
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(
        1,
        0,
        0,
        39
    )
    Button.Font = Enum.Font.GothamMedium
    Button.Text = ""
    Button.ZIndex = 6
    Button.Parent = TabContainer

    Corner(
        Button,
        12
    )

    local Icon = Instance.new("TextLabel")
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.fromOffset(11, 0)
    Icon.Size = UDim2.fromOffset(25, 39)
    Icon.Font = Enum.Font.GothamMedium
    Icon.Text = icon or "●"
    Icon.TextColor3 = CONFIG.SubText
    Icon.TextSize = 13
    Icon.ZIndex = 7
    Icon.Parent = Button

    local Text = Instance.new("TextLabel")
    Text.BackgroundTransparency = 1
    Text.Position = UDim2.fromOffset(38, 0)
    Text.Size = UDim2.new(
        1,
        -45,
        1,
        0
    )
    Text.Font = Enum.Font.GothamMedium
    Text.Text = name
    Text.TextColor3 = CONFIG.SubText
    Text.TextSize = 12
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.ZIndex = 7
    Text.Parent = Button

    local Indicator = Instance.new("Frame")
    Indicator.BackgroundColor3 = CONFIG.Accent
    Indicator.BackgroundTransparency = 1
    Indicator.BorderSizePixel = 0
    Indicator.Position = UDim2.new(
        1,
        -3,
        0,
        8
    )
    Indicator.Size = UDim2.fromOffset(
        3,
        23
    )
    Indicator.ZIndex = 8
    Indicator.Parent = Button

    Corner(
        Indicator,
        3
    )

    ------------------------------------------------------------
    -- PAGE
    ------------------------------------------------------------

    local Page = Instance.new("ScrollingFrame")

    Page.Name = name
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Size = UDim2.fromScale(1, 1)
    Page.CanvasSize = UDim2.new()
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageTransparency = 0.6
    Page.Visible = false
    Page.ZIndex = 5
    Page.Parent = PageHolder

    Padding(
        Page,
        4,
        4,
        4,
        10
    )

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 9)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    local Wrapper = {}

    ------------------------------------------------------------
    -- SECTION
    ------------------------------------------------------------

    function Wrapper:CreateSection(text)

        local Section = Instance.new("TextLabel")

        Section.BackgroundTransparency = 1
        Section.Size = UDim2.new(
            1,
            0,
            0,
            25
        )
        Section.Font = Enum.Font.GothamBold
        Section.Text = text
        Section.TextColor3 = CONFIG.Text
        Section.TextSize = 13
        Section.TextXAlignment = Enum.TextXAlignment.Left
        Section.Parent = Page

        return Section
    end

    ------------------------------------------------------------
    -- BUTTON
    ------------------------------------------------------------

    function Wrapper:CreateButton(options)

        options = options or {}

        local Button = Instance.new("TextButton")

        Button.AutoButtonColor = false
        Button.BackgroundColor3 = CONFIG.Card
        Button.BackgroundTransparency = 0.12
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(
            1,
            0,
            0,
            48
        )
        Button.Font = Enum.Font.GothamMedium
        Button.Text = options.Name or "Button"
        Button.TextColor3 = CONFIG.Text
        Button.TextSize = 12
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Button.Parent = Page

        Padding(
            Button,
            16,
            16,
            0,
            0
        )

        Corner(
            Button,
            CONFIG.SmallCorner
        )

        Stroke(
            Button,
            Color3.fromRGB(255, 255, 255),
            0.92,
            1
        )

        Button.MouseEnter:Connect(function()
            Tween(Button, {
                BackgroundTransparency = 0.03
            })
        end)

        Button.MouseLeave:Connect(function()
            Tween(Button, {
                BackgroundTransparency = 0.12
            })
        end)

        Button.MouseButton1Click:Connect(function()

            if options.Callback then
                task.spawn(options.Callback)
            end

        end)

        return Button
    end

    ------------------------------------------------------------
    -- TOGGLE
    ------------------------------------------------------------

    function Wrapper:CreateToggle(options)

        options = options or {}

        local Value = options.Default == true

        local Holder = Instance.new("Frame")

        Holder.BackgroundColor3 = CONFIG.Card
        Holder.BackgroundTransparency = 0.12
        Holder.BorderSizePixel = 0
        Holder.Size = UDim2.new(
            1,
            0,
            0,
            52
        )
        Holder.Parent = Page

        Corner(
            Holder,
            CONFIG.SmallCorner
        )

        Stroke(
            Holder,
            Color3.fromRGB(255, 255, 255),
            0.92,
            1
        )

        local Label = Instance.new("TextLabel")

        Label.BackgroundTransparency = 1
        Label.Position = UDim2.fromOffset(15, 0)
        Label.Size = UDim2.new(
            1,
            -80,
            1,
            0
        )
        Label.Font = Enum.Font.GothamMedium
        Label.Text = options.Name or "Toggle"
        Label.TextColor3 = CONFIG.Text
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Holder

        local ToggleButton = Instance.new("TextButton")

        ToggleButton.AutoButtonColor = false
        ToggleButton.BackgroundColor3 = Color3.fromRGB(
            55,
            59,
            67
        )
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Position = UDim2.new(
            1,
            -57,
            0.5,
            -12
        )
        ToggleButton.Size = UDim2.fromOffset(
            42,
            24
        )
        ToggleButton.Text = ""
        ToggleButton.Parent = Holder

        Corner(
            ToggleButton,
            50
        )

        local Circle = Instance.new("Frame")

        Circle.BackgroundColor3 = Color3.fromRGB(
            235,
            238,
            245
        )
        Circle.BorderSizePixel = 0
        Circle.Position = UDim2.fromOffset(3, 3)
        Circle.Size = UDim2.fromOffset(
            18,
            18
        )
        Circle.Parent = ToggleButton

        Corner(
            Circle,
            50
        )

        local function UpdateToggle()

            Tween(
                ToggleButton,
                {
                    BackgroundColor3 =
                        Value
                        and CONFIG.Accent
                        or Color3.fromRGB(
                            55,
                            59,
                            67
                        )
                }
            )

            Tween(
                Circle,
                {
                    Position =
                        Value
                        and UDim2.fromOffset(
                            21,
                            3
                        )
                        or UDim2.fromOffset(
                            3,
                            3
                        )
                }
            )
        end

        ToggleButton.MouseButton1Click:Connect(function()

            Value = not Value

            UpdateToggle()

            if options.Callback then
                task.spawn(
                    options.Callback,
                    Value
                )
            end

        end)

        UpdateToggle()

        local Object = {}

        function Object:Set(value)

            Value = value == true

            UpdateToggle()

            if options.Callback then
                task.spawn(
                    options.Callback,
                    Value
                )
            end
        end

        function Object:Get()
            return Value
        end

        return Object
    end

    ------------------------------------------------------------
    -- SLIDER
    ------------------------------------------------------------

    function Wrapper:CreateSlider(options)

        options = options or {}

        local Min = options.Min or 0
        local Max = options.Max or 100
        local Value = options.Default or Min

        if Max < Min then
            Max, Min = Min, Max
        end

        local Holder = Instance.new("Frame")

        Holder.BackgroundColor3 = CONFIG.Card
        Holder.BackgroundTransparency = 0.12
        Holder.BorderSizePixel = 0
        Holder.Size = UDim2.new(
            1,
            0,
            0,
            68
        )
        Holder.Parent = Page

        Corner(
            Holder,
            CONFIG.SmallCorner
        )

        Stroke(
            Holder,
            Color3.fromRGB(255, 255, 255),
            0.92,
            1
        )

        local Label = Instance.new("TextLabel")

        Label.BackgroundTransparency = 1
        Label.Position = UDim2.fromOffset(15, 7)
        Label.Size = UDim2.new(
            1,
            -100,
            0,
            20
        )
        Label.Font = Enum.Font.GothamMedium
        Label.Text = options.Name or "Slider"
        Label.TextColor3 = CONFIG.Text
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Holder

        local ValueLabel = Instance.new("TextLabel")

        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Position = UDim2.new(
            1,
            -70,
            0,
            7
        )
        ValueLabel.Size = UDim2.fromOffset(
            55,
            20
        )
        ValueLabel.Font = Enum.Font.GothamMedium
        ValueLabel.TextColor3 = CONFIG.Accent
        ValueLabel.TextSize = 11
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Holder

        local Bar = Instance.new("Frame")

        Bar.BackgroundColor3 = Color3.fromRGB(
            48,
            52,
            60
        )
        Bar.BorderSizePixel = 0
        Bar.Position = UDim2.new(
            0,
            15,
            1,
            -23
        )
        Bar.Size = UDim2.new(
            1,
            -30,
            0,
            6
        )
        Bar.Parent = Holder

        Corner(
            Bar,
            50
        )

        local Fill = Instance.new("Frame")

        Fill.BackgroundColor3 = CONFIG.Accent
        Fill.BorderSizePixel = 0
        Fill.Size = UDim2.fromScale(0, 1)
        Fill.Parent = Bar

        Corner(
            Fill,
            50
        )

        local dragging = false

        local function SetValueFromX(x)

            if Bar.AbsoluteSize.X <= 0 then
                return
            end

            local percent = math.clamp(
                (x - Bar.AbsolutePosition.X)
                    / Bar.AbsoluteSize.X,
                0,
                1
            )

            Value = Min + (Max - Min) * percent

            Value = math.floor(
                Value + 0.5
            )

            Fill.Size = UDim2.fromScale(
                percent,
                1
            )

            ValueLabel.Text = tostring(Value)

            if options.Callback then
                task.spawn(
                    options.Callback,
                    Value
                )
            end
        end

        Bar.InputBegan:Connect(function(input)

            if IsPointer(input) then

                dragging = true

                SetValueFromX(
                    GetPointerPosition(input).X
                )

            end

        end)

        UserInputService.InputChanged:Connect(function(input)

            if dragging and IsMoveInput(input) then

                SetValueFromX(
                    GetPointerPosition(input).X
                )

            end

        end)

        UserInputService.InputEnded:Connect(function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                Enum.UserInputType.Touch then

                dragging = false

            end

        end)

        local percent

        if Max == Min then
            percent = 0
        else
            percent = math.clamp(
                (Value - Min)
                    / (Max - Min),
                0,
                1
            )
        end

        Fill.Size = UDim2.fromScale(
            percent,
            1
        )

        ValueLabel.Text = tostring(Value)

        local Object = {}

        function Object:Set(NewValue)

            NewValue = tonumber(NewValue) or Min

            Value = math.clamp(
                NewValue,
                Min,
                Max
            )

            local p = 0

            if Max ~= Min then
                p = math.clamp(
                    (Value - Min)
                        / (Max - Min),
                    0,
                    1
                )
            end

            Fill.Size = UDim2.fromScale(
                p,
                1
            )

            ValueLabel.Text = tostring(Value)
        end

        function Object:Get()
            return Value
        end

        return Object
    end

    ------------------------------------------------------------
    -- DROPDOWN
    ------------------------------------------------------------

    function Wrapper:CreateDropdown(options)

        options = options or {}

        local Items = options.Items or {}
        local Selected =
            options.Default
            or Items[1]

        local Open = false

        local Holder = Instance.new("Frame")

        Holder.BackgroundColor3 = CONFIG.Card
        Holder.BackgroundTransparency = 0.12
        Holder.BorderSizePixel = 0
        Holder.Size = UDim2.new(
            1,
            0,
            0,
            48
        )
        Holder.ClipsDescendants = true
        Holder.Parent = Page

        Corner(
            Holder,
            CONFIG.SmallCorner
        )

        Stroke(
            Holder,
            Color3.fromRGB(255, 255, 255),
            0.92,
            1
        )

        local Button = Instance.new("TextButton")

        Button.AutoButtonColor = false
        Button.BackgroundTransparency = 1
        Button.Size = UDim2.new(
            1,
            0,
            0,
            48
        )
        Button.Text = ""
        Button.Parent = Holder

        local Label = Instance.new("TextLabel")

        Label.BackgroundTransparency = 1
        Label.Position = UDim2.fromOffset(15, 0)
        Label.Size = UDim2.new(
            0.55,
            0,
            0,
            48
        )
        Label.Font = Enum.Font.GothamMedium
        Label.Text = options.Name or "Dropdown"
        Label.TextColor3 = CONFIG.Text
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Button

        local SelectedLabel = Instance.new("TextLabel")

        SelectedLabel.BackgroundTransparency = 1
        SelectedLabel.Position = UDim2.new(
            0.55,
            0,
            0,
            0
        )
        SelectedLabel.Size = UDim2.new(
            0.45,
            -30,
            0,
            48
        )
        SelectedLabel.Font = Enum.Font.Gotham
        SelectedLabel.Text = tostring(
            Selected or ""
        )
        SelectedLabel.TextColor3 = CONFIG.Accent
        SelectedLabel.TextSize = 11
        SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
        SelectedLabel.Parent = Button

        local Arrow = Instance.new("TextLabel")

        Arrow.BackgroundTransparency = 1
        Arrow.Position = UDim2.new(
            1,
            -25,
            0,
            0
        )
        Arrow.Size = UDim2.fromOffset(
            20,
            48
        )
        Arrow.Font = Enum.Font.GothamBold
        Arrow.Text = "⌄"
        Arrow.TextColor3 = CONFIG.SubText
        Arrow.TextSize = 13
        Arrow.Parent = Button

        local OptionsFrame = Instance.new("Frame")

        OptionsFrame.BackgroundTransparency = 1
        OptionsFrame.Position = UDim2.fromOffset(
            8,
            53
        )
        OptionsFrame.Size = UDim2.new(
            1,
            -16,
            0,
            math.max(
                0,
                #Items * 31
            )
        )
        OptionsFrame.Parent = Holder

        local OptionLayout = Instance.new("UIListLayout")

        OptionLayout.Padding = UDim.new(0, 4)
        OptionLayout.Parent = OptionsFrame

        local function Close()

            Open = false

            Tween(
                Holder,
                {
                    Size = UDim2.new(
                        1,
                        0,
                        0,
                        48
                    )
                }
            )

            Tween(
                Arrow,
                {
                    Rotation = 0
                }
            )
        end

        local function Select(item)

            Selected = item

            SelectedLabel.Text =
                tostring(item)

            if options.Callback then
                task.spawn(
                    options.Callback,
                    item
                )
            end

            Close()
        end

        for _, item in ipairs(Items) do

            local Option = Instance.new("TextButton")

            Option.AutoButtonColor = false
            Option.BackgroundColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                )
            Option.BackgroundTransparency = 0.94
            Option.BorderSizePixel = 0
            Option.Size = UDim2.new(
                1,
                0,
                0,
                27
            )
            Option.Font = Enum.Font.Gotham
            Option.Text = tostring(item)
            Option.TextColor3 = CONFIG.Text
            Option.TextSize = 11
            Option.Parent = OptionsFrame

            Corner(
                Option,
                8
            )

            Option.MouseButton1Click:Connect(
                function()
                    Select(item)
                end
            )

            Option.MouseEnter:Connect(
                function()
                    Tween(Option, {
                        BackgroundTransparency = 0.87
                    })
                end
            )

            Option.MouseLeave:Connect(
                function()
                    Tween(Option, {
                        BackgroundTransparency = 0.94
                    })
                end
            )
        end

        Button.MouseButton1Click:Connect(function()

            Open = not Open

            if Open then

                local height =
                    61 + (#Items * 31)

                Tween(
                    Holder,
                    {
                        Size = UDim2.new(
                            1,
                            0,
                            0,
                            height
                        )
                    }
                )

                Tween(
                    Arrow,
                    {
                        Rotation = 180
                    }
                )

            else

                Close()

            end

        end)

        return {

            Set = function(_, item)
                Select(item)
            end,

            Get = function()
                return Selected
            end
        }
    end

    ------------------------------------------------------------
    -- INPUT
    ------------------------------------------------------------

    function Wrapper:CreateInput(options)

        options = options or {}

        local Holder = Instance.new("Frame")

        Holder.BackgroundColor3 = CONFIG.Card
        Holder.BackgroundTransparency = 0.12
        Holder.BorderSizePixel = 0
        Holder.Size = UDim2.new(
            1,
            0,
            0,
            62
        )
        Holder.Parent = Page

        Corner(
            Holder,
            CONFIG.SmallCorner
        )

        Stroke(
            Holder,
            Color3.fromRGB(255, 255, 255),
            0.92,
            1
        )

        local Label = Instance.new("TextLabel")

        Label.BackgroundTransparency = 1
        Label.Position = UDim2.fromOffset(15, 5)
        Label.Size = UDim2.new(
            1,
            -30,
            0,
            20
        )
        Label.Font = Enum.Font.GothamMedium
        Label.Text = options.Name or "Input"
        Label.TextColor3 = CONFIG.Text
        Label.TextSize = 11
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Holder

        local Input = Instance.new("TextBox")

        Input.BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            )
        Input.BackgroundTransparency = 0.94
        Input.BorderSizePixel = 0
        Input.Position = UDim2.fromOffset(
            12,
            28
        )
        Input.Size = UDim2.new(
            1,
            -24,
            0,
            27
        )
        Input.ClearTextOnFocus = false
        Input.Font = Enum.Font.Gotham
        Input.PlaceholderText =
            options.Placeholder
            or "Enter text..."
        Input.PlaceholderColor3 =
            CONFIG.SubText
        Input.Text =
            options.Default
            or ""
        Input.TextColor3 =
            CONFIG.Text
        Input.TextSize = 11
        Input.TextXAlignment =
            Enum.TextXAlignment.Left
        Input.Parent = Holder

        Padding(
            Input,
            9,
            9,
            0,
            0
        )

        Corner(
            Input,
            8
        )

        Input.FocusLost:Connect(
            function()
                if options.Callback then
                    task.spawn(
                        options.Callback,
                        Input.Text
                    )
                end
            end
        )

        return {

            Set = function(_, value)
                Input.Text = tostring(value)
            end,

            Get = function()
                return Input.Text
            end
        }
    end

    ------------------------------------------------------------
    -- KEYBIND
    ------------------------------------------------------------

    function Wrapper:CreateKeybind(options)

        options = options or {}

        local CurrentKey =
            options.Default
            or Enum.KeyCode.RightShift

        local Waiting = false

        local Holder = Instance.new("Frame")

        Holder.BackgroundColor3 = CONFIG.Card
        Holder.BackgroundTransparency = 0.12
        Holder.BorderSizePixel = 0
        Holder.Size = UDim2.new(
            1,
            0,
            0,
            48
        )
        Holder.Parent = Page

        Corner(
            Holder,
            CONFIG.SmallCorner
        )

        Stroke(
            Holder,
            Color3.fromRGB(255, 255, 255),
            0.92,
            1
        )

        local Label = Instance.new("TextLabel")

        Label.BackgroundTransparency = 1
        Label.Position = UDim2.fromOffset(
            15,
            0
        )
        Label.Size = UDim2.new(
            1,
            -115,
            1,
            0
        )
        Label.Font = Enum.Font.GothamMedium
        Label.Text = options.Name or "Keybind"
        Label.TextColor3 = CONFIG.Text
        Label.TextSize = 12
        Label.TextXAlignment =
            Enum.TextXAlignment.Left
        Label.Parent = Holder

        local KeyButton = Instance.new("TextButton")

        KeyButton.AutoButtonColor = false
        KeyButton.BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            )
        KeyButton.BackgroundTransparency = 0.91
        KeyButton.BorderSizePixel = 0
        KeyButton.Position = UDim2.new(
            1,
            -100,
            0.5,
            -14
        )
        KeyButton.Size = UDim2.fromOffset(
            85,
            28
        )
        KeyButton.Font = Enum.Font.GothamMedium
        KeyButton.Text = CurrentKey.Name
        KeyButton.TextColor3 = CONFIG.Text
        KeyButton.TextSize = 10
        KeyButton.Parent = Holder

        Corner(
            KeyButton,
            8
        )

        KeyButton.MouseButton1Click:Connect(
            function()

                Waiting = true

                KeyButton.Text =
                    "Press key..."

            end
        )

        UserInputService.InputBegan:Connect(
            function(input, processed)

                if Waiting then

                    if input.UserInputType ==
                        Enum.UserInputType.Keyboard then

                        CurrentKey =
                            input.KeyCode

                        KeyButton.Text =
                            CurrentKey.Name

                        Waiting = false
                    end

                    return
                end

                if processed then
                    return
                end

                if input.UserInputType ==
                    Enum.UserInputType.Keyboard
                    and input.KeyCode ==
                        CurrentKey then

                    if options.Callback then
                        task.spawn(
                            options.Callback,
                            CurrentKey
                        )
                    end
                end
            end
        )

        return {

            Set = function(_, key)

                if typeof(key) == "EnumItem" then

                    CurrentKey = key

                    KeyButton.Text =
                        key.Name

                end

            end,

            Get = function()
                return CurrentKey
            end
        }
    end

    ------------------------------------------------------------
    -- TAB CLICK
    ------------------------------------------------------------

    Button.MouseButton1Click:Connect(
        function()
            SelectTab(name)
        end
    )

    Button.MouseEnter:Connect(
        function()

            if CurrentTab ~= name then

                Tween(Button, {
                    BackgroundTransparency = 0.95
                })

            end

        end
    )

    Button.MouseLeave:Connect(
        function()

            if CurrentTab ~= name then

                Tween(Button, {
                    BackgroundTransparency = 1
                })

            end

        end
    )

    Pages[name] = Page

    Tabs[name] = {
        Button = Button,
        Indicator = Indicator,
        Page = Page,
        Wrapper = Wrapper
    }

    return Wrapper
end

----------------------------------------------------------------
-- DEFAULT PAGES
----------------------------------------------------------------

local Home = CreateTabInternal(
    "Home",
    "⌂"
)

local Settings = CreateTabInternal(
    "Settings",
    "⚙"
)

local Profile = CreateTabInternal(
    "Profile",
    "●"
)

----------------------------------------------------------------
-- HOME
----------------------------------------------------------------

Home:CreateSection(
    "Welcome"
)

Home:CreateButton({
    Name = "WALLXP is ready",

    Callback = function()
        print("WALLXP is ready")
    end
})

Home:CreateToggle({
    Name = "Example Toggle",
    Default = false,

    Callback = function(value)
        print(
            "Example Toggle:",
            value
        )
    end
})

Home:CreateSlider({
    Name = "Example Slider",

    Min = 0,
    Max = 100,
    Default = 50,

    Callback = function(value)
        print(
            "Slider:",
            value
        )
    end
})

Home:CreateDropdown({
    Name = "Example Dropdown",

    Items = {
        "Option 1",
        "Option 2",
        "Option 3"
    },

    Default = "Option 1",

    Callback = function(value)
        print(
            "Dropdown:",
            value
        )
    end
})

Home:CreateInput({
    Name = "Example Input",

    Placeholder = "Type something...",

    Callback = function(value)
        print(
            "Input:",
            value
        )
    end
})

----------------------------------------------------------------
-- SETTINGS
----------------------------------------------------------------

local KeepOnScreen = true

Settings:CreateSection(
    "Window"
)

Settings:CreateToggle({
    Name = "Keep window on screen",

    Default = true,

    Callback = function(value)
        KeepOnScreen = value
    end
})

----------------------------------------------------------------
-- PROFILE
----------------------------------------------------------------

Profile:CreateSection(
    "Profile"
)

Profile:CreateButton({
    Name =
        "Display Name: "
        .. LocalPlayer.DisplayName
})

Profile:CreateButton({
    Name =
        "Username: @"
        .. LocalPlayer.Name
})

----------------------------------------------------------------
-- SELECT HOME
----------------------------------------------------------------

SelectTab(
    "Home"
)

----------------------------------------------------------------
-- WINDOW POSITION
----------------------------------------------------------------

local function GetViewport()

    local camera =
        workspace.CurrentCamera

    if camera then
        return camera.ViewportSize
    end

    return Vector2.new(
        800,
        600
    )
end

local function GetWindowCenter()

    local viewport =
        GetViewport()

    return Vector2.new(

        viewport.X / 2
            + Window.Position.X.Offset,

        viewport.Y / 2
            + Window.Position.Y.Offset
    )
end

local function ApplyWindowCenter(center)

    local viewport =
        GetViewport()

    Window.Position =
        UDim2.new(
            0.5,
            center.X - viewport.X / 2,
            0.5,
            center.Y - viewport.Y / 2
        )

    Shadow.Position =
        Window.Position
end

local function ClampWindowCenter(center)

    if not KeepOnScreen then
        return center
    end

    local viewport =
        GetViewport()

    local width =
        Window.AbsoluteSize.X

    local height =
        Window.AbsoluteSize.Y

    if width <= 0
        or height <= 0 then

        return center
    end

    local margin = 8

    local halfWidth =
        width / 2

    local halfHeight =
        height / 2

    local minX =
        halfWidth + margin

    local maxX =
        viewport.X
        - halfWidth
        - margin

    local minY =
        halfHeight + margin

    local maxY =
        viewport.Y
        - halfHeight
        - margin

    local x = center.X
    local y = center.Y

    if minX <= maxX then

        x = math.clamp(
            x,
            minX,
            maxX
        )

    else

        x = viewport.X / 2

    end

    if minY <= maxY then

        y = math.clamp(
            y,
            minY,
            maxY
        )

    else

        y = viewport.Y / 2

    end

    return Vector2.new(
        x,
        y
    )
end

----------------------------------------------------------------
-- DRAG AREA
----------------------------------------------------------------

local DragArea = Instance.new("Frame")

DragArea.Name = "DragArea"
DragArea.BackgroundTransparency = 1
DragArea.BorderSizePixel = 0

-- ไม่กินพื้นที่ปุ่ม Search / Settings /
-- Minimize / Close
DragArea.Position =
    UDim2.fromOffset(
        0,
        0
    )

DragArea.Size =
    UDim2.new(
        1,
        -185,
        0,
        CONFIG.TopbarHeight
    )

DragArea.ZIndex = 9
DragArea.Active = true
DragArea.Parent = Header

----------------------------------------------------------------
-- WINDOW DRAG
----------------------------------------------------------------

local WindowDragging = false

local DragStart = nil
local StartPosition = nil

DragArea.InputBegan:Connect(
    function(input)

        if not IsPointer(input) then
            return
        end

        WindowDragging = true

        DragStart =
            GetPointerPosition(input)

        StartPosition =
            GetWindowCenter()
    end
)

UserInputService.InputChanged:Connect(
    function(input)

        if not WindowDragging then
            return
        end

        if not IsMoveInput(input) then
            return
        end

        if not DragStart
            or not StartPosition then
            return
        end

        local current =
            GetPointerPosition(input)

        local delta =
            current - DragStart

        local newCenter =
            StartPosition + delta

        newCenter =
            ClampWindowCenter(
                newCenter
            )

        ApplyWindowCenter(
            newCenter
        )
    end
)

UserInputService.InputEnded:Connect(
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
                Enum.UserInputType.Touch then

            WindowDragging = false

            DragStart = nil
            StartPosition = nil

        end
    end
)

----------------------------------------------------------------
-- SEARCH
----------------------------------------------------------------

local SearchOpen = false

SearchButton.MouseButton1Click:Connect(
    function()

        SearchOpen = not SearchOpen

        if SearchOpen then

            SearchBox.Visible = true

            SearchBox.BackgroundTransparency =
                1

            Tween(
                SearchBox,
                {
                    BackgroundTransparency = 0.89
                }
            )

            task.defer(
                function()

                    if SearchBox.Parent
                        and SearchOpen then

                        SearchBox:CaptureFocus()

                    end

                end
            )

        else

            Tween(
                SearchBox,
                {
                    BackgroundTransparency = 1
                }
            )

            task.delay(
                CONFIG.Animation,
                function()

                    if not SearchOpen
                        and SearchBox.Parent then

                        SearchBox.Visible = false

                    end

                end
            )

        end

    end
)

----------------------------------------------------------------
-- SETTINGS BUTTON
----------------------------------------------------------------

SettingsButton.MouseButton1Click:Connect(
    function()

        SearchOpen = false
        SearchBox.Visible = false

        SelectTab(
            "Settings"
        )

    end
)

----------------------------------------------------------------
-- RESET POSITION
----------------------------------------------------------------

local function ResetWindowPosition()

    local viewport =
        GetViewport()

    local center =
        Vector2.new(
            viewport.X / 2,
            viewport.Y / 2
        )

    ApplyWindowCenter(
        center
    )
end

Settings:CreateButton({
    Name = "Reset Window Position",

    Callback = function()
        ResetWindowPosition()
    end
})

----------------------------------------------------------------
-- FLOATING BUTTON
----------------------------------------------------------------

local WindowVisible = true

local Floating = Instance.new("TextButton")

Floating.Name = "Floating"
Floating.AutoButtonColor = false
Floating.AnchorPoint =
    Vector2.new(
        0.5,
        0
    )
Floating.BackgroundColor3 =
    Color3.fromRGB(
        18,
        21,
        27
    )
Floating.BackgroundTransparency = 0.06
Floating.BorderSizePixel = 0
Floating.Position =
    UDim2.new(
        0.5,
        0,
        0,
        25
    )
Floating.Size =
    UDim2.fromOffset(
        170,
        44
    )
Floating.Font = Enum.Font.GothamBold
Floating.Text = ""
Floating.Visible = false
Floating.ZIndex = 100
Floating.Parent = ScreenGui

Corner(
    Floating,
    50
)

Stroke(
    Floating,
    CONFIG.Accent,
    0.55,
    1.2
)

local FloatingGradient =
    Instance.new("UIGradient")

FloatingGradient.Rotation = 90

FloatingGradient.Color =
    ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(
                32,
                36,
                45
            )
        ),

        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(
                11,
                13,
                18
            )
        )
    })

FloatingGradient.Parent =
    Floating

local FloatingText =
    Instance.new("TextLabel")

FloatingText.BackgroundTransparency = 1
FloatingText.Size =
    UDim2.fromScale(
        1,
        1
    )
FloatingText.Font =
    Enum.Font.GothamBold
FloatingText.Text =
    CONFIG.Name
FloatingText.TextColor3 =
    CONFIG.Text
FloatingText.TextSize = 12
FloatingText.ZIndex = 102
FloatingText.Parent =
    Floating

local FloatingSub =
    Instance.new("TextLabel")

FloatingSub.BackgroundTransparency = 1
FloatingSub.Position =
    UDim2.new(
        0,
        0,
        0,
        20
    )
FloatingSub.Size =
    UDim2.new(
        1,
        0,
        0,
        16
    )
FloatingSub.Font =
    Enum.Font.Gotham
FloatingSub.Text =
    "Tap to show"
FloatingSub.TextColor3 =
    CONFIG.SubText
FloatingSub.TextSize = 9
FloatingSub.ZIndex = 102
FloatingSub.Parent =
    Floating

----------------------------------------------------------------
-- FLOATING DRAG
----------------------------------------------------------------

local FloatingDragging = false
local FloatingMoved = false

local FloatingDragStart = nil
local FloatingStartPosition = nil

local function ClampFloating(
    x,
    y
)

    local viewport =
        GetViewport()

    local width =
        Floating.AbsoluteSize.X

    local height =
        Floating.AbsoluteSize.Y

    if width <= 0
        or height <= 0 then

        return x, y
    end

    local margin = 8

    local minX =
        width / 2
        + margin

    local maxX =
        viewport.X
        - width / 2
        - margin

    local minY =
        margin

    local maxY =
        viewport.Y
        - height
        - margin

    local centerX =
        viewport.X / 2 + x

    if minX <= maxX then

        centerX =
            math.clamp(
                centerX,
                minX,
                maxX
            )

    else

        centerX =
            viewport.X / 2

    end

    if minY <= maxY then

        y =
            math.clamp(
                y,
                minY,
                maxY
            )

    else

        y =
            viewport.Y / 2
            - height / 2

    end

    return (
        centerX
        - viewport.X / 2
    ), y
end

Floating.InputBegan:Connect(
    function(input)

        if not IsPointer(input) then
            return
        end

        FloatingDragging = true
        FloatingMoved = false

        FloatingDragStart =
            GetPointerPosition(input)

        FloatingStartPosition =
            Floating.Position

        Tween(
            Floating,
            {
                Size =
                    UDim2.fromOffset(
                        164,
                        41
                    )
            }
        )
    end
)

UserInputService.InputChanged:Connect(
    function(input)

        if not FloatingDragging then
            return
        end

        if not IsMoveInput(input) then
            return
        end

        if not FloatingDragStart
            or not FloatingStartPosition then
            return
        end

        local current =
            GetPointerPosition(input)

        local delta =
            current
            - FloatingDragStart

        if math.abs(delta.X) > 5
            or math.abs(delta.Y) > 5 then

            FloatingMoved = true
        end

        local x =
            FloatingStartPosition.X.Offset
            + delta.X

        local y =
            FloatingStartPosition.Y.Offset
            + delta.Y

        x, y =
            ClampFloating(
                x,
                y
            )

        Floating.Position =
            UDim2.new(
                0.5,
                x,
                0,
                y
            )
    end
)

UserInputService.InputEnded:Connect(
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
                Enum.UserInputType.Touch then

            FloatingDragging = false

            Tween(
                Floating,
                {
                    Size =
                        UDim2.fromOffset(
                            170,
                            44
                        )
                }
            )

            if not FloatingMoved then

                WindowVisible = true

                Floating.Visible = false

                Window.Visible = true
                Shadow.Visible = true

                Window.BackgroundTransparency =
                    1

                Shadow.BackgroundTransparency =
                    1

                Tween(
                    Window,
                    {
                        BackgroundTransparency =
                            0.08
                    }
                )

                Tween(
                    Shadow,
                    {
                        BackgroundTransparency =
                            0.72
                    }
                )

            end

            FloatingDragStart = nil
            FloatingStartPosition = nil
        end
    end
)

----------------------------------------------------------------
-- MINIMIZE
----------------------------------------------------------------

local function Minimize()

    if not WindowVisible then
        return
    end

    WindowVisible = false

    Tween(
        Window,
        {
            Size =
                UDim2.fromOffset(
                    math.floor(
                        Window.AbsoluteSize.X
                        * 0.92
                    ),
                    math.floor(
                        Window.AbsoluteSize.Y
                        * 0.92
                    )
                ),

            BackgroundTransparency = 1
        }
    )

    Tween(
        Shadow,
        {
            Size =
                UDim2.fromOffset(
                    math.floor(
                        Shadow.AbsoluteSize.X
                        * 0.92
                    ),
                    math.floor(
                        Shadow.AbsoluteSize.Y
                        * 0.92
                    )
                ),

            BackgroundTransparency = 1
        }
    )

    task.delay(
        CONFIG.Animation,
        function()

            if not WindowVisible then

                Window.Visible = false
                Shadow.Visible = false

                Floating.Visible = true

                Floating.BackgroundTransparency =
                    1

                Tween(
                    Floating,
                    {
                        BackgroundTransparency =
                            0.06
                    }
                )

            end

        end
    )
end

----------------------------------------------------------------
-- RESTORE
----------------------------------------------------------------

local function Restore()

    WindowVisible = true

    Floating.Visible = false

    Window.Visible = true
    Shadow.Visible = true

    local currentWidth =
        math.max(
            CONFIG.MinWidth,
            Window.AbsoluteSize.X
        )

    local currentHeight =
        math.max(
            CONFIG.MinHeight,
            Window.AbsoluteSize.Y
        )

    Window.Size =
        UDim2.fromOffset(
            currentWidth * 0.92,
            currentHeight * 0.92
        )

    Shadow.Size =
        UDim2.fromOffset(
            currentWidth * 0.92 + 18,
            currentHeight * 0.92 + 18
        )

    Tween(
        Window,
        {
            Size =
                UDim2.fromOffset(
                    currentWidth,
                    currentHeight
                ),

            BackgroundTransparency =
                0.08
        }
    )

    Tween(
        Shadow,
        {
            Size =
                UDim2.fromOffset(
                    currentWidth + 18,
                    currentHeight + 18
                ),

            BackgroundTransparency =
                0.72
        }
    )

    task.defer(function()

        local center =
            ClampWindowCenter(
                GetWindowCenter()
            )

        ApplyWindowCenter(
            center
        )

    end)
end

----------------------------------------------------------------
-- MINIMIZE BUTTON
----------------------------------------------------------------

MinimizeButton.MouseButton1Click:Connect(
    Minimize
)

----------------------------------------------------------------
-- CLOSE BUTTON
----------------------------------------------------------------

local Closed = false

CloseButton.MouseButton1Click:Connect(
    function()

        if Closed then
            return
        end

        Closed = true

        WindowVisible = false

        Tween(
            Window,
            {
                Size =
                    UDim2.fromOffset(
                        math.max(
                            1,
                            math.floor(
                                Window.AbsoluteSize.X
                                * 0.92
                            )
                        ),
                        math.max(
                            1,
                            math.floor(
                                Window.AbsoluteSize.Y
                                * 0.92
                            )
                        )
                    ),

                BackgroundTransparency = 1
            }
        )

        Tween(
            Shadow,
            {
                BackgroundTransparency = 1
            }
        )

        task.delay(
            CONFIG.Animation,
            function()

                if ScreenGui
                    and ScreenGui.Parent then

                    ScreenGui:Destroy()

                end

            end
        )
    end
)

----------------------------------------------------------------
-- PUBLIC API
----------------------------------------------------------------

function WALLXP:CreateWindow(options)

    options = options or {}

    if options.Name then

        CONFIG.Name =
            options.Name

        Logo.Text =
            CONFIG.Name

        Title.Text =
            CONFIG.Name

        FloatingText.Text =
            CONFIG.Name
    end

    if options.Subtitle then

        CONFIG.Subtitle =
            options.Subtitle

        Subtitle.Text =
            CONFIG.Subtitle
    end

    ResetWindowPosition()

    return {

        CreateTab = function(
            _,
            name,
            icon
        )
            return CreateTabInternal(
                name,
                icon
            )
        end,

        Minimize = Minimize,

        Restore = Restore,

        Notify = function(
            _,
            data
        )
            WALLXP:Notify(data)
        end
    }
end

----------------------------------------------------------------
-- NOTIFICATION
----------------------------------------------------------------

function WALLXP:Notify(options)

    options = options or {}

    local Holder =
        Instance.new("Frame")

    Holder.Name =
        "Notification"

    Holder.AnchorPoint =
        Vector2.new(
            1,
            0
        )

    Holder.BackgroundColor3 =
        Color3.fromRGB(
            18,
            21,
            27
        )

    Holder.BackgroundTransparency =
        0.05

    Holder.BorderSizePixel = 0

    Holder.Position =
        UDim2.new(
            1,
            300,
            0,
            25
        )

    Holder.Size =
        UDim2.fromOffset(
            270,
            76
        )

    Holder.ZIndex = 200
    Holder.Parent =
        ScreenGui

    Corner(
        Holder,
        16
    )

    Stroke(
        Holder,
        CONFIG.Accent,
        0.65,
        1
    )

    local AccentBar =
        Instance.new("Frame")

    AccentBar.BackgroundColor3 =
        CONFIG.Accent

    AccentBar.BorderSizePixel = 0

    AccentBar.Position =
        UDim2.fromOffset(
            0,
            13
        )

    AccentBar.Size =
        UDim2.fromOffset(
            3,
            50
        )

    AccentBar.ZIndex = 201
    AccentBar.Parent =
        Holder

    Corner(
        AccentBar,
        3
    )

    local NTitle =
        Instance.new("TextLabel")

    NTitle.BackgroundTransparency = 1

    NTitle.Position =
        UDim2.fromOffset(
            17,
            12
        )

    NTitle.Size =
        UDim2.new(
            1,
            -30,
            0,
            20
        )

    NTitle.Font =
        Enum.Font.GothamBold

    NTitle.Text =
        options.Title
        or "WALLXP"

    NTitle.TextColor3 =
        CONFIG.Text

    NTitle.TextSize = 12

    NTitle.TextXAlignment =
        Enum.TextXAlignment.Left

    NTitle.ZIndex = 202
    NTitle.Parent =
        Holder

    local NContent =
        Instance.new("TextLabel")

    NContent.BackgroundTransparency =
        1

    NContent.Position =
        UDim2.fromOffset(
            17,
            34
        )

    NContent.Size =
        UDim2.new(
            1,
            -30,
            0,
            28
        )

    NContent.Font =
        Enum.Font.Gotham

    NContent.Text =
        options.Content
        or options.Text
        or ""

    NContent.TextColor3 =
        CONFIG.SubText

    NContent.TextSize = 10

    NContent.TextWrapped = true

    NContent.TextXAlignment =
        Enum.TextXAlignment.Left

    NContent.ZIndex = 202
    NContent.Parent =
        Holder

    Tween(
        Holder,
        {
            Position =
                UDim2.new(
                    1,
                    -20,
                    0,
                    25
                )
        }
    )

    task.delay(
        options.Duration
        or 3,
        function()

            if Holder
                and Holder.Parent then

                Tween(
                    Holder,
                    {
                        Position =
                            UDim2.new(
                                1,
                                300,
                                0,
                                25
                            )
                    }
                )

                task.delay(
                    CONFIG.Animation,
                    function()

                        if Holder
                            and Holder.Parent then

                            Holder:Destroy()

                        end

                    end
                )
            end

        end
    )

    return Holder
end

----------------------------------------------------------------
-- RESPONSIVE
----------------------------------------------------------------

local function UpdateResponsiveSize()

    local viewport =
        GetViewport()

    local targetWidth =
        CONFIG.Width

    local targetHeight =
        CONFIG.Height

    ------------------------------------------------------------
    -- PORTRAIT / MOBILE
    ------------------------------------------------------------

    if viewport.X < 520 then

        targetWidth =
            math.max(
                CONFIG.MinWidth,
                viewport.X - 20
            )

        targetHeight =
            math.min(
                CONFIG.Height,
                math.max(
                    CONFIG.MinHeight,
                    viewport.Y - 30
                )
            )

    ------------------------------------------------------------
    -- SHORT SCREEN
    ------------------------------------------------------------

    elseif viewport.Y < 400 then

        targetWidth =
            math.min(
                CONFIG.Width,
                math.max(
                    CONFIG.MinWidth,
                    viewport.X - 20
                )
            )

        targetHeight =
            math.max(
                CONFIG.MinHeight,
                viewport.Y - 20
            )
    end

    Window.Size =
        UDim2.fromOffset(
            targetWidth,
            targetHeight
        )

    Shadow.Size =
        UDim2.fromOffset(
            targetWidth + 18,
            targetHeight + 18
        )

    local center =
        ClampWindowCenter(
            Vector2.new(
                viewport.X / 2,
                viewport.Y / 2
            )
        )

    ApplyWindowCenter(
        center
    )
end

----------------------------------------------------------------
-- INITIAL RESPONSIVE UPDATE
----------------------------------------------------------------

task.defer(
    function()

        task.wait(0.15)

        if ScreenGui.Parent then
            UpdateResponsiveSize()
        end

    end
)

----------------------------------------------------------------
-- VIEWPORT CHANGE
----------------------------------------------------------------

local CameraConnection = nil

local function ConnectCamera()

    if CameraConnection then

        CameraConnection:Disconnect()

        CameraConnection = nil
    end

    local camera =
        workspace.CurrentCamera

    if camera then

        CameraConnection =
            camera:GetPropertyChangedSignal(
                "ViewportSize"
            ):Connect(
                function()

                    if ScreenGui.Parent
                        and WindowVisible then

                        task.defer(
                            UpdateResponsiveSize
                        )

                    end

                end
            )
    end
end

ConnectCamera()

workspace:GetPropertyChangedSignal(
    "CurrentCamera"
):Connect(
    ConnectCamera
)

----------------------------------------------------------------
-- OPEN ANIMATION
----------------------------------------------------------------

Window.BackgroundTransparency = 1

Window.Size =
    UDim2.fromOffset(
        CONFIG.Width * 0.92,
        CONFIG.Height * 0.92
    )

Shadow.BackgroundTransparency = 1

Shadow.Size =
    UDim2.fromOffset(
        CONFIG.Width * 0.92,
        CONFIG.Height * 0.92
    )

task.defer(
    function()

        task.wait(0.05)

        if not ScreenGui.Parent then
            return
        end

        Window.Visible = true
        Shadow.Visible = true

        Tween(
            Window,
            {
                Size =
                    UDim2.fromOffset(
                        CONFIG.Width,
                        CONFIG.Height
                    ),

                BackgroundTransparency =
                    0.08
            }
        )

        Tween(
            Shadow,
            {
                Size =
                    UDim2.fromOffset(
                        CONFIG.Width + 18,
                        CONFIG.Height + 18
                    ),

                BackgroundTransparency =
                    0.72
            }
        )

    end
)

----------------------------------------------------------------
-- RETURN
----------------------------------------------------------------

return WALLXP
