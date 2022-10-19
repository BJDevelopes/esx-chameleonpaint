ESX = nil
local gameBuild = GetGameBuildNumber()

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

RegisterNetEvent('chameleonpaint:sprayVehicle')
AddEventHandler('chameleonpaint:sprayVehicle', function(name, index)
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then
        local dict1, anim1 = 'switch@franklin@lamar_tagging_wall', 'lamar_tagging_wall_loop_lamar'
		local anim2 = 'lamar_tagging_exit_loop_lamar'
        local can_model = 'prop_cs_spray_can'
        RequestModel(can_model)
        while not HasModelLoaded(can_model) do
            Citizen.Wait(1)
            RequestModel(can_model)
        end
        local prop = CreateObject(can_model, GetEntityCoords(ped), true, true, true)
		AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 57005), 0.12, 0.0, -0.04, -70.0, 0.0, -10.0, true, true, false, false, 1, true)
        TriggerEvent("mythic_progbar:client:progress", {
            name = "shaking",
            duration = 15000,
            label = "Shaking can",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
           },
            animation = {
                animDict = dict1,
                anim = anim1,
           },
           -- prop = {
           --     model = "prop_paper_bag_small",
           -- }
        }, function(status)
            if not status then
                ClearPedTasks(ped)
                -- Might need to replace this with xSound
                --TriggerServerEvent("InteractSound_SV:PlayOnSource", "spraypaint", 0.3)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "Painting",
                    duration = 15000,
                    label = "Painting",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = dict1,
                        anim = anim2,
                    },
                    --prop = {
                    --    model = "prop_paper_bag_small",
                    --}
                }, function(status)
                    if not status then
                        -- Do Something If Event Wasn't Cancelled
                        local pedCoords = GetEntityCoords(ped)
                        local vehicle = ESX.Game.GetClosestVehicle(pedCoords)
                        SetVehicleColours(vehicle, Config.ChameleonColors[index][gameBuild], Config.ChameleonColors[index][gameBuild])
                        if Config.GarageSave then
                            savePaint()
                        end
                        DeleteObject(prop)
                        ClearPedTasks(ped)
                    end
                end)
            end
        end)
    end
end)

function GetCurrentXenonColour()
    local plyPed = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(plyPed, false)

    return GetVehicleHeadlightsColour(plyVeh)
end


function savePaint()
    local plyPed = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local veh = ESX.Game.GetClosestVehicle(pedCoords)
    local vehicleMods = {
        neon = {},
        colors = {},
        extracolors = {},
        dashColour = -1,
        interColour = -1,
        lights = {},
        tint = GetVehicleWindowTint(veh),
        wheeltype = GetVehicleWheelType(veh),
        platestyle = GetVehicleNumberPlateTextIndex(veh),
        mods = {},
        smokecolor = {},
        xenonColor = -1,
        oldLiveries = 24,
        extras = {}
    }

    vehicleMods.xenonColor = GetCurrentXenonColour(veh)
    vehicleMods.lights[1], vehicleMods.lights[2], vehicleMods.lights[3] = GetVehicleNeonLightsColour(veh)
    vehicleMods.colors[1], vehicleMods.colors[2] = GetVehicleColours(veh)
    vehicleMods.extracolors[1], vehicleMods.extracolors[2] = GetVehicleExtraColours(veh)
    vehicleMods.smokecolor[1], vehicleMods.smokecolor[2], vehicleMods.smokecolor[3] = GetVehicleTyreSmokeColor(veh)
    vehicleMods.dashColour = GetVehicleInteriorColour(veh)
    vehicleMods.interColour = GetVehicleDashboardColour(veh)
    vehicleMods.oldLiveries = GetVehicleLivery(veh)

    for i = 0, 3 do
        vehicleMods.neon[i] = IsVehicleNeonLightEnabled(veh, i)
    end

    for i = 0,16 do
        vehicleMods.mods[i] = GetVehicleMod(veh,i)
    end

    for i = 17, 22 do
        vehicleMods.mods[i] = IsToggleModOn(veh, i)
    end

    for i = 23, 48 do
        vehicleMods.mods[i] = GetVehicleMod(veh,i)
    end

    for i = 1, 12 do
        local ison = IsVehicleExtraTurnedOn(veh, i)
        if 1 == tonumber(ison) then
            vehicleMods.extras[i] = 1
        else
            vehicleMods.extras[i] = 0
        end
    end
    local myCar = ESX.Game.GetVehicleProperties(veh)
    TriggerServerEvent('chameleonpaint:updateVehicle', myCar)
end
