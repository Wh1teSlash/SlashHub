_G.delayBetweenTeleports = 115
if queue_on_teleport then
    local scriptUrl =
        "https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/rellcoin-afk.lua"
    queue_on_teleport(game:HttpGetAsync(scriptUrl))
end
if game.JobId == "4d80e454-a7e1-40b9-9084-d9cf3760a6cc" then
    local success, module = pcall(function()
        return loadstring(game:HttpGetAsync(
                              "https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/serverhop.lua"))()
    end)
    module:Teleport(game.PlaceId)
end
if not game:IsLoaded() then
    print("Game is loading, waiting...")
    repeat wait() until game:IsLoaded()
end
if not workspace:FindFirstChild("RPGpvp") then
    game:GetService("Players").LocalPlayer.startevent:FireServer("shindoworld",
                                                                 5943872934)
    return
end
-- anti-afk
local VirtualUser = game:service 'VirtualUser'
game:service 'Players'.LocalPlayer.Idled:connect(function()
    warn("anti-afk")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
wait(10)
local Players = game:GetService('Players');
local TeleportService = game:GetService('TeleportService');
local Teams = game:GetService('Teams');

local villagePriority = {"Rogue", "Akatsuki"}

local function selectVillage(village)
    local player = Players.LocalPlayer
    local choosevill = player.choosevill
    if choosevill then
        choosevill:FireServer("vill", village)
        choosevill:FireServer("occ", "kage")
        return true
    else
        warn("choosevill RemoteEvent not found")
        return false
    end
end

local function findPreferredTeam()
    local teams = {}

    for _, team in ipairs(Teams:GetChildren()) do
        if team:IsA("Team") then
            local playerCount = #team:GetPlayers()
            teams[team.Name] = {team = team, count = playerCount}
        end
    end

    for _, preferredVillage in ipairs(villagePriority) do
        if teams[preferredVillage] then
            return teams[preferredVillage].team, teams[preferredVillage].count
        end
    end

    local smallestTeam = nil
    local smallestCount = math.huge

    for villageName, teamData in pairs(teams) do
        if teamData.count < smallestCount then
            smallestCount = teamData.count
            smallestTeam = teamData.team
        end
    end

    return smallestTeam, smallestCount
end

local success, module = pcall(function()
    return loadstring(game:HttpGet(
                          "https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/serverhop.lua"))()
end)
if not success then
    warn("Failed to load serverhop module: " .. tostring(module))
    return
end

local selectedTeam, selectedCount = findPreferredTeam()
if selectedTeam then
    if selectedCount >= 1 then
        module:Teleport(game.PlaceId)
    else
        if selectVillage(selectedTeam.Name) then
            wait(_G.delayBetweenTeleports)
            local totalPlayers = #Players:GetPlayers()
            if (totalPlayers <= 1) then
                module:Teleport(game.PlaceId)
                return
            end
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        else
            module:Teleport(game.PlaceId)
        end
    end
else
    module:Teleport(game.PlaceId)
end
