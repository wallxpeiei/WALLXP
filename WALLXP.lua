--[[
    WALLXP v1.8.1
    Liquid Glass UI Library
    Single File
    No Require
    No External UI Library

    FIXES:
    - Window Drag fixed
    - Mouse + Touch
    - Keep On Screen fixed
    - Mobile screen support
    - Reset Window Position fixed
    - Floating Drag fixed
    - Floating Restore
    - Minimize / Restore
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
]]

--------------------------------------------------------
-- SERVICES
--------------------------------------------------------

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------
-- LIBRARY
--------------------------------------------------------

local WALLXP = {}

--------------------------------------------------------
-- CONFIG
--------------------------------------------------------

local CONFIG = {
    Name = "WALLXP",
    Subtitle = "Liquid Glass",

    Width = 630,
    Height = 350,

    SidebarWidth = 145,
    TopbarHeight = 72,

    Corner = 22,
    SmallCorner = 14,

    Animation = 0.22,

    Accent = Color3.fromRGB(78, 155, 255),

    Background = Color3.fromRGB(17, 19, 25),

    Text = Color3.fromRGB(248, 249, 255),
    SubText = Color3.fromRGB(168, 173, 188),

    Border = Color3.fromRGB(255, 255, 255)
}

--------------------------------------------------------
-- HELPERS
--------------------------------------------------------

local function New(className, properties)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    return object
end

local function Corner(object, radius)
    local corner = Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, radius or CONFIG.Corner)

    corner.Parent = object

    return corner
end

local function Stroke(object, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")

    stroke.Color =
        color or CONFIG.Border

    stroke.Transparency =
        transparency or 0.8

    stroke.Thickness =
        thickness or 1

    stroke.ApplyStrokeMode =
        Enum.ApplyStrokeMode.Border

    stroke.Parent = object

    return stroke
end

local function Gradient(object, colors, rotation)
    local gradient = Instance.new("UIGradient")

    gradient.Color =
        ColorSequence.new(colors)

    gradient.Rotation =
        rotation or 90

    gradient.Parent = object

    return gradient
end

local function Tween(
    object,
    duration,
    properties,
    style,
    direction
)
    if not object then
        return
    end

    local info = TweenInfo.new(
        duration or CONFIG.Animation,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )

    local tween =
        TweenService:Create(
            object,
            info,
            properties
        )

    tween:Play()

    return tween
end

local function Spring(object, duration, properties)
    return Tween(
        object,
        duration or 0.32,
        properties,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )
end

local function IsPointer(input)
    return
        input.UserInputType
            == Enum.UserInputType.MouseButton1
        or input.UserInputType
            == Enum.UserInputType.Touch
end

local function IsMoveInput(input)
    return
        input.UserInputType
            == Enum.UserInputType.MouseMovement
        or input.UserInputType
            == Enum.UserInputType.Touch
end

local function GetPointerPosition(input)
    if input.UserInputType
        == Enum.UserInputType.MouseMovement then

        return UserInputService:GetMouseLocation()
    end

    return input.Position
end

--------------------------------------------------------
-- SCREEN GUI
--------------------------------------------------------

local Existing

pcall(function()
    Existing =
        game:GetService("CoreGui")
        :FindFirstChild("WALLXP")
end)

if Existing then
    Existing:Destroy()
end

local ScreenGui = New("ScreenGui", {
    Name = "WALLXP",

    ResetOnSpawn = false,

    IgnoreGuiInset = true,

    ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling
})

pcall(function()
    ScreenGui.Parent =
        game:GetService("CoreGui")
end)

if not ScreenGui.Parent then
    ScreenGui.Parent =
        LocalPlayer:WaitForChild("PlayerGui")
end

--------------------------------------------------------
-- WINDOW
--------------------------------------------------------

local Window = New("Frame", {
    Name = "Window",

    Size = UDim2.new(
        0,
        CONFIG.Width,
        0,
        CONFIG.Height
    ),

    Position = UDim2.new(
        0.5,
        -CONFIG.Width / 2,
        0.5,
        -CONFIG.Height / 2
    ),

    BackgroundColor3 =
        CONFIG.Background,

    BackgroundTransparency = 0.08,

    BorderSizePixel = 0,

    ClipsDescendants = false,

    Visible = false,

    ZIndex = 10,

    Parent = ScreenGui
})

Corner(Window, CONFIG.Corner)

--------------------------------------------------------
-- SHADOW
--------------------------------------------------------

local Shadow = New("Frame", {
    Name = "Shadow",

    Size = UDim2.new(
        0,
        CONFIG.Width + 28,
        0,
        CONFIG.Height + 28
    ),

    Position = UDim2.new(
        0.5,
        -(CONFIG.Width + 28) / 2,
        0.5,
        -(CONFIG.Height + 28) / 2
    ),

    BackgroundColor3 =
        Color3.fromRGB(0, 0, 0),

    BackgroundTransparency = 0.72,

    BorderSizePixel = 0,

    ZIndex = 1,

    Parent = ScreenGui
})

Corner(
    Shadow,
    CONFIG.Corner + 8
)

--------------------------------------------------------
-- GLASS BACKGROUND
--------------------------------------------------------

Gradient(
    Window,
    {
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(35, 39, 51)
        ),

        ColorSequenceKeypoint.new(
            0.45,
            Color3.fromRGB(19, 22, 29)
        ),

        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(11, 13, 18)
        )
    },
    105
)

--------------------------------------------------------
-- OUTER BORDER
--------------------------------------------------------

local OuterStroke =
    Stroke(
        Window,
        Color3.fromRGB(255, 255, 255),
        0.72,
        1.25
    )

--------------------------------------------------------
-- INNER BORDER
--------------------------------------------------------

local InnerBorder = New("Frame", {
    Name = "InnerBorder",

    Position =
        UDim2.new(0, 2, 0, 2),

    Size =
        UDim2.new(1, -4, 1, -4),

    BackgroundTransparency = 1,

    BorderSizePixel = 0,

    ZIndex = 11,

    Parent = Window
})

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

--------------------------------------------------------
-- TOP HIGHLIGHT
--------------------------------------------------------

local TopHighlight = New("Frame", {
    Name = "TopHighlight",

    Position =
        UDim2.new(0, 10, 0, 7),

    Size =
        UDim2.new(1, -20, 0, 2),

    BackgroundColor3 =
        Color3.fromRGB(255, 255, 255),

    BackgroundTransparency = 0.86,

    BorderSizePixel = 0,

    ZIndex = 50,

    Parent = Window
})

Corner(
    TopHighlight,
    5
)

--------------------------------------------------------
-- SIDEBAR
--------------------------------------------------------

local Sidebar = New("Frame", {
    Name = "Sidebar",

    Position =
        UDim2.new(0, 8, 0, 8),

    Size =
        UDim2.new(
            0,
            CONFIG.SidebarWidth,
            1,
            -16
        ),

    BackgroundColor3 =
        Color3.fromRGB(255, 255, 255),

    BackgroundTransparency = 0.955,

    BorderSizePixel = 0,

    ZIndex = 20,

    Parent = Window
})

Corner(
    Sidebar,
    18
)

Stroke(
    Sidebar,
    Color3.fromRGB(255, 255, 255),
    0.93,
    1
)

--------------------------------------------------------
-- HEADER
--------------------------------------------------------

local Header = New("Frame", {
    Name = "Header",

    Position =
        UDim2.new(
            0,
            CONFIG.SidebarWidth + 18,
            0,
            8
        ),

    Size =
        UDim2.new(
            1,
            -(CONFIG.SidebarWidth + 26),
            0,
            CONFIG.TopbarHeight
        ),

    BackgroundTransparency = 1,

    BorderSizePixel = 0,

    ZIndex = 30,

    Parent = Window
})

--------------------------------------------------------
-- TITLE
--------------------------------------------------------

local Title = New("TextLabel", {
    Name = "Title",

    BackgroundTransparency = 1,

    Text = CONFIG.Name,

    TextColor3 =
        CONFIG.Text,

    TextSize = 18,

    Font =
        Enum.Font.GothamBold,

    TextXAlignment =
        Enum.TextXAlignment.Left,

    Position =
        UDim2.new(0, 12, 0, 10),

    Size =
        UDim2.new(1, -170, 0, 25),

    ZIndex = 31,

    Parent = Header
})

