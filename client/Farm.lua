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

function startScenario(anim)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

function startAnimation(lib, anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
    end)
end

Citizen.CreateThread(function()
    while true do
        local Time = 450
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'orpailleurs' then
        local player = GetEntityCoords(GetPlayerPed(-1), false)
        local distance = Vdist(player.x, player.y, player.z, -347.7, 3013.79, 14.25)
        if distance <= 3 then
            DrawMarker(1, -347.7, 3013.79, 14.05,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 2.5, 2.5, 0.5, 206, 185, 117 , 255, false, true, p19, true)
            end
            if distance <= 1.5 then
                Time = 0   
                        AddTextEntry("TEST",'Appuyer sur ~INPUT_CONTEXT~ ~s~ pour récolter ~y~les pépites.')
                        DisplayHelpTextThisFrame("TEST", false)
                        if IsControlJustPressed(1,51) then
                        startScenario('world_human_gardener_plant')
                        Citizen.Wait(4000)
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                        Citizen.Wait(2000)
                        TriggerServerEvent('recolte_pepites')
                    end   
                end
            end 
        Citizen.Wait(Time)
    end
end)

Citizen.CreateThread(function()
    while true do
        local Time = 450
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'orpailleurs' then
        local player = GetEntityCoords(GetPlayerPed(-1), false)
        local distance = Vdist(player.x, player.y, player.z, 1114.02, -2004.82, 34.25)
        if distance <= 3 then
            DrawMarker(1, 1114.02, -2004.82, 34.25,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 2.5, 2.5, 0.5, 206, 185, 117 , 255, false, true, p19, true)
            end
            if distance <= 1.5 then
                Time = 0   
                        AddTextEntry("TEST",'Appuyer sur ~INPUT_CONTEXT~ ~s~ pour traiter vos ~y~pépites.')
                        DisplayHelpTextThisFrame("TEST", false)
                        if IsControlJustPressed(1,51) then
                        startAnimation("amb@medic@standing@tendtodead@base", "base")
                        Citizen.Wait(Config.TempsTraitement1)
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                        TriggerServerEvent('traitement_pepites')
                    end   
                end
            end 
        Citizen.Wait(Time)
    end
end)

Citizen.CreateThread(function()
    while true do
        local Time = 450
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'orpailleurs' then
        local player = GetEntityCoords(GetPlayerPed(-1), false)
        local distance = Vdist(player.x, player.y, player.z, 1109.98, -2008.21, 30.15)
        if distance <= 3 then
            DrawMarker(1, 1109.98, -2008.21, 30.15,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 2.5, 2.5, 0.5, 206, 185, 117 , 255, false, true, p19, true)
            end
            if distance <= 1.5 then
                Time = 0   
                        AddTextEntry("TEST",'Appuyer sur ~INPUT_CONTEXT~ ~s~ pour traiter votre ~y~poudre d\'or.')
                        DisplayHelpTextThisFrame("TEST", false)
                        if IsControlJustPressed(1,51) then
                        startAnimation("anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer")
                        Citizen.Wait(Config.TempsTraitement2)
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                        TriggerServerEvent('traitement_powder')
                    end   
                end
            end 
        Citizen.Wait(Time)
    end
end)

