ESX = nil

local function sendNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(true, false)

end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local blips = {
    {title="Orpailleurs", colour=46, id=618, x =  1077.48, y = -1973.41, z =  31.47}
}
     
Citizen.CreateThread(function()

   for _, info in pairs(blips) do
     info.blip = AddBlipForCoord(info.x, info.y, info.z)
     SetBlipSprite(info.blip, info.id)
     SetBlipDisplay(info.blip, 4)
     SetBlipScale(info.blip, 0.8)
     SetBlipColour(info.blip, info.colour)
     SetBlipAsShortRange(info.blip, true)
     BeginTextCommandSetBlipName("STRING")
     AddTextComponentString(info.title)
     EndTextCommandSetBlipName(info.blip)
   end
end)

function TimeToGo(point_x, point_y, point_z)
    local player = PlayerPedId()
    local player_pos = GetEntityCoords(PlayerPedId())
    local point = vector3(point_x, point_y, point_z)
    local distance = GetDistanceBetweenCoords(player_pos, point, true)
    local coef = nil
    local temps = nil
    local time_ia_calc = 0.0370

if distance >= 500 then
    coef = 1.1
else
    coef = 1.0
end
    temps_final = distance * coef * time_ia_calc
    return temps_final
end

function round(num, dec)
    local mult = 10^(dec or 0)
    return math.floor(num * mult + 0.5) / mult
  end

  function startAnimation(lib, anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
    end)
end


