--[[
    WallXP UI Library
    Version: 0.4.0
    UI-only / executor-agnostic
]]

local WallXP = {}
WallXP.__index = WallXP

WallXP.Version = "0.5.0 Liquid Glass"

WallXP.Theme = {
    Background = Color3.fromRGB(20, 20, 27),
    Glass = Color3.fromRGB(255, 255, 255),
    GlassTransparency = 0.84,
    GlassHighlight = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(255, 255, 255),
    Element = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(105, 125, 255),
    AccentDark = Color3.fromRGB(76, 92, 210),
    Text = Color3.fromRGB(245, 245, 250),
    SubText = Color3.fromRGB(165, 165, 175),
    Stroke = Color3.fromRGB(45, 45, 55)
}

local function New(className, props)
    local obj = Instance.new(className)
    for key, value in pairs(props or {}) do
        obj[key] = value
    end
    return obj
end

local function Corner(obj, radius)
    New("UICorner", {
        Parent = obj,
        CornerRadius = UDim.new(0, radius or 8)
    })
end

local function Stroke(obj, color, thickness)
    New("UIStroke", {
        Parent = obj,
        Color = color or WallXP.Theme.Stroke,
        Thickness = thickness or 1,
        Transparency = 0.15
    })
end

local function Glassify(obj, transparency)
    obj.BackgroundTransparency = transparency or WallXP.Theme.GlassTransparency
    local gradient = New("UIGradient", {
        Parent = obj,
        Rotation = 115,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.48, Color3.fromRGB(225, 230, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.72),
            NumberSequenceKeypoint.new(0.5, 0.88),
            NumberSequenceKeypoint.new(1, 0.76)
        })
    })
    Stroke(obj, WallXP.Theme.GlassHighlight, 1)
    return gradient
end

local function Tween(obj, info, props)
    local TweenService = game:GetService("TweenService")
    TweenService:Create(obj, info, props):Play()
end

function WallXP:GetVersion()
    return self.Version
end

function WallXP:SetTheme(theme)
    for key, value in pairs(theme or {}) do
        if self.Theme[key] ~= nil then
            self.Theme[key] = value
        end
    end
end