function VenteCamion()
    local car_name = "mule"
    local car_hash = GetHashKey(car_name)

    RequestModel(car_hash)
    while not HasModelLoaded(car_hash) do Wait(1) end

    local car = CreateVehicle(car_hash, 152.57, -2494.39, 7.0, 0, true, false)

    local ped_name = "s_m_m_dockwork_01"
    local ped_hash = GetHashKey(ped_name)

    RequestModel(ped_hash)
    while not HasModelLoaded(ped_hash) do Wait(1) end

    local ped_driver = CreatePed(4, ped_hash, 152.57, -2494.39, 7.0-0.94, 242.62, false, true)
    
    SetVehicleNumberPlateText(car, "LIVRAISON")
    SetPedIntoVehicle(ped_driver, car, -1)
    Wait(40)
    TaskVehicleDriveToCoord(ped_driver, car, -71.46, -2521.64, 6.01, 10.00, 0, GetEntityModel(car), 442, 8.0)
    TimeLeft = 62
    repeat
    TriggerEvent("mt:missiontext", '~w~Le transporteur arrive dans : ~r~'.. TimeLeft .. ' ~w~secondes (Temps estimé)', 1000)
    TimeLeft = TimeLeft - 1
    Citizen.Wait(1000)
    until(TimeLeft == 0)

    local car_name2 = "forklift"
    local car_hash2 = GetHashKey(car_name2)

    RequestModel(car_hash2)
    while not HasModelLoaded(car_hash2) do Wait(1) end

    local car2 = CreateVehicle(car_hash2, -96.23, -2520.04, 6.0, 0.0, true, false)
    local blip_car = AddBlipForEntity(car2)
    SetBlipSprite(blip_car, 635)

    repeat
        RageUI.Text({ message = "~r~[Manager] ~w~ Va charger le camion ! (Monte dans le porte pallette)", time_display = 10000 })
        local player = PlayerPedId()
        Citizen.Wait(1000)
    until(IsPedInVehicle(player, car2, false))

    SetVehicleDoorOpen(car, 3, false, false)
    SetVehicleDoorOpen(car, 2, false, false)

    repeat
        RageUI.Text({ message = "~r~[Manager] ~w~ Rendez vous à l'arrière du camion !", time_display = 10000 })

        local player_coords = GetEntityCoords(GetPlayerPed(-1), false)
        local distance = Vdist(player_coords.x, player_coords.y, player_coords.z, -73.78, -2505.88, 6.00)
        Citizen.Wait(1000)

    until(distance <= 5)

    RageUI.Text({ message = "~r~[Manager] ~w~ Bien joué ! ", time_display = 5000 })

    Citizen.Wait(5000)
    SetVehicleDoorShut(car, 3, false)
    SetVehicleDoorShut(car, 2, false)

    TaskVehicleDriveToCoord(ped_driver, car, 59.43, -2474.87, 7.84, 10.00, 0, GetEntityModel(car), 442, 8.0)

    Citizen.Wait(2000)

    SetNewWaypoint(-37.08, -2418.88, 6.0)

    repeat
        local player_coords = GetEntityCoords(GetPlayerPed(-1), false)
        local distance_dv = Vdist(player_coords.x, player_coords.y, player_coords.z, -37.08, -2418.88, 6.0)
        RageUI.Text({ message = "~r~[Manager] ~w~ Range ton véhicule (Regarde le GPS) ", time_display = 10000 })

        Citizen.Wait(1000)

    until(distance_dv <= 7)


    local player = PlayerPedId()
    local vehicule = GetVehiclePedIsIn(player, false)    
    SetEntityAsMissionEntity(vehicule, true, true)
    DeleteVehicle(vehicule, false)

    RageUI.Text({ message = "~g~ Véhicule rangé", time_display = 5000 })

    RageUI.Text({ message = "~r~[Manager] ~w~ Voici ta paie.", time_display = 5000 })

    Citizen.Wait(1000)
    TriggerServerEvent("vente_lingots")

    Citizen.Wait(25000)

    TaskLeaveAnyVehicle(ped_driver, true, false)
    Citizen.SetTimeout(0, function()
      DeletePed(ped_driver)
      DeleteVehicle(car)
      
    end)


end


Citizen.CreateThread(function(source)
    while true do
        local Time = 450
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'orpailleurs' then
        local player = GetEntityCoords(GetPlayerPed(-1), false)
        local distance = Vdist(player.x, player.y, player.z, -63.78, -2519.98, 7.4-0.94)
            if distance <= 1.5 then
                Time = 0
                        RageUI.Text({ message = "Appuyez sur ~y~[E]~s~ pour vendre vos ~y~lingots d\'or", time_display = 1 })
                        DisplayHelpTextThisFrame("TEST", false)
                        if IsControlJustPressed(1,51) then
                            RageUI.Text({ message = "~r~[Manager] ~w~Tu as des lingots sur toi ?", time_display = 10000 })
                            Citizen.Wait(5000)
                            RageUI.Text({ message = "~b~[Moi] ~w~Euhh oui..", time_display = 10000 })
                            Citizen.Wait(5000)
                            RageUI.Text({ message = "~r~[Manager] ~w~Je peux te faire un bon prix, pour des ~y~lingots d\'or.", time_display = 10000 })
                            Citizen.Wait(5000)
                            ESX.TriggerServerCallback("orpailleur_job:getLingots", function(result) 
                                if result >= 100 then
                                    RageUI.Text({ message = "~r~[Manager] ~w~Je vois que tu as déjà la marchandise sur toi !", time_display = 10000 })
                                    Citizen.Wait(3000)
                                    RageUI.Text({ message = "~r~[Manager] ~w~J'appelle ~r~le transporteur.", time_display = 10000 })
                                    Citizen.Wait(3000)
                                    sendNotification('Le transporteur de ~y~lingots d\'or ~w~est en route !')
                                    Citizen.Wait(3000)
                                    sendNotification('~r~Reste dans la zone')
                                    Citizen.Wait(3000)
                                    VenteCamion()
                                else
                                    RageUI.Text({ message = "~r~[Manager] ~w~Reviens quand tu as tout sur toi (au moins ~y~100 lingots.~w~)", time_display = 7000 })
                                    Citizen.Wait(7000)


                                end
                            
                            end)
                            Citizen.Wait(50000)
                    end   
                end
            end 
        Citizen.Wait(Time)
    end
end)

Citizen.CreateThread(function()

    local ped_name = "s_m_y_construct_02"
    local ped_hash = GetHashKey(ped_name)

    RequestModel(ped_hash)
    while not HasModelLoaded(ped_hash) do Wait(1) end

    ped = CreatePed(4, ped_hash, -63.78, -2519.98, 7.4-0.94, 242.62, false, true)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD_FACILITY', 0, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)

end)

RegisterNetEvent("mt:missiontext")
AddEventHandler("mt:missiontext", function(text, time)
        ClearPrints()
        SetTextEntry_2("STRING")
        AddTextComponentString(text)
        DrawSubtitleTimed(time, 1)
end)
