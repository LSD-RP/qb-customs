-----------------------
----   Variables   ----
-----------------------
local QBCore = exports['qb-core']:GetCoreObject()
local RepairCosts = {}

-----------------------
----   Functions   ----
-----------------------

-- local function IsVehicleOwned(plate)
--     local retval = false
--     local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
--     if result then retval = true end
--     return retval
-- end

-----------------------
----   Threads     ----
-----------------------

-----------------------
---- Server Events ----
-----------------------

AddEventHandler("playerDropped", function()
	local source = source
    RepairCosts[source] = nil
end)

RegisterNetEvent('qb-customs:server:attemptPurchase', function(type, upgradeLevel, plate)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    local moneyType = Config.MoneyType
    local balance = Player.Functions.GetMoney(moneyType)

    if type == "repair" then
        local repairCost = RepairCosts[source] or 600
        moneyType = Config.RepairMoneyType
        balance = Player.Functions.GetMoney(moneyType)
        if balance >= repairCost then
            Player.Functions.RemoveMoney(moneyType, repairCost, "bennys")
            TriggerClientEvent('qb-customs:client:purchaseSuccessful', source)
	        exports['qb-management']:AddMoney("mechanic", repairCost)
            TriggerEvent("qb-log:server:CreateLog", "vehicleupgrades", "Customs", "green", "**"..GetPlayerName(source) .. "** purchased " ..type .. " for $" .. repairCost .. " on " .. plate)

        else
            TriggerClientEvent('qb-customs:client:purchaseFailed', source)
        end
    elseif type == "performance" or type == "turbo" then
        if balance >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('qb-customs:client:purchaseSuccessful', source)
            Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].prices[upgradeLevel], "bennys")
	        exports['qb-management']:AddMoney("mechanic", vehicleCustomisationPrices[type].prices[upgradeLevel]) 
            TriggerEvent("qb-log:server:CreateLog", "vehicleupgrades", "Customs", "green", "**"..GetPlayerName(source) .. "** purchased " ..type .. " for " .. vehicleCustomisationPrices[type].prices[upgradeLevel] .. " on " .. plate)

        else
            TriggerClientEvent('qb-customs:client:purchaseFailed', source)
        end
    else
        if balance >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('qb-customs:client:purchaseSuccessful', source)
            Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].price, "bennys")
            exports['qb-management']:AddMoney("mechanic", vehicleCustomisationPrices[type].price) 
            TriggerEvent("qb-log:server:CreateLog", "vehicleupgrades", "Customs", "green", "**"..GetPlayerName(source) .. "** purchased " ..type .. " for " .. vehicleCustomisationPrices[type].price .. " on " .. plate)

        else
            TriggerClientEvent('qb-customs:client:purchaseFailed', source)
        end
    end
end)

RegisterNetEvent('qb-customs:server:updateRepairCost', function(cost)
    local source = source
    RepairCosts[source] = cost
end)

RegisterNetEvent("qb-customs:server:updateVehicle", function(myCar)
    if IsVehicleOwned(myCar.plate) then
        MySQL.Async.execute('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(myCar), myCar.plate})
    end
end)

function IsVehicleOwned(plate)
    local thisplate = trimWhitespace(plate)
    local retval = false
	exports.oxmysql:execute('SELECT 1 FROM player_vehicles WHERE plate LIKE @plate', {
		['@plate'] = '%' ..thisplate.. '%'
	}, function(result)
		if result[1] == nil then
			exports.oxmysql:execute('SELECT 1 from player_vehicles WHERE plate = @plate', {
				['@plate'] = thisplate
			}, function(result2)
				if result2 then 
                    retval = true
                end
			end)
		else
			if result then 
                retval = true
            end
		end
		
	end)
    Wait(2000)
    return retval
end

function trimWhitespace(text)
    -- -- return text:gsub("%s+","")
	-- return text
	if text then
		return (string.gsub(text, "^%s*(.-)%s*$", "%1"))
	else
		return "nil"
	end
end

-- QBCore.Commands.Add('monkeygarage', '', {}, false, function(source, args)
-- 	local src = source
--     print("cmd")
-- 	TriggerClientEvent('qb-customs:triggerGarageMonkey', src)
-- end)
-- Use somthing like this to dynamically enable/disable a location. Can be used to change anything at a location.
-- TriggerEvent('qb-customs:server:UpdateLocation', 'Hayes', 'settings', 'enabled', test)

RegisterNetEvent('qb-customs:server:UpdateLocation', function(location, type, key, value)
    Config.Locations[location][type][key] = value
    TriggerClientEvent('qb-customs:client:UpdateLocation', -1, location, type, key, value)
end)

QBCore.Functions.CreateCallback('qb-customs:server:GetLocations', function(source, cb)
	cb(Config.Locations)
end)

QBCore.Functions.CreateCallback('qb-customs:server:GetMechanics', function(source, cb)
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for k,v in pairs(players) do
        if v.PlayerData.job.name == 'mechanic' then
			amount = amount + 1
		end
	end
	cb(amount)
end)

QBCore.Functions.CreateCallback('qb-customs:server:isOwned', function(source, cb, plate)
	cb(IsVehicleOwned(plate))
end)

RegisterNetEvent('qb-customs:server:chargeMonkey', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney('bank', 5000)
end)