local Subtitle = New("TextLabel", {
    Name = "Subtitle",

    BackgroundTransparency = 1,

    Text = CONFIG.Subtitle,

    TextColor3 =
        CONFIG.SubText,

    TextSize = 11,

    Font =
        Enum.Font.Gotham,

    TextXAlignment =
        Enum.TextXAlignment.Left,

    Position =
        UDim2.new(0, 12, 0, 35),

    Size =
        UDim2.new(1, -170, 0, 20),

    ZIndex = 31,

    Parent = Header
})

--------------------------------------------------------
-- HEADER BUTTON
--------------------------------------------------------

local function CreateHeaderButton(
    text,
    position
)
    local Button = New("TextButton", {
        AutoButtonColor = false,

        Text = text,

        TextColor3 =
            CONFIG.SubText,

        TextSize = 16,

        Font =
            Enum.Font.GothamMedium,

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BackgroundTransparency = 0.94,

        BorderSizePixel = 0,

        Position = position,

        Size =
            UDim2.new(
                0,
                34,
                0,
                34
            ),

        ZIndex = 35,

        Parent = Header
    })

    Corner(Button, 12)

    Stroke(
        Button,
        Color3.fromRGB(255, 255, 255),
        0.94,
        1
    )

    Button.MouseEnter:Connect(function()
        Tween(Button, 0.16, {
            BackgroundTransparency = 0.88,
            TextColor3 = CONFIG.Text
        })
    end)

    Button.MouseLeave:Connect(function()
        Tween(Button, 0.16, {
            BackgroundTransparency = 0.94,
            TextColor3 = CONFIG.SubText
        })
    end)

    Button.MouseButton1Down:Connect(function()
        Spring(Button, 0.16, {
            Size =
                UDim2.new(
                    0,
                    31,
                    0,
                    31
                )
        })
    end)

    Button.MouseButton1Up:Connect(function()
        Spring(Button, 0.2, {
            Size =
                UDim2.new(
                    0,
                    34,
                    0,
                    34
                )
        })
    end)

    return Button
end

local SearchButton =
    CreateHeaderButton(
        "⌕",
        UDim2.new(1, -112, 0, 13)
    )

local SettingsButton =
    CreateHeaderButton(
        "⚙",
        UDim2.new(1, -72, 0, 13)
    )

local MinimizeButton =
    CreateHeaderButton(
        "−",
        UDim2.new(1, -32, 0, 13)
    )

--------------------------------------------------------
-- CONTENT
--------------------------------------------------------

local Content = New("Frame", {
    Name = "Content",

    Position =
        UDim2.new(
            0,
            CONFIG.SidebarWidth + 18,
            0,
            CONFIG.TopbarHeight + 8
        ),

    Size =
        UDim2.new(
            1,
            -(CONFIG.SidebarWidth + 26),
            1,
            -(CONFIG.TopbarHeight + 16)
        ),

    BackgroundTransparency = 1,

    BorderSizePixel = 0,

    ZIndex = 20,

    Parent = Window
})

--------------------------------------------------------
-- PROFILE
--------------------------------------------------------

local ProfileArea = New("Frame", {
    Name = "Profile",

    Position =
        UDim2.new(0, 9, 1, -58),

    Size =
        UDim2.new(1, -18, 0, 48),

    BackgroundColor3 =
        Color3.fromRGB(255, 255, 255),

    BackgroundTransparency = 0.95,

    BorderSizePixel = 0,

    ZIndex = 25,

    Parent = Sidebar
})

Corner(
    ProfileArea,
    14
)

Stroke(
    ProfileArea,
    Color3.fromRGB(255, 255, 255),
    0.95,
    1
)

local Avatar = New("ImageLabel", {
    Name = "Avatar",

    BackgroundColor3 =
        CONFIG.Accent,

    BackgroundTransparency = 0.1,

    BorderSizePixel = 0,

    Position =
        UDim2.new(
            0,
            7,
            0.5,
            -17
        ),

    Size =
        UDim2.new(
            0,
            34,
            0,
            34
        ),

    ZIndex = 27,

    Parent = ProfileArea
})

Corner(
    Avatar,
    12
)

pcall(function()
    Avatar.Image =
        "rbxthumb://type=AvatarHeadShot&id="
        .. LocalPlayer.UserId
        .. "&w=150&h=150"
end)

local ProfileName = New("TextLabel", {
    BackgroundTransparency = 1,

    Text =
        LocalPlayer.DisplayName,

    TextColor3 =
        CONFIG.Text,

    TextSize = 11,

    Font =
        Enum.Font.GothamBold,

    TextXAlignment =
        Enum.TextXAlignment.Left,

    Position =
        UDim2.new(0, 48, 0, 7),

    Size =
        UDim2.new(1, -54, 0, 16),

    TextTruncate =
        Enum.TextTruncate.AtEnd,

    ZIndex = 28,

    Parent = ProfileArea
})

local ProfileUser = New("TextLabel", {
    BackgroundTransparency = 1,

    Text =
        "@" .. LocalPlayer.Name,

    TextColor3 =
        CONFIG.SubText,

    TextSize = 9,

    Font =
        Enum.Font.Gotham,

    TextXAlignment =
        Enum.TextXAlignment.Left,

    Position =
        UDim2.new(0, 48, 0, 24),

    Size =
        UDim2.new(1, -54, 0, 14),

    TextTruncate =
        Enum.TextTruncate.AtEnd,

    ZIndex = 28,

    Parent = ProfileArea
})

--------------------------------------------------------
-- TAB SYSTEM
--------------------------------------------------------

local Tabs = {}
local Pages = {}
local CurrentTab = nil

local TabContainer = New("Frame", {
    Name = "Tabs",

    Position =
        UDim2.new(0, 8, 0, 14),

    Size =
        UDim2.new(1, -16, 1, -78),

    BackgroundTransparency = 1,

    BorderSizePixel = 0,

    ZIndex = 30,

    Parent = Sidebar
})

local TabLayout =
    Instance.new("UIListLayout")

TabLayout.Padding =
    UDim.new(0, 6)

TabLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

TabLayout.Parent =
    TabContainer

--------------------------------------------------------
-- PAGE
--------------------------------------------------------

local function CreatePage(name)

    local Page = New("ScrollingFrame", {
        Name = name,

        Size =
            UDim2.new(1, 0, 1, 0),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        ScrollBarThickness = 2,

        ScrollBarImageColor3 =
            CONFIG.Accent,

        CanvasSize =
            UDim2.new(0, 0, 0, 0),

        AutomaticCanvasSize =
            Enum.AutomaticSize.Y,

        Visible = false,

        ZIndex = 22,

        Parent = Content
    })

    local Padding =
        Instance.new("UIPadding")

    Padding.PaddingTop =
        UDim.new(0, 3)

    Padding.PaddingBottom =
        UDim.new(0, 15)

    Padding.PaddingLeft =
        UDim.new(0, 3)

    Padding.PaddingRight =
        UDim.new(0, 8)

    Padding.Parent =
        Page

    local Layout =
        Instance.new("UIListLayout")

    Layout.Padding =
        UDim.new(0, 9)

    Layout.SortOrder =
        Enum.SortOrder.LayoutOrder

    Layout.Parent =
        Page

    Pages[name] =
        Page

    return Page
end

--------------------------------------------------------
-- SELECT TAB
--------------------------------------------------------

local function SelectTab(name)

    for tabName, data in pairs(Tabs) do

        local selected =
            tabName == name

        Tween(
            data.Button,
            0.2,
            {
                BackgroundTransparency =
                    selected
                    and 0.83
                    or 0.96,

                TextColor3 =
                    selected
                    and CONFIG.Text
                    or CONFIG.SubText
            }
        )

        Tween(
            data.Accent,
            0.2,
            {
                BackgroundTransparency =
                    selected
                    and 0
                    or 1
            }
        )
    end

    for pageName, page in pairs(Pages) do

        page.Visible =
            pageName == name
    end

    CurrentTab = name
