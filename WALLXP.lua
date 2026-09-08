--[[
    WALLXP v1.8.3
    Liquid Glass UI
    Single File
    UI / UX ONLY

    Changes:
    - Stable Open / Close system
    - Floating Toggle button
    - PC + Mobile drag
    - Window can move outside screen bounds
    - Stable Minimize / Restore
    - Drag does not interfere with buttons
    - Safer tween handling
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

    SidebarWidth = 145,
    TopbarHeight = 72,

    Corner = 22,
    SmallCorner = 14,

    Animation = 0.22,

    Accent = Color3.fromRGB(55, 160, 255),

    Background = Color3.fromRGB(13, 16, 23),
    Background2 = Color3.fromRGB(18, 23, 32),

    Sidebar = Color3.fromRGB(11, 14, 20),

    Card = Color3.fromRGB(23, 28, 38),
    Card2 = Color3.fromRGB(27, 33, 44),

    Text = Color3.fromRGB(245, 248, 255),
    SubText = Color3.fromRGB(145, 154, 170),

    Border = Color3.fromRGB(75, 90, 110),
}

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------

local function New(className, properties)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        pcall(function()
            object[property] = value
        end)
    end

    return object
end

local function Corner(parent, radius)
    return New("UICorner", {
        CornerRadius = UDim.new(0, radius or CONFIG.SmallCorner),
        Parent = parent
    })
end

local function Stroke(parent, color, transparency, thickness)
    return New("UIStroke", {
        Color = color or CONFIG.Border,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function Gradient(parent, color1, color2, rotation)
    return New("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1),
            ColorSequenceKeypoint.new(1, color2)
        }),
        Rotation = rotation or 90,
        Parent = parent
    })
end

local function Tween(object, time, properties, style, direction)
    if not object or not object.Parent then
        return nil
    end

    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            time or CONFIG.Animation,
            style or Enum.EasingStyle.Quint,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )

    tween:Play()

    return tween
end