function F6Menu()
    local Menu_Orpailleurs = RageUI.CreateMenu("Orpailleurs", "Menu Orpailleurs")
    local SubMenu_GPS = RageUI.CreateSubMenu(Menu_Orpailleurs, "GPS", "Orpailleurs")
    Menu_Orpailleurs:SetRectangleBanner(228, 191, 10)
    SubMenu_GPS:SetRectangleBanner(228, 191, 10)

    RageUI.Visible(Menu_Orpailleurs, not RageUI.Visible(Menu_Orpailleurs))
    while Menu_Orpailleurs do
        RageUI.IsVisible(Menu_Orpailleurs, true, true, true, function()
            if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'co-pdg' then 
                RageUI.Separator("↓~y~ Argent Orpailleurs ~s~↓")
                ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
                    societymoney = ESX.Math.GroupDigits(money)
                end, ESX.PlayerData.job.name)
                RageUI.Separator(societymoney.." ~g~$")
            end
            RageUI.Separator("↓ ~y~ Runs   ~s~↓")
            RageUI.ButtonWithStyle("Menu GPS pour le farm",nil, {RightLabel = "→ "}, true, function()

            end, SubMenu_GPS)


            RageUI.Separator("↓ ~y~ Autres  ~s~↓")
                if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'co-pdg' then 
                    RageUI.ButtonWithStyle("Menu Patron",nil, {RightLabel = "→ "}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerEvent('esx_society:openBossMenu', 'orpailleurs', function(data, menu)
                                menu.close()
                            end, {wash = false})
                            RageUI.CloseAll()

                        end
                    end)
                end

                RageUI.ButtonWithStyle("Faire une ~r~Facture",nil, {RightLabel = "→ "}, true, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    local playerPed        = GetPlayerPed(-1)
                    if s then
                        local raison = ""
                        local montant = 0
                        AddTextEntry("FMMC_MPM_NA", "Raison de la facture")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                raison = result
                                result = nil
                                AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Veuiller indiquez le montant de la facture :", "", "", "", "", 30)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0)
                                    Wait(0)
                                end
                                if (GetOnscreenKeyboardResult()) then
                                    result = GetOnscreenKeyboardResult()
                                    if result then
                                        montant = result
                                        result = nil
                                        if player ~= -1 and distance <= 3.0 then
                                            TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                                            Citizen.Wait(5000)
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_orpailleur', ('orpailleurs'), montant)
                                            ClearPedTasksImmediately(GetPlayerPed(-1))
                                            sendNotification("~g~ Facture envoyé !")
                                        else
                                            ESX.ShowNotification("~r~ Aucun joueurs à proximité.")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                RageUI.Separator("↓ ~y~ Annonces ~s~↓")
                RageUI.ButtonWithStyle("Annonces ~g~Ouvertures",nil, {RightLabel = "→ "}, true, function(Hovered, Active, Selected)
                    if Selected then       
                        TriggerServerEvent('Annonces_Ouvertures')
                    end
                end)
        
                RageUI.ButtonWithStyle("Annonces ~r~Fermetures",nil, {RightLabel = "→ "}, true, function(Hovered, Active, Selected)
                    if Selected then      
                        TriggerServerEvent('Annonces_Fermetures')
                    end
                end)

                RageUI.ButtonWithStyle("Annonces Personnalisées",nil, {RightLabel = "→ "}, true, function(Hovered, Active, Selected)
                    if Selected then
                        AddTextEntry("FMMC_MPM_NA", "Raison de l'annonce")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Merci de donner la raison de l'annonce :", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            print(result)    
                            TriggerServerEvent('Annonces_Perso', result)  
                        end
                    end
                end)
            end) 
        Citizen.Wait(0)

        RageUI.IsVisible(SubMenu_GPS, true, true, true, function()
            RageUI.Separator("↓ ~b~    Itinéraires   ~s~↓")
            RageUI.ButtonWithStyle("Point de recolte", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(h, a, s)
                if s then
                    local player = PlayerPedId()
                    if IsPedInAnyVehicle(player, true) then
                        SetNewWaypoint(-347.7, 3013.79, 14.25)
                        TimeToGo(-347.7, 3013.79, 14.25)
                        local time = nil
                        time = round(TimeToGo(-347.7, 3013.79, 14.25), 0)
                        print('Time =', time)
                        local time_minutes = nil
                        time_minutes = round(time / 60, 1)
                        print('Time en minutes =', time_minutes)
                        RageUI.Text({ message = "Temps estimé : ~r~".. time_minutes .. " ~w~minutes" , time_display = 10000 })
                    else
                        sendNotification('~r~ Veuillez monter dans un véhicule.')
                    end
                end
            end)

            RageUI.ButtonWithStyle("Point de traitement", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(h, a, s)
                if s then
                    local player = PlayerPedId()
                    if IsPedInAnyVehicle(player, true) then
                        SetNewWaypoint(1114.02, -2004.82, 34.25)
                        TimeToGo(1114.02, -2004.82, 34.25)
                        local time = nil
                        time = round(TimeToGo(1114.02, -2004.82, 34.25), 0)
                        local time_minutes = nil
                        time_minutes = round(time / 60, 1)
                        RageUI.Text({ message = "Temps estimé : ~r~".. time_minutes .. " ~w~minutes" , time_display = 10000 })
                    else
                        sendNotification('~r~ Veuillez monter dans un véhicule.')
                    end
                end
            end)

            RageUI.ButtonWithStyle("Point de traitement 2", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(h, a, s)
                if s then
                    local player = PlayerPedId()
                    if IsPedInAnyVehicle(player, true) then
                        SetNewWaypoint(1109.98, -2008.21, 30.15)
                        TimeToGo(1109.98, -2008.21, 30.15)
                        local time = nil
                        time = round(TimeToGo(1109.98, -2008.21, 30.15), 0)
                        local time_minutes = nil
                        time_minutes = round(time / 60, 1)
                        RageUI.Text({ message = "Temps estimé : ~r~".. time_minutes .. " ~w~minutes" , time_display = 10000 })
                    else
                        sendNotification('~r~ Veuillez monter dans un véhicule.')
                    end
                end
            end)

            RageUI.ButtonWithStyle("Point de vente", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(h, a, s)
                if s then
                    local player = PlayerPedId()
                    if IsPedInAnyVehicle(player, true) then
                        SetNewWaypoint(-63.78, -2519.98, 7.4-0.94)
                        TimeToGo(-63.78, -2519.98, 7.4-0.94)
                        local time = nil
                        time = round(TimeToGo(-63.78, -2519.98, 7.4-0.94), 0)
                        local time_minutes = nil
                        time_minutes = round(time / 60, 1)
                        RageUI.Text({ message = "Temps estimé : ~r~".. time_minutes .. " ~w~minutes" , time_display = 10000 })
                    else
                        sendNotification('~r~ Veuillez monter dans un véhicule.')
                    end
                end   
            end)
        end)
    end
    Citizen.Wait(0)
end

Keys.Register('F6', 'Orpailleurs', 'Menu Oprailleurs', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'orpailleurs' then
        F6Menu()
	end
end)

