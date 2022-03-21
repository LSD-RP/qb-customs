local QBCore = exports['qb-core']:GetCoreObject()

local repairCost = vehicleBaseRepairCost

RegisterNetEvent('qb-customs:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    local balance = nil
    if Player.PlayerData.job.name == "mechanic" then
        balance = Player.Functions.GetMoney(moneyType)
    else
        balance = Player.Functions.GetMoney(moneyType)
    end
    if type == "repair" then
        if balance >= repairCost then
            if Player.PlayerData.job.name == "mechanic" then
                Player.Functions.RemoveMoney(moneyType, repairCost, "bennys")
                TriggerEvent("qb-bossmenu:server:addAccountMoney", 'mechanic', repairCost)
                -- TriggerEvent('qb-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name, repairCost)
            else
                Player.Functions.RemoveMoney(moneyType, repairCost, "bennys")
                TriggerEvent("qb-bossmenu:server:addAccountMoney", 'mechanic', repairCost)
            end
            TriggerClientEvent('qb-customs:purchaseSuccessful', source)
        else
            TriggerClientEvent('qb-customs:purchaseFailed', source)
        end
    elseif type == "performance" then
        if balance >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('qb-customs:purchaseSuccessful', source)
            TriggerEvent("qb-log:server:CreateLog", "vehicleupgrades", "Customs", "green", "**"..GetPlayerName(source) .. "** purchased " ..type .. " for " .. vehicleCustomisationPrices[type].prices[upgradeLevel])

            if Player.PlayerData.job.name == "mechanic" then
                -- TriggerEvent('qb-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name,
                --     vehicleCustomisationPrices[type].prices[upgradeLevel])
                Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].prices[upgradeLevel], "bennys")
                TriggerEvent("qb-bossmenu:server:addAccountMoney", 'mechanic', vehicleCustomisationPrices[type].prices[upgradeLevel])
            else
                Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].prices[upgradeLevel], "bennys")
                TriggerEvent("qb-bossmenu:server:addAccountMoney", 'mechanic', vehicleCustomisationPrices[type].prices[upgradeLevel])
            end
        else
            TriggerClientEvent('qb-customs:purchaseFailed', source)
        end
    else
        if balance >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('qb-customs:purchaseSuccessful', source)
            TriggerEvent("qb-log:server:CreateLog", "vehicleupgrades", "Customs", "green", "**"..GetPlayerName(source) .. "** purchased " ..type .. " for " .. vehicleCustomisationPrices[type].price)
            if Player.PlayerData.job.name == "mechanic" then
                -- TriggerEvent('qb-bossmenu:server:removeAccountMoney', Player.PlayerData.job.name,
                --     vehicleCustomisationPrices[type].price)
                Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].price, "bennys")
                TriggerEvent("qb-bossmenu:server:addAccountMoney", 'mechanic', vehicleCustomisationPrices[type].price)
            else
                Player.Functions.RemoveMoney(moneyType, vehicleCustomisationPrices[type].price, "bennys")
                TriggerEvent("qb-bossmenu:server:addAccountMoney", 'mechanic', vehicleCustomisationPrices[type].price)
            end
        else
            TriggerClientEvent('qb-customs:purchaseFailed', source)
        end
    end
end)

RegisterNetEvent('qb-customs:updateRepairCost', function(cost)
    repairCost = cost
end)

RegisterNetEvent("updateVehicle", function(myCar)
    local src = source
    if IsVehicleOwned(myCar.plate) then
        MySQL.Async.execute('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(myCar), myCar.plate})
    end
end)

function IsVehicleOwned(plate)
    local retval = false
    local result = MySQL.Sync.fetchScalar('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        retval = true
    end
    return retval
end
