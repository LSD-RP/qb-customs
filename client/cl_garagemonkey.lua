local QBCore = exports['qb-core']:GetCoreObject()
local monkeyDriver = nil
-- local garage = vector3(-2974.71, 487.11, 15.28)

function GetVehProps(vehicle)
    if DoesEntityExist(vehicle) then
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)

        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        if GetIsVehiclePrimaryColourCustom(vehicle) then
            r, g, b = GetVehicleCustomPrimaryColour(vehicle)
            colorPrimary = {r, g, b}
        end

        if GetIsVehicleSecondaryColourCustom(vehicle) then
            r, g, b = GetVehicleCustomSecondaryColour(vehicle)
            colorSecondary = {r, g, b}
        end

        local extras = {}
        for extraId = 0, 12 do
            if DoesExtraExist(vehicle, extraId) then
                local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
                extras[tostring(extraId)] = state
            end
        end

        local modLivery = GetVehicleMod(vehicle, 48)
        if GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) ~= 0 then
            modLivery = GetVehicleLivery(vehicle)
        end

        local tireHealth = {}
        for i = 0, 3 do
            tireHealth[i] = GetVehicleWheelHealth(vehicle, i)
        end

        local tireBurstState = {}
        for i = 0, 5 do
            tireBurstState[i] = IsVehicleTyreBurst(vehicle, i, false)
        end

        local tireBurstCompletely = {}
        for i = 0, 5 do
            tireBurstCompletely[i] = IsVehicleTyreBurst(vehicle, i, true)
        end

        local windowStatus = {}

        for i = 0, 13 do

            windowStatus[i] = IsVehicleWindowIntact(vehicle, i) == 1
            -- if IsVehicleWindowIntact(vehicle, i) == 1 then
            --     print(i)
            -- end
        end

        local doorStatus = {}
        for i = 0, 5 do
            doorStatus[i] = IsVehicleDoorDamaged(vehicle, i) == 1
        end

        return {
            model = GetEntityModel(vehicle),
            plate = QBCore.Functions.GetPlate(vehicle),
            plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
            bodyHealth = QBCore.Shared.Round(GetVehicleBodyHealth(vehicle), 0.1),
            engineHealth = QBCore.Shared.Round(GetVehicleEngineHealth(vehicle), 0.1),
            tankHealth = QBCore.Shared.Round(GetVehiclePetrolTankHealth(vehicle), 0.1),
            fuelLevel = QBCore.Shared.Round(GetVehicleFuelLevel(vehicle), 0.1),
            dirtLevel = QBCore.Shared.Round(GetVehicleDirtLevel(vehicle), 0.1),
            oilLevel = QBCore.Shared.Round(GetVehicleOilLevel(vehicle), 0.1),
            color1 = colorPrimary,
            color2 = colorSecondary,
            pearlescentColor = pearlescentColor,
            dashboardColor = GetVehicleDashboardColour(vehicle),
            wheelColor = wheelColor,
            wheels = GetVehicleWheelType(vehicle),
            wheelSize = GetVehicleWheelSize(vehicle),
            wheelWidth = GetVehicleWheelWidth(vehicle),
            tireHealth = tireHealth,
            tireBurstState = tireBurstState,
            tireBurstCompletely = tireBurstCompletely,
            windowTint = GetVehicleWindowTint(vehicle),
            windowStatus = windowStatus,
            doorStatus = doorStatus,
            xenonColor = GetVehicleXenonLightsColour(vehicle),
            neonEnabled = {
                IsVehicleNeonLightEnabled(vehicle, 0),
                IsVehicleNeonLightEnabled(vehicle, 1),
                IsVehicleNeonLightEnabled(vehicle, 2),
                IsVehicleNeonLightEnabled(vehicle, 3)
            },
            neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
            headlightColor = GetVehicleHeadlightsColour(vehicle),
            interiorColor = GetVehicleInteriorColour(vehicle),
            extras = extras,
            tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),
            modSpoilers = GetVehicleMod(vehicle, 0),
            modFrontBumper = GetVehicleMod(vehicle, 1),
            modRearBumper = GetVehicleMod(vehicle, 2),
            modSideSkirt = GetVehicleMod(vehicle, 3),
            modExhaust = GetVehicleMod(vehicle, 4),
            modFrame = GetVehicleMod(vehicle, 5),
            modGrille = GetVehicleMod(vehicle, 6),
            modHood = GetVehicleMod(vehicle, 7),
            modFender = GetVehicleMod(vehicle, 8),
            modRightFender = GetVehicleMod(vehicle, 9),
            modRoof = GetVehicleMod(vehicle, 10),
            modEngine = GetVehicleMod(vehicle, 11),
            modBrakes = GetVehicleMod(vehicle, 12),
            modTransmission = GetVehicleMod(vehicle, 13),
            modHorns = GetVehicleMod(vehicle, 14),
            modSuspension = GetVehicleMod(vehicle, 15),
            modArmor = GetVehicleMod(vehicle, 16),
            modKit17 = GetVehicleMod(vehicle, 17),
            modTurbo = IsToggleModOn(vehicle, 18),
            modKit19 = GetVehicleMod(vehicle, 19),
            modSmokeEnabled = IsToggleModOn(vehicle, 20),
            modKit21 = GetVehicleMod(vehicle, 21),
            modXenon = IsToggleModOn(vehicle, 22),
            modFrontWheels = GetVehicleMod(vehicle, 23),
            modBackWheels = GetVehicleMod(vehicle, 24),
            modCustomTiresF = GetVehicleModVariation(vehicle, 23),
            modCustomTiresR = GetVehicleModVariation(vehicle, 24),
            modPlateHolder = GetVehicleMod(vehicle, 25),
            modVanityPlate = GetVehicleMod(vehicle, 26),
            modTrimA = GetVehicleMod(vehicle, 27),
            modOrnaments = GetVehicleMod(vehicle, 28),
            modDashboard = GetVehicleMod(vehicle, 29),
            modDial = GetVehicleMod(vehicle, 30),
            modDoorSpeaker = GetVehicleMod(vehicle, 31),
            modSeats = GetVehicleMod(vehicle, 32),
            modSteeringWheel = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate = GetVehicleMod(vehicle, 35),
            modSpeakers = GetVehicleMod(vehicle, 36),
            modTrunk = GetVehicleMod(vehicle, 37),
            modHydrolic = GetVehicleMod(vehicle, 38),
            modEngineBlock = GetVehicleMod(vehicle, 39),
            modAirFilter = GetVehicleMod(vehicle, 40),
            modStruts = GetVehicleMod(vehicle, 41),
            modArchCover = GetVehicleMod(vehicle, 42),
            modAerials = GetVehicleMod(vehicle, 43),
            modTrimB = GetVehicleMod(vehicle, 44),
            modTank = GetVehicleMod(vehicle, 45),
            modWindows = GetVehicleMod(vehicle, 46),
            modKit47 = GetVehicleMod(vehicle, 47),
            modLivery = modLivery,
            modKit49 = GetVehicleMod(vehicle, 49),
            liveryRoof = GetVehicleRoofLivery(vehicle),
        }
    else
        return
    end

