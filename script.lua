local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reuploaded"))()
local venyx = library.new("SlashHub", 5013109572)

local page = venyx:addPage("Teleporter", 5012544693)
local section1 = page:addSection("Teleports")

local hell = 12634382039
local maingame = 7056922815
local soul = 8934886191
local hueco = 12634378292

local function teleportToPlace(placeId)
	
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	
	game:GetService("TeleportService"):Teleport(placeId, humanoidRootPart)
end

local function onInputBegan(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.RightControl then
        venyx:toggle()
    end
end

game:GetService("UserInputService").InputBegan:Connect(onInputBegan)


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
venyx:SelectPage(venyx.pages[1], true)