local function IsPointer(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

local function IsMoveInput(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
end

----------------------------------------------------------------
-- CLEAN OLD UI
----------------------------------------------------------------

pcall(function()
    local old = game:GetService("CoreGui"):FindFirstChild("WALLXP")
    if old then
        old:Destroy()
    end
end)

pcall(function()
    local old = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("WALLXP")
    if old then
        old:Destroy()
    end
end)

----------------------------------------------------------------
-- SCREEN GUI
----------------------------------------------------------------

local ScreenGui = New("ScreenGui", {
    Name = "WALLXP",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local guiParent

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
    guiParent = ScreenGui
end)

if not guiParent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

----------------------------------------------------------------
-- MAIN STATE
----------------------------------------------------------------

local WindowVisible = true
local WindowMinimized = false

local WindowPosition = UDim2.new(
    0.5,
    -CONFIG.Width / 2,
    0.5,
    -CONFIG.Height / 2
)

----------------------------------------------------------------
-- WINDOW
----------------------------------------------------------------

local Shadow = New("Frame", {
    Name = "Shadow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = WindowPosition,
    Size = UDim2.new(0, CONFIG.Width + 22, 0, CONFIG.Height + 22),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.58,
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = ScreenGui
})

Corner(Shadow, CONFIG.Corner + 4)

local Window = New("Frame", {
    Name = "Window",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = WindowPosition,
    Size = UDim2.new(0, CONFIG.Width, 0, CONFIG.Height),
    BackgroundColor3 = CONFIG.Background,
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 10,
    Parent = ScreenGui
})

Corner(Window, CONFIG.Corner)
Stroke(Window, CONFIG.Border, 0.35, 1)

Gradient(
    Window,
    CONFIG.Background,
    CONFIG.Background2,
    135
)

----------------------------------------------------------------
-- TOP HIGHLIGHT
----------------------------------------------------------------

local TopHighlight = New("Frame", {
    Name = "TopHighlight",
    Size = UDim2.new(1, -30, 0, 1),
    Position = UDim2.new(0, 15, 0, 1),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.88,
    BorderSizePixel = 0,
    ZIndex = 20,
    Parent = Window
})

Corner(TopHighlight, 1)

----------------------------------------------------------------
-- SIDEBAR
----------------------------------------------------------------

local Sidebar = New("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, CONFIG.SidebarWidth, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = CONFIG.Sidebar,
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
    ZIndex = 11,
    Parent = Window
})

----------------------------------------------------------------
-- HEADER
----------------------------------------------------------------

local Header = New("Frame", {
    Name = "Header",
    Size = UDim2.new(
        1,
        -CONFIG.SidebarWidth,
        0,
        CONFIG.TopbarHeight
    ),
    Position = UDim2.new(
        0,
        CONFIG.SidebarWidth,
        0,
        0
    ),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 15,
    Parent = Window
})

----------------------------------------------------------------
-- TITLE
----------------------------------------------------------------

local Title = New("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -190, 0, 28),
    Position = UDim2.new(0, 22, 0, 12),
    BackgroundTransparency = 1,
    Text = CONFIG.Name,
    TextColor3 = CONFIG.Text,
    TextSize = 22,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 16,
    Parent = Header
})

local Subtitle = New("TextLabel", {
    Name = "Subtitle",
    Size = UDim2.new(1, -190, 0, 18),
    Position = UDim2.new(0, 23, 0, 39),
    BackgroundTransparency = 1,
    Text = CONFIG.Subtitle,
    TextColor3 = CONFIG.SubText,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 16,
    Parent = Header
})

----------------------------------------------------------------
-- HEADER BUTTON FACTORY
----------------------------------------------------------------

local function HeaderButton(text, position)
    local button = New("TextButton", {
        Size = UDim2.new(0, 38, 0, 38),
        Position = position,
        BackgroundColor3 = CONFIG.Card,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = CONFIG.Text,
        TextSize = 18,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
        ZIndex = 30,
        Parent = Header
    })

    Corner(button, 11)
    Stroke(button, CONFIG.Border, 0.55, 1)

    button.MouseEnter:Connect(function()
        Tween(button, 0.12, {
            BackgroundTransparency = 0
        })
    end)

    button.MouseLeave:Connect(function()
        Tween(button, 0.12, {
            BackgroundTransparency = 0.15
        })
    end)

    return button
end

local SearchButton = HeaderButton(
    "⌕",
    UDim2.new(1, -142, 0, 17)
)

local SettingsButton = HeaderButton(
    "⚙",
    UDim2.new(1, -96, 0, 17)
)

local MinimizeButton = HeaderButton(
    "−",
    UDim2.new(1, -50, 0, 17)
)

----------------------------------------------------------------
-- CONTENT
----------------------------------------------------------------

local Content = New("Frame", {
    Name = "Content",
    Size = UDim2.new(
        1,
        -CONFIG.SidebarWidth,
        1,
        -CONFIG.TopbarHeight
    ),
    Position = UDim2.new(
        0,
        CONFIG.SidebarWidth,
        0,
        CONFIG.TopbarHeight
    ),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 12,
    Parent = Window
})

----------------------------------------------------------------
-- PROFILE
----------------------------------------------------------------

local Profile = New("Frame", {
    Name = "Profile",
    Size = UDim2.new(1, -22, 0, 64),
    Position = UDim2.new(0, 11, 0, 12),
    BackgroundColor3 = CONFIG.Card,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ZIndex = 20,
    Parent = Sidebar
})

Corner(Profile, 15)
Stroke(Profile, CONFIG.Border, 0.6, 1)

local Avatar = New("ImageLabel", {
    Name = "Avatar",
    Size = UDim2.new(0, 42, 0, 42),
    Position = UDim2.new(0, 9, 0.5, -21),
    BackgroundColor3 = CONFIG.Card2,
    BorderSizePixel = 0,
    Image = "rbxthumb://type=AvatarHeadShot&id=" ..
        tostring(LocalPlayer.UserId) ..
        "&w=180&h=180",
    ZIndex = 21,
    Parent = Profile
})

Corner(Avatar, 12)

local DisplayName = New("TextLabel", {
    Size = UDim2.new(1, -62, 0, 20),
    Position = UDim2.new(0, 59, 0, 11),
    BackgroundTransparency = 1,
    Text = LocalPlayer.DisplayName,
    TextColor3 = CONFIG.Text,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    ZIndex = 21,
    Parent = Profile
})

local Username = New("TextLabel", {
    Size = UDim2.new(1, -62, 0, 18),
    Position = UDim2.new(0, 59, 0, 31),
    BackgroundTransparency = 1,
    Text = "@" .. LocalPlayer.Name,
    TextColor3 = CONFIG.SubText,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    ZIndex = 21,
    Parent = Profile
})

----------------------------------------------------------------
-- TAB CONTAINER
----------------------------------------------------------------

local TabContainer = New("ScrollingFrame", {
    Name = "Tabs",
    Size = UDim2.new(1, -18, 1, -95),
    Position = UDim2.new(0, 9, 0, 86),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageTransparency = 0.7,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 20,
    Parent = Sidebar
})

local TabLayout = New("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = TabContainer
})

----------------------------------------------------------------
-- PAGES
----------------------------------------------------------------

local Pages = {}
local Tabs = {}
local CurrentPage = nil
local CurrentTab = nil

local function CreatePage(name)
    local page = New("ScrollingFrame", {
        Name = name .. "Page",
        Size = UDim2.new(1, -24, 1, -20),
        Position = UDim2.new(0, 12, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageTransparency = 0.65,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ZIndex = 15,
        Parent = Content
    })

    local layout = New("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page
    })

    New("UIPadding", {
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 10),
        Parent = page
    })

    Pages[name] = page

    return page
end