end

local function CheckPlayers(vehicle, garage)
    for i = -1, 5, 1 do
        local seat = GetPedInVehicleSeat(vehicle, i)
        if seat then
            TaskLeaveVehicle(seat, vehicle, 0)
            if garage then
                SetEntityCoords(seat, garage.takeVehicle.x, garage.takeVehicle.y, garage.takeVehicle.z)
            end
        end
    end
    SetVehicleDoorsLocked(vehicle)
    Wait(1500)
    QBCore.Functions.DeleteVehicle(vehicle)
end

function storeVeh(veh, garage, indexgarage)
    print("store this vehicle")
    print(veh)
    print(garage)
    local plate = QBCore.Functions.GetPlate(veh)
    local bodyDamage = math.ceil(GetVehicleBodyHealth(veh))
    local engineDamage = math.ceil(GetVehicleEngineHealth(veh))
    local totalFuel = exports['LegacyFuel']:GetFuel(veh)
    -- local vehProperties = QBCore.Functions.GetVehicleProperties(veh)
    local vehProperties = GetVehProps(veh)
    TriggerServerEvent('qb-garage:server:updateVehicle', 1, totalFuel, engineDamage, bodyDamage, plate, indexgarage)
    TriggerServerEvent('qb-garage:server:updateVehicleProperties', vehProperties, plate)
    CheckPlayers(veh, garage)
    TriggerEvent('qb-garages:client:updateOutside', plate)
    -- if plate then
    --     -- OutsideVehicles[plate] = nil
    --     TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
    -- end
    TriggerServerEvent('qb-customs:server:chargeMonkey')
    DeleteEntity(monkeyDriver)
    QBCore.Functions.Notify("Vehicle parked", "primary", 4500)

