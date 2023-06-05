local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reuploaded"))()
local venyx = library.new("SlashHub", 5013109572)

local page = venyx:addPage("Main", 5012544693)
local section1 = page:addSection("Teleports")
local section2 = page:addSection("Raids")
local section3 = page:addSection("Other")

local hell = 12634382039
local maingame = 7056922815
local soul = 8934886191
local hueco = 12634378292
local ice = 7298553006

local function teleportToPlace(placeId)
	
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	
	game:GetService("TeleportService"):Teleport(placeId, humanoidRootPart)
end

local userInputService = game:GetService("UserInputService")

local function onControlPressed(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.RightControl then
        venyx:toggle()
    end
end

userInputService.InputBegan:Connect(onControlPressed)

section1:addButton("Main Game", function()
teleportToPlace(maingame)
end)
section1:addButton("Hell", function()
teleportToPlace(hell)
end)
section1:addButton("Soul Society", function()
teleportToPlace(soul)
end)
section1:addButton("Hueco Mundo", function()
teleportToPlace(hueco)
end)
--section2
--[[section2:addButton("Ice Capitan", function()
game:GetService("ReplicatedStorage").Remotes.TakeQuest:FireServer("Ice Captain", game:GetService("Workspace").NPCs.Jovahn)
wait(2)
teleportToPlace(ice)
end)
--]]
--section3
section3:addButton("Redeem money codes", function()
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("BUYSPINS!")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("PRIMEROSECONDOLESGO")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("PIMPINGCASH")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("FREECASH??")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("YAKRUSISGONE1")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("FINALLYUPDATEB")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("THANKYOUFORPAT14NCE")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("REALDANGAl24")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("KUCHILOARROGANTE")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("REEEEEEEE")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("100KLIKESPATCH")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("PRAYFORZENOKEI")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("CashDAY")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("Follow@ZenokeiRBLXOnTwitter")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("SubscribeZenokeiRBLXOnYoutube")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("SUPRISECASH20K")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("ROBLOXDOWN")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("DAVIDBAZOOKA")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("RANDOM")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("RANDOMV2")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("RANDOM3")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("bugfixes00")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("HoguMoney1")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("HoguMoney2")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("HoguMoney3")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("NozaCash")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("NozaCrazy")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("VizardCash")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("VizardTimes")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("Sorry1")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("Sorry2")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("5kEZ")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("THISWASNTHEREB4")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("APOLOGIES2")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("PREPAREFORPART2")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("BASH11")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("NEWBANKAI2")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("NEWBANKAI")
wait(2)
game:GetService("ReplicatedStorage").Remotes.SubmitCode:FireServer("NEWVOL")
end)
section3:addButton("Server Hop", function()
local module = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")()

module:Teleport(game.PlaceId)
end)
section3:addButton("Rejoin", function()
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)
section3:addButton("Teleport to lowest server", function()
local Https = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local Api = "https://games.roblox.com/v1/games/"

local _place = game.PlaceId
local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
function ListServers(cursor)
	local Raw = game:HttpGet(_servers ..((cursor and "&cursor="..cursor) or ""))
	return Https:JSONDecode(Raw)
end

local Server, Next; repeat
	local Servers = ListServers(Next)
	Server = Servers.data[1]
	Next = Servers.nextPageCursor
until Server

TPS:TeleportToPlaceInstance(_place,Server.id,game.Players.LocalPlayer)
end)
section3:addButton("Teleport to lowest server", function()
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PLACE_ID = game.PlaceId -- Replace with your game's place ID
local YOUR_USER_ID = game.Players.LocalPlayer.id -- Replace with your Roblox UserId
local MAX_SERVERS = 100

function getServerWithMaxPlayers()
    local serverWithMaxPlayers = nil
    local maxPlayers = -1

    local cursor = ""
    repeat
        local url = "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?limit=100&cursor=" .. cursor
        local response = HttpService:GetAsync(url)
        local data = HttpService:JSONDecode(response)

        for _, server in ipairs(data.data) do
            if server.playing and server.playing > maxPlayers then
                maxPlayers = server.playing
                serverWithMaxPlayers = server
            end
        end
        cursor = data.nextPageCursor
    until cursor == nil or cursor == "" or maxPlayers >= MAX_SERVERS

    return serverWithMaxPlayers
end

function teleportToMaxServer(player)
    if player.UserId == game.Players.LocalPlayer.id then
        local server = getServerWithMaxPlayers()
        if server then
            TeleportService:TeleportToPlaceInstance(PLACE_ID, server.id, player)
        else
            print("Could not find a server with max players.")
        end
    end
end

local player = Players.LocalPlayer
teleportToMaxServer(player)
end)

venyx:SelectPage(venyx.pages[1], true)
