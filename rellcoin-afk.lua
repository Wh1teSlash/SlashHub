local mainScript = [[
if not game:IsLoaded() then
    print("Game is loading, waiting...")
    repeat wait() until game:IsLoaded()
end
wait(10)
local Players = game:GetService('Players');
local TeleportService = game:GetService('TeleportService');
local Teams = game:GetService('Teams');
local Players = game:GetService('Players');
local Teams = game:GetService('Teams');
local TeleportService = game:GetService('TeleportService');

function selectVillage(village)
    local player = Players.LocalPlayer
    local choosevill = player.choosevill
    if choosevill then
        choosevill:FireServer("vill", village)
        choosevill:FireServer("occ", "kage")
    else
        warn("choosevill RemoteEvent not found")
    end
end

local module = loadstring(game:HttpGet("https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/serverhop.lua"))()

local smallestTeam = nil
local smallestCount = math.huge

for _, team in ipairs(Teams:GetChildren()) do
    local playerCount = #team:GetPlayers()
    if playerCount < smallestCount then
        smallestCount = playerCount
        smallestTeam = team
    end
end

if smallestTeam then
    if smallestCount >= 1 then
        module:Teleport(game.PlaceId)
    else
        selectVillage(smallestTeam.Name)
        wait(_G.delayBetweenTeleports)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
else
    module:Teleport(game.PlaceId)
end
]]

if queue_on_teleport then queue_on_teleport(mainScript) end

function selectVillage(village)
    local player = Players.LocalPlayer
    local choosevill = player.choosevill
    if choosevill then
        choosevill:FireServer("vill", village)
        choosevill:FireServer("occ", "kage")
    else
        warn("choosevill RemoteEvent not found")
    end
end

local module = loadstring(game:HttpGet(
                              "https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/serverhop.lua"))()

local smallestTeam = nil
local smallestCount = math.huge

for _, team in ipairs(Teams:GetChildren()) do
    local playerCount = #team:GetPlayers()
    if playerCount < smallestCount then
        smallestCount = playerCount
        smallestTeam = team
    end
end

if smallestTeam then
    if smallestCount >= 1 then
        module:Teleport(game.PlaceId)
    else
        selectVillage(smallestTeam.Name)
        wait(_G.delayBetweenTeleports)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
else
    module:Teleport(game.PlaceId)
end