end

--------------------------------------------------------
-- CREATE TAB
--------------------------------------------------------

local function CreateTab(
    name,
    icon
)

    local Button = New("TextButton", {

        Name = name,

        AutoButtonColor = false,

        Text =
            (icon or "•")
            .. "   "
            .. name,

        TextColor3 =
            CONFIG.SubText,

        TextSize = 11,

        Font =
            Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BackgroundTransparency = 0.96,

        BorderSizePixel = 0,

        Size =
            UDim2.new(
                1,
                0,
                0,
                36
            ),

        ZIndex = 31,

        Parent = TabContainer
    })

    Corner(Button, 12)

    local AccentLine = New("Frame", {

        BackgroundColor3 =
            CONFIG.Accent,

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        Position =
            UDim2.new(
                0,
                4,
                0.5,
                -8
            ),

        Size =
            UDim2.new(
                0,
                3,
                0,
                16
            ),

        ZIndex = 34,

        Parent = Button
    })

    Corner(
        AccentLine,
        4
    )

    Tabs[name] = {
        Button = Button,
        Accent = AccentLine
    }

    CreatePage(name)

    Button.MouseEnter:Connect(function()

        if CurrentTab ~= name then

            Tween(Button, 0.15, {
                BackgroundTransparency =
                    0.91
            })

        end

    end)

    Button.MouseLeave:Connect(function()

        if CurrentTab ~= name then

            Tween(Button, 0.15, {
                BackgroundTransparency =
                    0.96
            })

        end

    end)

    Button.MouseButton1Click:Connect(
        function()
            SelectTab(name)
        end
    )

    return Pages[name]
end

--------------------------------------------------------
-- ELEMENT HELPERS
--------------------------------------------------------

local function CreateSection(
    page,
    text
)

    local Section = New("TextLabel", {

        BackgroundTransparency = 1,

        Text = text,

        TextColor3 =
            CONFIG.Text,

        TextSize = 12,

        Font =
            Enum.Font.GothamBold,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        Size =
            UDim2.new(
                1,
                0,
                0,
                25
            ),

        ZIndex = 25,

        Parent = page
    })

    return Section
end

--------------------------------------------------------
-- BUTTON
--------------------------------------------------------

local function CreateButton(
    page,
    options
)

    options = options or {}

    local Button = New("TextButton", {

        AutoButtonColor = false,

        Text = "",

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BackgroundTransparency = 0.94,

        BorderSizePixel = 0,

        Size =
            UDim2.new(
                1,
                0,
                0,
                50
            ),

        ZIndex = 25,

        Parent = page
    })

    Corner(
        Button,
        CONFIG.SmallCorner
    )

    Stroke(
        Button,
        Color3.fromRGB(255, 255, 255),
        0.94,
        1
    )

    local Title = New("TextLabel", {

        BackgroundTransparency = 1,

        Text =
            options.Name
            or "Button",

        TextColor3 =
            CONFIG.Text,

        TextSize = 11,

        Font =
            Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        Position =
            UDim2.new(0, 14, 0, 7),

        Size =
            UDim2.new(1, -28, 0, 18),

        ZIndex = 27,

        Parent = Button
    })

    local Description = New(
        "TextLabel",
        {

            BackgroundTransparency = 1,

            Text =
                options.Description
                or "",

            TextColor3 =
                CONFIG.SubText,

            TextSize = 9,

            Font =
                Enum.Font.Gotham,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            Position =
                UDim2.new(0, 14, 0, 26),

            Size =
                UDim2.new(
                    1,
                    -28,
                    0,
                    14
                ),

            ZIndex = 27,

            Parent = Button
        }
    )

    Button.MouseEnter:Connect(
        function()
            Tween(Button, 0.16, {
                BackgroundTransparency =
                    0.88
            })
        end
    )

    Button.MouseLeave:Connect(
        function()
            Tween(Button, 0.16, {
                BackgroundTransparency =
                    0.94
            })
        end
    )

    Button.MouseButton1Click:Connect(
        function()

            Tween(Button, 0.08, {
                BackgroundTransparency =
                    0.78
            })

            task.delay(
                0.08,
                function()

                    if Button.Parent then

                        Tween(Button, 0.16, {
                            BackgroundTransparency =
                                0.94
                        })

                    end

                end
            )

            if typeof(
                options.Callback
            ) == "function" then

                options.Callback()

            end

        end
    )

    return Button
end

--------------------------------------------------------
-- TOGGLE
--------------------------------------------------------

local function CreateToggle(
    page,
    options
)

    options = options or {}

    local Value =
        options.Default == true

    local Button = New("TextButton", {

        AutoButtonColor = false,

        Text = "",

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BackgroundTransparency = 0.94,

        BorderSizePixel = 0,

        Size =
            UDim2.new(
                1,
                0,
                0,
                50
            ),

        ZIndex = 25,

        Parent = page
    })

    Corner(
        Button,
        CONFIG.SmallCorner
    )

    Stroke(
        Button,
        Color3.fromRGB(255, 255, 255),
        0.94,
        1
    )

    local Title = New("TextLabel", {

        BackgroundTransparency = 1,

        Text =
            options.Name
            or "Toggle",

        TextColor3 =
            CONFIG.Text,

        TextSize = 11,

        Font =
            Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        Position =
            UDim2.new(0, 14, 0, 16),

        Size =
            UDim2.new(
                1,
                -80,
                0,
                20
            ),

        ZIndex = 27,

        Parent = Button
    })

    local Switch = New("Frame", {

        BackgroundColor3 =
            Value
            and CONFIG.Accent
            or Color3.fromRGB(
                70,
                73,
                82
            ),

        BorderSizePixel = 0,

        Position =
            UDim2.new(
                1,
                -52,
                0.5,
                -11
            ),

        Size =
            UDim2.new(
                0,
                40,
                0,
                22
            ),

        ZIndex = 28,

        Parent = Button
    })

    Corner(
        Switch,
        20
    )

    local Knob = New("Frame", {

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BorderSizePixel = 0,

        Position =
            Value
            and UDim2.new(
                1,
                -20,
                0.5,
                -8
            )
            or UDim2.new(
                0,
                4,
                0.5,
                -8
            ),

        Size =
            UDim2.new(
                0,
                16,
                0,
                16
            ),

        ZIndex = 30,

        Parent = Switch
    })

    Corner(
        Knob,
        20
    )

    local function Update()

        Tween(
            Switch,
            0.2,
            {
                BackgroundColor3 =
                    Value
                    and CONFIG.Accent
                    or Color3.fromRGB(
                        70,
                        73,
                        82
                    )
            }
        )

        Spring(
            Knob,
            0.24,
            {
                Position =
                    Value
                    and UDim2.new(
                        1,
                        -20,
                        0.5,
                        -8
                    )
                    or UDim2.new(
                        0,
                        4,
                        0.5,
                        -8
                    )
            }
        )

        if typeof(
            options.Callback
        ) == "function" then

            options.Callback(Value)

        end
    end

    Button.MouseButton1Click:Connect(
        function()

            Value = not Value

            Update()

        end
    )

    return {

        Set = function(_, newValue)

            Value =
                newValue == true

            Update()

        end,

        Get = function()
            return Value
        end
    }
end

--------------------------------------------------------
-- SLIDER
--------------------------------------------------------

