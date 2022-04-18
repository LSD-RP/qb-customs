local QBCore = exports['qb-core']:GetCoreObject()
local monkeyDriver = nil
local garage = vector3(-2974.71, 487.11, 15.28)

RegisterNetEvent('qb-customs:triggerGarageMonkey')
AddEventHandler('qb-customs:triggerGarageMonkey', function()
    print("begin")
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed,true)
    local coordsBehindPlayer = GetOffsetFromEntityInWorldCoords(playerPed, 100, -50.0, 0)
    local found, outPos, outHeading = GetClosestVehicleNodeWithHeading(coordsBehindPlayer['x'], coordsBehindPlayer['y'], coordsBehindPlayer['z'], 1, 3.0, 0)

    if found then
        print("found")
    -- local spawned_car = CreateVehicle(vehicle, outPos, outHeading, true, false)
    -- SetVehicleOnGroundProperly(spawned_car)
    -- SetModelAsNoLongerNeeded(vehicle)
        local MonkeyHash = `a_c_chimp`
        RequestModel(MonkeyHash)
        while not HasModelLoaded(MonkeyHash) do
            Wait(5)
        end
        print("create person")
        monkeyDriver = CreatePed(1, MonkeyHash, outPos.x, outPos.y, outPos.z, outHeading, true, true)
        SetModelAsNoLongerNeeded(MonkeyHash)
        SetPedFleeAttributes(monkeyDriver, 0, 0)

        local curVeh = GetVehiclePedIsIn(playerPed, false)
        TaskGoToEntity(monkeyDriver, curVeh, -1, 0.5, 1073741824, 0)
        local monkeyPos = GetEntityCoords(monkeyDriver)
        local vehiclePos = GetEntityCoords(curVeh)
        while #(monkeyPos- vehiclePos) > 2.0 do
            monkeyPos = GetEntityCoords(monkeyDriver)
            vehiclePos = GetEntityCoords(curVeh)
            Wait(500)
        end
        print("at veh")
        TaskEnterVehicle(monkeyDriver, curVeh, -1, -1, 2.0, 8, 0)
        while not IsPedInVehicle(monkeyDriver, curVeh, false) do
            Wait(500)
        end
        print("in veh")
        TaskVehicleDriveToCoordLongrange(monkeyDriver, curVeh, garage.x, garage.y, garage.z, 60.0, 572, 5.0)
        while #(monkeyPos- garage) > 1.0 do
            monkeyPos = GetEntityCoords(monkeyDriver)
            Wait(500)
        end
        print("arrived")
    end
end)