local function SelectTab(name)
    local page = Pages[name]
    local tab = Tabs[name]

    if not page or not tab then
        return
    end

    if CurrentPage then
        CurrentPage.Visible = false
    end

    if CurrentTab then
        Tween(CurrentTab, 0.14, {
            BackgroundTransparency = 1
        })

        local oldStroke = CurrentTab:FindFirstChildOfClass("UIStroke")

        if oldStroke then
            oldStroke.Transparency = 1
        end
    end

    page.Visible = true

    Tween(tab, 0.14, {
        BackgroundTransparency = 0.15
    })

    local newStroke = tab:FindFirstChildOfClass("UIStroke")

    if newStroke then
        newStroke.Transparency = 0.35
    end

    CurrentPage = page
    CurrentTab = tab
end

local function CreateTab(name, icon)
    local page = CreatePage(name)

    local tab = New("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = CONFIG.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 25,
        Parent = TabContainer
    })

    Corner(tab, 12)
    local tabStroke = Stroke(tab, CONFIG.Accent, 1, 1)

    local iconLabel = New("TextLabel", {
        Size = UDim2.new(0, 32, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text = icon or "•",
        TextColor3 = CONFIG.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        ZIndex = 26,
        Parent = tab
    })

    local textLabel = New("TextLabel", {
        Size = UDim2.new(1, -45, 1, 0),
        Position = UDim2.new(0, 42, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = CONFIG.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 26,
        Parent = tab
    })

    tab.MouseButton1Click:Connect(function()
        SelectTab(name)
    end)

    tab.MouseEnter:Connect(function()
        if CurrentTab ~= tab then
            Tween(tab, 0.12, {
                BackgroundTransparency = 0.65
            })
        end
    end)

    tab.MouseLeave:Connect(function()
        if CurrentTab ~= tab then
            Tween(tab, 0.12, {
                BackgroundTransparency = 1
            })
        end
    end)

    Tabs[name] = tab

    return page
end

----------------------------------------------------------------
-- ELEMENT FACTORY
----------------------------------------------------------------

local function ElementFrame(parent, height)
    return New("Frame", {
        Size = UDim2.new(1, -4, 0, height),
        BackgroundColor3 = CONFIG.Card,
        BackgroundTransparency = 0.18,
        BorderSizePixel = 0,
        ZIndex = 20,
        Parent = parent
    })
end

----------------------------------------------------------------
-- SECTION
----------------------------------------------------------------

local function CreateSection(parent, text)
    local frame = ElementFrame(parent, 32)

    local label = New("TextLabel", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21,
        Parent = frame
    })

    return frame
end

----------------------------------------------------------------
-- BUTTON
----------------------------------------------------------------

local function CreateButton(parent, text, callback)
    local frame = ElementFrame(parent, 46)
    Corner(frame, 13)
    Stroke(frame, CONFIG.Border, 0.68, 1)

    local button = New("TextButton", {
        Size = UDim2.new(1, -12, 1, -12),
        Position = UDim2.new(0, 6, 0, 6),
        BackgroundColor3 = CONFIG.Card2,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Text = text,
        TextColor3 = CONFIG.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
        ZIndex = 22,
        Parent = frame
    })

    Corner(button, 10)

    button.MouseEnter:Connect(function()
        Tween(button, 0.12, {
            BackgroundColor3 = CONFIG.Accent
        })
    end)

    button.MouseLeave:Connect(function()
        Tween(button, 0.12, {
            BackgroundColor3 = CONFIG.Card2
        })
    end)

    button.MouseButton1Click:Connect(function()
        if typeof(callback) == "function" then
            task.spawn(callback)
        end
    end)

    return frame
end

----------------------------------------------------------------
-- TOGGLE
----------------------------------------------------------------

local function CreateToggle(parent, text, default, callback)
    local state = default == true

    local frame = ElementFrame(parent, 50)

    Corner(frame, 13)
    Stroke(frame, CONFIG.Border, 0.68, 1)

    local label = New("TextLabel", {
        Size = UDim2.new(1, -75, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21,
        Parent = frame
    })

    local button = New("TextButton", {
        Size = UDim2.new(0, 48, 0, 26),
        Position = UDim2.new(1, -60, 0.5, -13),
        BackgroundColor3 = CONFIG.Card2,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 22,
        Parent = frame
    })

    Corner(button, 13)

    local knob = New("Frame", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 3, 0.5, -10),
        BackgroundColor3 = CONFIG.SubText,
        BorderSizePixel = 0,
        ZIndex = 23,
        Parent = button
    })

    Corner(knob, 10)

    local function Update(fire)
        if state then
            Tween(button, 0.16, {
                BackgroundColor3 = CONFIG.Accent
            })

            Tween(knob, 0.16, {
                Position = UDim2.new(1, -23, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })
        else
            Tween(button, 0.16, {
                BackgroundColor3 = CONFIG.Card2
            })

            Tween(knob, 0.16, {
                Position = UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = CONFIG.SubText
            })
        end

        if fire and typeof(callback) == "function" then
            task.spawn(callback, state)
        end
    end

    button.MouseButton1Click:Connect(function()
        state = not state
        Update(true)
    end)

    Update(false)

    return {
        Set = function(value)
            state = value == true
            Update(true)
        end,

        Get = function()
            return state
        end
    }
end

----------------------------------------------------------------
-- SLIDER
----------------------------------------------------------------

local function CreateSlider(parent, text, min, max, default, callback)
    min = tonumber(min) or 0
    max = tonumber(max) or 100

    if max < min then
        min, max = max, min
    end

    local value = math.clamp(
        tonumber(default) or min,
        min,
        max
    )

    local frame = ElementFrame(parent, 65)

    Corner(frame, 13)
    Stroke(frame, CONFIG.Border, 0.68, 1)

    local label = New("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20),
        Position = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21,
        Parent = frame
    })

    local valueLabel = New("TextLabel", {
        Size = UDim2.new(0, 55, 0, 20),
        Position = UDim2.new(1, -68, 0, 8),
        BackgroundTransparency = 1,
        TextColor3 = CONFIG.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 21,
        Parent = frame
    })

    local bar = New("Frame", {
        Size = UDim2.new(1, -28, 0, 6),
        Position = UDim2.new(0, 14, 0, 42),
        BackgroundColor3 = CONFIG.Card2,
        BorderSizePixel = 0,
        ZIndex = 21,
        Parent = frame
    })

    Corner(bar, 5)

    local fill = New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = CONFIG.Accent,
        BorderSizePixel = 0,
        ZIndex = 22,
        Parent = bar
    })

    Corner(fill, 5)

    local dragging = false

    local function SetValueFromX(x, fire)
        local width = math.max(bar.AbsoluteSize.X, 1)
        local relative = math.clamp(
            (x - bar.AbsolutePosition.X) / width,
            0,
            1
        )

        value = min + ((max - min) * relative)

        if max - min > 0 then
            value = math.floor(value + 0.5)
        else
            value = min
        end

        local percent = 0

        if max ~= min then
            percent = (value - min) / (max - min)
        end

        Tween(fill, 0.08, {
            Size = UDim2.new(percent, 0, 1, 0)
        })

        valueLabel.Text = tostring(value)

        if fire and typeof(callback) == "function" then
            task.spawn(callback, value)
        end
    end

    bar.InputBegan:Connect(function(input)
        if IsPointer(input) then
            dragging = true
            SetValueFromX(
                input.Position.X,
                true
            )
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and IsMoveInput(input) then
            SetValueFromX(
                input.Position.X,
                true
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if IsPointer(input) then
            dragging = false
        end
    end)

    local initialPercent = 0

    if max ~= min then
        initialPercent = (value - min) / (max - min)
    end

    fill.Size = UDim2.new(initialPercent, 0, 1, 0)
    valueLabel.Text = tostring(value)

    return {
        Set = function(newValue)
            value = math.clamp(
                tonumber(newValue) or min,
                min,
                max
            )

            SetValueFromX(
                bar.AbsolutePosition.X +
                ((value - min) / math.max(max - min, 1)) *
                math.max(bar.AbsoluteSize.X, 1),
                true
            )
        end,

        Get = function()
            return value
        end
    }
end

----------------------------------------------------------------
-- DROPDOWN
----------------------------------------------------------------

local function CreateDropdown(parent, text, items, default, callback)
    items = items or {}

    local selected = default
    local opened = false

    local frame = ElementFrame(parent, 48)

    Corner(frame, 13)
    Stroke(frame, CONFIG.Border, 0.68, 1)

    local button = New("TextButton", {
        Size = UDim2.new(1, -12, 1, -12),
        Position = UDim2.new(0, 6, 0, 6),
        BackgroundColor3 = CONFIG.Card2,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 25,
        Parent = frame
    })

    Corner(button, 10)

    local titleLabel = New("TextLabel", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 26,
        Parent = button
    })

    local selectedLabel = New("TextLabel", {
        Size = UDim2.new(0.5, -12, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(selected or "Select"),
        TextColor3 = CONFIG.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 26,
        Parent = button
    })

    local optionsFrame = New("Frame", {
        Size = UDim2.new(1, -12, 0, 0),
        Position = UDim2.new(0, 6, 0, 53),
        BackgroundColor3 = CONFIG.Card2,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 100,
        Parent = frame
    })

    Corner(optionsFrame, 11)
    Stroke(optionsFrame, CONFIG.Border, 0.5, 1)

    local list = New("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = optionsFrame
    })

    New("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        Parent = optionsFrame
    })

    local function Close()
        opened = false

        Tween(optionsFrame, 0.15, {
            Size = UDim2.new(1, -12, 0, 0)
        })

        task.delay(0.16, function()
            if not opened and optionsFrame.Parent then
                optionsFrame.Visible = false
            end
        end)
    end

    local function Open()
        opened = true
        optionsFrame.Visible = true

        local height = math.max(
            40,
            (#items * 32) + 10
        )

        Tween(optionsFrame, 0.18, {
            Size = UDim2.new(1, -12, 0, height)
        })
    end

    for index, item in ipairs(items) do
        local option = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = CONFIG.Card,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            Text = tostring(item),
            TextColor3 = CONFIG.Text,
            TextSize = 11,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false,
            LayoutOrder = index,
            ZIndex = 101,
            Parent = optionsFrame
        })

        Corner(option, 8)

        option.MouseButton1Click:Connect(function()
            selected = item
            selectedLabel.Text = tostring(item)

            Close()

            if typeof(callback) == "function" then
                task.spawn(callback, item)
            end
        end)
    end

    button.MouseButton1Click:Connect(function()
        if opened then
            Close()
        else
            Open()
        end
    end)

    return {
        Set = function(item)
            selected = item
            selectedLabel.Text = tostring(item)

            if typeof(callback) == "function" then
                task.spawn(callback, item)
            end
        end,

        Get = function()
            return selected
        end
    }