local function CreateSlider(
    page,
    options
)

    options = options or {}

    local Min =
        options.Min or 0

    local Max =
        options.Max or 100

    if Max <= Min then
        Max = Min + 1
    end

    local Value =
        math.clamp(
            options.Default or Min,
            Min,
            Max
        )

    local Frame = New("Frame", {

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BackgroundTransparency = 0.94,

        BorderSizePixel = 0,

        Size =
            UDim2.new(
                1,
                0,
                0,
                66
            ),

        ZIndex = 25,

        Parent = page
    })

    Corner(
        Frame,
        CONFIG.SmallCorner
    )

    Stroke(
        Frame,
        Color3.fromRGB(255, 255, 255),
        0.94,
        1
    )

    local Title = New("TextLabel", {

        BackgroundTransparency = 1,

        Text =
            options.Name
            or "Slider",

        TextColor3 =
            CONFIG.Text,

        TextSize = 11,

        Font =
            Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        Position =
            UDim2.new(0, 14, 0, 9),

        Size =
            UDim2.new(
                0.7,
                0,
                0,
                18
            ),

        ZIndex = 27,

        Parent = Frame
    })

    local ValueLabel = New(
        "TextLabel",
        {

            BackgroundTransparency = 1,

            TextColor3 =
                CONFIG.SubText,

            TextSize = 10,

            Font =
                Enum.Font.GothamMedium,

            TextXAlignment =
                Enum.TextXAlignment.Right,

            Position =
                UDim2.new(
                    1,
                    -55,
                    0,
                    9
                ),

            Size =
                UDim2.new(
                    0,
                    40,
                    0,
                    18
                ),

            ZIndex = 27,

            Parent = Frame
        }
    )

    local Bar = New("Frame", {

        BackgroundColor3 =
            Color3.fromRGB(
                65,
                68,
                78
            ),

        BorderSizePixel = 0,

        Position =
            UDim2.new(
                0,
                14,
                0,
                42
            ),

        Size =
            UDim2.new(
                1,
                -28,
                0,
                6
            ),

        ZIndex = 27,

        Parent = Frame
    })

    Corner(
        Bar,
        6
    )

    local Fill = New("Frame", {

        BackgroundColor3 =
            CONFIG.Accent,

        BorderSizePixel = 0,

        Size =
            UDim2.new(
                0,
                0,
                1,
                0
            ),

        ZIndex = 28,

        Parent = Bar
    })

    Corner(
        Fill,
        6
    )

    local Knob = New("Frame", {

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BorderSizePixel = 0,

        Size =
            UDim2.new(
                0,
                14,
                0,
                14
            ),

        AnchorPoint =
            Vector2.new(
                0.5,
                0.5
            ),

        ZIndex = 30,

        Parent = Bar
    })

    Corner(
        Knob,
        20
    )

    local Dragging = false

    local function UpdateFromX(x)

        local width =
            Bar.AbsoluteSize.X

        if width <= 0 then
            return
        end

        local percent =
            math.clamp(
                (
                    x
                    - Bar.AbsolutePosition.X
                )
                / width,
                0,
                1
            )

        Value =
            Min
            + (Max - Min)
            * percent

        if options.Round then

            Value =
                math.floor(
                    Value + 0.5
                )

        end

        local finalPercent =
            (Value - Min)
            / (Max - Min)

        Fill.Size =
            UDim2.new(
                finalPercent,
                0,
                1,
                0
            )

        Knob.Position =
            UDim2.new(
                finalPercent,
                0,
                0.5,
                0
            )

        ValueLabel.Text =
            tostring(Value)

        if typeof(
            options.Callback
        ) == "function" then

            options.Callback(Value)

        end
    end

    local function UpdateInitial()

        local percent =
            (Value - Min)
            / (Max - Min)

        UpdateFromX(
            Bar.AbsolutePosition.X
            + percent
            * Bar.AbsoluteSize.X
        )
    end

    Bar.InputBegan:Connect(
        function(input)

            if IsPointer(input) then

                Dragging = true

                UpdateFromX(
                    GetPointerPosition(
                        input
                    ).X
                )

            end

        end
    )

    UserInputService.InputChanged:Connect(
        function(input)

            if Dragging
                and IsMoveInput(input) then

                UpdateFromX(
                    GetPointerPosition(
                        input
                    ).X
                )

            end

        end
    )

    UserInputService.InputEnded:Connect(
        function(input)

            if input.UserInputType
                == Enum.UserInputType.MouseButton1
                or input.UserInputType
                == Enum.UserInputType.Touch then

                Dragging = false

            end

        end
    )

    task.defer(
        UpdateInitial
    )

    return {

        Set = function(_, newValue)

            Value =
                math.clamp(
                    newValue,
                    Min,
                    Max
                )

            UpdateInitial()

        end,

        Get = function()
            return Value
        end
    }
end

--------------------------------------------------------
-- DROPDOWN
--------------------------------------------------------

