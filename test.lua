

RegisterNetEvent('orpailleur_job:putStockItems')
AddEventHandler('orpailleur_job:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_orpailleur', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

        if count > 0 and inventoryItem.count >= count then
            print("1t")
			xPlayer.removeInventoryItem(itemName, count)
            print("t")
            TriggerClientEvent('esx:showNotification', _source, count..'~g~+ objet(s)')
            inventory.addItem(itemName, count)

		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)