end

----------------------------------------------------------------
-- INPUT
----------------------------------------------------------------

local function CreateInput(parent, text, placeholder, callback)
    local frame = ElementFrame(parent, 62)

    Corner(frame, 13)
    Stroke(frame, CONFIG.Border, 0.68, 1)

    local label = New("TextLabel", {
        Size = UDim2.new(1, -25, 0, 18),
        Position = UDim2.new(0, 13, 0, 7),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.Text,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21,
        Parent = frame
    })

    local box = New("TextBox", {
        Size = UDim2.new(1, -24, 0, 27),
        Position = UDim2.new(0, 12, 0, 29),
        BackgroundColor3 = CONFIG.Card2,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        PlaceholderText = placeholder or "",
        PlaceholderColor3 = CONFIG.SubText,
        Text = "",
        TextColor3 = CONFIG.Text,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        ZIndex = 22,
        Parent = frame
    })

    Corner(box, 9)

    box.FocusLost:Connect(function(enterPressed)
        if typeof(callback) == "function" then
            task.spawn(callback, box.Text, enterPressed)
        end
    end)

    return box
end

----------------------------------------------------------------
-- KEYBIND
----------------------------------------------------------------

local function CreateKeybind(parent, text, defaultKey, callback)
    local currentKey = defaultKey or Enum.KeyCode.RightShift
    local listening = false

    local frame = ElementFrame(parent, 48)

    Corner(frame, 13)
    Stroke(frame, CONFIG.Border, 0.68, 1)

    local label = New("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21,
        Parent = frame
    })

    local button = New("TextButton", {
        Size = UDim2.new(0, 75, 0, 28),
        Position = UDim2.new(1, -87, 0.5, -14),
        BackgroundColor3 = CONFIG.Card2,
        BorderSizePixel = 0,
        Text = currentKey.Name,
        TextColor3 = CONFIG.Accent,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 22,
        Parent = frame
    })

    Corner(button, 9)

    button.MouseButton1Click:Connect(function()
        listening = true
        button.Text = "Press key..."
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false

            currentKey = input.KeyCode
            button.Text = currentKey.Name
        end

        if not processed and input.KeyCode == currentKey then
            if typeof(callback) == "function" then
                task.spawn(callback)
            end
        end
    end)

    return {
        Set = function(key)
            if typeof(key) == "EnumItem" then
                currentKey = key
                button.Text = key.Name
            end
        end,

        Get = function()
            return currentKey
        end
    }
