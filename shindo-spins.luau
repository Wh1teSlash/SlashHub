getgenv().selectedBloodlineSlots = {}
getgenv().selectedBloodlinesToSpin = {}
getgenv().bloodlineSpinning = false

local player = game:GetService("Players").LocalPlayer

local Library = loadstring(game:HttpGetAsync(
                               "https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync(
                                   "https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync(
                                        "https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

function getAllBloodlines()
    local bloodlines = workspace.RAREKGS:GetChildren()
    local allBloodlines = {}

    for _, bloodline in pairs(bloodlines) do
        if bloodline.Name ~= "KGTEMPLATE" and bloodline.tim.Value ~= "N/A" then
            print(bloodline.Name)
            table.insert(allBloodlines, bloodline.Name)
        end
    end

    return allBloodlines
end

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
    Spins = Window:CreateTab{Title = "Spins", Icon = "refresh-cw"},
    Settings = Window:CreateTab{Title = "Settings", Icon = "settings"}
}

local Options = Library.Options

Tabs.Spins:CreateParagraph("Paragraph", {
    Title = "Info",
    Content = "Do not change your character or enter codes while this script is running."
})

local bloodlineSlots = Tabs.Spins:CreateDropdown("BloodlineSlotsDropdown", {
    Title = "Bloodline Slots",
    Description = "Select slots you want to spin.",
    Values = {"kg1", "kg2", "kg3", "kg4"},
    Multi = true,
    Default = {}
})

bloodlineSlots:OnChanged(function(Value)
    local Values = {}
    for Value, State in next, Value do Values[#Values + 1] = Value end

    getgenv().selectedBloodlineSlots = Values
end)

local bloodlinesToSpin = Tabs.Spins:CreateDropdown("BloodlinesToSpinDropdown", {
    Title = "Bloodlines to Spin",
    Description = "Select the bloodlines you want to spin.",
    Values = {},
    Multi = true,
    Default = {}
})

local allBloodlines = getAllBloodlines()
bloodlinesToSpin:SetValues(allBloodlines)

bloodlinesToSpin:OnChanged(function(Value)
    local Values = {}
    for Value, State in next, Value do Values[#Values + 1] = Value end

    getgenv().selectedBloodlinesToSpin = Values
end)

Tabs.Spins:CreateToggle("BloodlineSpinToggle", {
    Title = "Start Spin Bloodlines",
    Default = false,
    Callback = function(state)
        getgenv().bloodlineSpinning = state

        spawn(function()
            if getgenv().bloodlineSpinning then
                player.startevent:FireServer("band", "\128")
            end
            while getgenv().bloodlineSpinning do
                wait(0.1)
                for _, slot in pairs(getgenv().selectedBloodlineSlots) do
                    for _, bloodline in
                        pairs(getgenv().selectedBloodlinesToSpin) do
                        if game:GetService("Players").LocalPlayer.statz.main[slot]
                            .Value ~= bloodline then
                            if game:GetService("Players").LocalPlayer.statz
                                .spins.Value > 0 then
                                game:GetService("Players").LocalPlayer
                                    .startevent:FireServer("spin", slot)
                            else
                                if queue_on_teleport then
                                    queue_on_teleport(game:HttpGetAsync(
                                                          "https://raw.githubusercontent.com/Wh1teSlash/SlashHub/main/shindo-spins.luau"))
                                end

                                game:GetService("TeleportService"):Teleport(
                                    game.PlaceId, player)
                            end
                        else
                            player.startevent:FireServer("band", "Eye")
                            player:Kick("Saved data!\n\nBloodline you got: " ..
                                            bloodline)
                        end
                    end
                end
            end
        end)
    end
})

Tabs.Spins:CreateButton{
    Title = "Reset Data Manually",
    Description = "Completely resets the data to the moment you joined the game before.",
    Callback = function()
        player.startevent:FireServer("band", "\128")
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
}

Tabs.Spins:CreateButton{
    Title = "Save Data Manually",
    Description = "Saves your data.",
    Callback = function()
        player.startevent:FireServer("band", "Eye")
        player:Kick("Saved data!")
    end
}

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

InterfaceManager:SetFolder("SlashHub")
SaveManager:SetFolder("SlashHub/shindo-life-spins")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Library:Notify{
    Title = "SlashHub",
    Content = "The script has been loaded.",
    Duration = 4
}

SaveManager:LoadAutoloadConfig()
