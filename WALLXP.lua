--// WALLXP UI LIBRARY
--// Version 1.1
--// Window + Sidebar + Tabs

local WALLXP = {}
WALLXP.__index = WALLXP

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

--==================================================
-- Services / GUI
--==================================================

local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WALLXP_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success = pcall(function()
    ScreenGui.Parent = CoreGui
end)

if not success or not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

--==================================================
-- Utility
--==================================================

local function Create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent

    return object
end

local function Corner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, parent)
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
        Size = UDim2.fromOffset(650, 420),
        Position = UDim2.new(0.5, -325, 0.5, -210),
        BackgroundColor3 = Color3.fromRGB(17, 17, 21),
        BorderSizePixel = 0
    }, ScreenGui)

    Corner(Window, 12)

    --==================================================
    -- Top Bar
    --==================================================

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundTransparency = 1
    }, Window)

    -- Title

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

    -- Subtitle

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

    Corner(Close, 8)

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

    Corner(MainArea, 10)

    --==================================================
    -- Sidebar
    --==================================================

    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Position = UDim2.fromOffset(8, 8),
        Size = UDim2.new(0, 145, 1, -16),
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        BorderSizePixel = 0
    }, MainArea)

    Corner(Sidebar, 8)

    --==================================================
    -- Tab List
    --==================================================

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
    -- Page Container
    --==================================================

    local PageContainer = Create("Frame", {
        Name = "Pages",
        Position = UDim2.fromOffset(161, 8),
        Size = UDim2.new(1, -169, 1, -16),
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

        -- Tab Button

        local TabButton = Create("TextButton", {
            Name = Name .. "_Button",
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Color3.fromRGB(27, 27, 33),
            BorderSizePixel = 0,
            Text = Name,
            TextColor3 = Color3.fromRGB(170, 170, 175),
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        }, TabList)

        Corner(TabButton, 7)

        local Padding = Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12)
        }, TabButton)

        -- Page

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
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, Page)

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

            Page.CanvasSize = UDim2.fromOffset(
                0,
                PageLayout.AbsoluteContentSize.Y + 10
            )

        end)

        --==================================================
        -- Tab Object
        --==================================================

        local Tab = {}

        Tab.Name = Name
        Tab.Button = TabButton
        Tab.Page = Page

        --==================================================
        -- Select Tab
        --==================================================

        function Tab:Select()

            local Previous = WindowObject.CurrentTab

            if Previous then

                Previous.Page.Visible = false

                TweenService:Create(
                    Previous.Button,
                    TweenInfo.new(0.15),
                    {
                        BackgroundColor3 = Color3.fromRGB(27, 27, 33),
                        TextColor3 = Color3.fromRGB(170, 170, 175)
                    }
                ):Play()

            end

            WindowObject.CurrentTab = Tab

            Page.Visible = true

            TweenService:Create(
                TabButton,
                TweenInfo.new(0.15),
                {
                    BackgroundColor3 = Color3.fromRGB(45, 45, 55),
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }
            ):Play()

        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Select()
        end)

        table.insert(WindowObject.Tabs, Tab)

        -- First tab automatically selected

        if #WindowObject.Tabs == 1 then
            Tab:Select()
        end

        return Tab
    end

    --==================================================
    -- Drag System
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