local function CreateDropdown(
    page,
    options
)

    options = options or {}

    local Items =
        options.Options or {}

    local Selected =
        options.Default
        or Items[1]

    local Main = New("Frame", {

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BackgroundTransparency = 0.94,

        BorderSizePixel = 0,

        Size =
            UDim2.new(
                1,
                0,
                0,
                50
            ),

        ClipsDescendants = true,

        ZIndex = 25,

        Parent = page
    })

    Corner(
        Main,
        CONFIG.SmallCorner
    )

    Stroke(
        Main,
        Color3.fromRGB(255, 255, 255),
        0.94,
        1
    )

    local Button = New("TextButton", {

        AutoButtonColor = false,

        Text = "",

        BackgroundTransparency = 1,

        Size =
            UDim2.new(
                1,
                0,
                0,
                50
            ),

        ZIndex = 27,

        Parent = Main
    })

    local Title = New("TextLabel", {

        BackgroundTransparency = 1,

        Text =
            options.Name
            or "Dropdown",

        TextColor3 =
            CONFIG.Text,

        TextSize = 11,

        Font =
            Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        Position =
            UDim2.new(0, 14, 0, 7),

        Size =
            UDim2.new(
                0.5,
                0,
                0,
                18
            ),

        ZIndex = 29,

        Parent = Button
    })

    local SelectedLabel = New(
        "TextLabel",
        {

            BackgroundTransparency = 1,

            Text =
                tostring(
                    Selected or ""
                ),

            TextColor3 =
                CONFIG.SubText,

            TextSize = 9,

            Font =
                Enum.Font.Gotham,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            Position =
                UDim2.new(
                    0,
                    14,
                    0,
                    27
                ),

            Size =
                UDim2.new(
                    1,
                    -45,
                    0,
                    14
                ),

            ZIndex = 29,

            Parent = Button
        }
    )

    local Arrow = New("TextLabel", {

        BackgroundTransparency = 1,

        Text = "⌄",

        TextColor3 =
            CONFIG.SubText,

        TextSize = 15,

        Font =
            Enum.Font.GothamBold,

        Position =
            UDim2.new(
                1,
                -34,
                0,
                16
            ),

        Size =
            UDim2.new(
                0,
                20,
                0,
                20
            ),

        ZIndex = 29,

        Parent = Button
    })

    local OptionsFrame = New("Frame", {

        BackgroundTransparency = 1,

        Position =
            UDim2.new(
                0,
                10,
                0,
                54
            ),

        Size =
            UDim2.new(
                1,
                -20,
                0,
                math.max(
                    1,
                    #Items * 32
                )
            ),

        ZIndex = 30,

        Parent = Main
    })

    local Layout =
        Instance.new("UIListLayout")

    Layout.Padding =
        UDim.new(0, 4)

    Layout.SortOrder =
        Enum.SortOrder.LayoutOrder

    Layout.Parent =
        OptionsFrame

    local Open = false

    for _, item in ipairs(Items) do

        local Option = New(
            "TextButton",
            {

                AutoButtonColor = false,

                Text =
                    tostring(item),

                TextColor3 =
                    CONFIG.SubText,

                TextSize = 10,

                Font =
                    Enum.Font.GothamMedium,

                BackgroundColor3 =
                    Color3.fromRGB(
                        255,
                        255,
                        255
                    ),

                BackgroundTransparency =
                    0.94,

                BorderSizePixel = 0,

                Size =
                    UDim2.new(
                        1,
                        0,
                        0,
                        28
                    ),

                ZIndex = 31,

                Parent =
                    OptionsFrame
            }
        )

        Corner(
            Option,
            9
        )

        Option.MouseEnter:Connect(
            function()

                Tween(Option, 0.12, {
                    BackgroundTransparency =
                        0.87,

                    TextColor3 =
                        CONFIG.Text
                })

            end
        )

        Option.MouseLeave:Connect(
            function()

                Tween(Option, 0.12, {
                    BackgroundTransparency =
                        0.94,

                    TextColor3 =
                        CONFIG.SubText
                })

            end
        )

        Option.MouseButton1Click:Connect(
            function()

                Selected = item

                SelectedLabel.Text =
                    tostring(item)

                Open = false

                Tween(
                    Main,
                    0.22,
                    {
                        Size =
                            UDim2.new(
                                1,
                                0,
                                0,
                                50
                            )
                    }
                )

                Arrow.Text = "⌄"

                if typeof(
                    options.Callback
                ) == "function" then

                    options.Callback(
                        item
                    )

                end

            end
        )
    end

    Button.MouseButton1Click:Connect(
        function()

            Open = not Open

            if Open then

                Tween(
                    Main,
                    0.24,
                    {
                        Size =
                            UDim2.new(
                                1,
                                0,
                                0,
                                62
                                + (#Items * 32)
                            )
                    }
                )

                Arrow.Text = "⌃"

            else

                Tween(
                    Main,
                    0.22,
                    {
                        Size =
                            UDim2.new(
                                1,
                                0,
                                0,
                                50
                            )
                    }
                )

                Arrow.Text = "⌄"

            end
        end
    )

    return {

        Set = function(_, item)

            Selected = item

            SelectedLabel.Text =
                tostring(item)

        end,

        Get = function()
            return Selected
        end
    }
end

--------------------------------------------------------
-- INPUT
--------------------------------------------------------

local function CreateInput(
    page,
    options
)

    options = options or {}

    local Frame = New("Frame", {

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BackgroundTransparency = 0.94,

        BorderSizePixel = 0,

        Size =
            UDim2.new(
                1,
                0,
                0,
                58
            ),

        ZIndex = 25,

        Parent = page
    })

    Corner(
        Frame,
        CONFIG.SmallCorner
    )

    Stroke(
        Frame,
        Color3.fromRGB(255, 255, 255),
        0.94,
        1
    )

    local Title = New("TextLabel", {

        BackgroundTransparency = 1,

        Text =
            options.Name
            or "Input",

        TextColor3 =
            CONFIG.Text,

        TextSize = 10,

        Font =
            Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        Position =
            UDim2.new(0, 13, 0, 7),

        Size =
            UDim2.new(
                0.35,
                0,
                0,
                18
            ),

        ZIndex = 27,

        Parent = Frame
    })

    local Box = New("TextBox", {

        Text =
            options.Default
            or "",

        PlaceholderText =
            options.Placeholder
            or "Enter text...",

        ClearTextOnFocus = false,

        TextColor3 =
            CONFIG.Text,

        PlaceholderColor3 =
            CONFIG.SubText,

        TextSize = 10,

        Font =
            Enum.Font.Gotham,

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BackgroundTransparency = 0.94,

        BorderSizePixel = 0,

        Position =
            UDim2.new(
                0.35,
                4,
                0,
                8
            ),

        Size =
            UDim2.new(
                0.65,
                -17,
                0,
                38
            ),

        ZIndex = 28,

        Parent = Frame
    })

    Corner(
        Box,
        10
    )

    Stroke(
        Box,
        Color3.fromRGB(255, 255, 255),
        0.95,
        1
    )

    Box.FocusLost:Connect(
        function()

            if typeof(
                options.Callback
            ) == "function" then

                options.Callback(
                    Box.Text
                )

            end

        end
    )

    return {

        Set = function(_, text)

            Box.Text =
                tostring(text)

        end,

        Get = function()

            return Box.Text

        end
    }
end

--------------------------------------------------------
-- KEYBIND
--------------------------------------------------------

local function CreateKeybind(
    page,
    options
)

    options = options or {}

    local CurrentKey =
        options.Default
        or Enum.KeyCode.RightShift

    local Button = New("TextButton", {

        AutoButtonColor = false,

        Text = "",

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BackgroundTransparency = 0.94,

        BorderSizePixel = 0,

        Size =
            UDim2.new(
                1,
                0,
                0,
                50
            ),

        ZIndex = 25,

        Parent = page
    })

    Corner(
        Button,
        CONFIG.SmallCorner
    )

    Stroke(
        Button,
        Color3.fromRGB(255, 255, 255),
        0.94,
        1
    )

    local Title = New("TextLabel", {

        BackgroundTransparency = 1,

        Text =
            options.Name
            or "Keybind",

        TextColor3 =
            CONFIG.Text,

        TextSize = 11,

        Font =
            Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        Position =
            UDim2.new(
                0,
                14,
                0,
                16
            ),

        Size =
            UDim2.new(
                0.6,
                0,
                0,
                20
            ),

        ZIndex = 27,

        Parent = Button
    })

    local KeyLabel = New(
        "TextLabel",
        {

            BackgroundColor3 =
                Color3.fromRGB(
                    255,
                    255,
                    255
                ),

            BackgroundTransparency =
                0.9,

            Text =
                CurrentKey.Name,

            TextColor3 =
                CONFIG.SubText,

            TextSize = 9,

            Font =
                Enum.Font.GothamMedium,

            Position =
                UDim2.new(
                    1,
                    -95,
                    0.5,
                    -14
                ),

            Size =
                UDim2.new(
                    0,
                    80,
                    0,
                    28
                ),

            ZIndex = 28,

            Parent = Button
        }
    )

    Corner(
        KeyLabel,
        9
    )

    local Listening = false

    Button.MouseButton1Click:Connect(
        function()

            Listening = true

            KeyLabel.Text =
                "Press key..."

            Tween(
                KeyLabel,
                0.15,
                {
                    BackgroundTransparency =
                        0.78,

                    TextColor3 =
                        CONFIG.Text
                }
            )

        end
    )

    UserInputService.InputBegan:Connect(
        function(input, processed)

            if Listening
                and input.UserInputType
                    == Enum.UserInputType.Keyboard then

                CurrentKey =
                    input.KeyCode

                KeyLabel.Text =
                    CurrentKey.Name

                Listening = false

                Tween(
                    KeyLabel,
                    0.18,
                    {
                        BackgroundTransparency =
                            0.9,

                        TextColor3 =
                            CONFIG.SubText
                    }
                )

            elseif
                not processed
                and input.KeyCode
                    == CurrentKey then

                if typeof(
                    options.Callback
                ) == "function" then

                    options.Callback()

                end

            end
        end
    )

    return {

        Set = function(_, key)

            CurrentKey = key

            KeyLabel.Text =
                key.Name

        end,

        Get = function()

            return CurrentKey

        end
    }
end

--------------------------------------------------------
-- NOTIFICATIONS
--------------------------------------------------------

local NotificationContainer =
    New("Frame", {

        Name = "Notifications",

        AnchorPoint =
            Vector2.new(1, 0),

        Position =
            UDim2.new(
                1,
                -18,
                0,
                18
            ),

        Size =
            UDim2.new(
                0,
                280,
                1,
                -36
            ),

        BackgroundTransparency = 1,

        BorderSizePixel = 0,

        ZIndex = 200,

        Parent = ScreenGui
    })

local NotificationLayout =
    Instance.new("UIListLayout")

NotificationLayout.Padding =
    UDim.new(0, 8)

NotificationLayout.HorizontalAlignment =
    Enum.HorizontalAlignment.Right

NotificationLayout.VerticalAlignment =
    Enum.VerticalAlignment.Top

NotificationLayout.Parent =
    NotificationContainer

function WALLXP:Notify(options)

    options = options or {}

    local Card = New("Frame", {

        BackgroundColor3 =
            CONFIG.Background,

        BackgroundTransparency = 0.08,

        BorderSizePixel = 0,

        Size =
            UDim2.new(
                0,
                270,
                0,
                70
            ),

        ZIndex = 201,

        Parent =
            NotificationContainer
    })

    Corner(
        Card,
        17
    )

    Stroke(
        Card,
        CONFIG.Accent,
        0.55,
        1.2
    )

    Gradient(
        Card,
        {
            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(
                    35,
                    40,
                    52
                )
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(
                    15,
                    17,
                    23
                )
            )
        },
        90
    )

    local Title = New(
        "TextLabel",
        {

            BackgroundTransparency = 1,

            Text =
                options.Title
                or "WALLXP",

            TextColor3 =
                CONFIG.Text,

            TextSize = 12,

            Font =
                Enum.Font.GothamBold,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            Position =
                UDim2.new(
                    0,
                    14,
                    0,
                    10
                ),

            Size =
                UDim2.new(
                    1,
                    -28,
                    0,
                    18
                ),

            ZIndex = 203,

            Parent = Card
        }
    )

    local Message = New(
        "TextLabel",
        {

            BackgroundTransparency = 1,

            Text =
                options.Content
                or "",

            TextColor3 =
                CONFIG.SubText,

            TextSize = 9,

            Font =
                Enum.Font.Gotham,

            TextXAlignment =
                Enum.TextXAlignment.Left,

            TextWrapped = true,

            Position =
                UDim2.new(
                    0,
                    14,
                    0,
                    31
                ),

            Size =
                UDim2.new(
                    1,
                    -28,
                    0,
                    28
                ),

            ZIndex = 203,

            Parent = Card
        }
    )

    Card.Position =
        UDim2.new(
            0,
            300,
            0,
            0
        )

    Spring(
        Card,
        0.4,
        {
            Position =
                UDim2.new(
                    0,
                    0,
                    0,
                    0
                )
        }
    )

    task.delay(
        options.Duration or 3,
        function()

            if Card.Parent then

                Tween(
                    Card,
                    0.25,
                    {
                        Position =
                            UDim2.new(
                                0,
                                300,
                                0,
                                0
                            ),

                        BackgroundTransparency = 1
                    }
                )

                task.wait(0.28)

                if Card.Parent then
                    Card:Destroy()
                end

            end

        end
    )
