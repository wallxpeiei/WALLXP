--//==================================================
--// WALLXP UI LIBRARY
--// Version 1.4
--//
--// Window
--// Tabs
--// Section
--// Button
--// Toggle
--// Slider
--// Dropdown
--// Input
--// Keybind
--// Notification
--// Minimize / Restore
--// Mobile Touch Support
--//==================================================

local WALLXP = {}
WALLXP.__index = WALLXP

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

--==================================================
-- ScreenGui
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WALLXP_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not success or not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

--==================================================
-- Utility
--==================================================

local function Create(ClassName, Properties, Parent)

    local Object = Instance.new(ClassName)

    for Property, Value in pairs(Properties or {}) do
        Object[Property] = Value
    end

    Object.Parent = Parent

    return Object
end

local function AddCorner(Object, Radius)

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, Radius)
    Corner.Parent = Object

    return Corner
end

local function AddStroke(Object, Color, Transparency, Thickness)

    local Stroke = Instance.new("UIStroke")

    Stroke.Color = Color or Color3.fromRGB(70, 130, 255)
    Stroke.Transparency = Transparency or 0
    Stroke.Thickness = Thickness or 1

    Stroke.Parent = Object

    return Stroke
end

local function Tween(Object, Time, Properties)

    return TweenService:Create(
        Object,
        TweenInfo.new(
            Time,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        Properties
    )

end

--==================================================
-- Notification Holder
--==================================================

local NotificationHolder = Create("Frame", {
    Name = "Notifications",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -18, 1, -18),
    Size = UDim2.fromOffset(310, 400),
    BackgroundTransparency = 1
}, ScreenGui)

local NotificationLayout = Create("UIListLayout", {
    Padding = UDim.new(0, 8),
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    SortOrder = Enum.SortOrder.LayoutOrder
}, NotificationHolder)

--==================================================
-- Notification
--==================================================

