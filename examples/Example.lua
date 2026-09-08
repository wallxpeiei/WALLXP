local WallXP = require(script.Parent.Parent.src.WallXP)

local Window = WallXP:CreateWindow({
    Title = "WallXP Demo"
})

local Tab = Window:CreateTab({
    Name = "Main"
})

local Section = Tab:CreateSection({
    Name = "Example"
})

Section:CreateLabel({
    Text = "WallXP UI Library"
})

Section:CreateButton({
    Name = "Test Button",
    Callback = function()
        print("WallXP Button Works!")
        WallXP:Notify({
            Title = "WallXP",
            Content = "Button works!",
            Duration = 3
        })
    end
})

Section:CreateToggle({
    Name = "Test Toggle",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

Section:CreateSlider({
    Name = "Test Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Round = true,
    Callback = function(value)
        print("Slider:", value)
    end
})

Section:CreateDropdown({
    Name = "Test Dropdown",
    Values = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(value)
        print("Dropdown:", value)
    end
})

Section:CreateTextbox({
    Name = "Test Textbox",
    Placeholder = "Type something...",
    Callback = function(text)
        print("Textbox:", text)
    end
})
