do
    if not game:IsLoaded() then
        print("Game is loading, waiting...")
        repeat wait() until game:IsLoaded()
    end
end

do
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        warn("anti-afk")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

if game.GameId ~= 1511883870 and game.PlaceId ~= 4616652839 then return end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local selectedBloodlineSlots = {}
local selectedBloodlinesToSpin = {}
local bloodlineSpinning = false

do
    local Library = loadstring(game:HttpGetAsync(
                                   "https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
    local SaveManager = loadstring(game:HttpGetAsync(
                                       "https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
    local InterfaceManager = loadstring(game:HttpGetAsync(
                                            "https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

    local function getAllBloodlines()
        local bloodlines = ReplicatedStorage.Main.Customization.Genkaibag.Frame2
                               .BossTab:GetChildren()
        local allBloodlines = {}

        for _, bloodline in pairs(bloodlines) do
            if bloodline.Name ~= "SEARCHBAR" then
                table.insert(allBloodlines, bloodline.Name)
            end
        end

        return allBloodlines
    end

    local function hasDesiredBloodline()
        for _, slot in pairs(selectedBloodlineSlots) do
            local currentBloodline = player.statz.main[slot].Value
            for _, bloodline in pairs(selectedBloodlinesToSpin) do
                if currentBloodline == bloodline then
                    return true, bloodline
                end
            end
        end
        return false, nil
    end

    local function spinBloodlines()
        if not bloodlineSpinning then return end

        for _, slot in pairs(selectedBloodlineSlots) do
            local currentBloodline = player.statz.main[slot].Value
            local isDesiredBloodline = false

            for _, bloodline in pairs(selectedBloodlinesToSpin) do
                if currentBloodline == bloodline then
                    isDesiredBloodline = true
                    break
                end
            end

            if not isDesiredBloodline then
                if player.statz.spins.Value > 0 then
                    player.startevent:FireServer("spin", slot)
                else
                    if queue_on_teleport then
                        queue_on_teleport(game:HttpGetAsync(
                                              "https://raw.githubusercontent.com/Wh1teSlash/SlashHub/main/shindo-spins.luau"))
                    end

                    bloodlineSpinning = false
                    if Library.Options.BloodlineSpinToggle then
                        Library.Options.BloodlineSpinToggle:SetValue(false)
                    end

                    TeleportService:Teleport(game.PlaceId, player)
                    return
                end
            end
        end
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
        Coins = Window:CreateTab{Title = "Rell Coins", Icon = "coins"},
        Settings = Window:CreateTab{Title = "Settings", Icon = "settings"}
    }

    do
        Tabs.Spins:CreateParagraph("Paragraph", {
            Title = "Info",
            Content = "Do not change your character or enter codes while this script is running."
        })

        local bloodlineSlots = Tabs.Spins:CreateDropdown(
                                   "BloodlineSlotsDropdown", {
                Title = "Bloodline Slots",
                Description = "Select slots you want to spin.",
                Values = {"kg1", "kg2", "kg3", "kg4"},
                Multi = true,
                Default = {}
            })

        bloodlineSlots:OnChanged(function(Value)
            local Values = {}
            for Value, State in next, Value do
                Values[#Values + 1] = Value
            end
            selectedBloodlineSlots = Values
        end)

        local bloodlinesToSpin = Tabs.Spins:CreateDropdown(
                                     "BloodlinesToSpinDropdown", {
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
            for Value, State in next, Value do
                Values[#Values + 1] = Value
            end
            selectedBloodlinesToSpin = Values
        end)

        Tabs.Spins:CreateToggle("BloodlineSpinToggle", {
            Title = "Start Spin Bloodlines",
            Default = false,
            Callback = function(state)
                bloodlineSpinning = state

                if bloodlineSpinning then
                    player.startevent:FireServer("band", "\128")
                else
                    player.startevent:FireServer("band", "Eye")
                end
            end
        })

        Tabs.Spins:CreateButton{
            Title = "Reset Data Manually",
            Description = "Completely resets the data to the moment you joined the game before.",
            Callback = function()
                player.startevent:FireServer("band", "\128")
                TeleportService:Teleport(game.PlaceId, player)
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
    end

    do
        Tabs.Coins:CreateButton{
            Title = "Start Rell Coins Auto Farm",
            Description = "Automatically farms Rell Coins.",
            Callback = function()
                queue_on_teleport(game:HttpGetAsync(
                                      "https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/rellcoin-afk.lua"))
            end
        }
    end

    do
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
    end

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not bloodlineSpinning then return end

        local foundBloodline, bloodlineName = hasDesiredBloodline()
        if foundBloodline then
            connection:Disconnect()
            player.startevent:FireServer("band", "Eye")
            player:Kick("Saved data!\n\nBloodline you got: " .. bloodlineName)
            return
        end

        spinBloodlines()
    end)
end
