_G.delayBetweenTeleports = 115

if not game:IsLoaded() then
    print("Game is loading waiting...")
    repeat wait() until game:IsLoaded()
end

wait(10)

function reexecuteScript()
    queue_on_load(
        'loadstring(game:HttpGet "https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/rellcoin-afk.lua")()')
end

function selectVillage(village)
    local Players = game:GetService('Players');
    local Teams = game:GetService('Teams');

    local choosevill = Players.LocalPlayer.choosevill

    choosevill:FireServer("vill", village)

    choosevill:FireServer("occ", "kage")
end

local module = loadstring(
                   game:HttpGet "https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/serverhop.lua")()

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
        reexecuteScript()
        module:Teleport(game.PlaceId)
    else
        selectVillage(smallestTeam.Name)
        wait(_G.delayBetweenTeleports)

        reexecuteScript()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,
                                                                   game.JobId)
    end
else
    reexecuteScript()
    module:Teleport(game.PlaceId)
end