end

--------------------------------------------------------
-- SEARCH
--------------------------------------------------------

local SearchFrame =
    New("Frame", {

        Name = "Search",

        AnchorPoint =
            Vector2.new(
                0.5,
                0
            ),

        Position =
            UDim2.new(
                0.5,
                0,
                0,
                72
            ),

        Size =
            UDim2.new(
                0,
                360,
                0,
                44
            ),

        BackgroundColor3 =
            CONFIG.Background,

        BackgroundTransparency = 0.06,

        BorderSizePixel = 0,

        Visible = false,

        ZIndex = 150,

        Parent = Window
    })

Corner(
    SearchFrame,
    15
)

Stroke(
    SearchFrame,
    CONFIG.Accent,
    0.7,
    1
)

local SearchBox =
    New("TextBox", {

        BackgroundTransparency = 1,

        PlaceholderText =
            "Search all pages",

        PlaceholderColor3 =
            CONFIG.SubText,

        Text = "",

        TextColor3 =
            CONFIG.Text,

        TextSize = 11,

        Font =
            Enum.Font.Gotham,

        ClearTextOnFocus = false,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        Position =
            UDim2.new(
                0,
                15,
                0,
                0
            ),

        Size =
            UDim2.new(
                1,
                -30,
                1,
                0
            ),

        ZIndex = 152,

        Parent = SearchFrame
    })

SearchButton.MouseButton1Click:Connect(
    function()

        SearchFrame.Visible =
            not SearchFrame.Visible

        if SearchFrame.Visible then
            SearchBox:CaptureFocus()
        end

    end
)

--------------------------------------------------------
-- SETTINGS
--------------------------------------------------------

local SettingsPage =
    CreateTab(
        "Settings",
        "⚙"
    )

local HomePage
local ProfilePage

local KeepOnScreen = true

CreateSection(
    SettingsPage,
    "Interface"
)

CreateToggle(
    SettingsPage,
    {
        Name =
            "Keep window on screen",

        Default = true,

        Callback = function(value)

            KeepOnScreen = value

        end
    }
)

--------------------------------------------------------
-- WINDOW POSITION RESET
--------------------------------------------------------

local function ResetWindowPosition()

    local camera =
        workspace.CurrentCamera

    if not camera then
        return
    end

    local viewport =
        camera.ViewportSize

    local width =
        Window.AbsoluteSize.X

    local height =
        Window.AbsoluteSize.Y

    if width <= 0 then
        width = CONFIG.Width
    end

    if height <= 0 then
        height = CONFIG.Height
    end

    local x =
        viewport.X / 2
        - width / 2

    local y =
        viewport.Y / 2
        - height / 2

    Window.Position =
        UDim2.new(
            0.5,
            -width / 2,
            0.5,
            -height / 2
        )

    Shadow.Position =
        UDim2.new(
            0.5,
            -Shadow.AbsoluteSize.X / 2,
            0.5,
            -Shadow.AbsoluteSize.Y / 2
        )
end

CreateButton(
    SettingsPage,
    {
        Name =
            "Reset Window Position",

        Description =
            "Move the window back to the center.",

        Callback = function()

            ResetWindowPosition()

            WALLXP:Notify({
                Title = "WALLXP",
                Content =
                    "Window position reset."
            })

        end
    }
)

CreateSection(
    SettingsPage,
    "Display"
)

CreateToggle(
    SettingsPage,
    {
        Name =
            "Glass reflection",

        Default = true,

        Callback = function(value)

            TopHighlight.BackgroundTransparency =
                value
                and 0.86
                or 1

        end
    }
)

--------------------------------------------------------
-- SETTINGS BUTTON
--------------------------------------------------------

SettingsButton.MouseButton1Click:Connect(
    function()

        SelectTab("Settings")

    end
)

--------------------------------------------------------
-- PROFILE PAGE
--------------------------------------------------------

ProfilePage =
    CreateTab(
        "Profile",
        "●"
    )

CreateSection(
    ProfilePage,
    "Account"
)

CreateButton(
    ProfilePage,
    {
        Name =
            LocalPlayer.DisplayName,

        Description =
            "@" .. LocalPlayer.Name,

        Callback = function()

            WALLXP:Notify({
                Title = "Profile",

                Content =
                    "Hello, "
                    .. LocalPlayer.DisplayName
                    .. "!"
            })

        end
    }
)

CreateSection(
    ProfilePage,
    "Information"
)

CreateButton(
    ProfilePage,
    {
        Name =
            "User ID",

        Description =
            tostring(
                LocalPlayer.UserId
            ),

        Callback = function()
        end
    }
)

--------------------------------------------------------
-- HOME
--------------------------------------------------------

HomePage =
    CreateTab(
        "Home",
        "⌂"
    )

CreateSection(
    HomePage,
    "General"
)

CreateButton(
    HomePage,
    {
        Name =
            "Welcome to WALLXP",

        Description =
            "Liquid Glass UI Library",

        Callback = function()

            WALLXP:Notify({
                Title = "WALLXP",

                Content =
                    "Welcome to WALLXP v1.8.1!"
            })

        end
    }
)

CreateToggle(
    HomePage,
    {
        Name =
            "Example Toggle",

        Default = false,

        Callback = function(value)

            print(
                "Example Toggle:",
                value
            )

        end
    }
)

CreateSlider(
    HomePage,
    {
        Name =
            "Example Slider",

        Min = 0,

        Max = 100,

        Default = 50,

        Round = true,

        Callback = function(value)

            print(
                "Example Slider:",
                value
            )

        end
    }
)

CreateDropdown(
    HomePage,
    {
        Name =
            "Example Dropdown",

        Options = {
            "Option 1",
            "Option 2",
            "Option 3"
        },

        Default =
            "Option 1",

        Callback = function(value)

            print(
                "Selected:",
                value
            )

        end
    }
)

CreateInput(
    HomePage,
    {
        Name =
            "Example Input",

        Placeholder =
            "Type something...",

        Callback = function(value)

            print(
                "Input:",
                value
            )

        end
    }
)

CreateKeybind(
    HomePage,
    {
        Name =
            "Example Keybind",

        Default =
            Enum.KeyCode.RightShift,

        Callback = function()

            print(
                "Keybind pressed"
            )

        end
    }
)

--------------------------------------------------------
-- FLOATING RESTORE
--------------------------------------------------------

local Minimized = false