function WallXP:CreateWindow(options)
    options = options or {}

    local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local gui = New("ScreenGui", {
        Name = "WallXP",
        Parent = playerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local windowSize = options.Size or UDim2.fromOffset(600, 400)

    local WindowFrame = New("Frame", {
        Parent = gui,
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0
    })
    Corner(WindowFrame, 22)
    Glassify(WindowFrame, 0.18)

    local Topbar = New("Frame", {
        Parent = WindowFrame,
        Size = UDim2.new(1, 0, 0, 76),
        BackgroundTransparency = 1
    })

    local Title = New("TextLabel", {
        Parent = Topbar,
        Position = UDim2.fromOffset(28, 20),
        Size = UDim2.new(1, -150, 0, 38),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = options.Title or "WallXP",
        TextColor3 = self.Theme.Text,
        TextSize = 26,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Highlight = New("Frame", {
        Parent = WindowFrame,
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 0, 2),
        BackgroundColor3 = WallXP.Theme.GlassHighlight,
        BackgroundTransparency = 0.72,
        BorderSizePixel = 0,
        ZIndex = 3
    })
    Corner(Highlight, 2)

    local Minimize = New("TextButton", {
        Parent = Topbar,
        Size = UDim2.fromOffset(54, 54),
        Position = UDim2.new(1, -126, 0, 11),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "—",
        TextColor3 = self.Theme.Text,
        TextSize = 24,
        AutoButtonColor = false
    })
    Corner(Minimize, 16)
    Glassify(Minimize, 0.72)

    local Close = New("TextButton", {
        Parent = Topbar,
        Size = UDim2.fromOffset(54, 54),
        Position = UDim2.new(1, -66, 0, 11),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = self.Theme.Text,
        TextSize = 25,
        AutoButtonColor = false
    })
    Corner(Close, 16)
    Glassify(Close, 0.72)

    local Side = New("Frame", {
        Parent = WindowFrame,
        Position = UDim2.fromOffset(14, 90),
        Size = UDim2.new(0, 220, 1, -104),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0
    })
    Corner(Side, 18)
    Glassify(Side, 0.78)

    local Pages = New("Frame", {
        Parent = WindowFrame,
        Position = UDim2.fromOffset(246, 90),
        Size = UDim2.new(1, -260, 1, -104),
        BackgroundTransparency = 1
    })

    local TabList = New("ScrollingFrame", {
        Parent = Side,
        Position = UDim2.fromOffset(8, 8),
        Size = UDim2.new(1, -16, 1, -16),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new()
    })

    local TabLayout = New("UIListLayout", {
        Parent = TabList,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local window = {}
    window.Gui = gui
    window.Frame = WindowFrame
    window.Pages = Pages
    window.Tabs = {}
    window.CurrentTab = nil
    window.Minimized = false

    local dragging = false
    local dragStart
    local startPos

    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = WindowFrame.Position
        end
    end)

    Topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then return end

        local delta = input.Position - dragStart
        WindowFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end)

    Minimize.MouseButton1Click:Connect(function()
        window.Minimized = not window.Minimized
        Side.Visible = not window.Minimized
        Pages.Visible = not window.Minimized

        if window.Minimized then
            WindowFrame.Size = UDim2.fromOffset(math.max(360, windowSize.X.Offset), 76)
        else
            WindowFrame.Size = windowSize
        end
    end)

    Close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    function window:CreateTab(tabOptions)
        tabOptions = tabOptions or {}

        local tabButton = New("TextButton", {
            Parent = TabList,
            Size = UDim2.new(1, 0, 0, 58),
            BackgroundColor3 = self.CurrentTab and WallXP.Theme.Element or WallXP.Theme.Accent,
            BorderSizePixel = 0,
            Font = Enum.Font.GothamMedium,
            Text = tabOptions.Name or "Tab",
            TextColor3 = WallXP.Theme.Text,
            TextSize = 17,
            AutoButtonColor = false
        })
        Corner(tabButton, 10)

        local page = New("ScrollingFrame", {
            Parent = Pages,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            CanvasSize = UDim2.new(),
            Visible = false
        })

        local pagePadding = New("UIPadding", {
            Parent = page,
            PaddingTop = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8)
        })

        local layout = New("UIListLayout", {
            Parent = page,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 20)
            TabList.CanvasSize = UDim2.fromOffset(0, TabLayout.AbsoluteContentSize.Y + 10)
        end)

        local tab = {
            Button = tabButton,
            Page = page,
            Window = self
        }

        function tab:Show()
            for _, other in ipairs(self.Window.Tabs) do
                other.Page.Visible = false
                other.Button.BackgroundColor3 = WallXP.Theme.Element
            end

            page.Visible = true
            tabButton.BackgroundColor3 = WallXP.Theme.Accent
            self.Window.CurrentTab = self
        end

        function tab:CreateSection(sectionOptions)
            sectionOptions = sectionOptions or {}

            local section = New("Frame", {
                Parent = page,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = WallXP.Theme.Secondary,
                BorderSizePixel = 0
            })
            Corner(section, 18)
            Glassify(section, 0.78)

            local sectionTitle = New("TextLabel", {
                Parent = section,
                Position = UDim2.fromOffset(16, 12),
                Size = UDim2.new(1, -32, 0, 26),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                Text = sectionOptions.Name or "Section",
                TextColor3 = WallXP.Theme.Text,
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local content = New("Frame", {
                Parent = section,
                Position = UDim2.fromOffset(12, 46),
                Size = UDim2.new(1, -24, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1
            })

            local contentLayout = New("UIListLayout", {
                Parent = content,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            New("UIPadding", {
                Parent = content,
                PaddingBottom = UDim.new(0, 14)
            })

            local api = {}

            function api:CreateLabel(o)
                o = o or {}
                local label = New("TextLabel", {
                    Parent = content,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    Text = o.Text or "Label",
                    TextColor3 = WallXP.Theme.SubText,
                    TextSize = 15,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                return label
            end

            function api:CreateButton(o)
                o = o or {}
                local button = New("TextButton", {
                    Parent = content,
                    Size = UDim2.new(1, 0, 0, 46),
                    BackgroundColor3 = WallXP.Theme.Element,
                    BorderSizePixel = 0,
                    Font = Enum.Font.GothamMedium,
                    Text = o.Name or "Button",
                    TextColor3 = WallXP.Theme.Text,
                    TextSize = 15,
                    AutoButtonColor = false
                })
                Corner(button, 12)
                Glassify(button, 0.72)

                button.MouseEnter:Connect(function()
                    Tween(button, TweenInfo.new(0.15), {BackgroundColor3 = WallXP.Theme.AccentDark})
                end)

                button.MouseLeave:Connect(function()
                    Tween(button, TweenInfo.new(0.15), {BackgroundColor3 = WallXP.Theme.Element})
                end)

                button.MouseButton1Click:Connect(function()
                    if typeof(o.Callback) == "function" then
                        task.spawn(o.Callback)
                    end
                end)

                return button
            end

            function api:CreateToggle(o)
                o = o or {}
                local state = o.Default == true

                local button = New("TextButton", {
                    Parent = content,
                    Size = UDim2.new(1, 0, 0, 46),
                    BackgroundColor3 = WallXP.Theme.Element,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false
                })
                Corner(button, 12)
                Glassify(button, 0.72)

                local text = New("TextLabel", {
                    Parent = button,
                    Position = UDim2.fromOffset(14, 0),
                    Size = UDim2.new(1, -80, 1, 0),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.GothamMedium,
                    Text = o.Name or "Toggle",
                    TextColor3 = WallXP.Theme.Text,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local indicator = New("Frame", {
                    Parent = button,
                    Size = UDim2.fromOffset(46, 24),
                    Position = UDim2.new(1, -60, 0.5, -12),
                    BackgroundColor3 = state and WallXP.Theme.Accent or WallXP.Theme.Stroke,
                    BorderSizePixel = 0
                })
                Corner(indicator, 12)

                local knob = New("Frame", {
                    Parent = indicator,
                    Size = UDim2.fromOffset(18, 18),
                    Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.fromOffset(3, 3),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                Corner(knob, 9)

                local function setState(value)
                    state = value == true
                    indicator.BackgroundColor3 = state and WallXP.Theme.Accent or WallXP.Theme.Stroke
                    Tween(knob, TweenInfo.new(0.15), {
                        Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.fromOffset(3, 3)
                    })
                    if typeof(o.Callback) == "function" then
                        task.spawn(o.Callback, state)
                    end
                end

                button.MouseButton1Click:Connect(function()
                    setState(not state)
                end)

                return {
                    Set = setState,
                    Get = function() return state end,
                    Instance = button
                }
            end

            function api:CreateSlider(o)
                o = o or {}
                local min = o.Min or 0
                local max = o.Max or 100
                local value = math.clamp(o.Default or min, min, max)

                local holder = New("Frame", {
                    Parent = content,
                    Size = UDim2.new(1, 0, 0, 68),
                    BackgroundColor3 = WallXP.Theme.Element,
                    BorderSizePixel = 0
                })
                Corner(holder, 12)
                Glassify(holder, 0.72)

                local name = New("TextLabel", {
                    Parent = holder,
                    Position = UDim2.fromOffset(14, 8),
                    Size = UDim2.new(1, -90, 0, 22),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.GothamMedium,
                    Text = o.Name or "Slider",
                    TextColor3 = WallXP.Theme.Text,
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local valueLabel = New("TextLabel", {
                    Parent = holder,
                    Position = UDim2.new(1, -70, 0, 8),
                    Size = UDim2.fromOffset(56, 22),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    Text = tostring(value),
                    TextColor3 = WallXP.Theme.SubText,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                local bar = New("Frame", {
                    Parent = holder,
                    Position = UDim2.new(0, 14, 1, -22),
                    Size = UDim2.new(1, -28, 0, 7),
                    BackgroundColor3 = WallXP.Theme.Stroke,
                    BorderSizePixel = 0
                })
                Corner(bar, 5)

                local fill = New("Frame", {
                    Parent = bar,
                    Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0),
                    BackgroundColor3 = WallXP.Theme.Accent,
                    BorderSizePixel = 0
                })
                Corner(fill, 5)

                local hitbox = New("TextButton", {
                    Parent = holder,
                    Position = UDim2.new(0, 8, 0, 28),
                    Size = UDim2.new(1, -16, 0, 34),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false
                })

                local function setValue(newValue)
                    value = math.clamp(newValue, min, max)
                    if o.Round ~= false then
                        value = math.floor(value + 0.5)
                    end
                    local percent = (value - min) / math.max(max - min, 1)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    valueLabel.Text = tostring(value)

                    if typeof(o.Callback) == "function" then
                        task.spawn(o.Callback, value)
                    end
                end

                local function updateFromX(x)
                    local percent = math.clamp(
                        (x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
                        0, 1
                    )
                    setValue(min + (max - min) * percent)
                end

                hitbox.MouseButton1Down:Connect(function(x)
                    updateFromX(x)
                    local moveConnection
                    local endConnection

                    moveConnection = game:GetService("UserInputService").InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch then
                            updateFromX(input.Position.X)
                        end
                    end)

                    endConnection = game:GetService("UserInputService").InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then
                            moveConnection:Disconnect()
                            endConnection:Disconnect()
                        end
                    end)
                end)

                return {
                    Set = setValue,
                    Get = function() return value end,
                    Instance = holder
                }
            end

            function api:CreateDropdown(o)
                o = o or {}
                local values = o.Values or {}
                local selected = o.Default or values[1] or "Select..."

                local holder = New("Frame", {
                    Parent = content,
                    Size = UDim2.new(1, 0, 0, 48),
                    BackgroundColor3 = WallXP.Theme.Element,
                    BorderSizePixel = 0,
                    ClipsDescendants = false
                })
                Corner(holder, 12)
                Glassify(holder, 0.72)

                local button = New("TextButton", {
                    Parent = holder,
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.GothamMedium,
                    Text = (o.Name or "Dropdown") .. ": " .. tostring(selected),
                    TextColor3 = WallXP.Theme.Text,
                    TextSize = 15,
                    AutoButtonColor = false
                })

                local list = New("Frame", {
                    Parent = holder,
                    Position = UDim2.new(0, 0, 1, 6),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = WallXP.Theme.Secondary,
                    BorderSizePixel = 0,
                    Visible = false,
                    ZIndex = 20
                })
                Corner(list, 9)
                Stroke(list)

                local listLayout = New("UIListLayout", {
                    Parent = list,
                    Padding = UDim.new(0, 4)
                })

                local open = false

                for _, item in ipairs(values) do
                    local option = New("TextButton", {
                        Parent = list,
                        Size = UDim2.new(1, -8, 0, 36),
                        Position = UDim2.fromOffset(4, 0),
                        BackgroundColor3 = WallXP.Theme.Element,
                        BorderSizePixel = 0,
                        Font = Enum.Font.Gotham,
                        Text = tostring(item),
                        TextColor3 = WallXP.Theme.Text,
                        TextSize = 14,
                        AutoButtonColor = false,
                        ZIndex = 21
                    })
                    Corner(option, 7)

                    option.MouseButton1Click:Connect(function()
                        selected = item
                        button.Text = (o.Name or "Dropdown") .. ": " .. tostring(selected)
                        open = false
                        list.Visible = false

                        if typeof(o.Callback) == "function" then
                            task.spawn(o.Callback, selected)
                        end
                    end)
                end

                button.MouseButton1Click:Connect(function()
                    open = not open
                    list.Visible = open
                end)

                return {
                    Set = function(item)
                        selected = item
                        button.Text = (o.Name or "Dropdown") .. ": " .. tostring(selected)
                    end,
                    Get = function() return selected end,
                    Instance = holder
                }
            end

            function api:CreateTextbox(o)
                o = o or {}

                local box = New("TextBox", {
                    Parent = content,
                    Size = UDim2.new(1, 0, 0, 46),
                    BackgroundColor3 = WallXP.Theme.Element,
                    BorderSizePixel = 0,
                    Font = Enum.Font.Gotham,
                    PlaceholderText = o.Placeholder or "Type something...",
                    Text = o.Default or "",
                    TextColor3 = WallXP.Theme.Text,
                    PlaceholderColor3 = WallXP.Theme.SubText,
                    TextSize = 15,
                    ClearTextOnFocus = false
                })
                Corner(box, 12)
                Glassify(box, 0.72)

                New("UIPadding", {
                    Parent = box,
                    PaddingLeft = UDim.new(0, 14),
                    PaddingRight = UDim.new(0, 14)
                })

                box.FocusLost:Connect(function()
                    if typeof(o.Callback) == "function" then
                        task.spawn(o.Callback, box.Text)
                    end
                end)

                return box
            end

            return api
        end

        table.insert(self.Tabs, tab)

        tabButton.MouseButton1Click:Connect(function()
            tab:Show()
        end)

        if not self.CurrentTab then
            tab:Show()
        end

        return tab
    end

    function window:Minimize()
        Minimize:Activate()
    end

    function window:Destroy()
        gui:Destroy()
    end

    return window
end

function WallXP:Notify(options)
    options = options or {}

    local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local holder = New("ScreenGui", {
        Parent = playerGui,
        Name = "WallXP_Notification",
        ResetOnSpawn = false
    })

    local frame = New("Frame", {
        Parent = holder,
        Size = UDim2.fromOffset(300, 88),
        Position = UDim2.new(1, -320, 1, -110),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0
    })
    Corner(frame, 18)
    Glassify(frame, 0.20)

    New("TextLabel", {
        Parent = frame,
        Position = UDim2.fromOffset(16, 10),
        Size = UDim2.new(1, -32, 0, 24),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = options.Title or "WallXP",
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    New("TextLabel", {
        Parent = frame,
        Position = UDim2.fromOffset(16, 38),
        Size = UDim2.new(1, -32, 0, 36),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = options.Content or "",
        TextColor3 = self.Theme.SubText,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    task.delay(options.Duration or 3, function()
        if holder then
            holder:Destroy()
        end
    end)

    return holder
end

return WallXP
