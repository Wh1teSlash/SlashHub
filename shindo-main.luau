repeat wait() until game:IsLoaded()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local green = "http://www.roblox.com/asset/?id=5459241648"

local settings = {
    autofarmGreen = false,
    autoRankUp = false,
    addStats = false,
    amountStats = 25,
    selectedStats = {},
    isAttacking = false,
    placeBosses = {},
    selectedBosses = {},
    autoFarmSelectedBosses = false,
    currentFarmingMode = "none",
    farmingLock = false
}

-- Anti-AFK
player.Idled:Connect(function()
    warn("anti-afk")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

player.CharacterAdded:Connect(function(character)
    settings.isAttacking = false
    settings.farmingLock = false
    settings.currentFarmingMode = "none"

    character:WaitForChild("Humanoid")
    character:WaitForChild("HumanoidRootPart")

    wait(1)
end)

do

    local function fixMouse(cframe)
        if not player.Character or not player.Character:FindFirstChild("combat") then
            return
        end
        player.Character.combat.update:FireServer("fixmouse", cframe)
    end

    local function doClick(enabled)
        settings.isAttacking = enabled
        if not enabled then return end

        spawn(function()
            while settings.isAttacking do
                wait(.3)

                if not player or not player.Character or
                    not player.Character:FindFirstChild("combat") then
                    settings.isAttacking = false
                    break
                end

                if player.Character:FindFirstChild("Humanoid") and
                    player.Character.Humanoid.Health <= 0 then
                    settings.isAttacking = false
                    break
                end

                player.Character.combat.update:FireServer("inair", false)
                player.Character.combat.update:FireServer("spamspace")
                player.Character.combat.update:FireServer("mouse1", true)
            end
        end)
    end

    local function attackNPC(npc, farmType)
        if settings.farmingLock then return end
        settings.farmingLock = true
        settings.currentFarmingMode = farmType

        doClick(true)

        pcall(function()
            repeat
                wait(0.1)

                if (farmType == "green" and not settings.autofarmGreen) or
                    (farmType == "bosses" and
                        not settings.autoFarmSelectedBosses) then
                    break
                end

                if not player.Character or
                    not player.Character:FindFirstChild("HumanoidRootPart") or
                    not player.Character:FindFirstChild("Humanoid") or
                    player.Character.Humanoid.Health <= 0 then
                    break
                end

                if not npc or not npc:FindFirstChild("HumanoidRootPart") or
                    not npc:FindFirstChild("Humanoid") then break end

                if farmType == "green" and
                    (not player.currentmission or player.currentmission.Value ==
                        nil) then break end

                if farmType == "bosses" and
                    (not player.currentmission or player.currentmission.Value ==
                        nil) then break end

                player.Character.HumanoidRootPart.CFrame =
                    npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                fixMouse(npc.HumanoidRootPart.CFrame)

                npc.Humanoid.Health = 0
                npc.Humanoid.MaxHealth = 0

            until npc.Humanoid.Health == 0 or
                (farmType == "green" and not settings.autofarmGreen) or
                (farmType == "bosses" and not settings.autoFarmSelectedBosses) or
                (not player.currentmission or player.currentmission.Value == nil) or
                not player.Character or
                not player.Character:FindFirstChild("Humanoid") or
                player.Character.Humanoid.Health <= 0
        end)

        doClick(false)
        settings.farmingLock = false
        settings.currentFarmingMode = "none"
    end

    local function getAllVillageBosses()
        settings.placeBosses = {}

        local missionsFolder = workspace.bossdropmission.missions
        if not missionsFolder then return settings.placeBosses end

        for _, bossFolder in ipairs(missionsFolder:GetChildren()) do
            if bossFolder:IsA("Folder") then
                local missionGiver = bossFolder:FindFirstChild("missiongiver")
                if missionGiver then
                    table.insert(settings.placeBosses, bossFolder.Name)
                end
            end
        end

        return settings.placeBosses
    end

    local function isBossQuestAvailable()
        if not settings.autoFarmSelectedBosses or #settings.selectedBosses == 0 then
            return false
        end

        if not workspace.bossdropmission or
            not workspace.bossdropmission.missions then return false end

        for _, missionFolder in pairs(
                                    workspace.bossdropmission.missions:GetChildren()) do
            if table.find(settings.selectedBosses, missionFolder.Name) then
                for _, missionObject in pairs(missionFolder:GetChildren()) do
                    if missionObject.Name == "missiongiver" and
                        missionObject.Talk and missionObject.Talk.cooldown and
                        missionObject.Talk.cooldown.Value < 1 and
                        missionObject.Talk.accepted and
                        missionObject.Talk.accepted.Value == false then
                        return true
                    end
                end
            end
        end

        return false
    end

    getgenv().attackNPC = attackNPC
    getgenv().getAllVillageBosses = getAllVillageBosses
    getgenv().isBossQuestAvailable = isBossQuestAvailable
end

do
    local lastUpdate = 0
    local updateInterval = 0.1

    local function processGreenQuests()
        if not settings.autofarmGreen or settings.currentFarmingMode == "bosses" then
            return
        end
        if getgenv().isBossQuestAvailable() then return end
        if not player.Character or
            not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        if not player.currentmission or player.currentmission.Value == nil then
            for _, missionGiver in pairs(workspace.missiongivers:GetChildren()) do
                local success, result = pcall(function()
                    if missionGiver.Name == "" and
                        missionGiver:FindFirstChild("Head") and
                        missionGiver.Head:FindFirstChild("givemission") and
                        missionGiver.Head.givemission.Enabled and
                        missionGiver.Head.givemission:FindFirstChild("color") and
                        missionGiver.Head.givemission.color.Visible and
                        missionGiver.Head.givemission.color.Image == green then

                        local clienttalk =
                            missionGiver:FindFirstChild("CLIENTTALK")
                        if clienttalk then
                            player.Character.HumanoidRootPart.CFrame =
                                missionGiver.HumanoidRootPart.CFrame
                            wait(0.3)
                            clienttalk:FireServer()
                            wait(0.2)
                            clienttalk:FireServer("accept")
                            return true
                        end
                    end
                    return false
                end)
                if success and result then break end
            end
        else
            if not settings.farmingLock then
                for _, npcEntity in pairs(workspace.npc:GetChildren()) do
                    pcall(function()
                        if npcEntity.ClassName == "Model" and
                            npcEntity:FindFirstChild("npctype") and
                            string.find(npcEntity.Name, "npc") and
                            npcEntity:FindFirstChild("HumanoidRootPart") and
                            npcEntity:FindFirstChild("Humanoid") and
                            npcEntity:FindFirstChild("Head") and
                            npcEntity.Head.CFrame.Y > -1000 and
                            not npcEntity:FindFirstChild("fullsusanoo") and
                            settings.autofarmGreen then
                            getgenv().attackNPC(npcEntity, "green")
                        end
                    end)
                end
            end
        end
    end

    local function processBossQuests()
        if not settings.autoFarmSelectedBosses or #settings.selectedBosses == 0 or
            settings.currentFarmingMode == "green" then return end
        if not player.Character or
            not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        if not player.currentmission or player.currentmission.Value == nil then
            for _, missionFolder in pairs(
                                        workspace.bossdropmission.missions:GetChildren()) do
                if table.find(settings.selectedBosses, missionFolder.Name) then
                    local missionObject =
                        missionFolder:FindFirstChild("missiongiver")
                    if missionObject and missionObject.Talk and
                        missionObject.Talk.cooldown and
                        missionObject.Talk.cooldown.Value < 1 and
                        missionObject.Talk.accepted and
                        missionObject.Talk.accepted.Value == false then

                        local remote = missionObject.CLIENTTALK
                        if remote then
                            player.Character.HumanoidRootPart.CFrame =
                                missionObject.HumanoidRootPart.CFrame
                            wait(0.3)
                            remote:FireServer(player)
                            break
                        end
                    end
                end
            end
        else
            if not settings.farmingLock then
                for _, npcEntity in pairs(workspace.npc:GetChildren()) do
                    pcall(function()
                        if npcEntity.ClassName == "Model" and
                            npcEntity:FindFirstChild("npctype") and
                            string.find(npcEntity.Name, "npc") and
                            npcEntity:FindFirstChild("HumanoidRootPart") and
                            npcEntity:FindFirstChild("Humanoid") and
                            npcEntity:FindFirstChild("Head") and
                            npcEntity.Head.CFrame.Y > -1000 and
                            not npcEntity:FindFirstChild("fullsusanoo") and
                            settings.autoFarmSelectedBosses then
                            getgenv().attackNPC(npcEntity, "bosses")
                        end
                    end)
                end
            end
        end
    end

    local function processAutoRank()
        if not settings.autoRankUp then return end
        if not (player.statz and player.statz.lvl and
            player.statz.lvl:FindFirstChild("lvl") and
            player.statz.lvl.lvl.Value == 1000) then return end

        spawn(function()
            while settings.autoRankUp and player.statz and player.statz.lvl and
                player.statz.lvl:FindFirstChild("lvl") and
                player.statz.lvl.lvl.Value == 1000 do
                player.startevent:FireServer("rankup")
                wait(1)
            end
        end)
    end

    local function processStatsAdd()
        if not settings.addStats or not settings.selectedStats or
            #settings.selectedStats == 0 then return end

        spawn(function()
            for _, selectedStat in pairs(settings.selectedStats) do
                if player.startevent then
                    player.startevent:FireServer("addstat", selectedStat,
                                                 settings.amountStats)
                    wait(0.1)
                end
            end
        end)
    end

    RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        if currentTime - lastUpdate < updateInterval then return end
        lastUpdate = currentTime

        processAutoRank()
        processStatsAdd()
        processGreenQuests()
        processBossQuests()
    end)