function Vestiaire()
        local Vestiaire_Orpailleurs = RageUI.CreateMenu("Orpailleurs", "Menu Orpailleurs")
        Vestiaire_Orpailleurs:SetRectangleBanner(228, 191, 10)

        RageUI.Visible(Vestiaire_Orpailleurs, not RageUI.Visible(Vestiaire_Orpailleurs))
                while Vestiaire_Orpailleurs do
                Citizen.Wait(0)
                RageUI.IsVisible(Vestiaire_Orpailleurs, true, true, true, function()

                    RageUI.ButtonWithStyle("Reprendre tes vêtements", nil, {RightLabel = "→ "}, true, function(h, a, s)
                        if s then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                startAnimation('amb@world_human_leaning@male@wall@back@foot_up@idle_a', 'idle_a')
                                Citizen.Wait(4000)
                                ClearPedTasksImmediately(GetPlayerPed(-1))
                                TriggerEvent('skinchanger:loadSkin', skin)
                            RageUI.CloseAll()
                        end)
                    end
                    end)
                RageUI.Separator("↓ ~y~ Tenue Disponibles  ~s~↓")
                if ESX.PlayerData.job.grade_name == 'boss' then 
                    RageUI.ButtonWithStyle("Tenue Patron", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(h, a, s)
                        if s then
                            local player_vetement = PlayerPedId()
                            SetPedComponentVariation(player_vetement, componentId, drawableId, 0)
                            SetPedComponentVariation(player_vetement, 6, 10, 0) -- Chaussures
                            SetPedComponentVariation(player_vetement, 4, 25, 0) -- Jambes
                            SetPedComponentVariation(player_vetement, 11, 20, 0) -- Torse 1
                            SetPedComponentVariation(player_vetement, 3, 4, 0) -- Bras
                            SetPedComponentVariation(player_vetement, 8, 4, 0) -- T-shirt
                            RageUI.CloseAll()
                        end
                    end)
                end
                if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'co-pdg' then 
                    RageUI.ButtonWithStyle("Tenue Adjoint", nil, {RightBadge = RageUI.BadgeStyle.Clothes} , true, function(h, a, s)
                        if s then
                            local player_vetement = PlayerPedId()
                            SetPedComponentVariation(player_vetement, componentId, drawableId, 0)
                            SetPedComponentVariation(player_vetement, 6, 10, 0) -- Chaussures
                            SetPedComponentVariation(player_vetement, 4, 25, 0) -- Jambes
                            SetPedComponentVariation(player_vetement, 11, 10, 0) -- Torse 1
                            SetPedComponentVariation(player_vetement, 3, 1, 0) -- Bras
                            SetPedComponentVariation(player_vetement, 8, 3, 0) -- T-shirt
                            RageUI.CloseAll()
                        end
                    end)
                end
                if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'co-pdg'  or ESX.PlayerData.job.grade_name == 'manager' then 
                    RageUI.ButtonWithStyle("Tenue Manager", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(h, a, s)
                        if s then
                            local player_vetement = PlayerPedId()
                            SetPedComponentVariation(player_vetement, componentId, drawableId, 0)
                            SetPedComponentVariation(player_vetement, 6, 7, 0) -- Chaussures
                            SetPedComponentVariation(player_vetement, 4, 35, 0) -- Jambes
                            SetPedComponentVariation(player_vetement, 11, 242, 0) -- Torse 1
                            SetPedComponentVariation(player_vetement, 3, 0, 0) -- Bras
                            SetPedComponentVariation(player_vetement, 8, 15, 0) -- T-shirt
                            RageUI.CloseAll()
                        end
                    end)
                end
                if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'co-pdg'  or ESX.PlayerData.job.grade_name == 'manager' or ESX.PlayerData.job.grade_name == 'worker2' or ESX.PlayerData.job.grade_name == 'worker' then 
                    RageUI.ButtonWithStyle("Tenue Employé", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true, function(h, a, s)
                        if s then
                            local player_vetement = PlayerPedId()
                            SetPedComponentVariation(player_vetement, componentId, drawableId, 0)
                            SetPedComponentVariation(player_vetement, 6, 25, 0) -- Chaussures
                            SetPedComponentVariation(player_vetement, 4, 9, 0) -- Jambes
                            SetPedComponentVariation(player_vetement, 11, 97, 0) -- Torse 1
                            SetPedComponentVariation(player_vetement, 3, 0, 0) -- Bras
                            SetPedComponentVariation(player_vetement, 8, 15, 0) -- T-shirt
                            SetPedComponentVariation(player_vetement, 5, 41, 0) -- Sac

                            RageUI.CloseAll()
                        end
                    end)
                end       
                end, function()end, 1)

                    if not RageUI.Visible(Vestiaire_Orpailleurs) then
                        Vestiaire_Orpailleurs = RMenu:DeleteType("Vestiaire_Orpailleurs", true)
                end
        end
end

