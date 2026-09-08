--// WALLXP UI LIBRARY
--// Version 1.0
--// CreateWindow

local WALLXP = {}
WALLXP.__index = WALLXP

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--==================================================
-- ScreenGui
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WALLXP_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

--==================================================
-- Create Window
--==================================================

function WALLXP:CreateWindow(Settings)

    Settings = Settings or {}

    local WindowName = Settings.Name or "WALLXP"
    local WindowSubtitle = Settings.Subtitle or "Custom UI Library"

    -- Main Window
    local Window = Instance.new("Frame")
    Window.Name = "MainWindow"
    Window.Parent = ScreenGui
    Window.Size = UDim2.fromOffset(620, 400)
    Window.Position = UDim2.new(0.5, -310, 0.5, -200)
    Window.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Window.BorderSizePixel = 0

    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = UDim.new(0, 12)
    WindowCorner.Parent = Window

    --==================================================
    -- Top Bar
    --==================================================

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = Window
    TopBar.Size = UDim2.new(1, 0, 0, 60)
    TopBar.BackgroundTransparency = 1

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.Position = UDim2.fromOffset(20, 8)
    Title.Size = UDim2.new(1, -80, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Text = WindowName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Parent = TopBar
    Subtitle.Position = UDim2.fromOffset(21, 34)
    Subtitle.Size = UDim2.new(1, -80, 0, 18)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = WindowSubtitle
    Subtitle.TextColor3 = Color3.fromRGB(145, 145, 150)
    Subtitle.TextSize = 11
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left

    --==================================================
    -- Close Button
    --==================================================

    local Close = Instance.new("TextButton")
    Close.Name = "Close"
    Close.Parent = TopBar
    Close.AnchorPoint = Vector2.new(1, 0.5)
    Close.Position = UDim2.new(1, -15, 0.5, 0)
    Close.Size = UDim2.fromOffset(32, 32)
    Close.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    Close.BorderSizePixel = 0
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(220, 220, 220)
    Close.TextSize = 20
    Close.Font = Enum.Font.GothamBold

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = Close

    --==================================================
    -- Content
    --==================================================

    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Parent = Window
    Content.Position = UDim2.fromOffset(12, 65)
    Content.Size = UDim2.new(1, -24, 1, -77)
    Content.BackgroundColor3 = Color3.fromRGB(23, 23, 28)
    Content.BorderSizePixel = 0

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = Content

    --==================================================
    -- Close
    --==================================================

    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

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

    --==================================================
    -- Window Object
    --==================================================

    local WindowObject = {}

    WindowObject.Window = Window
    WindowObject.Content = Content

    return WindowObject
end

return WALLXP
