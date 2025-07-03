local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local S_T = game:GetService("TeleportService")
local S_H = game:GetService("HttpService")

local File = pcall(function()
	AllIDs = S_H:JSONDecode(readfile("server-hop-temp.json"))
end)
if not File then
	table.insert(AllIDs, actualHour)
	pcall(function()
		writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs))
	end)
end

local function cleanupOldIDs()
	if #AllIDs > 6 then
		local hour = AllIDs[1]
		local recentIDs = {}
		table.insert(recentIDs, hour)
		
		for i = math.max(2, #AllIDs - 4), #AllIDs do
			table.insert(recentIDs, AllIDs[i])
		end
		
		AllIDs = recentIDs
	end
end

local function TPReturner(placeId)
	local Site;
	if foundAnything == "" then
		Site = S_H:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'))
	else
		Site = S_H:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
	end
	
	local ID = ""
	if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
		foundAnything = Site.nextPageCursor
	end
	
	local num = 0
	for i,v in pairs(Site.data) do
		local Possible = true
		ID = tostring(v.id)
		
		if tonumber(v.maxPlayers) > tonumber(v.playing) then
			for _,Existing in pairs(AllIDs) do
				if num ~= 0 then
					if ID == tostring(Existing) then
						Possible = false
					end
				else
					if tonumber(actualHour) ~= tonumber(Existing) then
						local delFile = pcall(function()
							delfile("server-hop-temp.json")
							AllIDs = {}
							table.insert(AllIDs, actualHour)
						end)
					end
				end
				num = num + 1
			end
			
			if Possible == true then
				table.insert(AllIDs, ID)
				
				cleanupOldIDs()
				
				pcall(function()
					writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs))
				end)
				
				wait(1) 
				pcall(function()
					S_T:TeleportToPlaceInstance(placeId, ID, game.Players.LocalPlayer)
				end)
				
				return true 
			end
		end
	end
	
	return false 
end

local module = {}
function module:Teleport(placeId)
	local attempts = 0
	local maxAttempts = 10
	
	while attempts < maxAttempts do
		attempts = attempts + 1
		
		pcall(function()
			local success = TPReturner(placeId)
			if success then
				return
			end
			
			if foundAnything ~= "" then
				TPReturner(placeId)
			end
		end)
		
		wait(3)

		if attempts % 3 == 0 then
			collectgarbage("collect")
		end
	end
	
	foundAnything = ""
	warn("Max teleport attempts reached. Resetting...")
end

return module
