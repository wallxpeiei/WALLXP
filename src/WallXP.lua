local WallXP = {}
WallXP.__index = WallXP

WallXP.Version = "0.2.0"

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

    local Window = {
        Tabs = {}
    }

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "WallXP"
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = Gui
    Main.Size = options.Size or UDim2.fromOffset(600, 400)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = self.Theme.Background
    Main.BorderSizePixel = 0

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    -- Title
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

    -- Tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "Tabs"
    TabContainer.Parent = Main
    TabContainer.Position = UDim2.fromOffset(12, 55)
    TabContainer.Size = UDim2.new(0, 130, 1, -67)
    TabContainer.BackgroundColor3 = self.Theme.Secondary
    TabContainer.BorderSizePixel = 0

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.Padding = UDim.new(0, 6)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)

    -- Content
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Parent = Main
    Content.Position = UDim2.fromOffset(152, 55)
    Content.Size = UDim2.new(1, -164, 1, -67)
    Content.BackgroundTransparency = 1

    function Window:CreateTab(options)
        options = options or {}

        local Tab = {
            Name = options.Name or "Tab"
        }

        local TabButton = Instance.new("TextButton")
        TabButton.Name = Tab.Name
        TabButton.Parent = TabContainer
        TabButton.Size = UDim2.new(1, 0, 0, 36)
        TabButton.BackgroundColor3 = self.Theme.Background
        TabButton.BorderSizePixel = 0
        TabButton.Text = Tab.Name
        TabButton.TextColor3 = self.Theme.SubText
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.AutoButtonColor = false

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = TabButton

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = Tab.Name .. "_Page"
        TabPage.Parent = Content
        TabPage.Size = UDim2.fromScale(1, 1)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 3
        TabPage.Visible = false
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = TabPage
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = TabPage
        PagePadding.PaddingTop = UDim.new(0, 5)
        PagePadding.PaddingLeft = UDim.new(0, 5)
        PagePadding.PaddingRight = UDim.new(0, 5)
        PagePadding.PaddingBottom = UDim.new(0, 5)

        function Tab:Show()
            for _, OtherTab in pairs(Window.Tabs) do
                OtherTab.Page.Visible = false
                OtherTab.Button.BackgroundColor3 = WallXP.Theme.Background
                OtherTab.Button.TextColor3 = WallXP.Theme.SubText
            end

            TabPage.Visible = true
            TabButton.BackgroundColor3 = WallXP.Theme.Accent
            TabButton.TextColor3 = WallXP.Theme.Text
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Show()
        end)

        Tab.Button = TabButton
        Tab.Page = TabPage

        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            Tab:Show()
        end

        return Tab
    end

    Gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    Window.Gui = Gui
    Window.Main = Main
    Window.Content = Content

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
