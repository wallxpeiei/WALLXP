# WallXP

A modern and customizable Luau UI Library.

## Features

- Window
- Tabs
- Sections
- Buttons
- Toggles
- Sliders
- Dropdowns
- Textboxes
- Labels
- Notifications
- Custom Themes
- Drag & Minimize

## Example

```lua
local WallXP = require(script.Parent.src.WallXP)

local Window = WallXP:CreateWindow({
    Title = "WallXP"
})

local Main = Window:CreateTab({
    Name = "Main"
})

local Section = Main:CreateSection({
    Name = "Example"
})

Section:CreateButton({
    Name = "Hello",
    Callback = function()
        print("Hello WallXP!")
    end
})
