--[[
    WALLXP v1.6
    LIQUID GLASS UI LIBRARY

    Single File
    Loadstring Compatible
    Mouse + Touch
    UI Only
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
    Name = "WALLXP",

    WindowWidth = 640,
    WindowHeight = 390,

    SidebarWidth = 148,
    TopbarHeight = 66,

    Animation = 0.20,

    Accent = Color3.fromRGB(75, 140, 255),

    Background = Color3.fromRGB(15, 17, 22),

    Glass = Color3.fromRGB(255, 255, 255),

    Text = Color3.fromRGB(245, 247, 255),
    SubText = Color3.fromRGB(165, 170, 185),

    Border = Color3.fromRGB(255, 255, 255),

    Corner = 14
}

local TWEEN = TweenInfo.new(
    CONFIG.Animation,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

local FAST_TWEEN = TweenInfo.new(
    0.12,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

--==================================================
-- UTILITY
--==================================================

local function New(Class, Properties)

    local Object = Instance.new(Class)

    for Property, Value in pairs(Properties or {}) do
        Object[Property] = Value
    end

    return Object
end

local function Corner(Object, Radius)

    local C = Instance.new("UICorner")

    C.CornerRadius = UDim.new(
        0,
        Radius or CONFIG.Corner
    )

    C.Parent = Object

    return C
end

local function Stroke(Object, Transparency)

    local S = Instance.new("UIStroke")

    S.Color = CONFIG.Border
    S.Thickness = 1
    S.Transparency = Transparency or 0.86

    S.Parent = Object

    return S
end

local function Gradient(Object, Color1, Color2, Rotation)

    local G = Instance.new("UIGradient")

    G.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color1),
        ColorSequenceKeypoint.new(1, Color2)
    })

    G.Rotation = Rotation or 90

    G.Parent = Object

    return G
end

local function Padding(Object, Left, Right, Top, Bottom)

    local P = Instance.new("UIPadding")

    P.PaddingLeft = UDim.new(0, Left or 0)
    P.PaddingRight = UDim.new(0, Right or 0)
    P.PaddingTop = UDim.new(0, Top or 0)
    P.PaddingBottom = UDim.new(0, Bottom or 0)

    P.Parent = Object

    return P
end

local function Tween(Object, Properties, Info)

    if not Object then
        return
    end

    local Success, Animation = pcall(function()

        return TweenService:Create(
            Object,
            Info or TWEEN,
            Properties
        )

    end)

    if Success then
        Animation:Play()
        return Animation
    end
end

local function CreateGlass(Object)

    Object.BackgroundColor3 = CONFIG.Glass
    Object.BackgroundTransparency = 0.91

    Stroke(Object, 0.86)

    local Shine = New("Frame", {
        Name = "GlassHighlight",
        Parent = Object,
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.97,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 0, 1),
        ZIndex = Object.ZIndex + 1
    })

    Corner(Shine, 10)

    return Object
end

--==================================================
-- DRAG
--==================================================

local function MakeDraggable(Handle, Object)

    local Dragging = false
    local DragStart
    local StartPosition

    Handle.InputBegan:Connect(function(Input)

        if Input.UserInputType ~= Enum.UserInputType.MouseButton1
            and Input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        Dragging = true
        DragStart = Input.Position
        StartPosition = Object.Position

        Input.Changed:Connect(function()

            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end

        end)

    end)

    UserInputService.InputChanged:Connect(function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local Delta = Input.Position - DragStart

        Object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )

    end)
end

--==================================================
-- GUI
--==================================================

