local Library = loadstring(game:HttpGetAsync(
                               "https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync(
                                   "https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync(
                                        "https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local bloodline = ""
local slot = ""

local Window = Library:CreateWindow{
    Title = "SlashHub",
    SubTitle = "by Wh1teSlash",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
}

local Tabs = {
    Main = Window:CreateTab{Title = "Main", Icon = "phosphor-users-bold"},
    Settings = Window:CreateTab{Title = "Settings", Icon = "settings"}
}

local Options = Library.Options

Tabs.Main:CreateInput("Input", {
    Title = "Bloodline",
    Default = "",
    Placeholder = "Enter bloodline",
    Numeric = false,
    Finished = false,
    Callback = function(Value) bloodline = Value end
})

local Dropdown = Tabs.Main:CreateDropdown("Dropdown", {
    Title = "Slot",
    Values = {"item1", "item2", "item3"},
    Multi = false,
    Default = "",
    Callback = function(Value) slot = Value end
})

Tabs.Main:CreateButton{
    Title = "Set slot",
    Description = "",
    Callback = function()
        local slotValue = workspace.RCGENKAI:FindFirstChild(slot)

        if slotValue then
            slotValue.Value = bloodline
        else
            warn("Slot not found")
        end
    end
}

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

InterfaceManager:SetFolder("SlashHub")
SaveManager:SetFolder("SlashHub/shindo-rc-changer")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

SaveManager:LoadAutoloadConfig()
