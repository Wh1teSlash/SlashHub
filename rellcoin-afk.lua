if not game:IsLoaded() then
    print("Game is loading waiting...")
    repeat wait() until game:IsLoaded()
end

local module = loadstring(
                   game:HttpGet "https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/serverhop.lua")()

function selectVillage(village)
    local Players = game:GetService('Players');
    local Teams = game:GetService('Teams');

    local choosevill = Players.LocalPlayer.choosevill

    choosevill:FireServer("vill", village)

    choosevill:FireServer("occ", "kage")
end

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
        queue_on_teleport(
            'loadstring(game:HttpGet("https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/rellcoin-afk.lua"))()')
        module:Teleport(game.PlaceId)
    else
        selectVillage(smallestTeam.Name)
        wait(_G.delayBetweenTeleports)

        queue_on_teleport(
            'loadstring(game:HttpGet("https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/rellcoin-afk.lua"))()')

        game:GetService("TeleportService"):Teleport(game.PlaceId,
                                                    game.Players.LocalPlayer)
    end
else
    queue_on_teleport(
        'loadstring(game:HttpGet("https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/rellcoin-afk.lua"))()')
    module:Teleport(game.PlaceId)
end

if not smallestTeam then
    queue_on_teleport(
        'loadstring(game:HttpGet("https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/rellcoin-afk.lua"))()')
    module:Teleport(game.PlaceId)
end
