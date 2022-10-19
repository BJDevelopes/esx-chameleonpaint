ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


for k, v in pairs(Config.ChameleonColors) do
    ESX.RegisterUsableItem('chameleonpaint_'..k, function(source, item)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        if Config.JobOnly then
            local playerjob = xPlayer.getJob().name
            if playerjob == Config.JobName then
                TriggerClientEvent('chameleonpaint:sprayVehicle', src , item.name, k)
                xPlayer.removeInventoryItem('chameleonpaint_'..k, 1)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You dont have permission to use this!'})
            end
        else
            TriggerClientEvent('chameleonpaint:sprayVehicle', src , item.name, k)
            xPlayer.removeInventoryItem('chameleonpaint_'..k, 1)
        end
    end)
end


RegisterServerEvent('chameleonpaint:updateVehicle')
AddEventHandler('chameleonpaint:updateVehicle', function(vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] then
			local vehicle = json.decode(result[1].vehicle)

			if vehicleProps.model == vehicle.model then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
					['@plate'] = vehicleProps.plate,
					['@vehicle'] = json.encode(vehicleProps)
				})
			else
				print(('esx_customs: %s attempted to upgrade vehicle with mismatching vehicle model!'):format(xPlayer.identifier))
			end
		end
	end)
end)