end

do
    local Library = loadstring(game:HttpGetAsync(
                                   "https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
    local SaveManager = loadstring(game:HttpGetAsync(
                                       "https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
    local InterfaceManager = loadstring(game:HttpGetAsync(
                                            "https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

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

    Tabs.Main:CreateToggle("AutoFarmGreenToggle", {
        Title = "Auto Farm Green Quests",
        Default = false,
        Callback = function(state) settings.autofarmGreen = state end
    })

    local bossesDropdown = Tabs.Main:CreateDropdown("BossesDropdown", {
        Title = "Bosses",
        Description = "Select the bosses you want to farm.",
        Values = {},
        Multi = true,
        Default = {}
    })

    bossesDropdown:OnChanged(function(selectedValues)
        local values = {}
        for value, state in next, selectedValues do
            if state then values[#values + 1] = value end
        end
        settings.selectedBosses = values
    end)

    local initialBosses = getgenv().getAllVillageBosses()
    bossesDropdown:SetValues(initialBosses)

    Tabs.Main:CreateToggle("AutoFarmSelectedBossesToggle", {
        Title = "Auto Farm Selected Bosses",
        Default = false,
        Callback = function(state)
            settings.autoFarmSelectedBosses = state
        end
    })

    Tabs.Main:CreateToggle("AutoRankUpToggle", {
        Title = "Auto Rank",
        Default = false,
        Callback = function(state) settings.autoRankUp = state end
    })

    Tabs.Main:CreateToggle("StatsAddToggle", {
        Title = "Add Stats",
        Default = false,
        Callback = function(state) settings.addStats = state end
    })

    Tabs.Main:CreateInput("StatsInput", {
        Title = "Amount of stats to add",
        Default = "25",
        Placeholder = "Amount of stats to add",
        Numeric = true,
        Finished = false,
        Callback = function(Value) settings.amountStats = tonumber(Value) end
    })

    local MultiDropdown = Tabs.Main:CreateDropdown("AddStatsMultiDropdown", {
        Title = "Select Stats",
        Description = "Select the stats you want to add points to.",
        Values = {"health", "taijutsu", "ninjutsu", "chakra"},
        Multi = true,
        Default = {}
    })

    MultiDropdown:OnChanged(function(selectedValues)
        local values = {}
        for value, state in next, selectedValues do
            if state then values[#values + 1] = value end
        end
        settings.selectedStats = values
    end)

    SaveManager:SetLibrary(Library)
    InterfaceManager:SetLibrary(Library)

    InterfaceManager:SetFolder("SlashHub")
    SaveManager:SetFolder("SlashHub/shindo-life")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    Window:SelectTab(1)

    Library:Notify{
        Title = "SlashHub",
        Content = "Script loaded successfully!",
        Duration = 5
    }

    SaveManager:LoadAutoloadConfig()
end
