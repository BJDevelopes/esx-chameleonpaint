ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


for k, v in pairs(Config.ChameleonColors) do
    ESX.RegisterUsableItem('chameleonpaint_'..k, function(source, item)
        print("Item Used..")
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        TriggerClientEvent('chameleonpaint:sprayVehicle', src , item.name, k)
        xPlayer.removeInventoryItem('chameleonpaint_'..k, 1)
    end)
end