function WALLXP:Notify(Settings)

    Settings = Settings or {}

    local Title = Settings.Title or "WALLXP"
    local Content = Settings.Content or ""
    local Duration = Settings.Duration or 3

    local Notification = Create("Frame", {
        Name = "Notification",
        Size = UDim2.fromOffset(290, 72),
        BackgroundColor3 = Color3.fromRGB(25, 25, 31),
        BorderSizePixel = 0
    }, NotificationHolder)

    AddCorner(Notification, 10)

    AddStroke(
        Notification,
        Color3.fromRGB(70, 130, 255),
        0.35,
        1
    )

    local Accent = Create("Frame", {
        Position = UDim2.fromOffset(0, 10),
        Size = UDim2.fromOffset(3, 52),
        BackgroundColor3 = Color3.fromRGB(70, 130, 255),
        BorderSizePixel = 0
    }, Notification)

    AddCorner(Accent, 2)

    Create("TextLabel", {
        Position = UDim2.fromOffset(15, 8),
        Size = UDim2.new(1, -30, 0, 22),
        BackgroundTransparency = 1,
        Text = Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Notification)

    Create("TextLabel", {
        Position = UDim2.fromOffset(15, 31),
        Size = UDim2.new(1, -30, 0, 30),
        BackgroundTransparency = 1,
        Text = Content,
        TextColor3 = Color3.fromRGB(165, 165, 172),
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, Notification)

    Notification.Position = UDim2.new(1, 25, 0, 0)

    Tween(
        Notification,
        0.25,
        {
            Position = UDim2.new(0, 0, 0, 0)
        }
    ):Play()

    task.delay(Duration, function()

        if not Notification.Parent then
            return
        end

        local Out = Tween(
            Notification,
            0.25,
            {
                Position = UDim2.new(1, 25, 0, 0),
                BackgroundTransparency = 1
            }
        )

        Out:Play()

        Out.Completed:Connect(function()

            if Notification.Parent then
                Notification:Destroy()
            end

        end)

    end)

    return Notification
end

--==================================================
-- Create Window
--==================================================

function WALLXP:CreateWindow(Settings)

    Settings = Settings or {}

    local WindowName = Settings.Name or "WALLXP"
    local WindowSubtitle = Settings.Subtitle or "Custom UI Library"

    --==================================================
    -- Window
    --==================================================

    local Window = Create("Frame", {
        Name = "Window",
        Size = UDim2.fromOffset(600, 330),
        Position = UDim2.new(0.5, -300, 0.5, -165),
        BackgroundColor3 = Color3.fromRGB(17, 17, 21),
        BorderSizePixel = 0
    }, ScreenGui)

    AddCorner(Window, 12)

    --==================================================
    -- TopBar
    --==================================================

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundTransparency = 1
    }, Window)

    --==================================================
    -- Title
    --==================================================

    Create("TextLabel", {
        Name = "Title",
        Position = UDim2.fromOffset(20, 8),
        Size = UDim2.new(1, -180, 0, 25),
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, TopBar)

    --==================================================
    -- Subtitle
    --==================================================

    Create("TextLabel", {
        Name = "Subtitle",
        Position = UDim2.fromOffset(21, 33),
        Size = UDim2.new(1, -180, 0, 18),
        BackgroundTransparency = 1,
        Text = WindowSubtitle,
        TextColor3 = Color3.fromRGB(145, 145, 150),
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, TopBar)

    --==================================================
    -- Minimize
    --==================================================

    local Minimize = Create("TextButton", {
        Name = "Minimize",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -55, 0.5, 0),
        Size = UDim2.fromOffset(32, 32),
        BackgroundColor3 = Color3.fromRGB(31, 31, 37),
        BorderSizePixel = 0,
        Text = "—",
        TextColor3 = Color3.fromRGB(225, 225, 225),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    }, TopBar)

    AddCorner(Minimize, 8)

    --==================================================
    -- Close
    --==================================================

    local Close = Create("TextButton", {
        Name = "Close",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -15, 0.5, 0),
        Size = UDim2.fromOffset(32, 32),
        BackgroundColor3 = Color3.fromRGB(31, 31, 37),
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Color3.fromRGB(225, 225, 225),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    }, TopBar)

    AddCorner(Close, 8)

    --==================================================
    -- Main Area
    --==================================================

    local MainArea = Create("Frame", {
        Name = "MainArea",
        Position = UDim2.fromOffset(10, 62),
        Size = UDim2.new(1, -20, 1, -72),
        BackgroundColor3 = Color3.fromRGB(23, 23, 28),
        BorderSizePixel = 0
    }, Window)

    AddCorner(MainArea, 10)

    --==================================================
    -- Sidebar
    --==================================================

    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Position = UDim2.fromOffset(8, 8),
        Size = UDim2.new(0, 135, 1, -16),
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BorderSizePixel = 0
    }, MainArea)

    AddCorner(Sidebar, 8)

    local TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Position = UDim2.fromOffset(7, 8),
        Size = UDim2.new(1, -14, 1, -16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, Sidebar)

    local TabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, TabList)

    TabLayout:GetPropertyChangedSignal(
        "AbsoluteContentSize"
    ):Connect(function()

        TabList.CanvasSize = UDim2.fromOffset(
            0,
            TabLayout.AbsoluteContentSize.Y + 10
        )

    end)

    --==================================================
    -- Pages
    --==================================================

    local PageContainer = Create("Frame", {
        Name = "Pages",
        Position = UDim2.fromOffset(151, 8),
        Size = UDim2.new(1, -159, 1, -16),
        BackgroundTransparency = 1
    }, MainArea)

    --==================================================
    -- Restore Button
    --==================================================

    local Restore = Create("TextButton", {
        Name = "Restore",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 18, 1, -18),
        Size = UDim2.fromOffset(55, 55),
        BackgroundColor3 = Color3.fromRGB(20, 20, 26),
        BorderSizePixel = 0,
        Text = "W",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Visible = false,
        AutoButtonColor = false
    }, ScreenGui)

    AddCorner(Restore, 14)

    AddStroke(
        Restore,
        Color3.fromRGB(70, 130, 255),
        0.15,
        2
    )

    --==================================================
    -- Window Object
    --==================================================

    local WindowObject = {}

    WindowObject.Window = Window
    WindowObject.MainArea = MainArea
    WindowObject.Sidebar = Sidebar
    WindowObject.Pages = PageContainer
    WindowObject.Tabs = {}
    WindowObject.CurrentTab = nil
    WindowObject.Minimized = false

    --==================================================
    -- Minimize
    --==================================================

    Minimize.MouseButton1Click:Connect(function()

        if WindowObject.Minimized then
            return
        end

        WindowObject.Minimized = true

        MainArea.Visible = false

        Tween(
            Window,
            0.25,
            {
                Size = UDim2.fromOffset(600, 58)
            }
        ):Play()

        Restore.Visible = true

    end)

    --==================================================
    -- Restore
    --==================================================

    Restore.MouseButton1Click:Connect(function()

        if not WindowObject.Minimized then
            return
        end

        WindowObject.Minimized = false

        Restore.Visible = false

        Tween(
            Window,
            0.25,
            {
                Size = UDim2.fromOffset(600, 330)
            }
        ):Play()

        task.delay(0.12, function()

            if Window.Parent then
                MainArea.Visible = true
            end

        end)

    end)

    --==================================================
    -- Close
    --==================================================

    Close.MouseButton1Click:Connect(function()

        if ScreenGui.Parent then
            ScreenGui:Destroy()
        end

    end)

    --==================================================
    -- Create Tab
    --==================================================

    function WindowObject:CreateTab(Name)

        Name = Name or "Tab"

        --==================================================
        -- Tab Button
        --==================================================

        local TabButton = Create("TextButton", {
            Name = Name .. "_Button",
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Color3.fromRGB(27, 27, 33),
            BorderSizePixel = 0,
            Text = Name,
            TextColor3 = Color3.fromRGB(170, 170, 175),
            TextSize = 12,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }, TabList)

        AddCorner(TabButton, 7)

        Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12)
        }, TabButton)

        --==================================================
        -- Page
        --==================================================

        local Page = Create("ScrollingFrame", {
            Name = Name .. "_Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false
        }, PageContainer)

        local PageLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 7),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, Page)

        PageLayout:GetPropertyChangedSignal(
            "AbsoluteContentSize"
        ):Connect(function()

            Page.CanvasSize = UDim2.fromOffset(
                0,
                PageLayout.AbsoluteContentSize.Y + 10
            )

        end)

        local Tab = {}

        Tab.Name = Name
        Tab.Button = TabButton
        Tab.Page = Page

        --==================================================
        -- Select Tab
        --==================================================

        function Tab:Select()

            if WindowObject.CurrentTab then

                local Previous = WindowObject.CurrentTab

                Previous.Page.Visible = false

                Tween(
                    Previous.Button,
                    0.15,
                    {
                        BackgroundColor3 =
                            Color3.fromRGB(27, 27, 33),

                        TextColor3 =
                            Color3.fromRGB(170, 170, 175)
                    }
                ):Play()

            end

            WindowObject.CurrentTab = Tab

            Page.Visible = true

            Tween(
                TabButton,
                0.15,
                {
                    BackgroundColor3 =
                        Color3.fromRGB(45, 45, 55),

                    TextColor3 =
                        Color3.fromRGB(255, 255, 255)
                }
            ):Play()

        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Select()
        end)

        --==================================================
        -- Section
        --==================================================

        function Tab:CreateSection(Name)

            local Section = Create("TextLabel", {
                Name = "Section",
                Size = UDim2.new(1, -6, 0, 24),
                BackgroundTransparency = 1,
                Text = Name or "Section",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Page)

            return Section

        end

        --==================================================
        -- Button
        --==================================================

        function Tab:CreateButton(Settings)

            Settings = Settings or {}

            local Button = Create("TextButton", {
                Name = "Button",
                Size = UDim2.new(1, -6, 0, 40),
                BackgroundColor3 = Color3.fromRGB(30, 30, 36),
                BorderSizePixel = 0,
                Text = Settings.Name or "Button",
                TextColor3 = Color3.fromRGB(235, 235, 235),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                AutoButtonColor = false
            }, Page)

            AddCorner(Button, 8)

            Button.MouseButton1Click:Connect(function()

                Tween(
                    Button,
                    0.08,
                    {
                        BackgroundColor3 =
                            Color3.fromRGB(50, 50, 60)
                    }
                ):Play()

                task.delay(0.08, function()

                    if Button.Parent then

                        Tween(
                            Button,
                            0.12,
                            {
                                BackgroundColor3 =
                                    Color3.fromRGB(30, 30, 36)
                            }
                        ):Play()

                    end

                end)

                if Settings.Callback then
                    task.spawn(Settings.Callback)
                end

            end)

            return Button

        end

        --==================================================
        -- Toggle
        --==================================================

        function Tab:CreateToggle(Settings)

            Settings = Settings or {}

            local State = Settings.Default == true

            local Toggle = Create("TextButton", {
                Name = "Toggle",
                Size = UDim2.new(1, -6, 0, 46),
                BackgroundColor3 = Color3.fromRGB(30, 30, 36),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            }, Page)

            AddCorner(Toggle, 8)

            Create("TextLabel", {
                Position = UDim2.fromOffset(14, 0),
                Size = UDim2.new(1, -75, 1, 0),
                BackgroundTransparency = 1,
                Text = Settings.Name or "Toggle",
                TextColor3 = Color3.fromRGB(235, 235, 235),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Toggle)

            local Switch = Create("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(42, 22),
                BackgroundColor3 = Color3.fromRGB(55, 55, 62),
                BorderSizePixel = 0
            }, Toggle)

            AddCorner(Switch, 11)

            local Circle = Create("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 3, 0.5, 0),
                Size = UDim2.fromOffset(16, 16),
                BackgroundColor3 = Color3.fromRGB(220, 220, 220),
                BorderSizePixel = 0
            }, Switch)

            AddCorner(Circle, 8)

            local function Update()

                if State then

                    Tween(
                        Switch,
                        0.15,
                        {
                            BackgroundColor3 =
                                Color3.fromRGB(70, 130, 255)
                        }
                    ):Play()

                    Tween(
                        Circle,
                        0.15,
                        {
                            Position =
                                UDim2.new(1, -19, 0.5, 0)
                        }
                    ):Play()

                else

                    Tween(
                        Switch,
                        0.15,
                        {
                            BackgroundColor3 =
                                Color3.fromRGB(55, 55, 62)
                        }
                    ):Play()

                    Tween(
                        Circle,
                        0.15,
                        {
                            Position =
                                UDim2.new(0, 3, 0.5, 0)
                        }
                    ):Play()

                end

                if Settings.Callback then
                    task.spawn(
                        Settings.Callback,
                        State
                    )
                end

            end

            Toggle.MouseButton1Click:Connect(function()

                State = not State

                Update()

            end)

            Update()

            local ToggleObject = {}

            function ToggleObject:Set(Value)

                State = Value == true

                Update()

            end

            function ToggleObject:Get()

                return State

            end

            ToggleObject.Instance = Toggle

            return ToggleObject

        end

        --==================================================
        -- Slider
        --==================================================

        function Tab:CreateSlider(Settings)

            Settings = Settings or {}

            local Range = Settings.Range or {0, 100}

            local Minimum = tonumber(Range[1]) or 0
            local Maximum = tonumber(Range[2]) or 100

            local Increment =
                tonumber(Settings.Increment) or 1

            local CurrentValue =
                tonumber(Settings.CurrentValue) or Minimum

            CurrentValue = math.clamp(
                CurrentValue,
                Minimum,
                Maximum
            )

            local Slider = Create("Frame", {
                Name = "Slider",
                Size = UDim2.new(1, -6, 0, 58),
                BackgroundColor3 = Color3.fromRGB(30, 30, 36),
                BorderSizePixel = 0
            }, Page)

            AddCorner(Slider, 8)

            Create("TextLabel", {
                Position = UDim2.fromOffset(14, 7),
                Size = UDim2.new(1, -80, 0, 20),
                BackgroundTransparency = 1,
                Text = Settings.Name or "Slider",
                TextColor3 = Color3.fromRGB(235, 235, 235),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Slider)

            local ValueLabel = Create("TextLabel", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -14, 0, 7),
                Size = UDim2.fromOffset(55, 20),
                BackgroundTransparency = 1,
                Text = tostring(CurrentValue),
                TextColor3 = Color3.fromRGB(150, 170, 255),
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Right
            }, Slider)

            local Bar = Create("Frame", {
                Position = UDim2.new(0, 14, 0, 36),
                Size = UDim2.new(1, -28, 0, 6),
                BackgroundColor3 = Color3.fromRGB(55, 55, 62),
                BorderSizePixel = 0
            }, Slider)

            AddCorner(Bar, 4)

            local Denominator =
                math.max(Maximum - Minimum, 1)

            local InitialPercent =
                (CurrentValue - Minimum) /
                Denominator

            local Fill = Create("Frame", {
                Size = UDim2.new(
                    InitialPercent,
                    0,
                    1,
                    0
                ),
                BackgroundColor3 = Color3.fromRGB(70, 130, 255),
                BorderSizePixel = 0
            }, Bar)

            AddCorner(Fill, 4)

            local Knob = Create("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(
                    InitialPercent,
                    0,
                    0.5,
                    0
                ),
                Size = UDim2.fromOffset(14, 14),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0
            }, Bar)

            AddCorner(Knob, 7)

            local Hitbox = Create("TextButton", {
                Position = UDim2.fromOffset(0, -12),
                Size = UDim2.new(1, 0, 1, 24),
                BackgroundTransparency = 1,
                Text = ""
            }, Bar)

            local Dragging = false

            local function SetValue(Value)

                Value = math.clamp(
                    Value,
                    Minimum,
                    Maximum
                )

                Value =
                    math.floor(
                        ((Value - Minimum) / Increment) + 0.5
                    ) * Increment + Minimum

                Value = math.clamp(
                    Value,
                    Minimum,
                    Maximum
                )

                CurrentValue = Value

                local Percent =
                    (Value - Minimum) /
                    Denominator

                Tween(
                    Fill,
                    0.08,
                    {
                        Size = UDim2.new(
                            Percent,
                            0,
                            1,
                            0
                        )
                    }
                ):Play()

                Tween(
                    Knob,
                    0.08,
                    {
                        Position = UDim2.new(
                            Percent,
                            0,
                            0.5,
                            0
                        )
                    }
                ):Play()

                ValueLabel.Text = tostring(Value)

                if Settings.Callback then

                    task.spawn(
                        Settings.Callback,
                        Value
                    )

                end

            end

            local function UpdateFromInput(Input)

                if Bar.AbsoluteSize.X <= 0 then
                    return
                end

                local Percent = math.clamp(
                    (
                        Input.Position.X -
                        Bar.AbsolutePosition.X
                    ) / Bar.AbsoluteSize.X,
                    0,
                    1
                )

                local Value =
                    Minimum +
                    (
                        (Maximum - Minimum) *
                        Percent
                    )

                SetValue(Value)

            end

            Hitbox.InputBegan:Connect(function(Input)

                if Input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                    or Input.UserInputType ==
                    Enum.UserInputType.Touch then

                    Dragging = true

                    UpdateFromInput(Input)

                end

            end)

            UserInputService.InputChanged:Connect(function(Input)

                if not Dragging then
                    return
                end

                if Input.UserInputType ==
                    Enum.UserInputType.MouseMovement
                    or Input.UserInputType ==
                    Enum.UserInputType.Touch then

                    UpdateFromInput(Input)

                end

            end)

            UserInputService.InputEnded:Connect(function(Input)

                if Input.UserInputType ==
                    Enum.UserInputType.MouseButton1
                    or Input.UserInputType ==
                    Enum.UserInputType.Touch then

                    Dragging = false

                end

            end)

            local SliderObject = {}

            function SliderObject:Set(Value)

                SetValue(
                    tonumber(Value) or Minimum
                )

            end

            function SliderObject:Get()

                return CurrentValue

            end

            SliderObject.Instance = Slider

            return SliderObject

        end

        --==================================================
        -- Dropdown
        --==================================================

        function Tab:CreateDropdown(Settings)

            Settings = Settings or {}

            local Options = Settings.Options or {}

            local CurrentOption =
                Settings.CurrentOption or Options[1]

            local Opened = false

            local Dropdown = Create("Frame", {
                Name = "Dropdown",
                Size = UDim2.new(1, -6, 0, 42),
                BackgroundColor3 = Color3.fromRGB(30, 30, 36),
                BorderSizePixel = 0,
                ClipsDescendants = true
            }, Page)

            AddCorner(Dropdown, 8)

            local SelectButton = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false
            }, Dropdown)

            Create("TextLabel", {
                Position = UDim2.fromOffset(14, 0),
                Size = UDim2.new(0.55, 0, 0, 42),
                BackgroundTransparency = 1,
                Text = Settings.Name or "Dropdown",
                TextColor3 = Color3.fromRGB(235, 235, 235),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, SelectButton)

            local SelectedLabel = Create("TextLabel", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -30, 0, 0),
                Size = UDim2.new(0.35, 0, 0, 42),
                BackgroundTransparency = 1,
                Text = tostring(CurrentOption or "None"),
                TextColor3 = Color3.fromRGB(150, 170, 255),
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Right
            }, SelectButton)

            local Arrow = Create("TextLabel", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -12, 0, 0),
                Size = UDim2.fromOffset(15, 42),
                BackgroundTransparency = 1,
                Text = "⌄",
                TextColor3 = Color3.fromRGB(180, 180, 185),
                TextSize = 14,
                Font = Enum.Font.GothamBold
            }, SelectButton)

            local OptionList = Create("ScrollingFrame", {
                Position = UDim2.fromOffset(8, 45),
                Size = UDim2.new(1, -16, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 2,
                CanvasSize = UDim2.new(0, 0, 0, 0)
            }, Dropdown)

            local OptionLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, OptionList)

            OptionLayout:GetPropertyChangedSignal(
                "AbsoluteContentSize"
            ):Connect(function()

                OptionList.CanvasSize =
                    UDim2.fromOffset(
                        0,
                        OptionLayout.AbsoluteContentSize.Y + 5
                    )

            end)

            local function SelectOption(Option)

                CurrentOption = Option

                SelectedLabel.Text =
                    tostring(Option)

                if Settings.Callback then

                    task.spawn(
                        Settings.Callback,
                        Option
                    )

                end

            end

            for _, Option in ipairs(Options) do

                local OptionButton = Create("TextButton", {
                    Name = "Option",
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Color3.fromRGB(38, 38, 45),
                    BorderSizePixel = 0,
                    Text = tostring(Option),
                    TextColor3 = Color3.fromRGB(220, 220, 225),
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    AutoButtonColor = false
                }, OptionList)

                AddCorner(OptionButton, 6)

                OptionButton.MouseButton1Click:Connect(function()

                    SelectOption(Option)

                    Opened = false

                    Tween(
                        Dropdown,
                        0.15,
                        {
                            Size = UDim2.new(
                                1,
                                -6,
                                0,
                                42
                            )
                        }
                    ):Play()

                    Arrow.Text = "⌄"

                end)

            end

            SelectButton.MouseButton1Click:Connect(function()

                Opened = not Opened

                if Opened then

                    local Height =
                        math.min(
                            50 + (#Options * 36),
                            230
                        )

                    Tween(
                        Dropdown,
                        0.2,
                        {
                            Size = UDim2.new(
                                1,
                                -6,
                                0,
                                Height
                            )
                        }
                    ):Play()

                    Tween(
                        OptionList,
                        0.2,
                        {
                            Size = UDim2.new(
                                1,
                                -16,
                                0,
                                Height - 50
                            )
                        }
                    ):Play()

                    Arrow.Text = "⌃"

                else

                    Tween(
                        Dropdown,
                        0.2,
                        {
                            Size = UDim2.new(
                                1,
                                -6,
                                0,
                                42
                            )
                        }
                    ):Play()

                    Arrow.Text = "⌄"

                end

            end)

            local DropdownObject = {}

            function DropdownObject:Set(Option)

                for _, Value in ipairs(Options) do

                    if Value == Option then

                        SelectOption(Option)

                        return

                    end

                end

            end

            function DropdownObject:Get()

                return CurrentOption

            end

            DropdownObject.Instance = Dropdown

            return DropdownObject

        end

        --==================================================
        -- Input
        --==================================================

        function Tab:CreateInput(Settings)

            Settings = Settings or {}

            local InputFrame = Create("Frame", {
                Name = "Input",
                Size = UDim2.new(1, -6, 0, 58),
                BackgroundColor3 = Color3.fromRGB(30, 30, 36),
                BorderSizePixel = 0
            }, Page)

            AddCorner(InputFrame, 8)

            Create("TextLabel", {
                Position = UDim2.fromOffset(14, 6),
                Size = UDim2.new(1, -28, 0, 20),
                BackgroundTransparency = 1,
                Text = Settings.Name or "Input",
                TextColor3 = Color3.fromRGB(235, 235, 235),
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, InputFrame)

            local Box = Create("TextBox", {
                Position = UDim2.fromOffset(14, 30),
                Size = UDim2.new(1, -28, 0, 22),
                BackgroundColor3 = Color3.fromRGB(43, 43, 50),
                BorderSizePixel = 0,
                Text = Settings.Default or "",
                PlaceholderText =
                    Settings.PlaceholderText or "Enter text...",
                PlaceholderColor3 =
                    Color3.fromRGB(125, 125, 132),
                TextColor3 =
                    Color3.fromRGB(235, 235, 235),
                TextSize = 11,
                Font = Enum.Font.Gotham,
                ClearTextOnFocus =
                    Settings.ClearTextOnFocus == true
            }, InputFrame)

            AddCorner(Box, 6)

            Create("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8)
            }, Box)

            Box.FocusLost:Connect(function(EnterPressed)

                if Settings.Callback then

                    task.spawn(
                        Settings.Callback,
                        Box.Text,
                        EnterPressed
                    )

                end

            end)

            local InputObject = {}

            function InputObject:Set(Text)

                Box.Text = tostring(Text)

            end

            function InputObject:Get()

                return Box.Text

            end

            InputObject.Instance = InputFrame
            InputObject.TextBox = Box

            return InputObject

        end

        --==================================================
        -- Keybind
        --==================================================

        function Tab:CreateKeybind(Settings)

            Settings = Settings or {}

            local CurrentKey =
                Settings.CurrentKeybind or
                Enum.KeyCode.RightShift

            local Listening = false

            local Keybind = Create("TextButton", {
                Name = "Keybind",
                Size = UDim2.new(1, -6, 0, 46),
                BackgroundColor3 = Color3.fromRGB(30, 30, 36),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            }, Page)

            AddCorner(Keybind, 8)

            Create("TextLabel", {
                Position = UDim2.fromOffset(14, 0),
                Size = UDim2.new(1, -120, 1, 0),
                BackgroundTransparency = 1,
                Text = Settings.Name or "Keybind",
                TextColor3 = Color3.fromRGB(235, 235, 235),
                TextSize = 13,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            }, Keybind)

            local KeyLabel = Create("TextLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(90, 28),
                BackgroundColor3 = Color3.fromRGB(45, 45, 53),
                BorderSizePixel = 0,
                Text = CurrentKey.Name,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 11,
                Font = Enum.Font.GothamMedium
            }, Keybind)

            AddCorner(KeyLabel, 6)

            Keybind.MouseButton1Click:Connect(function()

                if Listening then
                    return
                end

                Listening = true

                KeyLabel.Text = "Press key..."

                Tween(
                    KeyLabel,
                    0.15,
                    {
                        BackgroundColor3 =
                            Color3.fromRGB(70, 130, 255)
                    }
                ):Play()

            end)

            local KeyConnection

            KeyConnection =
                UserInputService.InputBegan:Connect(
                    function(Input, GameProcessed)

                        if Listening then

                            if Input.UserInputType ==
                                Enum.UserInputType.Keyboard then

                                CurrentKey =
                                    Input.KeyCode

                                KeyLabel.Text =
                                    CurrentKey.Name

                                Listening = false

                                Tween(
                                    KeyLabel,
                                    0.15,
                                    {
                                        BackgroundColor3 =
                                            Color3.fromRGB(
                                                45,
                                                45,
                                                53
                                            )
                                    }
                                ):Play()

                            end

                            return
                        end

                        if GameProcessed then
                            return
                        end

                        if Input.KeyCode ==
                            CurrentKey then

                            if Settings.Callback then

                                task.spawn(
                                    Settings.Callback,
                                    CurrentKey
                                )

                            end

                        end

                    end
                )

            local KeybindObject = {}

            function KeybindObject:Set(Key)

                if typeof(Key) == "EnumItem" then

                    CurrentKey = Key

                    KeyLabel.Text =
                        CurrentKey.Name

                end

            end

            function KeybindObject:Get()

                return CurrentKey

            end

            function KeybindObject:Destroy()

                if KeyConnection then
                    KeyConnection:Disconnect()
                end

                if Keybind.Parent then
                    Keybind:Destroy()
                end

            end

            KeybindObject.Instance = Keybind

            return KeybindObject

        end

        --==================================================
        -- Store Tab
        --==================================================

        table.insert(
            WindowObject.Tabs,
            Tab
        )

        if #WindowObject.Tabs == 1 then
            Tab:Select()
        end

        return Tab

    end

    --==================================================
    -- Window Drag
    --==================================================

    local Dragging = false
    local DragStart
    local StartPosition

    TopBar.InputBegan:Connect(function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging = true

            DragStart = Input.Position
            StartPosition = Window.Position

            Input.Changed:Connect(function()

                if Input.UserInputState ==
                    Enum.UserInputState.End then

                    Dragging = false

                end

            end)

        end

    end)

    UserInputService.InputChanged:Connect(function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            local Delta =
                Input.Position - DragStart

            Window.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,

                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )

        end

    end)

    --==================================================
    -- Restore Button Drag
    --==================================================

    local RestoreDragging = false
    local RestoreStart
    local RestorePosition

    Restore.InputBegan:Connect(function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            RestoreDragging = true

            RestoreStart = Input.Position
            RestorePosition = Restore.Position

            Input.Changed:Connect(function()

                if Input.UserInputState ==
                    Enum.UserInputState.End then

                    RestoreDragging = false

                end

            end)

        end

    end)

    UserInputService.InputChanged:Connect(function(Input)

        if not RestoreDragging then
            return
        end

        if Input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            local Delta =
                Input.Position - RestoreStart

            Restore.Position = UDim2.new(
                RestorePosition.X.Scale,
                RestorePosition.X.Offset + Delta.X,

                RestorePosition.Y.Scale,
                RestorePosition.Y.Offset + Delta.Y
            )

        end

    end)

    return WindowObject

end

return WALLXP
