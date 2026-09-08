-- WallXP UI Library
-- Version 0.3.0
-- UI-only Luau library

local WallXP = {}
WallXP.__index = WallXP

WallXP.Version = "0.3.0"

WallXP.Theme = {
    Background = Color3.fromRGB(18, 18, 22),
    Secondary = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(100, 120, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(160, 160, 170),
    Stroke = Color3.fromRGB(45, 45, 55)
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function New(className, props)
    local object = Instance.new(className)

    for property, value in pairs(props or {}) do
        object[property] = value
    end

    return object
end

local function Corner(parent, radius)
    return New("UICorner", {
        Parent = parent,
        CornerRadius = UDim.new(0, radius or 8)
    })
end

local function Stroke(parent)
    return New("UIStroke", {
        Parent = parent,
        Color = WallXP.Theme.Stroke,
        Thickness = 1
    })
end

local function Tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    ):Play()
end

function WallXP:GetVersion()
    return self.Version
end

function WallXP:SetTheme(theme)
    if typeof(theme) ~= "table" then
        return
    end

    for name, value in pairs(theme) do
        if self.Theme[name] ~= nil then
            self.Theme[name] = value
        end
    end
end

function WallXP:CreateWindow(options)
    options = options or {}

    if self._Gui then
        self._Gui:Destroy()
        self._Gui = nil
    end

    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Minimized = false
    }

    local player = Players.LocalPlayer
    if not player then
        error("WallXP: LocalPlayer is required.")
    end

    local playerGui = player:WaitForChild("PlayerGui")

    local Gui = New("ScreenGui", {
        Name = "WallXP",
        Parent = playerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Main = New("Frame", {
        Name = "Main",
        Parent = Gui,
        Size = options.Size or UDim2.fromOffset(620, 420),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0
    })
    Corner(Main, 10)
    Stroke(Main)

    local Topbar = New("Frame", {
        Name = "Topbar",
        Parent = Main,
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundTransparency = 1
    })

    New("TextLabel", {
        Name = "Title",
        Parent = Topbar,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(1, -105, 1, 0),
        Text = options.Title or "WallXP",
        TextColor3 = self.Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Minimize = New("TextButton", {
        Name = "Minimize",
        Parent = Topbar,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -45, 0.5, 0),
        Size = UDim2.fromOffset(30, 30),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Text = "—",
        TextColor3 = self.Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    })
    Corner(Minimize, 7)

    local Close = New("TextButton", {
        Name = "Close",
        Parent = Topbar,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(30, 30),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = self.Theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    })
    Corner(Close, 7)

    local TabContainer = New("Frame", {
        Name = "Tabs",
        Parent = Main,
        Position = UDim2.fromOffset(12, 55),
        Size = UDim2.new(0, 135, 1, -67),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0
    })
    Corner(TabContainer, 8)

    New("UIPadding", {
        Parent = TabContainer,
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8)
    })

    New("UIListLayout", {
        Parent = TabContainer,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local Content = New("Frame", {
        Name = "Content",
        Parent = Main,
        Position = UDim2.fromOffset(157, 55),
        Size = UDim2.new(1, -169, 1, -67),
        BackgroundTransparency = 1
    })

    -- Dragging
    local dragging = false
    local dragStart
    local startPosition

    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = Main.Position

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

            Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    function Window:CreateTab(options)
        options = options or {}

        local Tab = {
            Name = options.Name or ("Tab " .. tostring(#Window.Tabs + 1))
        }

        local TabButton = New("TextButton", {
            Name = Tab.Name,
            Parent = TabContainer,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = WallXP.Theme.Background,
            BorderSizePixel = 0,
            Text = Tab.Name,
            TextColor3 = WallXP.Theme.SubText,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false
        })
        Corner(TabButton, 6)

        local TabPage = New("ScrollingFrame", {
            Name = Tab.Name .. "_Page",
            Parent = Content,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = WallXP.Theme.Accent,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })

        New("UIPadding", {
            Parent = TabPage,
            PaddingTop = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5)
        })

        New("UIListLayout", {
            Parent = TabPage,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        function Tab:Show()
            for _, otherTab in ipairs(Window.Tabs) do
                otherTab.Page.Visible = false
                otherTab.Button.BackgroundColor3 = WallXP.Theme.Background
                otherTab.Button.TextColor3 = WallXP.Theme.SubText
            end

            TabPage.Visible = true
            TabButton.BackgroundColor3 = WallXP.Theme.Accent
            TabButton.TextColor3 = WallXP.Theme.Text
            Window.CurrentTab = Tab
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Show()
        end)

        function Tab:CreateSection(options)
            options = options or {}

            local Section = {}

            local Frame = New("Frame", {
                Name = options.Name or "Section",
                Parent = TabPage,
                Size = UDim2.new(1, 0, 0, 44),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = WallXP.Theme.Secondary,
                BorderSizePixel = 0
            })
            Corner(Frame, 8)

            New("TextLabel", {
                Name = "Title",
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 7),
                Size = UDim2.new(1, -24, 0, 25),
                Text = options.Name or "Section",
                TextColor3 = WallXP.Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Container = New("Frame", {
                Name = "Container",
                Parent = Frame,
                Position = UDim2.fromOffset(8, 38),
                Size = UDim2.new(1, -16, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1
            })

            local Layout = New("UIListLayout", {
                Parent = Container,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            local Padding = New("UIPadding", {
                Parent = Container,
                PaddingBottom = UDim.new(0, 8)
            })

            local function Resize()
                Frame.Size = UDim2.new(
                    1,
                    0,
                    0,
                    46 + Layout.AbsoluteContentSize.Y + 8
                )
            end

            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)

            function Section:CreateButton(options)
                options = options or {}

                local Button = New("TextButton", {
                    Name = "Button",
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 38),
                    BackgroundColor3 = WallXP.Theme.Background,
                    BorderSizePixel = 0,
                    Text = options.Name or "Button",
                    TextColor3 = WallXP.Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamMedium,
                    AutoButtonColor = false
                })
                Corner(Button, 6)

                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundColor3 = WallXP.Theme.Accent}, 0.12)
                end)

                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundColor3 = WallXP.Theme.Background}, 0.12)
                end)

                Button.MouseButton1Click:Connect(function()
                    if typeof(options.Callback) == "function" then
                        options.Callback()
                    end
                end)

                return Button
            end

            function Section:CreateToggle(options)
                options = options or {}

                local state = options.Default == true

                local Button = New("TextButton", {
                    Name = "Toggle",
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 38),
                    BackgroundColor3 = WallXP.Theme.Background,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false
                })
                Corner(Button, 6)

                New("TextLabel", {
                    Parent = Button,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 0),
                    Size = UDim2.new(1, -65, 1, 0),
                    Text = options.Name or "Toggle",
                    TextColor3 = WallXP.Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamMedium,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local Switch = New("Frame", {
                    Parent = Button,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.fromOffset(38, 20),
                    BackgroundColor3 = WallXP.Theme.Background,
                    BorderSizePixel = 0
                })
                Corner(Switch, 10)
                Stroke(Switch)

                local Knob = New("Frame", {
                    Parent = Switch,
                    Size = UDim2.fromOffset(14, 14),
                    Position = UDim2.fromOffset(3, 3),
                    BackgroundColor3 = WallXP.Theme.SubText,
                    BorderSizePixel = 0
                })
                Corner(Knob, 7)

                local function Update()
                    if state then
                        Tween(Switch, {BackgroundColor3 = WallXP.Theme.Accent}, 0.15)
                        Tween(Knob, {Position = UDim2.new(1, -17, 0, 3)}, 0.15)
                    else
                        Tween(Switch, {BackgroundColor3 = WallXP.Theme.Background}, 0.15)
                        Tween(Knob, {Position = UDim2.fromOffset(3, 3)}, 0.15)
                    end
                end

                function Button:Set(value)
                    state = value == true
                    Update()

                    if typeof(options.Callback) == "function" then
                        options.Callback(state)
                    end
                end

                function Button:Get()
                    return state
                end

                Button.MouseButton1Click:Connect(function()
                    Button:Set(not state)
                end)

                Update()

                return Button
            end

            function Section:CreateSlider(options)
                options = options or {}

                local min = tonumber(options.Min) or 0
                local max = tonumber(options.Max) or 100
                local value = tonumber(options.Default) or min

                if max <= min then
                    max = min + 1
                end

                value = math.clamp(value, min, max)

                local Holder = New("Frame", {
                    Name = "Slider",
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 55),
                    BackgroundColor3 = WallXP.Theme.Background,
                    BorderSizePixel = 0
                })
                Corner(Holder, 6)

                local NameLabel = New("TextLabel", {
                    Parent = Holder,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(10, 5),
                    Size = UDim2.new(1, -70, 0, 20),
                    Text = options.Name or "Slider",
                    TextColor3 = WallXP.Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamMedium,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local ValueLabel = New("TextLabel", {
                    Parent = Holder,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -10, 0, 5),
                    Size = UDim2.fromOffset(55, 20),
                    Text = tostring(value),
                    TextColor3 = WallXP.Theme.SubText,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                local Bar = New("Frame", {
                    Parent = Holder,
                    Position = UDim2.new(0, 10, 1, -18),
                    Size = UDim2.new(1, -20, 0, 6),
                    BackgroundColor3 = WallXP.Theme.Secondary,
                    BorderSizePixel = 0
                })
                Corner(Bar, 3)

                local Fill = New("Frame", {
                    Parent = Bar,
                    Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = WallXP.Theme.Accent,
                    BorderSizePixel = 0
                })
                Corner(Fill, 3)

                local draggingSlider = false

                local function SetValue(newValue, fireCallback)
                    value = math.clamp(newValue, min, max)
                    local percent = (value - min) / (max - min)

                    Fill.Size = UDim2.new(percent, 0, 1, 0)
                    ValueLabel.Text = tostring(value)

                    if fireCallback and typeof(options.Callback) == "function" then
                        options.Callback(value)
                    end
                end

                local function UpdateFromInput(input)
                    local percent = math.clamp(
                        (input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
                        0,
                        1
                    )

                    local newValue = min + (max - min) * percent

                    if options.Round then
                        newValue = math.floor(newValue + 0.5)
                    else
                        newValue = math.floor(newValue * 100) / 100
                    end

                    SetValue(newValue, true)
                end

                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then

                        draggingSlider = true
                        UpdateFromInput(input)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if draggingSlider and (
                        input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch
                    ) then
                        UpdateFromInput(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                        draggingSlider = false
                    end
                end)

                function Holder:Set(newValue)
                    SetValue(tonumber(newValue) or min, true)
                end

                function Holder:Get()
                    return value
                end

                return Holder
            end

            function Section:CreateDropdown(options)
                options = options or {}

                local values = options.Values or {}
                local selected = options.Default or values[1]
                local opened = false

                local Holder = New("Frame", {
                    Name = "Dropdown",
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = WallXP.Theme.Background,
                    BorderSizePixel = 0,
                    ClipsDescendants = true
                })
                Corner(Holder, 6)

                local MainButton = New("TextButton", {
                    Parent = Holder,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false
                })

                New("TextLabel", {
                    Parent = MainButton,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(10, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Text = options.Name or "Dropdown",
                    TextColor3 = WallXP.Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamMedium,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local SelectedLabel = New("TextLabel", {
                    Parent = MainButton,
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -12, 0, 0),
                    Size = UDim2.new(0.45, 0, 1, 0),
                    Text = tostring(selected or ""),
                    TextColor3 = WallXP.Theme.SubText,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                local List = New("Frame", {
                    Parent = Holder,
                    Position = UDim2.fromOffset(8, 44),
                    Size = UDim2.new(1, -16, 0, 0),
                    BackgroundTransparency = 1
                })

                local ListLayout = New("UIListLayout", {
                    Parent = List,
                    Padding = UDim.new(0, 5)
                })

                local function ResizeList()
                    List.Size = UDim2.new(1, -16, 0, ListLayout.AbsoluteContentSize.Y)
                    Holder.Size = UDim2.new(
                        1, 0,
                        0,
                        opened and (44 + ListLayout.AbsoluteContentSize.Y) or 40
                    )
                end

                for _, item in ipairs(values) do
                    local Option = New("TextButton", {
                        Parent = List,
                        Size = UDim2.new(1, 0, 0, 30),
                        BackgroundColor3 = WallXP.Theme.Secondary,
                        BorderSizePixel = 0,
                        Text = tostring(item),
                        TextColor3 = WallXP.Theme.Text,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        AutoButtonColor = false
                    })
                    Corner(Option, 5)

                    Option.MouseButton1Click:Connect(function()
                        selected = item
                        SelectedLabel.Text = tostring(item)
                        opened = false
                        ResizeList()

                        if typeof(options.Callback) == "function" then
                            options.Callback(item)
                        end
                    end)
                end

                MainButton.MouseButton1Click:Connect(function()
                    opened = not opened
                    ResizeList()
                end)

                ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(ResizeList)

                function Holder:Set(value)
                    selected = value
                    SelectedLabel.Text = tostring(value)

                    if typeof(options.Callback) == "function" then
                        options.Callback(value)
                    end
                end

                function Holder:Get()
                    return selected
                end

                ResizeList()

                return Holder
            end

            function Section:CreateTextbox(options)
                options = options or {}

                local Holder = New("Frame", {
                    Name = "Textbox",
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = WallXP.Theme.Background,
                    BorderSizePixel = 0
                })
                Corner(Holder, 6)

                local Box = New("TextBox", {
                    Parent = Holder,
                    Position = UDim2.fromOffset(10, 4),
                    Size = UDim2.new(1, -20, 1, -8),
                    BackgroundTransparency = 1,
                    ClearTextOnFocus = options.ClearOnFocus ~= false,
                    PlaceholderText = options.Placeholder or "Enter text...",
                    Text = options.Default or "",
                    TextColor3 = WallXP.Theme.Text,
                    PlaceholderColor3 = WallXP.Theme.SubText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                Box.FocusLost:Connect(function(enterPressed)
                    if typeof(options.Callback) == "function" then
                        options.Callback(Box.Text, enterPressed)
                    end
                end)

                function Holder:Set(text)
                    Box.Text = tostring(text)
                end

                function Holder:Get()
                    return Box.Text
                end

                return Holder
            end

            function Section:CreateLabel(options)
                options = options or {}

                local Label = New("TextLabel", {
                    Name = "Label",
                    Parent = Container,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = options.Text or "Label",
                    TextColor3 = options.Color or WallXP.Theme.SubText,
                    TextSize = options.TextSize or 13,
                    Font = options.Font or Enum.Font.Gotham,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                function Label:Set(text)
                    Label.Text = tostring(text)
                end

                return Label
            end

            return Section
        end

        Tab.Button = TabButton
        Tab.Page = TabPage

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            Tab:Show()
        end

        return Tab
    end

    function Window:Minimize()
        Window.Minimized = not Window.Minimized

        Content.Visible = not Window.Minimized
        TabContainer.Visible = not Window.Minimized

        if Window.Minimized then
            Main.Size = UDim2.new(
                Main.Size.X.Scale,
                Main.Size.X.Offset,
                0,
                48
            )
        else
            Main.Size = options.Size or UDim2.fromOffset(620, 420)
        end
    end

    function Window:Destroy()
        if Gui then
            Gui:Destroy()
        end

        if WallXP._Gui == Gui then
            WallXP._Gui = nil
        end
    end

    Minimize.MouseButton1Click:Connect(function()
        Window:Minimize()
    end)

    Close.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)

    self._Gui = Gui

    return Window
end

function WallXP:Notify(options)
    options = options or {}

    if not self._Gui then
        return
    end

    local holder = self._Gui:FindFirstChild("Notifications")

    if not holder then
        holder = New("Frame", {
            Name = "Notifications",
            Parent = self._Gui,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -15, 1, -15),
            Size = UDim2.fromOffset(300, 350),
            BackgroundTransparency = 1
        })

        New("UIListLayout", {
            Parent = holder,
            Padding = UDim.new(0, 8),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
    end

    local notification = New("Frame", {
        Parent = holder,
        Size = UDim2.fromOffset(280, 65),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0
    })
    Corner(notification, 8)
    Stroke(notification)

    New("TextLabel", {
        Parent = notification,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 7),
        Size = UDim2.new(1, -24, 0, 22),
        Text = options.Title or "WallXP",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    New("TextLabel", {
        Parent = notification,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 29),
        Size = UDim2.new(1, -24, 0, 25),
        Text = options.Content or "",
        TextColor3 = self.Theme.SubText,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    task.delay(tonumber(options.Duration) or 3, function()
        if notification.Parent then
            Tween(notification, {BackgroundTransparency = 1}, 0.2)
            task.wait(0.2)
            notification:Destroy()
        end
    end)

    return notification
end

return WallXP
