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

function WallXP:CreateWindow(options)
    options = options or {}

    local Window = {
        Title = options.Title or "WallXP",
        Tabs = {}
    }

    return Window
end

function WallXP:SetTheme(theme)
    for Name, Value in pairs(theme) do
        if self.Theme[Name] ~= nil then
            self.Theme[Name] = Value
        end
    end
end

function WallXP:GetVersion()
    return self.Version
end

return WallXP
