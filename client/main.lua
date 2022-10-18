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
                        local vehicle = GetClosestVehicle(pedCoords)
                        SetVehicleModKit(vehicle, 0)
                        SetVehicleColours(vehicle, Config.ChameleonColors[index][gameBuild], Config.ChameleonColors[index][gameBuild])
                        DeleteObject(prop)
                        ClearPedTasks(ped)
                    end
                end)
            end
        end)
    end
end)