Citizen.CreateThread(function()
    while true do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'orpailleurs' then
        local player = GetEntityCoords(GetPlayerPed(-1), false)
        local distance = Vdist(player.x, player.y, player.z, 1077.66, -1972.5, 31.47)
        if distance <= 1.2 then
            DrawMarker(2, 1077.66, -1972.5, 31.35,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.75, 0.75, 0.75, 206, 185, 117 , 255, false, true, p19, false)
        end
            if distance <= 1.2 then
                FreezeEntityPosition(PlayerPedId(), false)
                    AddTextEntry("TEST",'Appuyer sur ~INPUT_CONTEXT~ ~s~ pour accèder aux vestiaires.')
                    DisplayHelpTextThisFrame("TEST", false)
                    if IsControlJustPressed(1,51) then
                        FreezeEntityPosition(PlayerPedId(), false)
                        Vestiaire()
                end
                end
            end 
        Citizen.Wait(0)
    end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end


function Coffre()
    local Coffre_Orpailleurs = RageUI.CreateMenu("Coffre", "Menu Orpailleurs")
    Coffre_Orpailleurs:SetRectangleBanner(228, 191, 10)

    
    RageUI.Visible(Coffre_Orpailleurs, not RageUI.Visible(Coffre_Orpailleurs))
    while Coffre_Orpailleurs do
    Citizen.Wait(0)
    RageUI.IsVisible(Coffre_Orpailleurs, true, true, true, function()

        RageUI.Separator("↓ ~y~ Actions Coffre  ~s~↓")

        RageUI.ButtonWithStyle("Déposer un objet", nil, {RightLabel = "→ "}, true, function(h, a, s)
            if s then
                DeposeItem()
                RageUI.CloseAll()
            end
        end)
        RageUI.ButtonWithStyle("Retirer un objet", nil, {RightLabel = "→ "}, true, function(h, a, s)
            if s then
                RetireItem()
                RageUI.CloseAll()
            end
        end)
                 
        RageUI.Separator("↓ ~y~ Autres  ~s~↓")
        if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'co-pdg' then 
            RageUI.ButtonWithStyle("Menu Patron",nil, {RightLabel = "→ "}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerEvent('esx_society:openBossMenu', 'orpailleurs', function(data, menu)
                        menu.close()
                    end, {wash = false})
                    RageUI.CloseAll()

                end
            end)
        end

        end, function()end, 1)

        if not RageUI.Visible(Coffre_Orpailleurs) then
            Coffre_Orpailleurs = RMenu:DeleteType("Coffre_Orpailleurs", true)
    end
end

end

function RetireItem()
    local Menu_Coffre_1 = RageUI.CreateMenu("Coffre", "Menu Intéraction..")
    Menu_Coffre_1:SetRectangleBanner(228, 191, 10)
    ESX.TriggerServerCallback('orpailleur_job:getItemsStock', function(items) 
    itemstock = items
    RageUI.Visible(Menu_Coffre_1, not RageUI.Visible(Menu_Coffre_1))
        while Menu_Coffre_1 do
            Citizen.Wait(0)
                RageUI.IsVisible(Menu_Coffre_1, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count ~= 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", '' , 8)
                                    TriggerServerEvent('orpailleur_job:getStockItem', v.name, tonumber(count))
                                    RageUI.CloseAll()
                                end
                                end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(Menu_Coffre_1) then
            Menu_Coffre_1 = RMenu:DeleteType("Coffre", true)
        end
    end
end)
end

function DeposeItem()
    local Menu_Coffre_2 = RageUI.CreateMenu("Coffre", "Deposer un item")
    Menu_Coffre_2:SetRectangleBanner(228, 191, 10)
    ESX.TriggerServerCallback('orpailleur_job:getPlayerInventory', function(inventory)
        RageUI.Visible(Menu_Coffre_2, not RageUI.Visible(Menu_Coffre_2))
    while Menu_Coffre_2 do
        Citizen.Wait(0)
            RageUI.IsVisible(Menu_Coffre_2, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                            local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('orpailleur_job:putStockItems', item.name, tonumber(count))
                                            RageUI.CloseAll()
                                        end
                                    end)
                                end
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(Menu_Coffre_2) then
                Menu_Coffre_2 = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'orpailleurs' then
        local player = GetEntityCoords(GetPlayerPed(-1), false)
        local distance = Vdist(player.x, player.y, player.z, 1074.16, -2010.35, 32.08)
        if distance <= 1.2 then
            DrawMarker(2, 1074.16, -2010.35, 32.08,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.75, 0.75, 0.75, 206, 185, 117 , 255, false, true, p19, false)
        end
            if distance <= 1.2 then
                FreezeEntityPosition(PlayerPedId(), false)
                    AddTextEntry("TEST",'Appuyer sur ~INPUT_CONTEXT~ ~s~ pour accèder au coffre.')
                    DisplayHelpTextThisFrame("TEST", false)
                    if IsControlJustPressed(1,51) then
                        FreezeEntityPosition(PlayerPedId(), false)
                        Coffre()
                end
                end
            end 
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'orpailleurs' then
        local player = GetEntityCoords(GetPlayerPed(-1), false)
        local distance = Vdist(player.x, player.y, player.z, 1075.28, -1948.14, 31.01-0.94)
        if distance <= 4 then
            Timer = 0
            DrawMarker(25, 1075.28, -1948.14, 31.01-0.94,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 1.75, 1.75, 0.5, 191, 34, 34 , 255, false, true, p19, false)
        end
            if distance <= 2 then
                FreezeEntityPosition(PlayerPedId(), false)
                    AddTextEntry("TEST",'Appuyer sur ~INPUT_CONTEXT~ ~s~ pour ranger le véhicule.')
                    DisplayHelpTextThisFrame("TEST", false)
                    if IsControlJustPressed(1,51) then
                        local vehicle =GetVehiclePedIsIn(PlayerPedId(), false)
                        SetEntityAsMissionEntity(vehicle, true, true);  
                        DeleteVehicle(vehicle)
                end
                end
            end 
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()

    local ped_name = "s_m_y_construct_01"
    local ped_hash = GetHashKey(ped_name)

    RequestModel(ped_hash)
    while not HasModelLoaded(ped_hash) do Wait(1) end

    ped = CreatePed(4, ped_hash, 1082.34, -1960.3, 32.82-0.94, 54.24, false, true)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD_FACILITY', 0, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)


end)


function CreateCar(vehicleName)
    local player = PlayerPedId()
    local vehiculeHash = GetHashKey(vehicleName)

    RequestModel(vehiculeHash)
    while not HasModelLoaded(vehiculeHash) do Wait(1) end
    local Vehicle = CreateVehicle(vehiculeHash, 1065.74, -1962.00, 32.01, 0, true, false)

    SetVehicleEngineOn(Vehicle, true, true, false)
    SetPedIntoVehicle(player, Vehicle, -1)
    SetVehicleRadioEnabled(Vehicle, false)
    sendNotification("~b~ Bonne route :)")

end

Citizen.CreateThread(function(source)
    while true do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'orpailleurs' then
            local playerdistance = GetEntityCoords(GetPlayerPed(-1), false)
            local distancetoplayer = Vdist(playerdistance.x, playerdistance.y, playerdistance.z,1082.34, -1960.3, 32.82)
                if distancetoplayer <= 1.5 then
                            AddTextEntry("veh",'Appuyer sur ~INPUT_CONTEXT~ ~s~ pour prendre ton ~b~véhicule~s~.')
                            DisplayHelpTextThisFrame("veh", false)
                            if IsControlJustPressed(1,51) then
                                Menu_Vehicle()
                            end
                end
        end 
        Citizen.Wait(0)
    end
end)

function Menu_Vehicle()
    FreezeEntityPosition(PlayerPedId(), true)

    local Menu_Vehicle = RageUI.CreateMenu("Vehicules", "Menu Orpailleurs")
    Menu_Vehicle:SetRectangleBanner(228, 191, 10)

    
    RageUI.Visible(Menu_Vehicle, not RageUI.Visible(Menu_Vehicle))
    while Menu_Vehicle do
    Citizen.Wait(0)
    RageUI.IsVisible(Menu_Vehicle, true, true, true, function()


        RageUI.Separator("↓ ~y~ Vehicules  ~s~↓")
        RageUI.ButtonWithStyle("Mule", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(h, a, s)
            if s then
                RageUI.CloseAll()
                CreateCar("mule3")
            end
        end)

        if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'co-pdg' or ESX.PlayerData.job.grade_name == 'worker2' or ESX.PlayerData.job.grade_name == 'manager' then 


        RageUI.ButtonWithStyle("Bison", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(h, a, s)
            if s then
                RageUI.CloseAll()
                CreateCar("Bison")
            end
        end)

    end

    if ESX.PlayerData.job.grade_name == 'boss' or ESX.PlayerData.job.grade_name == 'co-pdg' then 

        RageUI.ButtonWithStyle("Voiture du Patron", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(h, a, s)
            if s then
                RageUI.CloseAll()
                CreateCar("baller3")
            end
        end)

    end
        end, function()end, 1)

        if not RageUI.Visible(Menu_Vehicle) then
            Menu_Vehicle = RMenu:DeleteType("Menu_Vehicle", true)
            FreezeEntityPosition(PlayerPedId(), false)
    end
end
    Citizen.Wait(0)
end


RegisterCommand("lan", function()
    
    print(_U('test'))    
end)