end

RegisterNetEvent('qb-customs:triggerGarageMonkey')
AddEventHandler('qb-customs:triggerGarageMonkey', function(garage, index)
    -- print("begin")
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed,true)
    local coordsBehindPlayer = GetOffsetFromEntityInWorldCoords(playerPed, 100, -50.0, 0)
    local found, outPos, outHeading = GetClosestVehicleNodeWithHeading(coordsBehindPlayer['x'], coordsBehindPlayer['y'], coordsBehindPlayer['z'], 1, 3.0, 0)

    if found then
        -- print("found")
        local curVeh = GetVehiclePedIsIn(playerPed, false)
        QBCore.Functions.TriggerCallback('qb-customs:server:isOwned', function(isOwnedVehicle)
            -- print(isOwnedVehicle)
            if isOwnedVehicle then
                QBCore.Functions.Notify("A driver has been dispatched to your position.")
                local MonkeyHash = `a_c_chimp`
                RequestModel(MonkeyHash)
                while not HasModelLoaded(MonkeyHash) do
                    Wait(5)
                end
                -- print("create person")
                monkeyDriver = CreatePed(1, MonkeyHash, outPos.x, outPos.y, outPos.z, outHeading, true, true)
                SetModelAsNoLongerNeeded(MonkeyHash)
                SetPedFleeAttributes(monkeyDriver, 0, 0)
                SetBlockingOfNonTemporaryEvents(monkeyDriver, true)
            
                TaskGoToEntity(monkeyDriver, curVeh, -1, 0.5, 1073741824, 0)
                local monkeyPos = GetEntityCoords(monkeyDriver)
                local vehiclePos = GetEntityCoords(curVeh)
                while #(monkeyPos- vehiclePos) > 2.0 do
                    monkeyPos = GetEntityCoords(monkeyDriver)
                    vehiclePos = GetEntityCoords(curVeh)
                    Wait(500)
                end
                -- print("at veh")
                TaskEnterVehicle(monkeyDriver, curVeh, -1, -1, 2.0, 8, 0)
                while not IsPedInVehicle(monkeyDriver, curVeh, false) do
                    Wait(500)
                    if IsPedDeadOrDying(monkeyDriver) then
                        QBCore.Functions.Notify("Your monkey driver has died")
                        return
                    end
                end
                -- print("in veh")
                -- old driving style: 572
                TaskVehicleDriveToCoordLongrange(monkeyDriver, curVeh, garage.x, garage.y, garage.z, 60.0, 263103, 5.0)
                while #(monkeyPos- garage) > 5.0 do
                    monkeyPos = GetEntityCoords(monkeyDriver)
                    Wait(500)
                    if IsPedDeadOrDying(monkeyDriver) then
                        QBCore.Functions.Notify("Your monkey driver has died")
                        return
                    end
                end
                -- print("arrived")
                local garagePos = {}
                garagePos.takeVehicle = garage
                -- TriggerEvent('qb-garages:client:storeVehicleMonkey', curVeh, garagePos)
                FreezeEntityPosition(curVeh, true)
                storeVeh(curVeh, garagePos, index)
            else
                QBCore.Functions.Notify("This vehicle is not owned")
            end
        end, GetVehicleNumberPlateText(curVeh))
    -- local spawned_car = CreateVehicle(vehicle, outPos, outHeading, true, false)
    -- SetVehicleOnGroundProperly(spawned_car)
    -- SetModelAsNoLongerNeeded(vehicle)
        
    end
end)