end

----------------------------------------------------------------
-- HOME
----------------------------------------------------------------

local HomePage = CreateTab("Home", "⌂")

CreateSection(HomePage, "WALLXP")

CreateButton(HomePage, "Test Button", function()
    WALLXP:Notify(
        "WALLXP",
        "Button works correctly."
    )
end)

CreateToggle(
    HomePage,
    "Example Toggle",
    false,
    function(value)
        WALLXP:Notify(
            "Toggle",
            value and "Enabled" or "Disabled"
        )
    end
)

CreateSlider(
    HomePage,
    "Example Slider",
    0,
    100,
    50,
    function(value)
        -- callback
    end
)

CreateDropdown(
    HomePage,
    "Example Dropdown",
    {
        "Option 1",
        "Option 2",
        "Option 3"
    },
    "Option 1",
    function(value)
        WALLXP:Notify(
            "Dropdown",
            "Selected: " .. tostring(value)
        )
    end
)

CreateInput(
    HomePage,
    "Example Input",
    "Type something...",
    function(text)
        if text ~= "" then
            WALLXP:Notify(
                "Input",
                text
            )
        end
    end
)

CreateKeybind(
    HomePage,
    "Toggle UI Key",
    Enum.KeyCode.RightShift,
    function()
        WALLXP:SetVisible(not WindowVisible)
    end
)

----------------------------------------------------------------
-- PROFILE PAGE
----------------------------------------------------------------

