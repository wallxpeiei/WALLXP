local WallXP = {}
WallXP.__index = WallXP

WallXP.Version = "0.1.0"

WallXP.Theme = {
    Background = Color3.fromRGB(18, 18, 22),
    Secondary = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(100, 120, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(160, 160, 170)
}

local Players = game:GetService("Players")

function WallXP:CreateWindow(options)
    options = options or {}

    local Window = {}

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "WallXP"
    Gui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = Gui
    Main.Size = options.Size or UDim2.fromOffset(600, 400)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = self.Theme.Background
    Main.BorderSizePixel = 0

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Main
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.fromOffset(18, 10)
    Title.Size = UDim2.new(1, -36, 0, 35)
    Title.Text = options.Title or "WallXP"
    Title.TextColor3 = self.Theme.Text
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    Gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    Window.Gui = Gui
    Window.Main = Main

    return Window
end

function WallXP:SetTheme(theme)
    for name, value in pairs(theme) do
        if self.Theme[name] ~= nil then
            self.Theme[name] = value
        end
    end
end

function WallXP:GetVersion()
    return self.Version
end

return WallXP