local Floating = New(
    "TextButton",
    {

        Name =
            "FloatingRestore",

        AutoButtonColor = false,

        Text = "",

        BackgroundColor3 =
            CONFIG.Background,

        BackgroundTransparency = 0.08,

        BorderSizePixel = 0,

        AnchorPoint =
            Vector2.new(
                0.5,
                0.5
            ),

        Position =
            UDim2.new(
                0.5,
                0,
                0,
                42
            ),

        Size =
            UDim2.new(
                0,
                150,
                0,
                48
            ),

        Visible = false,

        ClipsDescendants = false,

        ZIndex = 90,

        Parent = ScreenGui
    }
)

Corner(
    Floating,
    24
)

local FloatingGlow =
    New("Frame", {

        BackgroundColor3 =
            CONFIG.Accent,

        BackgroundTransparency =
            0.86,

        BorderSizePixel = 0,

        Position =
            UDim2.new(
                0,
                -4,
                0,
                -4
            ),

        Size =
            UDim2.new(
                1,
                8,
                1,
                8
            ),

        ZIndex = 88,

        Parent = Floating
    })

Corner(
    FloatingGlow,
    28
)

local FloatingStroke =
    Stroke(
        Floating,
        Color3.fromRGB(
            255,
            255,
            255
        ),
        0.48,
        1.25
    )

local FloatingInner =
    New("Frame", {

        BackgroundTransparency = 1,

        Position =
            UDim2.new(
                0,
                2,
                0,
                2
            ),

        Size =
            UDim2.new(
                1,
                -4,
                1,
                -4
            ),

        BorderSizePixel = 0,

        ZIndex = 91,

        Parent = Floating
    })

Corner(
    FloatingInner,
    22
)

Stroke(
    FloatingInner,
    CONFIG.Accent,
    0.84,
    1
)

Gradient(
    Floating,
    {
        ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(
                42,
                47,
                61
            )
        ),

        ColorSequenceKeypoint.new(
            0.5,
            Color3.fromRGB(
                21,
                24,
                32
            )
        ),

        ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(
                12,
                14,
                19
            )
        )
    },
    90
)

local FloatingScale =
    Instance.new("UIScale")

FloatingScale.Scale = 1

FloatingScale.Parent =
    Floating

--------------------------------------------------------
-- FLOATING REFLECTION
--------------------------------------------------------

local FloatingReflection =
    New("Frame", {

        BackgroundColor3 =
            Color3.fromRGB(
                255,
                255,
                255
            ),

        BackgroundTransparency = 0.9,

        BorderSizePixel = 0,

        Position =
            UDim2.new(
                0,
                10,
                0,
                6
            ),

        Size =
            UDim2.new(
                1,
                -20,
                0,
                2
            ),

        ZIndex = 94,

        Parent = Floating
    })

Corner(
    FloatingReflection,
    5
)

--------------------------------------------------------
-- FLOATING TEXT
--------------------------------------------------------

local FloatingTitle =
    New("TextLabel", {

        BackgroundTransparency = 1,

        Text =
            CONFIG.Name,

        TextColor3 =
            CONFIG.Text,

        TextSize = 12,

        Font =
            Enum.Font.GothamBold,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        Position =
            UDim2.new(
                0,
                15,
                0,
                8
            ),

        Size =
            UDim2.new(
                1,
                -30,
                0,
                17
            ),

        ZIndex = 95,

        Parent = Floating
    })

local FloatingSub =
    New("TextLabel", {

        BackgroundTransparency = 1,

        Text =
            "Tap to show",

        TextColor3 =
            CONFIG.SubText,

        TextSize = 9,

        Font =
            Enum.Font.Gotham,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        Position =
            UDim2.new(
                0,
                15,
                0,
                27
            ),

        Size =
            UDim2.new(
                1,
                -30,
                0,
                14
            ),

        ZIndex = 95,

        Parent = Floating
    })

--------------------------------------------------------
-- FLOATING PRESS
--------------------------------------------------------

local function FloatingPress()

    FloatingSub.Text =
        "Hold to move"

    Tween(
        FloatingScale,
        0.14,
        {
            Scale = 1.075
        },
        Enum.EasingStyle.Quad
    )

    Tween(
        FloatingStroke,
        0.14,
        {
            Transparency = 0.05,

            Color =
                CONFIG.Accent,

            Thickness = 1.7
        },
        Enum.EasingStyle.Quad
    )

    Tween(
        FloatingGlow,
        0.14,
        {
            BackgroundTransparency =
                0.68
        },
        Enum.EasingStyle.Quad
    )

    Tween(
        FloatingReflection,
        0.14,
        {
            BackgroundTransparency =
                0.72
        },
        Enum.EasingStyle.Quad
    )
end

local function FloatingRelease()

    FloatingSub.Text =
        "Tap to show"

    Spring(
        FloatingScale,
        0.34,
        {
            Scale = 1
        }
    )

    Tween(
        FloatingStroke,
        0.25,
        {
            Transparency = 0.48,

            Color =
                Color3.fromRGB(
                    255,
                    255,
                    255
                ),

            Thickness = 1.25
        }
    )

    Tween(
        FloatingGlow,
        0.25,
        {
            BackgroundTransparency =
                0.86
        }
    )

    Tween(
        FloatingReflection,
        0.25,
        {
            BackgroundTransparency =
                0.9
        }
    )
end

--------------------------------------------------------
-- FLOATING DRAG
-- FIXED
--------------------------------------------------------

local FloatingDragging = false
local FloatingMoved = false

local FloatingStartInput = nil
local FloatingStartPosition = nil

Floating.InputBegan:Connect(
    function(input)

        if not IsPointer(input) then
            return
        end

        FloatingDragging = true
        FloatingMoved = false

        FloatingStartInput =
            GetPointerPosition(
                input
            )

        FloatingStartPosition =
            Floating.Position

        FloatingPress()

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

        local currentPosition =
            GetPointerPosition(
                input
            )

        local delta =
            currentPosition
            - FloatingStartInput

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

        local camera =
            workspace.CurrentCamera

        if camera then

            local viewport =
                camera.ViewportSize

            local width =
                Floating.AbsoluteSize.X

            local height =
                Floating.AbsoluteSize.Y

            local halfWidth =
                width / 2

            local halfHeight =
                height / 2

            local centerX =
                viewport.X / 2
                + x

            local centerY =
                y

            local minX =
                halfWidth + 8

            local maxX =
                viewport.X
                - halfWidth
                - 8

            local minY =
                halfHeight + 8

            local maxY =
                viewport.Y
                - halfHeight
                - 8

            if minX > maxX then

                centerX =
                    viewport.X / 2

            else

                centerX =
                    math.clamp(
                        centerX,
                        minX,
                        maxX
                    )

            end

            if minY > maxY then

                centerY =
                    viewport.Y / 2

            else

                centerY =
                    math.clamp(
                        centerY,
                        minY,
                        maxY
                    )

            end

            x =
                centerX
                - viewport.X / 2

            y =
                centerY

        end

        Floating.Position =
            UDim2.new(
                0.5,
                x,
                0,
                y
            )

    end
)

--------------------------------------------------------
-- RESTORE
--------------------------------------------------------

local function Restore()

    if not Minimized then
        return
    end

    Minimized = false

    FloatingRelease()

    Tween(
        FloatingScale,
        0.18,
        {
            Scale = 0.88
        }
    )

    task.delay(
        0.08,
        function()

            if Floating.Parent then
                Floating.Visible = false
            end

            Window.Visible = true
            Shadow.Visible = true

            Window.Size =
                UDim2.new(
                    0,
                    CONFIG.Width - 20,
                    0,
                    70
                )

            Shadow.Size =
                UDim2.new(
                    0,
                    CONFIG.Width,
                    0,
                    90
                )

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
                        )
                },
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            )

            Tween(
                Shadow,
                0.38,
                {
                    Size =
                        UDim2.new(
                            0,
                            CONFIG.Width + 28,
                            0,
                            CONFIG.Height + 28
                        )
                },
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            )

            Tween(
                FloatingScale,
                0.25,
                {
                    Scale = 1
                }
            )

        end
    )
end

--------------------------------------------------------
-- FLOATING INPUT END
--------------------------------------------------------