local ProfilePage = CreateTab("Profile", "●")

CreateSection(ProfilePage, "PROFILE")

CreateButton(
    ProfilePage,
    "Display Name : " .. LocalPlayer.DisplayName,
    function() end
)

CreateButton(
    ProfilePage,
    "Username : @" .. LocalPlayer.Name,
    function() end
)

CreateButton(
    ProfilePage,
    "UserId : " .. tostring(LocalPlayer.UserId),
    function() end
)

----------------------------------------------------------------
-- SETTINGS PAGE
----------------------------------------------------------------

local SettingsPage = CreateTab("Settings", "⚙")

CreateSection(SettingsPage, "WINDOW")

CreateToggle(
    SettingsPage,
    "Keep On Screen",
    false,
    function(value)
        -- false = can move outside screen
    end
)

CreateButton(
    SettingsPage,
    "Reset Window Position",
    function()
        WindowPosition = UDim2.new(
            0.5,
            -CONFIG.Width / 2,
            0.5,
            -CONFIG.Height / 2
        )

        Tween(Window, 0.3, {
            Position = WindowPosition
        })

        Tween(Shadow, 0.3, {
            Position = WindowPosition
        })
    end
)

----------------------------------------------------------------
-- SEARCH
----------------------------------------------------------------

local SearchFrame = New("Frame", {
    Name = "SearchFrame",
    Size = UDim2.new(0, 210, 0, 40),
    Position = UDim2.new(1, -350, 0, 16),
    BackgroundColor3 = CONFIG.Card,
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 50,
    Parent = Header
})

Corner(SearchFrame, 11)
Stroke(SearchFrame, CONFIG.Border, 0.45, 1)

local SearchBox = New("TextBox", {
    Size = UDim2.new(1, -16, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    PlaceholderText = "Search...",
    PlaceholderColor3 = CONFIG.SubText,
    Text = "",
    TextColor3 = CONFIG.Text,
    TextSize = 12,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false,
    ZIndex = 51,
    Parent = SearchFrame
})

SearchButton.MouseButton1Click:Connect(function()
    SearchFrame.Visible = not SearchFrame.Visible

    if SearchFrame.Visible then
        SearchBox:CaptureFocus()
    else
        SearchBox:ReleaseFocus()
    end
end)

----------------------------------------------------------------
-- NOTIFICATION
----------------------------------------------------------------

local NotificationContainer = New("Frame", {
    Name = "Notifications",
    Size = UDim2.new(0, 290, 1, -30),
    Position = UDim2.new(1, -305, 0, 15),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 500,
    Parent = ScreenGui
})

local NotificationLayout = New("UIListLayout", {
    Padding = UDim.new(0, 8),
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Top,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = NotificationContainer
})

function WALLXP:Notify(title, message, duration)
    duration = tonumber(duration) or 3

    local notification = New("Frame", {
        Size = UDim2.new(0, 280, 0, 64),
        BackgroundColor3 = CONFIG.Card,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ZIndex = 501,
        Parent = NotificationContainer
    })

    Corner(notification, 14)
    Stroke(notification, CONFIG.Border, 0.45, 1)

    local accent = New("Frame", {
        Size = UDim2.new(0, 4, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = CONFIG.Accent,
        BorderSizePixel = 0,
        ZIndex = 502,
        Parent = notification
    })

    Corner(accent, 3)

    local titleLabel = New("TextLabel", {
        Size = UDim2.new(1, -32, 0, 20),
        Position = UDim2.new(0, 22, 0, 8),
        BackgroundTransparency = 1,
        Text = tostring(title or "WALLXP"),
        TextColor3 = CONFIG.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 502,
        Parent = notification
    })

    local messageLabel = New("TextLabel", {
        Size = UDim2.new(1, -32, 0, 26),
        Position = UDim2.new(0, 22, 0, 29),
        BackgroundTransparency = 1,
        Text = tostring(message or ""),
        TextColor3 = CONFIG.SubText,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        ZIndex = 502,
        Parent = notification
    })

    notification.Position = UDim2.new(
        1,
        30,
        0,
        0
    )

    Tween(notification, 0.25, {
        Position = UDim2.new(
            0,
            0,
            0,
            0
        )
    })

    task.delay(duration, function()
        if notification and notification.Parent then
            local out = Tween(notification, 0.22, {
                Position = UDim2.new(
                    1,
                    30,
                    0,
                    0
                )
            })

            if out then
                out.Completed:Wait()
            end

            if notification then
                notification:Destroy()
            end
        end
    end)
end

----------------------------------------------------------------
-- FLOATING TOGGLE
----------------------------------------------------------------

local Floating = New("TextButton", {
    Name = "FloatingToggle",
    Size = UDim2.new(0, 150, 0, 48),
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 42),
    BackgroundColor3 = CONFIG.Card,
    BackgroundTransparency = 0.05,
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 400,
    Parent = ScreenGui
})

Corner(Floating, 16)
Stroke(Floating, CONFIG.Accent, 0.3, 1)

Gradient(
    Floating,
    CONFIG.Card,
    CONFIG.Card2,
    135
)

local FloatingTitle = New("TextLabel", {
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 42, 0, 0),
    BackgroundTransparency = 1,
    Text = "WALLXP",
    TextColor3 = CONFIG.Text,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 401,
    Parent = Floating
})