local ScreenGui = New("ScreenGui", {
    Name = "WALLXP_UI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local function ParentGui()

    local Success = pcall(function()

        ScreenGui.Parent = game:GetService("CoreGui")

    end)

    if not Success then

        ScreenGui.Parent =
            LocalPlayer:WaitForChild("PlayerGui")

    end
end

ParentGui()

--==================================================
-- NOTIFICATION
--==================================================

local NotificationHolder = New("Frame", {
    Parent = ScreenGui,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -18, 1, -18),
    Size = UDim2.fromOffset(310, 350)
})

local NotificationLayout = New("UIListLayout", {
    Parent = NotificationHolder,
    Padding = UDim.new(0, 8),
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Right
})

function WALLXP:Notify(Data)

    Data = Data or {}

    local Title = Data.Title or "WALLXP"
    local Content = Data.Content or ""
    local Duration = Data.Duration or 3

    local Frame = New("Frame", {
        Parent = NotificationHolder,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.90,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(290, 72)
    })

    Corner(Frame, 13)
    Stroke(Frame, 0.82)

    Gradient(
        Frame,
        Color3.fromRGB(255,255,255),
        Color3.fromRGB(100,120,160),
        45
    )

    local Accent = New("Frame", {
        Parent = Frame,
        BackgroundColor3 = CONFIG.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 12),
        Size = UDim2.fromOffset(3, 48)
    })

    Corner(Accent, 2)

    local TitleLabel = New("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 12),
        Size = UDim2.new(1, -28, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = CONFIG.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ContentLabel = New("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 35),
        Size = UDim2.new(1, -28, 0, 25),
        Font = Enum.Font.Gotham,
        Text = Content,
        TextColor3 = CONFIG.SubText,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    Frame.Position = UDim2.new(
        1,
        310,
        0,
        0
    )

    Tween(Frame, {
        Position = UDim2.new(
            0,
            0,
            0,
            0
        )
    })

    task.delay(Duration, function()

        if not Frame.Parent then
            return
        end

        Tween(Frame, {
            BackgroundTransparency = 1,
            Position = UDim2.new(
                1,
                310,
                0,
                0
            )
        })

        Tween(TitleLabel, {
            TextTransparency = 1
        })

        Tween(ContentLabel, {
            TextTransparency = 1
        })

        task.wait(0.22)

        if Frame then
            Frame:Destroy()
        end

    end)
end

--==================================================
-- CREATE WINDOW
--==================================================

function WALLXP:CreateWindow(Settings)

    Settings = Settings or {}

    local WindowObject = {}

    local WindowName =
        Settings.Name or "WALLXP"

    local WindowSubtitle =
        Settings.Subtitle or "Liquid Glass Interface"

    --==================================================
    -- WINDOW
    --==================================================

    local Window = New("Frame", {
        Name = "Window",
        Parent = ScreenGui,
        BackgroundColor3 = CONFIG.Background,
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(
            CONFIG.WindowWidth,
            CONFIG.WindowHeight
        ),
        Position = UDim2.new(
            0.5,
            -CONFIG.WindowWidth / 2,
            0.5,
            -CONFIG.WindowHeight / 2
        ),
        ClipsDescendants = true
    })

    Corner(Window, 17)
    Stroke(Window, 0.70)

    -- Window Shadow

    local Shadow = New("ImageLabel", {
        Parent = Window,
        BackgroundTransparency = 1,
        Image = "rbxassetid://1316045217",
        ImageTransparency = 0.55,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0
    })

    Window.ZIndex = 5

    --==================================================
    -- TOPBAR
    --==================================================

    local Topbar = New("Frame", {
        Parent = Window,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
        Size = UDim2.new(
            1,
            0,
            0,
            CONFIG.TopbarHeight
        ),
        ZIndex = 10
    })

    CreateGlass(Topbar)

    local Logo = New("Frame", {
        Parent = Topbar,
        BackgroundColor3 = CONFIG.Accent,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0.5, -18),
        Size = UDim2.fromOffset(36, 36),
        ZIndex = 12
    })

    Corner(Logo, 11)

    Gradient(
        Logo,
        Color3.fromRGB(100,160,255),
        CONFIG.Accent,
        45
    )

    local LogoText = New("TextLabel", {
        Parent = Logo,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1,1),
        Font = Enum.Font.GothamBlack,
        Text = "W",
        TextColor3 = Color3.new(1,1,1),
        TextSize = 18,
        ZIndex = 13
    })

    local Title = New("TextLabel", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 62, 0, 13),
        Size = UDim2.fromOffset(300, 20),
        Font = Enum.Font.GothamBold,
        Text = WindowName,
        TextColor3 = CONFIG.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12
    })

    local Subtitle = New("TextLabel", {
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 62, 0, 34),
        Size = UDim2.fromOffset(300, 16),
        Font = Enum.Font.Gotham,
        Text = WindowSubtitle,
        TextColor3 = CONFIG.SubText,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12
    })

    --==================================================
    -- TOP BUTTONS
    --==================================================

    local SearchButton = New("TextButton", {
        Parent = Topbar,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.96,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -132, 0.5, -17),
        Size = UDim2.fromOffset(34,34),
        Font = Enum.Font.GothamBold,
        Text = "⌕",
        TextColor3 = CONFIG.SubText,
        TextSize = 22,
        AutoButtonColor = false,
        ZIndex = 15
    })

    Corner(SearchButton, 9)

    local SettingsButton = New("TextButton", {
        Parent = Topbar,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.96,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -92, 0.5, -17),
        Size = UDim2.fromOffset(34,34),
        Font = Enum.Font.GothamBold,
        Text = "⚙",
        TextColor3 = CONFIG.SubText,
        TextSize = 16,
        AutoButtonColor = false,
        ZIndex = 15
    })

    Corner(SettingsButton, 9)

    local MinimizeButton = New("TextButton", {
        Parent = Topbar,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.96,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -52, 0.5, -17),
        Size = UDim2.fromOffset(34,34),
        Font = Enum.Font.GothamBold,
        Text = "—",
        TextColor3 = CONFIG.SubText,
        TextSize = 17,
        AutoButtonColor = false,
        ZIndex = 15
    })

    Corner(MinimizeButton, 9)

    local CloseButton = New("TextButton", {
        Parent = Topbar,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.96,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -13, 0.5, -17),
        Size = UDim2.fromOffset(34,34),
        Font = Enum.Font.Gotham,
        Text = "×",
        TextColor3 = CONFIG.SubText,
        TextSize = 20,
        AutoButtonColor = false,
        ZIndex = 15
    })

    Corner(CloseButton, 9)

    --==================================================
    -- BODY
    --==================================================

    local Body = New("Frame", {
        Parent = Window,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,0,0,CONFIG.TopbarHeight),
        Size = UDim2.new(
            1,
            0,
            1,
            -CONFIG.TopbarHeight
        ),
        ZIndex = 7
    })

    --==================================================
    -- SIDEBAR
    --==================================================

    local Sidebar = New("Frame", {
        Parent = Body,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.95,
        BorderSizePixel = 0,
        Size = UDim2.new(
            0,
            CONFIG.SidebarWidth,
            1,
            0
        ),
        ZIndex = 8
    })

    CreateGlass(Sidebar)

    local SidebarSeparator = New("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = 0.91,
        BorderSizePixel = 0,
        Position = UDim2.new(1,-1,0,0),
        Size = UDim2.new(0,1,1,0),
        ZIndex = 20
    })

    --==================================================
    -- TAB HOLDER
    --==================================================

    local TabHolder = New("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0,9,0,12),
        Size = UDim2.new(1,-18,1,-82),
        ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        ZIndex = 10
    })

    local TabLayout = New("UIListLayout", {
        Parent = TabHolder,
        Padding = UDim.new(0,5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    --==================================================
    -- PROFILE
    --==================================================

    local Profile = New("Frame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,10,1,-62),
        Size = UDim2.new(1,-20,0,48),
        ZIndex = 12
    })

    local Avatar = New("ImageLabel", {
        Parent = Profile,
        BackgroundColor3 = CONFIG.Card,
        BorderSizePixel = 0,
        Position = UDim2.new(0,0,0.5,-17),
        Size = UDim2.fromOffset(34,34),
        ZIndex = 13
    })

    Corner(Avatar,17)

    pcall(function()

        Avatar.Image =
            Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )

    end)

    local ProfileName = New("TextLabel", {
        Parent = Profile,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,43,0,6),
        Size = UDim2.new(1,-43,0,16),
        Font = Enum.Font.GothamSemibold,
        Text = LocalPlayer.DisplayName,
        TextColor3 = CONFIG.Text,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13
    })

    local ProfileUser = New("TextLabel", {
        Parent = Profile,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,43,0,24),
        Size = UDim2.new(1,-43,0,14),
        Font = Enum.Font.Gotham,
        Text = "@" .. LocalPlayer.Name,
        TextColor3 = CONFIG.SubText,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13
    })

    --==================================================
    -- CONTENT
    --==================================================

    local Content = New("Frame", {
        Parent = Body,
        BackgroundTransparency = 1,
        Position = UDim2.new(
            0,
            CONFIG.SidebarWidth,
            0,
            0
        ),
        Size = UDim2.new(
            1,
            -CONFIG.SidebarWidth,
            1,
            0
        ),
        ZIndex = 8
    })

    local Pages = New("Frame", {
        Parent = Content,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1,1),
        ZIndex = 9
    })

    --==================================================
    -- SEARCH
    --==================================================

    local SearchFrame = New("Frame", {
        Parent = Content,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.91,
        BorderSizePixel = 0,
        Position = UDim2.new(0,15,0,10),
        Size = UDim2.new(1,-30,0,38),
        Visible = false,
        ZIndex = 50
    })

    Corner(SearchFrame,10)
    Stroke(SearchFrame,0.84)

    local SearchIcon = New("TextLabel", {
        Parent = SearchFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,10,0,0),
        Size = UDim2.fromOffset(28,38),
        Font = Enum.Font.GothamBold,
        Text = "⌕",
        TextColor3 = CONFIG.SubText,
        TextSize = 20,
        ZIndex = 51
    })

    local SearchBox = New("TextBox", {
        Parent = SearchFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,38,0,0),
        Size = UDim2.new(1,-48,1,0),
        Font = Enum.Font.Gotham,
        Text = "",
        PlaceholderText = "Search all controls...",
        PlaceholderColor3 = CONFIG.SubText,
        TextColor3 = CONFIG.Text,
        TextSize = 10,
        ClearTextOnFocus = false,
        ZIndex = 51
    })

    --==================================================
    -- TAB SYSTEM
    --==================================================

    local Tabs = {}
    local CurrentTab = nil
    local CurrentPage = nil

    --==================================================
    -- CREATE PAGE
    --==================================================

    local function CreatePage()

        local Page = New("ScrollingFrame", {
            Parent = Pages,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(0,0),
            Size = UDim2.fromScale(1,1),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = CONFIG.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            Visible = false,
            ZIndex = 10
        })

        Padding(
            Page,
            15,
            15,
            14,
            18
        )

        New("UIListLayout", {
            Parent = Page,
            Padding = UDim.new(0,8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        return Page
    end

    --==================================================
    -- SELECT TAB
    --==================================================

    local function SelectTab(Tab)

        if CurrentTab == Tab then
            return
        end

        for _, Other in ipairs(Tabs) do

            if Other ~= Tab then

                Other.Page.Visible = false

                Tween(
                    Other.Button,
                    {
                        BackgroundTransparency = 1,
                        TextColor3 = CONFIG.SubText
                    },
                    FAST_TWEEN
                )

                Tween(
                    Other.Indicator,
                    {
                        Size = UDim2.fromOffset(2,0)
                    },
                    FAST_TWEEN
                )

                task.delay(0.12,function()

                    if Other.Indicator then
                        Other.Indicator.Visible = false
                    end

                end)
            end
        end

        if CurrentPage then
            CurrentPage.Visible = false
        end

        Tab.Page.Visible = true
        Tab.Page.CanvasPosition = Vector2.new(0,0)

        Tab.Indicator.Visible = true

        Tween(
            Tab.Button,
            {
                BackgroundTransparency = 0.90,
                TextColor3 = CONFIG.Text
            },
            TWEEN
        )

        Tween(
            Tab.Indicator,
            {
                Size = UDim2.fromOffset(3,20)
            },
            TWEEN
        )

        CurrentTab = Tab
        CurrentPage = Tab.Page

        SearchBox.Text = ""
    end

    --==================================================
    -- CREATE TAB
    --==================================================

    function WindowObject:CreateTab(Name)

        local Tab = {}

        local Page = CreatePage()

        local Button = New("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = CONFIG.Glass,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1,0,0,38),
            Font = Enum.Font.GothamSemibold,
            Text = Name,
            TextColor3 = CONFIG.SubText,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            ZIndex = 11
        })

        Corner(Button,9)

        Padding(Button,15,5,0,0)

        local Indicator = New("Frame", {
            Parent = Button,
            BackgroundColor3 = CONFIG.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0,0,0.5,-10),
            Size = UDim2.fromOffset(3,0),
            Visible = false,
            ZIndex = 15
        })

        Corner(Indicator,3)

        local Items = {}

        Tab.Page = Page
        Tab.Button = Button
        Tab.Indicator = Indicator
        Tab.Items = Items

        function Tab:Select()

            SelectTab(Tab)

        end

        function Tab:_AddItem(Object, SearchName)

            table.insert(
                Items,
                {
                    Object = Object,
                    Name = string.lower(
                        SearchName or ""
                    )
                }
            )

        end

        --==================================================
        -- SECTION
        --==================================================

        function Tab:CreateSection(Name)

            local Section = New("TextLabel", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,0,25),
                Font = Enum.Font.GothamBold,
                Text = Name,
                TextColor3 = CONFIG.Text,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            self:_AddItem(Section, Name)

            return Section
        end

        --==================================================
        -- BUTTON
        --==================================================

        function Tab:CreateButton(Data)

            Data = Data or {}

            local Holder = New("TextButton", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Glass,
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0,48),
                Font = Enum.Font.GothamSemibold,
                Text = Data.Name or "Button",
                TextColor3 = CONFIG.Text,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            })

            Corner(Holder,10)
            Stroke(Holder,0.88)

            Padding(Holder,15,15,0,0)

            Holder.MouseEnter:Connect(function()

                Tween(
                    Holder,
                    {
                        BackgroundTransparency = 0.86
                    },
                    FAST_TWEEN
                )

            end)

            Holder.MouseLeave:Connect(function()

                Tween(
                    Holder,
                    {
                        BackgroundTransparency = 0.92
                    },
                    FAST_TWEEN
                )

            end)

            Holder.MouseButton1Click:Connect(function()

                if Data.Callback then
                    task.spawn(Data.Callback)
                end

            end)

            self:_AddItem(
                Holder,
                Data.Name
            )

            return {
                Instance = Holder
            }
        end

        --==================================================
        -- TOGGLE
        --==================================================

        function Tab:CreateToggle(Data)

            Data = Data or {}

            local Value =
                Data.Default == true

            local Holder = New("Frame", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Glass,
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0,58)
            })

            Corner(Holder,10)
            Stroke(Holder,0.88)

            local Name = New("TextLabel", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0,15,0,0),
                Size = UDim2.new(1,-90,1,0),
                Font = Enum.Font.GothamSemibold,
                Text = Data.Name or "Toggle",
                TextColor3 = CONFIG.Text,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Toggle = New("TextButton", {
                Parent = Holder,
                BackgroundColor3 =
                    Value
                    and CONFIG.Accent
                    or Color3.fromRGB(70,72,82),
                BorderSizePixel = 0,
                Position = UDim2.new(1,-58,0.5,-12),
                Size = UDim2.fromOffset(43,24),
                Text = "",
                AutoButtonColor = false
            })

            Corner(Toggle,12)

            local Knob = New("Frame", {
                Parent = Toggle,
                BackgroundColor3 = Color3.new(1,1,1),
                BorderSizePixel = 0,
                Size = UDim2.fromOffset(16,16),
                Position =
                    Value
                    and UDim2.new(1,-20,0.5,-8)
                    or UDim2.new(0,4,0.5,-8)
            })

            Corner(Knob,8)

            local function Set(NewValue)

                Value = NewValue == true

                Tween(
                    Toggle,
                    {
                        BackgroundColor3 =
                            Value
                            and CONFIG.Accent
                            or Color3.fromRGB(70,72,82)
                    }
                )

                Tween(
                    Knob,
                    {
                        Position =
                            Value
                            and UDim2.new(1,-20,0.5,-8)
                            or UDim2.new(0,4,0.5,-8)
                    }
                )

                if Data.Callback then
                    task.spawn(
                        Data.Callback,
                        Value
                    )
                end
            end

            Toggle.MouseButton1Click:Connect(function()

                Set(not Value)

            end)

            self:_AddItem(
                Holder,
                Data.Name
            )

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

        function Tab:CreateSlider(Data)

            Data = Data or {}

            local Range =
                Data.Range or {0,100}

            local Min = Range[1]
            local Max = Range[2]

            local Increment =
                Data.Increment or 1

            local Value =
                Data.CurrentValue or Min

            local Holder = New("Frame", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Glass,
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0,72)
            })

            Corner(Holder,10)
            Stroke(Holder,0.88)

            local Name = New("TextLabel", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0,15,0,9),
                Size = UDim2.new(0.6,0,0,18),
                Font = Enum.Font.GothamSemibold,
                Text = Data.Name or "Slider",
                TextColor3 = CONFIG.Text,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ValueText = New("TextLabel", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.6,0,0,9),
                Size = UDim2.new(0.35,0,0,18),
                Font = Enum.Font.GothamSemibold,
                Text = tostring(Value),
                TextColor3 = CONFIG.Accent,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Bar = New("Frame", {
                Parent = Holder,
                BackgroundColor3 = Color3.fromRGB(65,67,77),
                BorderSizePixel = 0,
                Position = UDim2.new(0,15,0,47),
                Size = UDim2.new(1,-30,0,6)
            })

            Corner(Bar,3)

            local Fill = New("Frame", {
                Parent = Bar,
                BackgroundColor3 = CONFIG.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new(
                    math.clamp(
                        (Value-Min)/(Max-Min),
                        0,
                        1
                    ),
                    0,
                    1,
                    0
                )
            })

            Corner(Fill,3)

            local Knob = New("Frame", {
                Parent = Bar,
                BackgroundColor3 = Color3.new(1,1,1),
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(
                    math.clamp(
                        (Value-Min)/(Max-Min),
                        0,
                        1
                    ),
                    0,
                    0.5,
                    0
                ),
                Size = UDim2.fromOffset(12,12)
            })

            Corner(Knob,6)

            local Sliding = false

            local function Round(ValueToRound)

                local Result =
                    math.floor(
                        ((ValueToRound-Min)/Increment)
                        +0.5
                    ) * Increment + Min

                return math.clamp(
                    Result,
                    Min,
                    Max
                )
            end

            local function Set(NewValue)

                Value = Round(NewValue)

                local Percent =
                    math.clamp(
                        (Value-Min)/(Max-Min),
                        0,
                        1
                    )

                Tween(
                    Fill,
                    {
                        Size =
                            UDim2.new(
                                Percent,
                                0,
                                1,
                                0
                            )
                    },
                    FAST_TWEEN
                )

                Tween(
                    Knob,
                    {
                        Position =
                            UDim2.new(
                                Percent,
                                0,
                                0.5,
                                0
                            )
                    },
                    FAST_TWEEN
                )

                ValueText.Text =
                    tostring(Value)

                if Data.Callback then
                    task.spawn(
                        Data.Callback,
                        Value
                    )
                end
            end

            local function Update(Input)

                local Start =
                    Bar.AbsolutePosition.X

                local Width =
                    Bar.AbsoluteSize.X

                local Percent =
                    math.clamp(
                        (Input.Position.X-Start)
                        / Width,
                        0,
                        1
                    )

                Set(
                    Min +
                    ((Max-Min)*Percent)
                )
            end

            Bar.InputBegan:Connect(function(Input)

                if Input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                    or Input.UserInputType ==
                    Enum.UserInputType.Touch then

                    Sliding = true
                    Update(Input)

                end
            end)

            UserInputService.InputChanged:Connect(function(Input)

                if not Sliding then
                    return
                end

                if Input.UserInputType ==
                    Enum.UserInputType.MouseMovement
                    or Input.UserInputType ==
                    Enum.UserInputType.Touch then

                    Update(Input)

                end
            end)

            UserInputService.InputEnded:Connect(function(Input)

                if Input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                    or Input.UserInputType ==
                    Enum.UserInputType.Touch then

                    Sliding = false

                end
            end)

            self:_AddItem(
                Holder,
                Data.Name
            )

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

        function Tab:CreateDropdown(Data)

            Data = Data or {}

            local Options =
                Data.Options or {}

            local Current =
                Data.CurrentOption
                or Options[1]

            local Opened = false

            local Holder = New("Frame", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Glass,
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0,58),
                ClipsDescendants = true
            })

            Corner(Holder,10)
            Stroke(Holder,0.88)

            local MainButton = New("TextButton", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,0,58),
                Text = "",
                AutoButtonColor = false
            })

            local Name = New("TextLabel", {
                Parent = MainButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(0,15,0,0),
                Size = UDim2.new(0.45,0,1,0),
                Font = Enum.Font.GothamSemibold,
                Text = Data.Name or "Dropdown",
                TextColor3 = CONFIG.Text,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Selected = New("TextLabel", {
                Parent = MainButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.45,0,0,0),
                Size = UDim2.new(0.43,0,1,0),
                Font = Enum.Font.Gotham,
                Text = tostring(Current or ""),
                TextColor3 = CONFIG.Accent,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Arrow = New("TextLabel", {
                Parent = MainButton,
                BackgroundTransparency = 1,
                Position = UDim2.new(1,-30,0,0),
                Size = UDim2.fromOffset(20,58),
                Font = Enum.Font.GothamBold,
                Text = "⌄",
                TextColor3 = CONFIG.SubText,
                TextSize = 13
            })

            local OptionHolder = New("Frame", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0,10,0,58),
                Size = UDim2.new(1,-20,0,0)
            })

            local OptionLayout = New("UIListLayout", {
                Parent = OptionHolder,
                Padding = UDim.new(0,4),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            local function Set(NewValue)

                Current = NewValue

                Selected.Text =
                    tostring(NewValue)

                if Data.Callback then
                    task.spawn(
                        Data.Callback,
                        NewValue
                    )
                end
            end

            for _, Option in ipairs(Options) do

                local OptionButton = New("TextButton", {
                    Parent = OptionHolder,
                    BackgroundColor3 = CONFIG.Glass,
                    BackgroundTransparency = 0.91,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1,0,0,30),
                    Font = Enum.Font.Gotham,
                    Text = tostring(Option),
                    TextColor3 = CONFIG.Text,
                    TextSize = 9,
                    AutoButtonColor = false
                })

                Corner(OptionButton,7)

                OptionButton.MouseButton1Click:Connect(function()

                    Set(Option)

                    Opened = false

                    Tween(
                        Holder,
                        {
                            Size = UDim2.new(1,0,0,58)
                        }
                    )

                    Tween(
                        Arrow,
                        {
                            Rotation = 0
                        }
                    )

                end)
            end

            MainButton.MouseButton1Click:Connect(function()

                Opened = not Opened

                if Opened then

                    local Height =
                        (#Options*30)
                        + (math.max(#Options-1,0)*4)
                        + 10

                    Tween(
                        Holder,
                        {
                            Size = UDim2.new(
                                1,
                                0,
                                0,
                                58+Height
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

                    Tween(
                        Holder,
                        {
                            Size = UDim2.new(
                                1,
                                0,
                                0,
                                58
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

            end)

            self:_AddItem(
                Holder,
                Data.Name
            )

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

        function Tab:CreateInput(Data)

            Data = Data or {}

            local Holder = New("Frame", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Glass,
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0,58)
            })

            Corner(Holder,10)
            Stroke(Holder,0.88)

            local Name = New("TextLabel", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0,15,0,0),
                Size = UDim2.new(0.36,0,1,0),
                Font = Enum.Font.GothamSemibold,
                Text = Data.Name or "Input",
                TextColor3 = CONFIG.Text,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Box = New("TextBox", {
                Parent = Holder,
                BackgroundColor3 = CONFIG.Background,
                BackgroundTransparency = 0.35,
                BorderSizePixel = 0,
                Position = UDim2.new(0.38,0,0.5,-16),
                Size = UDim2.new(0.57,0,0,32),
                Font = Enum.Font.Gotham,
                Text = Data.Default or "",
                PlaceholderText =
                    Data.PlaceholderText
                    or "Enter text...",
                PlaceholderColor3 = CONFIG.SubText,
                TextColor3 = CONFIG.Text,
                TextSize = 9,
                ClearTextOnFocus =
                    Data.ClearTextOnFocus or false
            })

            Corner(Box,8)
            Stroke(Box,0.90)

            Box.FocusGained:Connect(function()

                Tween(
                    Box,
                    {
                        BackgroundTransparency = 0.20
                    },
                    FAST_TWEEN
                )

            end)

            Box.FocusLost:Connect(function()

                Tween(
                    Box,
                    {
                        BackgroundTransparency = 0.35
                    },
                    FAST_TWEEN
                )

                if Data.Callback then

                    task.spawn(
                        Data.Callback,
                        Box.Text
                    )

                end

            end)

            self:_AddItem(
                Holder,
                Data.Name
            )

            return {

                Set = function(Value)
                    Box.Text = tostring(Value)
                end,

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

        function Tab:CreateKeybind(Data)

            Data = Data or {}

            local CurrentKey =
                Data.CurrentKeybind
                or Enum.KeyCode.RightShift

            local Listening = false

            local Holder = New("Frame", {
                Parent = Page,
                BackgroundColor3 = CONFIG.Glass,
                BackgroundTransparency = 0.92,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0,58)
            })

            Corner(Holder,10)
            Stroke(Holder,0.88)

            local Name = New("TextLabel", {
                Parent = Holder,
                BackgroundTransparency = 1,
                Position = UDim2.new(0,15,0,0),
                Size = UDim2.new(0.55,0,1,0),
                Font = Enum.Font.GothamSemibold,
                Text = Data.Name or "Keybind",
                TextColor3 = CONFIG.Text,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local KeyButton = New("TextButton", {
                Parent = Holder,
                BackgroundColor3 = CONFIG.Background,
                BackgroundTransparency = 0.30,
                BorderSizePixel = 0,
                Position = UDim2.new(1,-105,0.5,-15),
                Size = UDim2.fromOffset(90,30),
                Font = Enum.Font.GothamSemibold,
                Text = CurrentKey.Name,
                TextColor3 = CONFIG.Text,
                TextSize = 9,
                AutoButtonColor = false
            })

            Corner(KeyButton,8)
            Stroke(KeyButton,0.90)

            local function Set(Key)

                if typeof(Key) == "EnumItem" then
                    CurrentKey = Key
                end

                KeyButton.Text =
                    CurrentKey.Name

            end

            KeyButton.MouseButton1Click:Connect(function()

                if Listening then
                    return
                end

                Listening = true
                KeyButton.Text = "Press key..."

                local Connection

                Connection =
                    UserInputService.InputBegan:Connect(function(Input)

                        if Input.UserInputType ==
                            Enum.UserInputType.Keyboard then

                            Set(Input.KeyCode)

                            Listening = false

                            Connection:Disconnect()

                            if Data.Callback then

                                task.spawn(
                                    Data.Callback,
                                    CurrentKey
                                )

                            end

                        end

                    end)

            end)

            self:_AddItem(
                Holder,
                Data.Name
            )

            return {

                Set = Set,

                Get = function()
                    return CurrentKey
                end,

                Instance = Holder,

                Destroy = function()
                    Holder:Destroy()
                end
            }
        end

        table.insert(Tabs,Tab)

        Button.MouseButton1Click:Connect(function()
            SelectTab(Tab)
        end)

        -- Hover

        Button.MouseEnter:Connect(function()

            if CurrentTab ~= Tab then

                Tween(
                    Button,
                    {
                        BackgroundTransparency = 0.96
                    },
                    FAST_TWEEN
                )

            end
        end)

        Button.MouseLeave:Connect(function()

            if CurrentTab ~= Tab then

                Tween(
                    Button,
                    {
                        BackgroundTransparency = 1
                    },
                    FAST_TWEEN
                )

            end
        end)

        if not CurrentTab then
            SelectTab(Tab)
        end

        return Tab
    end

    --==================================================
    -- HOME PAGE
    --==================================================

    local HomePage = CreatePage()

    local HomeTitle = New("TextLabel", {
        Parent = HomePage,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,0,28),
        Font = Enum.Font.GothamBold,
        Text = "Welcome",
        TextColor3 = CONFIG.Text,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local HomeSubtitle = New("TextLabel", {
        Parent = HomePage,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,0,25),
        Font = Enum.Font.Gotham,
        Text = "Your interface is ready.",
        TextColor3 = CONFIG.SubText,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local WelcomeCard = New("Frame", {
        Parent = HomePage,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.89,
        BorderSizePixel = 0,
        Size = UDim2.new(1,0,0,105)
    })

    Corner(WelcomeCard,13)
    Stroke(WelcomeCard,0.82)

    Gradient(
        WelcomeCard,
        Color3.fromRGB(80,140,255),
        Color3.fromRGB(255,255,255),
        25
    )

    local WelcomeTitle = New("TextLabel", {
        Parent = WelcomeCard,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,17,0,15),
        Size = UDim2.new(1,-34,0,22),
        Font = Enum.Font.GothamBold,
        Text = WindowName,
        TextColor3 = CONFIG.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local WelcomeText = New("TextLabel", {
        Parent = WelcomeCard,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,17,0,42),
        Size = UDim2.new(1,-34,0,45),
        Font = Enum.Font.Gotham,
        Text = "Liquid Glass interface • Smooth animations • Mobile ready",
        TextColor3 = CONFIG.SubText,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    --==================================================
    -- SETTINGS PAGE
    --==================================================

    local SettingsPage = CreatePage()

    local SettingsTitle = New("TextLabel", {
        Parent = SettingsPage,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,0,28),
        Font = Enum.Font.GothamBold,
        Text = "Settings",
        TextColor3 = CONFIG.Text,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local SettingsSubtitle = New("TextLabel", {
        Parent = SettingsPage,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,0,25),
        Font = Enum.Font.Gotham,
        Text = "Customize your WALLXP interface.",
        TextColor3 = CONFIG.SubText,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Settings toggle helper

    local function CreateSettingToggle(
        Name,
        Description,
        Default,
        Callback
    )

        local Holder = New("Frame", {
            Parent = SettingsPage,
            BackgroundColor3 = CONFIG.Glass,
            BackgroundTransparency = 0.92,
            BorderSizePixel = 0,
            Size = UDim2.new(1,0,0,62)
        })

        Corner(Holder,10)
        Stroke(Holder,0.88)

        local TitleLabel = New("TextLabel", {
            Parent = Holder,
            BackgroundTransparency = 1,
            Position = UDim2.new(0,15,0,9),
            Size = UDim2.new(1,-90,0,18),
            Font = Enum.Font.GothamSemibold,
            Text = Name,
            TextColor3 = CONFIG.Text,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local DescriptionLabel = New("TextLabel", {
            Parent = Holder,
            BackgroundTransparency = 1,
            Position = UDim2.new(0,15,0,31),
            Size = UDim2.new(1,-90,0,17),
            Font = Enum.Font.Gotham,
            Text = Description,
            TextColor3 = CONFIG.SubText,
            TextSize = 8,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local Value = Default == true

        local Toggle = New("TextButton", {
            Parent = Holder,
            BackgroundColor3 =
                Value
                and CONFIG.Accent
                or Color3.fromRGB(70,72,82),
            BorderSizePixel = 0,
            Position = UDim2.new(1,-58,0.5,-12),
            Size = UDim2.fromOffset(43,24),
            Text = "",
            AutoButtonColor = false
        })

        Corner(Toggle,12)

        local Knob = New("Frame", {
            Parent = Toggle,
            BackgroundColor3 = Color3.new(1,1,1),
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(16,16),
            Position =
                Value
                and UDim2.new(1,-20,0.5,-8)
                or UDim2.new(0,4,0.5,-8)
        })

        Corner(Knob,8)

        local function Set(NewValue)

            Value = NewValue == true

            Tween(
                Toggle,
                {
                    BackgroundColor3 =
                        Value
                        and CONFIG.Accent
                        or Color3.fromRGB(70,72,82)
                }
            )

            Tween(
                Knob,
                {
                    Position =
                        Value
                        and UDim2.new(1,-20,0.5,-8)
                        or UDim2.new(0,4,0.5,-8)
                }
            )

            if Callback then
                task.spawn(Callback,Value)
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

    local ProfileToggle = CreateSettingToggle(
        "Show profile",
        "Show your profile in the sidebar.",
        true,
        function(Value)
            Profile.Visible = Value
        end
    )

    local KeepScreenToggle = CreateSettingToggle(
        "Keep window on screen",
        "Prevent the window from being moved outside the screen.",
        true,
        function()
        end
    )

    local ResetHolder = New("Frame", {
        Parent = SettingsPage,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        Size = UDim2.new(1,0,0,62)
    })

    Corner(ResetHolder,10)
    Stroke(ResetHolder,0.88)

    local ResetTitle = New("TextLabel", {
        Parent = ResetHolder,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,15,0,9),
        Size = UDim2.new(1,-140,0,18),
        Font = Enum.Font.GothamSemibold,
        Text = "Reset Window Position",
        TextColor3 = CONFIG.Text,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ResetDesc = New("TextLabel", {
        Parent = ResetHolder,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,15,0,31),
        Size = UDim2.new(1,-140,0,17),
        Font = Enum.Font.Gotham,
        Text = "Return the interface to the center.",
        TextColor3 = CONFIG.SubText,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ResetButton = New("TextButton", {
        Parent = ResetHolder,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        Position = UDim2.new(1,-110,0.5,-15),
        Size = UDim2.fromOffset(95,30),
        Font = Enum.Font.GothamSemibold,
        Text = "Reset",
        TextColor3 = CONFIG.Text,
        TextSize = 9,
        AutoButtonColor = false
    })

    Corner(ResetButton,8)
    Stroke(ResetButton,0.85)

    --==================================================
    -- HOME / SETTINGS NAV
    --==================================================

    local function CreateSpecialButton(Name)

        local Button = New("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = CONFIG.Glass,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1,0,0,38),
            Font = Enum.Font.GothamSemibold,
            Text = Name,
            TextColor3 = CONFIG.SubText,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            ZIndex = 11
        })

        Corner(Button,9)
        Padding(Button,15,5,0,0)

        return Button
    end

    local HomeButton = CreateSpecialButton("Home")
    local SettingsNavButton = CreateSpecialButton("Settings")

    -- Put special buttons at top visually

    HomeButton.LayoutOrder = -100
    SettingsNavButton.LayoutOrder = 100000

    local function SelectHome()

        for _, Tab in ipairs(Tabs) do

            Tab.Page.Visible = false

            Tween(
                Tab.Button,
                {
                    BackgroundTransparency = 1,
                    TextColor3 = CONFIG.SubText
                },
                FAST_TWEEN
            )

            Tab.Indicator.Visible = false
        end

        SettingsPage.Visible = false

        HomePage.Visible = true

        CurrentTab = nil
        CurrentPage = HomePage

        Tween(
            HomeButton,
            {
                BackgroundTransparency = 0.90,
                TextColor3 = CONFIG.Text
            }
        )

        Tween(
            SettingsNavButton,
            {
                BackgroundTransparency = 1,
                TextColor3 = CONFIG.SubText
            }
        )

        SearchFrame.Visible = false
        SearchBox.Text = ""
    end

    local function SelectSettings()

        for _, Tab in ipairs(Tabs) do

            Tab.Page.Visible = false

            Tween(
                Tab.Button,
                {
                    BackgroundTransparency = 1,
                    TextColor3 = CONFIG.SubText
                },
                FAST_TWEEN
            )

            Tab.Indicator.Visible = false
        end

        HomePage.Visible = false
        SettingsPage.Visible = true

        CurrentTab = nil
        CurrentPage = SettingsPage

        Tween(
            HomeButton,
            {
                BackgroundTransparency = 1,
                TextColor3 = CONFIG.SubText
            }
        )

        Tween(
            SettingsNavButton,
            {
                BackgroundTransparency = 0.90,
                TextColor3 = CONFIG.Text
            }
        )

        SearchFrame.Visible = false
        SearchBox.Text = ""
    end

    HomeButton.MouseButton1Click:Connect(
        SelectHome
    )

    SettingsNavButton.MouseButton1Click:Connect(
        SelectSettings
    )

    --==================================================
    -- SEARCH
    --==================================================

    local SearchOpen = false

    SearchButton.MouseButton1Click:Connect(function()

        SearchOpen = not SearchOpen

        SearchFrame.Visible = SearchOpen

        if SearchOpen then
            SearchBox:CaptureFocus()
        else
            SearchBox.Text = ""
        end

    end)

    SearchBox:GetPropertyChangedSignal(
        "Text"
    ):Connect(function()

        if not CurrentTab then
            return
        end

        local Query =
            string.lower(
                SearchBox.Text
            )

        for _, Item in ipairs(
            CurrentTab.Items
        ) do

            if Query == "" then

                Item.Object.Visible = true

            else

                Item.Object.Visible =
                    string.find(
                        Item.Name,
                        Query,
                        1,
                        true
                    ) ~= nil

            end
        end

    end)

    --==================================================
    -- RESET
    --==================================================

    ResetButton.MouseButton1Click:Connect(function()

        Tween(
            Window,
            {
                Position = UDim2.new(
                    0.5,
                    -CONFIG.WindowWidth/2,
                    0.5,
                    -CONFIG.WindowHeight/2
                )
            }
        )

        WALLXP:Notify({
            Title = "WALLXP",
            Content = "Window position reset.",
            Duration = 2
        })

    end)

    --==================================================
    -- MINIMIZE
    --==================================================

    local Minimized = false

    local Floating = New("TextButton", {
        Parent = ScreenGui,
        BackgroundColor3 = CONFIG.Glass,
        BackgroundTransparency = 0.87,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1,0),
        Position = UDim2.new(1,-18,0,18),
        Size = UDim2.fromOffset(150,52),
        Visible = false,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 100
    })

    Corner(Floating,14)
    Stroke(Floating,0.80)

    Gradient(
        Floating,
        Color3.fromRGB(80,130,255),
        Color3.fromRGB(255,255,255),
        35
    )

    local FloatingTitle = New("TextLabel", {
        Parent = Floating,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,15,0,8),
        Size = UDim2.new(1,-30,0,17),
        Font = Enum.Font.GothamBold,
        Text = "WALLXP",
        TextColor3 = CONFIG.Text,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101
    })

    local FloatingSubtitle = New("TextLabel", {
        Parent = Floating,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,15,0,27),
        Size = UDim2.new(1,-30,0,14),
        Font = Enum.Font.Gotham,
        Text = "Tap to restore",
        TextColor3 = CONFIG.SubText,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101
    })

    local function Minimize()

        if Minimized then
            return
        end

        Minimized = true

        Tween(
            Window,
            {
                Size = UDim2.fromOffset(
                    CONFIG.WindowWidth,
                    CONFIG.TopbarHeight
                )
            }
        )

        task.delay(0.16,function()

            if Window then
                Window.Visible = false
            end

            Floating.Visible = true

            Floating.Size =
                UDim2.fromOffset(0,52)

            Tween(
                Floating,
                {
                    Size = UDim2.fromOffset(
                        150,
                        52
                    )
                }
            )

        end)
    end

    local function Restore()

        if not Minimized then
            return
        end

        Minimized = false

        Tween(
            Floating,
            {
                Size = UDim2.fromOffset(0,52)
            }
        )

        task.delay(0.15,function()

            Floating.Visible = false

            Window.Visible = true

            Window.Size =
                UDim2.fromOffset(
                    CONFIG.WindowWidth,
                    CONFIG.TopbarHeight
                )

            Tween(
                Window,
                {
                    Size = UDim2.fromOffset(
                        CONFIG.WindowWidth,
                        CONFIG.WindowHeight
                    )
                }
            )

        end)
    end

    MinimizeButton.MouseButton1Click:Connect(
        Minimize
    )

    Floating.MouseButton1Click:Connect(
        Restore
    )

    --==================================================
    -- CLOSE
    --==================================================

    CloseButton.MouseButton1Click:Connect(function()

        Tween(
            Window,
            {
                Size = UDim2.fromOffset(
                    CONFIG.WindowWidth,
                    0
                ),
                BackgroundTransparency = 1
            }
        )

        task.wait(0.2)

        if ScreenGui then
            ScreenGui:Destroy()
        end

    end)

    --==================================================
    -- BUTTON HOVER
    --==================================================

    local HeaderButtons = {
        SearchButton,
        SettingsButton,
        MinimizeButton,
        CloseButton
    }

    for _, Button in ipairs(HeaderButtons) do

        Button.MouseEnter:Connect(function()

            Tween(
                Button,
                {
                    BackgroundTransparency = 0.88,
                    TextColor3 = CONFIG.Text
                },
                FAST_TWEEN
            )

        end)

        Button.MouseLeave:Connect(function()

            Tween(
                Button,
                {
                    BackgroundTransparency = 0.96,
                    TextColor3 = CONFIG.SubText
                },
                FAST_TWEEN
            )

        end)

    end

    --==================================================
    -- SETTINGS TOP BUTTON
    --==================================================

    SettingsButton.MouseButton1Click:Connect(
        SelectSettings
    )

    --==================================================
    -- DRAG
    --==================================================

    MakeDraggable(
        Topbar,
        Window
    )

    MakeDraggable(
        Floating,
        Floating
    )

    --==================================================
    -- INITIAL PAGE
    --==================================================

    HomePage.Visible = true
    SettingsPage.Visible = false

    CurrentPage = HomePage

    Tween(
        HomeButton,
        {
            BackgroundTransparency = 0.90,
            TextColor3 = CONFIG.Text
        }
    )

    --==================================================
    -- OPEN ANIMATION
    --==================================================

    Window.Size =
        UDim2.fromOffset(
            CONFIG.WindowWidth - 30,
            CONFIG.WindowHeight - 30
        )

    Window.BackgroundTransparency = 1

    Tween(
        Window,
        {
            Size = UDim2.fromOffset(
                CONFIG.WindowWidth,
                CONFIG.WindowHeight
            ),
            BackgroundTransparency = 0.04
        },
        TweenInfo.new(
            0.28,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        )
    )

    --==================================================
    -- PUBLIC API
    --==================================================

    function WindowObject:Notify(Data)
        WALLXP:Notify(Data)
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

    function WindowObject:SelectHome()
        SelectHome()
    end

    function WindowObject:SelectSettings()
        SelectSettings()
    end

    function WindowObject:GetInstance()
        return Window
    end

    return WindowObject
end

return WALLXP