UserInputService.InputEnded:Connect(
    function(input)

        if not FloatingDragging then
            return
        end

        if not IsPointer(input) then
            return
        end

        FloatingDragging = false

        FloatingRelease()

        if not FloatingMoved then

            task.delay(
                0.08,
                function()

                    if Minimized then
                        Restore()
                    end

                end
            )

        end

        FloatingStartInput = nil
        FloatingStartPosition = nil

    end
)

--------------------------------------------------------
-- MINIMIZE
--------------------------------------------------------

local function Minimize()

    if Minimized then
        return
    end

    Minimized = true

    Tween(
        Window,
        0.28,
        {
            Size =
                UDim2.new(
                    0,
                    CONFIG.Width,
                    0,
                    70
                )
        },
        Enum.EasingStyle.Quart
    )

    Tween(
        Shadow,
        0.28,
        {
            Size =
                UDim2.new(
                    0,
                    CONFIG.Width + 20,
                    0,
                    90
                )
        }
    )

    task.delay(
        0.28,
        function()

            if not Window.Parent then
                return
            end

            Window.Visible = false
            Shadow.Visible = false

            Floating.Visible = true

            FloatingScale.Scale =
                0.65

            Spring(
                FloatingScale,
                0.48,
                {
                    Scale = 1
                }
            )

            Tween(
                FloatingGlow,
                0.3,
                {
                    BackgroundTransparency =
                        0.8
                }
            )

        end
    )
end

MinimizeButton.MouseButton1Click:Connect(
    Minimize
)

--------------------------------------------------------
-- WINDOW DRAG
-- v1.8.1 FIX
--------------------------------------------------------

local WindowDragging = false

local WindowStartInput = nil
local WindowStartPosition = nil

local function ClampWindowPosition(
    x,
    y
)

    if not KeepOnScreen then
        return x, y
    end

    local camera =
        workspace.CurrentCamera

    if not camera then
        return x, y
    end

    local viewport =
        camera.ViewportSize

    local width =
        Window.AbsoluteSize.X

    local height =
        Window.AbsoluteSize.Y

    if width <= 0
        or height <= 0 then

        return x, y
    end

    local halfWidth =
        width / 2

    local halfHeight =
        height / 2

    local centerX =
        viewport.X / 2 + x

    local centerY =
        viewport.Y / 2 + y

    local minX =
        halfWidth + 5

    local maxX =
        viewport.X
        - halfWidth
        - 5

    local minY =
        halfHeight + 5

    local maxY =
        viewport.Y
        - halfHeight
        - 5

    ----------------------------------------------------
    -- IMPORTANT:
    -- ถ้า Window ใหญ่กว่าหน้าจอ
    -- ห้ามใช้ math.clamp()
    -- เพราะ min > max
    ----------------------------------------------------

    if minX > maxX then

        centerX =
            viewport.X / 2

    else

        centerX =
            math.clamp(
                centerX,
                minX,
                maxX
            )

    end

    if minY > maxY then

        centerY =
            viewport.Y / 2

    else

        centerY =
            math.clamp(
                centerY,
                minY,
                maxY
            )

    end

    return
        centerX - viewport.X / 2,
        centerY - viewport.Y / 2
end

Header.InputBegan:Connect(
    function(input)

        if not IsPointer(input) then
            return
        end

        WindowDragging = true

        WindowStartInput =
            GetPointerPosition(
                input
            )

        WindowStartPosition =
            Window.Position

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

        local currentPosition =
            GetPointerPosition(
                input
            )

        local delta =
            currentPosition
            - WindowStartInput

        local x =
            WindowStartPosition.X.Offset
            + delta.X

        local y =
            WindowStartPosition.Y.Offset
            + delta.Y

        x, y =
            ClampWindowPosition(
                x,
                y
            )

        Window.Position =
            UDim2.new(
                0.5,
                x,
                0.5,
                y
            )

        Shadow.Position =
            UDim2.new(
                0.5,
                x,
                0.5,
                y
            )

    end
)

UserInputService.InputEnded:Connect(
    function(input)

        if input.UserInputType
            == Enum.UserInputType.MouseButton1
            or input.UserInputType
            == Enum.UserInputType.Touch then

            WindowDragging = false

            WindowStartInput = nil
            WindowStartPosition = nil

        end

    end
)

--------------------------------------------------------
-- PUBLIC API
--------------------------------------------------------

function WALLXP:CreateWindow(
    options
)

    options = options or {}

    if options.Name then

        CONFIG.Name =
            options.Name

        Title.Text =
            options.Name

        FloatingTitle.Text =
            options.Name

    end

    if options.Subtitle then

        CONFIG.Subtitle =
            options.Subtitle

        Subtitle.Text =
            options.Subtitle

    end

    return {

        CreateTab =
            function(_, name, icon)

                local page =
                    CreateTab(
                        name,
                        icon
                    )

                return {

                    CreateSection =
                        function(_, text)

                            return CreateSection(
                                page,
                                text
                            )

                        end,

                    CreateButton =
                        function(_, data)

                            return CreateButton(
                                page,
                                data
                            )

                        end,

                    CreateToggle =
                        function(_, data)

                            return CreateToggle(
                                page,
                                data
                            )

                        end,

                    CreateSlider =
                        function(_, data)

                            return CreateSlider(
                                page,
                                data
                            )

                        end,

                    CreateDropdown =
                        function(_, data)

                            return CreateDropdown(
                                page,
                                data
                            )

                        end,

                    CreateInput =
                        function(_, data)

                            return CreateInput(
                                page,
                                data
                            )

                        end,

                    CreateKeybind =
                        function(_, data)

                            return CreateKeybind(
                                page,
                                data
                            )

                        end
                }

            end,

        Minimize =
            Minimize,

        Restore =
            Restore,

        Notify =
            function(_, data)

                WALLXP:Notify(data)

            end
    }
end

--------------------------------------------------------
-- DEFAULT TAB
--------------------------------------------------------

SelectTab("Home")

--------------------------------------------------------
-- INITIAL POSITION
--------------------------------------------------------

local function CenterWindow()

    local camera =
        workspace.CurrentCamera

    if not camera then
        return
    end

    local viewport =
        camera.ViewportSize

    local width =
        math.min(
            CONFIG.Width,
            math.max(
                260,
                viewport.X - 20
            )
        )

    local height =
        math.min(
            CONFIG.Height,
            math.max(
                220,
                viewport.Y - 20
            )
        )

    -- ถ้าจอเล็กมาก ให้ใช้ขนาดเดิม
    -- แต่ไม่ปล่อยตำแหน่งติดขอบ

    Window.Position =
        UDim2.new(
            0.5,
            -width / 2,
            0.5,
            -height / 2
        )

    Shadow.Position =
        UDim2.new(
            0.5,
            -(
                width + 28
            ) / 2,
            0.5,
            -(
                height + 28
            ) / 2
        )
end

CenterWindow()

--------------------------------------------------------
-- OPEN ANIMATION
--------------------------------------------------------

Window.Size =
    UDim2.new(
        0,
        CONFIG.Width - 35,
        0,
        CONFIG.Height - 35
    )

Shadow.Size =
    UDim2.new(
        0,
        CONFIG.Width - 5,
        0,
        CONFIG.Height - 5
    )

Window.Visible = true
Shadow.Visible = true

Tween(
    Window,
    0.45,
    {
        Size =
            UDim2.new(
                0,
                CONFIG.Width,
                0,
                CONFIG.Height
            )
    },
    Enum.EasingStyle.Back,
    Enum.EasingDirection.Out
)

Tween(
    Shadow,
    0.45,
    {
        Size =
            UDim2.new(
                0,
                CONFIG.Width + 28,
                0,
                CONFIG.Height + 28
            )
    },
    Enum.EasingStyle.Back,
    Enum.EasingDirection.Out
)

--------------------------------------------------------
-- START NOTIFICATION
--------------------------------------------------------

task.delay(
    0.55,
    function()

        WALLXP:Notify({
            Title =
                "WALLXP v1.8.1",

            Content =
                "Liquid Glass UI loaded successfully.",

            Duration = 3
        })

    end
)

--------------------------------------------------------
-- RETURN
--------------------------------------------------------

return WALLXP
