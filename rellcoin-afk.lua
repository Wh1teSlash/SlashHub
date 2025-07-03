if not game:IsLoaded() then
    print("Game is loading waiting...")
    repeat
        wait()
    until game:IsLoaded()
end

local module = loadstring(game:HttpGet "https://raw.githubusercontent.com/Wh1teSlash/SlashHub/refs/heads/main/serverhop.lua")()

function selectVillage(village)
    local Players = game:GetService("Players")

    local choosevill = Players.LocalPlayer.choosevill

    choosevill:FireServer(
        "vill",
        village
    )

    choosevill:FireServer(
        "occ",
        "kage"
    )
end

local Teams = game:GetService("Teams")
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

        module:Teleport(game.PlaceId)
    end
else
    module:Teleport(game.PlaceId)
end
