ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'orpailleurs', 'orpailleurs', 'society_orpailleur', 'society_orpailleur', 'society_orpailleur', {type = 'private'})

----------- INVENTAIRE / COFFRE -------------------
ESX.RegisterServerCallback('orpailleur_job:getItemsStock', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_orpailleur', function(inventory)
		cb(inventory.items)
    end)
end)

-- RETIRER ---
RegisterNetEvent('orpailleur_job:getStockItem')
AddEventHandler('orpailleur_job:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_orpailleur', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Retrait\n~s~- ~g~Coffre : ~y~Orpailleurs \n~s~- ~b~Item ~s~: "..itemName.."\n~s~- ~o~Quantitée ~s~: "..count.."")
            else
			TriggerClientEvent('esx:showNotification', _source, "La quantité est ~r~invalide")
		end
	end)
end)
-- FIN RETIRER ---


ESX.RegisterServerCallback('orpailleur_job:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

-- AJOUTER ---

RegisterNetEvent('orpailleur_job:putStockItems')
AddEventHandler('orpailleur_job:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
    local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_orpailleur', function(inventory)

        if sourceItem.count >= count and count > 0 then
            xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Depôt\n~s~- ~g~Coffre : ~y~Orpailleurs \n~s~- ~b~Item ~s~: "..itemName.."\n~s~- ~o~Quantitée ~s~: "..count.."")
        else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "La quantité est ~r~invalide")
		end
    end)

end)

-- AJOUTER ---


----------FIN INVENTAIRE ---------------


------------------------------------------------------

--Recolte - Limite Inventaire    
RegisterNetEvent('recolte_pepites')
AddEventHandler('recolte_pepites', function()
    local item = "pepites"
    local limiteitem = 50
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbitemdansinventaire = xPlayer.getInventoryItem(item).count
    

    if nbitemdansinventaire >= limiteitem then
        TriggerClientEvent('esx:showNotification', source, "Tu ne peux plus porter de ~y~ pépites.")
    else
        local random =  math.random(Config.Farm1Random.Min,Config.Farm1Random.Max)
        xPlayer.addInventoryItem(item, random)
        TriggerClientEvent('esx:showNotification', source, "~y~+"..random.."~y~ pépites.")


    end
end)

RegisterNetEvent('traitement_pepites')
AddEventHandler('traitement_pepites', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local pepites = xPlayer.getInventoryItem('pepites').count
    local powder = xPlayer.getInventoryItem('powder').count

    if powder > 100 then
        TriggerClientEvent('esx:showNotification', source, 'Tu ne peux plus porter de ~y~ poudres d\'or.')
    elseif pepites < Config.Farms.Farm2.pepites then
        TriggerClientEvent('esx:showNotification', source, 'Tu n\'as plus assez de ~y~pépites ~w~pour les fondres.')
    else
        xPlayer.removeInventoryItem('pepites', Config.Farms.Farm2.pepites)
        xPlayer.addInventoryItem('powder', Config.Farms.Farm2.poudre)
    end
end)

RegisterNetEvent('traitement_powder')
AddEventHandler('traitement_powder', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local powder = xPlayer.getInventoryItem('powder').count
    local lingot = xPlayer.getInventoryItem('lingot').count

    if lingot > 100 then
        TriggerClientEvent('esx:showNotification', source, 'Ton invetaire est ~r~plein~w~...de ~y~lingots ~w~!')
    elseif powder < Config.Farms.Farm3.poudre then
        TriggerClientEvent('esx:showNotification', source, 'Tu n\'as plus assez de ~y~poudre ~w~pour traiter.')
    else
        xPlayer.removeInventoryItem('powder', Config.Farms.Farm3.poudre)
        xPlayer.addInventoryItem('lingot', Config.Farms.Farm3.lingots)
        TriggerClientEvent('esx:showNotification', source, "~y~+5~y~ lingots.")

    end
end)

RegisterNetEvent('venteorpa')
AddEventHandler('venteorpa', function()

    local money = math.random(Config.Farms.Seller.onelingotprice,Config.Farms.Seller.onelingotprice)
    local xPlayer = ESX.GetPlayerFromId(source)
    local societyAccount = nil
    local lingo = 0

    if xPlayer.getInventoryItem('lingot').count <= 0 then
        lingot_count = 0
    else
        lingot_count = 1
    end

    if lingot_count == 0 then
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Pas assez de lingots à vendre...')
        return
    elseif xPlayer.getInventoryItem('lingo').count <= 0 and argent == 0 then
        TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Pas assez de lingots à vendre...')
        lingot_count = 0
        return
    elseif lingot_count == 1 then
            local money = math.random(Config.Farms.Seller.onelingotprice,Config.Farms.Seller.onelingotprice)
            xPlayer.removeInventoryItem('lingo', 1)
            local societyAccount = nil

            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_orpa', function(account)
                societyAccount = account
            end)
            if societyAccount ~= nil then
                societyAccount.addMoney(money)
                TriggerClientEvent('esx:showNotification', source, "Vous avez vendu 1 ~y~lingot~w~ pour 30$")
            end
        end
        end) 


RegisterNetEvent("vente_lingots")
AddEventHandler("vente_lingots", function()

    local money = math.random(Config.Farms.Seller.onelingotprice,Config.Farms.Seller.onelingotprice)
    local xPlayer = ESX.GetPlayerFromId(source)
    local societyAccount = nil
    local lingots = xPlayer.getInventoryItem('lingot').count
    local Totalmoney = 0

    xPlayer.removeInventoryItem('lingot', lingots)

    Totalmoney = money * lingots

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_orpailleur', function(account)
        societyAccount = account
    end)
    if societyAccount ~= nil then
        societyAccount.addMoney(Totalmoney)
        TriggerClientEvent('esx:showNotification', source, "Vous avez vendu ".. lingots .." ~y~lingots ~w~ pour ~g~".. Totalmoney .."$." )

    end

end)

ESX.RegisterServerCallback('orpailleur_job:getLingots', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local lingots = xPlayer.getInventoryItem('lingot').count

    cb(lingots)
end)



RegisterNetEvent("Annonces_Ouvertures")
AddEventHandler("Annonces_Ouvertures", function()
    local player = source
    local xPlayer = ESX.GetPlayerFromId(player)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
	    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Orpailleurs', '~y~Annonce', 'Notre entreprise est désormais ~g~ouverte !', 'CHAR_SOCIAL_CLUB', 2)
    end
end)

RegisterNetEvent("Annonces_Fermetures")
AddEventHandler("Annonces_Fermetures", function()
    local player = source
    local xPlayer = ESX.GetPlayerFromId(player)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
	    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Orpailleurs', '~y~Annonce', 'Notre entreprise est désormais ~r~fermer !', 'CHAR_SOCIAL_CLUB', 2)
    end
end)

RegisterNetEvent("Annonces_Perso")
AddEventHandler("Annonces_Perso", function(result)
    local player = source
    local xPlayer = ESX.GetPlayerFromId(player)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
	    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Orpailleurs', '~y~Annonce', ''..result..'', 'CHAR_SOCIAL_CLUB', 2)
    end

end)