local FloatingIcon = New("TextLabel", {
    Size = UDim2.new(0, 32, 1, 0),
    Position = UDim2.new(0, 9, 0, 0),
    BackgroundTransparency = 1,
    Text = "W",
    TextColor3 = CONFIG.Accent,
    TextSize = 17,
    Font = Enum.Font.GothamBlack,
    ZIndex = 401,
    Parent = Floating
})

local FloatingDragging = false
local FloatingDragStart
local FloatingStartPosition

Floating.InputBegan:Connect(function(input)
    if IsPointer(input) then
        FloatingDragging = true
        FloatingDragStart = input.Position
        FloatingStartPosition = Floating.Position

        Tween(Floating, 0.1, {
            Size = UDim2.new(0, 144, 0, 46)
        })
    end
end)

Floating.InputChanged:Connect(function(input)
    if IsMoveInput(input) then
        -- handled globally
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if FloatingDragging and IsMoveInput(input) then
        local delta = input.Position - FloatingDragStart

        Floating.Position = UDim2.new(
            FloatingStartPosition.X.Scale,
            FloatingStartPosition.X.Offset + delta.X,
            FloatingStartPosition.Y.Scale,
            FloatingStartPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if IsPointer(input) then
        if FloatingDragging then
            FloatingDragging = false

            Tween(Floating, 0.1, {
                Size = UDim2.new(0, 150, 0, 48)
            })
        end
    end
end)

Floating.MouseButton1Click:Connect(function()
    -- prevent click action from fighting with drag
    if not FloatingDragging then
        WALLXP:Restore()
    end
end)

----------------------------------------------------------------
-- WINDOW DRAG SYSTEM
----------------------------------------------------------------

local WindowDragging = false
local WindowDragStart
local WindowStartPosition

Header.InputBegan:Connect(function(input)
    if not IsPointer(input) then
        return
    end

    -- Do not start dragging when clicking header buttons.
    local target = input.Target

    if target == SearchButton
        or target:IsDescendantOf(SearchButton)
        or target == SettingsButton
        or target:IsDescendantOf(SettingsButton)
        or target == MinimizeButton
        or target:IsDescendantOf(MinimizeButton)
        or target == SearchFrame
        or target:IsDescendantOf(SearchFrame) then
        return
    end

    WindowDragging = true
    WindowDragStart = input.Position
    WindowStartPosition = Window.Position
end)

UserInputService.InputChanged:Connect(function(input)
    if not WindowDragging or not IsMoveInput(input) then
        return
    end

    local delta = input.Position - WindowDragStart

    Window.Position = UDim2.new(
        WindowStartPosition.X.Scale,
        WindowStartPosition.X.Offset + delta.X,
        WindowStartPosition.Y.Scale,
        WindowStartPosition.Y.Offset + delta.Y
    )

    Shadow.Position = Window.Position

    WindowPosition = Window.Position
end)

UserInputService.InputEnded:Connect(function(input)
    if IsPointer(input) then
        WindowDragging = false
    end
end)

----------------------------------------------------------------
-- OPEN / CLOSE / MINIMIZE / RESTORE
----------------------------------------------------------------

local function SetWindowTransparency(hidden)
    if hidden then
        Tween(Window, 0.18, {
            BackgroundTransparency = 1
        })

        Tween(Shadow, 0.18, {
            BackgroundTransparency = 1
        })
    else
        Tween(Window, 0.18, {
            BackgroundTransparency = 0.08
        })

        Tween(Shadow, 0.18, {
            BackgroundTransparency = 0.58
        })
    end
end

function WALLXP:SetVisible(visible)
    visible = visible == true

    if WindowMinimized then
        WindowVisible = visible
        Floating.Visible = not visible
        return
    end

    WindowVisible = visible

    if visible then
        Window.Visible = true
        Shadow.Visible = true

        SetWindowTransparency(false)

        Tween(Window, 0.22, {
            Size = UDim2.new(
                0,
                CONFIG.Width,
                0,
                CONFIG.Height
            )
        })

        Tween(Shadow, 0.22, {
            Size = UDim2.new(
                0,
                CONFIG.Width + 22,
                0,
                CONFIG.Height + 22
            )
        })

        Floating.Visible = false
    else
        SetWindowTransparency(true)

        task.delay(0.2, function()
            if not WindowVisible then
                Window.Visible = false
                Shadow.Visible = false
            end
        end)

        Floating.Visible = true
    end
end

function WALLXP:Open()
    self:SetVisible(true)
end

function WALLXP:Close()
    self:SetVisible(false)
end

function WALLXP:Toggle()
    self:SetVisible(not WindowVisible)
end

function WALLXP:Minimize()
    if WindowMinimized then
        return
    end

    WindowMinimized = true
    WindowVisible = false

    Tween(Window, 0.2, {
        Size = UDim2.new(0, CONFIG.Width, 0, 0),
        BackgroundTransparency = 1
    })

    Tween(Shadow, 0.2, {
        Size = UDim2.new(0, CONFIG.Width + 22, 0, 0),
        BackgroundTransparency = 1
    })

    task.delay(0.21, function()
        if WindowMinimized then
            Window.Visible = false
            Shadow.Visible = false
            Floating.Visible = true
        end
    end)
end

function WALLXP:Restore()
    WindowMinimized = false
    WindowVisible = true

    Floating.Visible = false

    Window.Visible = true
    Shadow.Visible = true

    Window.Size = UDim2.new(
        0,
        CONFIG.Width,
        0,
        0
    )

    Shadow.Size = UDim2.new(
        0,
        CONFIG.Width + 22,
        0,
        0
    )

    Window.BackgroundTransparency = 1
    Shadow.BackgroundTransparency = 1

    Tween(Window, 0.24, {
        Size = UDim2.new(
            0,
            CONFIG.Width,
            0,
            CONFIG.Height
        ),
        BackgroundTransparency = 0.08
    })

    Tween(Shadow, 0.24, {
        Size = UDim2.new(
            0,
            CONFIG.Width + 22,
            0,
            CONFIG.Height + 22
        ),
        BackgroundTransparency = 0.58
    })
end

----------------------------------------------------------------
-- HEADER BUTTON ACTIONS
----------------------------------------------------------------

MinimizeButton.MouseButton1Click:Connect(function()
    WALLXP:Minimize()
end)

SettingsButton.MouseButton1Click:Connect(function()
    SelectTab("Settings")
end)

----------------------------------------------------------------
-- PUBLIC API
----------------------------------------------------------------

function WALLXP:CreateWindow(options)
    options = options or {}

    if options.Name then
        Title.Text = tostring(options.Name)
    end

    if options.Subtitle then
        Subtitle.Text = tostring(options.Subtitle)
    end

    return {
        CreateTab = function(_, name, icon)
            return CreateTab(name, icon)
        end,

        CreateSection = function(_, parent, text)
            return CreateSection(parent, text)
        end,

        CreateButton = function(_, parent, text, callback)
            return CreateButton(parent, text, callback)
        end,

        CreateToggle = function(_, parent, text, default, callback)
            return CreateToggle(
                parent,
                text,
                default,
                callback
            )
        end,

        CreateSlider = function(_, parent, text, min, max, default, callback)
            return CreateSlider(
                parent,
                text,
                min,
                max,
                default,
                callback
            )
        end,

        CreateDropdown = function(_, parent, text, items, default, callback)
            return CreateDropdown(
                parent,
                text,
                items,
                default,
                callback
            )
        end,

        CreateInput = function(_, parent, text, placeholder, callback)
            return CreateInput(
                parent,
                text,
                placeholder,
                callback
            )
        end,

        CreateKeybind = function(_, parent, text, key, callback)
            return CreateKeybind(
                parent,
                text,
                key,
                callback
            )
        end,

        Open = function()
            WALLXP:Open()
        end,

        Close = function()
            WALLXP:Close()
        end,

        Toggle = function()
            WALLXP:Toggle()
        end,

        Minimize = function()
            WALLXP:Minimize()
        end,

        Restore = function()
            WALLXP:Restore()
        end,

        Notify = function(_, title, message, duration)
            WALLXP:Notify(title, message, duration)
        end
    }
end

----------------------------------------------------------------
-- DEFAULT TAB
----------------------------------------------------------------

SelectTab("Home")

----------------------------------------------------------------
-- START
----------------------------------------------------------------

Window.Visible = true
Shadow.Visible = true

Window.BackgroundTransparency = 1
Shadow.BackgroundTransparency = 1

Window.Size = UDim2.new(0, CONFIG.Width - 30, 0, CONFIG.Height - 30)
Shadow.Size = UDim2.new(0, CONFIG.Width - 8, 0, CONFIG.Height - 8)

Tween(Window, 0.3, {
    Size = UDim2.new(
        0,
        CONFIG.Width,
        0,
        CONFIG.Height
    ),
    BackgroundTransparency = 0.08
})

Tween(Shadow, 0.3, {
    Size = UDim2.new(
        0,
        CONFIG.Width + 22,
        0,
        CONFIG.Height + 22
    ),
    BackgroundTransparency = 0.58
})

task.delay(0.4, function()
    WALLXP:Notify(
        "WALLXP",
        "Liquid Glass UI v1.8.3",
        3
    )
end)

----------------------------------------------------------------
-- RETURN
----------------------------------------------------------------

return WALLXP
