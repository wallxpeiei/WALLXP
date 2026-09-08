--//==================================================
--// WALLXP UI LIBRARY
--// Version 1.3
--// Window + Tabs + Section + Button + Toggle
--// Slider + Dropdown
--//==================================================

local WALLXP = {}
WALLXP.__index = WALLXP

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WALLXP_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScreenGui.Parent = Player:WaitForChild("PlayerGui")

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
-- Create Window
--==================================================

function WALLXP:CreateWindow(Settings)

    Settings = Settings or {}

    local WindowName = Settings.Name or "WALLXP"
    local WindowSubtitle = Settings.Subtitle or "Custom UI Library"

    local Window = Create("Frame", {
        Name = "Window",
        Size = UDim2.fromOffset(600, 330),
        Position = UDim2.new(0.5, -300, 0.5, -165),
        BackgroundColor3 = Color3.fromRGB(17, 17, 21),
        BorderSizePixel = 0
    }, ScreenGui)

    AddCorner(Window, 12)

    --==================================================
    -- Top Bar
    --==================================================

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundTransparency = 1
    }, Window)

    Create("TextLabel", {
        Name = "Title",
        Position = UDim2.fromOffset(20, 8),
        Size = UDim2.new(1, -80, 0, 25),
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, TopBar)

    Create("TextLabel", {
        Name = "Subtitle",
        Position = UDim2.fromOffset(21, 33),
        Size = UDim2.new(1, -80, 0, 18),
        BackgroundTransparency = 1,
        Text = WindowSubtitle,
        TextColor3 = Color3.fromRGB(145, 145, 150),
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, TopBar)

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

    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

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

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

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
    -- Window Object
    --==================================================

    local WindowObject = {}

    WindowObject.Window = Window
    WindowObject.MainArea = MainArea
    WindowObject.Sidebar = Sidebar
    WindowObject.Pages = PageContainer
    WindowObject.Tabs = {}
    WindowObject.CurrentTab = nil

    --==================================================
    -- Create Tab
    --==================================================

    function WindowObject:CreateTab(Name)

        Name = Name or "Tab"

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

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

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
                        BackgroundColor3 = Color3.fromRGB(27, 27, 33),
                        TextColor3 = Color3.fromRGB(170, 170, 175)
                    }
                ):Play()

            end

            WindowObject.CurrentTab = Tab

            Page.Visible = true

            Tween(
                TabButton,
                0.15,
                {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 55),
                    TextColor3 = Color3.fromRGB(255, 255, 255)
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
                        BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                    }
                ):Play()

                task.delay(0.08, function()

                    if Button.Parent then

                        Tween(
                            Button,
                            0.12,
                            {
                                BackgroundColor3 = Color3.fromRGB(30, 30, 36)
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
                            BackgroundColor3 = Color3.fromRGB(70, 130, 255)
                        }
                    ):Play()

                    Tween(
                        Circle,
                        0.15,
                        {
                            Position = UDim2.new(1, -19, 0.5, 0)
                        }
                    ):Play()

                else

                    Tween(
                        Switch,
                        0.15,
                        {
                            BackgroundColor3 = Color3.fromRGB(55, 55, 62)
                        }
                    ):Play()

                    Tween(
                        Circle,
                        0.15,
                        {
                            Position = UDim2.new(0, 3, 0.5, 0)
                        }
                    ):Play()

                end

                if Settings.Callback then
                    task.spawn(Settings.Callback, State)
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
            local Minimum = Range[1]
            local Maximum = Range[2]

            local Increment = Settings.Increment or 1
            local CurrentValue = Settings.CurrentValue or Minimum

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
                Position = UDim2.new(1, -14, 7, 0),
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

            local Fill = Create("Frame", {
                Size = UDim2.new(
                    (CurrentValue - Minimum) /
                    (Maximum - Minimum),
                    0,
                    1,
                    0
                ),
                BackgroundColor3 = Color3.fromRGB(70, 130, 255),
                BorderSizePixel = 0
            }, Bar)

            AddCorner(Fill, 4)

            local Hitbox = Create("TextButton", {
                Position = UDim2.fromOffset(0, -10),
                Size = UDim2.new(1, 0, 1, 20),
                BackgroundTransparency = 1,
                Text = ""
            }, Bar)

            local Dragging = false

            local function SetValue(Value)

                Value = math.clamp(Value, Minimum, Maximum)

                Value = math.floor(
                    ((Value - Minimum) / Increment) + 0.5
                ) * Increment + Minimum

                Value = math.clamp(Value, Minimum, Maximum)

                CurrentValue = Value

                local Percent =
                    (Value - Minimum) /
                    (Maximum - Minimum)

                Tween(
                    Fill,
                    0.1,
                    {
                        Size = UDim2.new(
                            Percent,
                            0,
                            1,
                            0
                        )
                    }
                ):Play()

                ValueLabel.Text = tostring(Value)

                if Settings.Callback then
                    task.spawn(Settings.Callback, Value)
                end

            end

            local function UpdateFromInput(Input)

                local Percent = math.clamp(
                    (Input.Position.X - Bar.AbsolutePosition.X) /
                    Bar.AbsoluteSize.X,
                    0,
                    1
                )

                local Value =
                    Minimum +
                    ((Maximum - Minimum) * Percent)

                SetValue(Value)

            end

            Hitbox.InputBegan:Connect(function(Input)

                if Input.UserInputType == Enum.UserInputType.MouseButton1
                or Input.UserInputType == Enum.UserInputType.Touch then

                    Dragging = true

                    UpdateFromInput(Input)

                end

            end)

            UserInputService.InputChanged:Connect(function(Input)

                if not Dragging then
                    return
                end

                if Input.UserInputType == Enum.UserInputType.MouseMovement
                or Input.UserInputType == Enum.UserInputType.Touch then

                    UpdateFromInput(Input)

                end

            end)

            UserInputService.InputEnded:Connect(function(Input)

                if Input.UserInputType == Enum.UserInputType.MouseButton1
                or Input.UserInputType == Enum.UserInputType.Touch then

                    Dragging = false

                end

            end)

            local SliderObject = {}

            function SliderObject:Set(Value)
                SetValue(Value)
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

            local OptionList = Create("Frame", {
                Position = UDim2.fromOffset(8, 45),
                Size = UDim2.new(1, -16, 0, 0),
                BackgroundTransparency = 1
            }, Dropdown)

            local OptionLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, OptionList)

            local function SelectOption(Option)

                CurrentOption = Option

                SelectedLabel.Text = tostring(Option)

                if Settings.Callback then
                    task.spawn(Settings.Callback, Option)
                end

            end

            for _, Option in ipairs(Options) do

                local OptionButton = Create("TextButton", {
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

                    local Height = 42

                    Tween(
                        Dropdown,
                        0.15,
                        {
                            Size = UDim2.new(1, -6, 0, Height)
                        }
                    ):Play()

                    Arrow.Text = "⌄"

                end)

            end

            SelectButton.MouseButton1Click:Connect(function()

                Opened = not Opened

                if Opened then

                    local Height =
                        50 +
                        (#Options * 36)

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
        -- Store Tab
        --==================================================

        table.insert(WindowObject.Tabs, Tab)

        if #WindowObject.Tabs == 1 then
            Tab:Select()
        end

        return Tab

    end

    --==================================================
    -- Drag Window
    --==================================================

    local Dragging = false
    local DragStart
    local StartPosition

    TopBar.InputBegan:Connect(function(Input)

        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

            Dragging = true
            DragStart = Input.Position
            StartPosition = Window.Position

            Input.Changed:Connect(function()

                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end

            end)

        end

    end)

    UserInputService.InputChanged:Connect(function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then

            local Delta = Input.Position - DragStart

            Window.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,

                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )

        end

    end)

    return WindowObject
end

return WALLXP
