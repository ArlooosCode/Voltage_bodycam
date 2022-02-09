ESX = nil
local PlayerData = {}
local haveItem = false
local Loaded = false

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtestaredObjtestect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    Citizen.Wait(5000)
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	Loaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	if PlayerData.job ~= nil and (PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police') and haveItem then
		TriggerEvent('bodycam:showw')
	else
		TriggerEvent('bodycam:closee')
	end
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	if PlayerData and PlayerData.inventory then
		CreateThread(function()
			Citizen.Wait(100)
			PlayerData = ESX.GetPlayerData()

			local found = false
			for i = 1, #PlayerData.inventory, 1 do
				if PlayerData.inventory[i].name == item.name then
					PlayerData.inventory[i] = item
					found = true
					break
				end
			end
		end)
	end
	
	if PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' then
		if item == 'bodycam' and count > 0 then
			TriggerEvent('bodycam:showw')
		end	
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	if PlayerData and PlayerData.inventory then
		CreateThread(function()
			Citizen.Wait(100)
			ESX.PlayerData = ESX.GetPlayerData()

			local found = false
			for i = 1, #PlayerData.inventory, 1 do
				if PlayerData.inventory[i].name == item.name then
					PlayerData.inventory[i] = item
					found = true
					break
				end
			end
		end)
	end
	
	if PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' then
		if item == 'bodycam' and count <= 0 then
			TriggerEvent('bodycam:closee')
		end	
	end
end)

RegisterNetEvent('bodycam:state')
AddEventHandler('bodycam:state', function(rodzaj)
	if PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' and haveItem then
		if rodzaj == true then
			TriggerEvent('bodycam:closee')
		elseif rodzaj == false then
			TriggerEvent('bodycam:showw')
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(500)
		if Loaded then
			for i = 1, #PlayerData.inventory, 1 do
				if PlayerData.inventory[i].name == 'bodycam' then
					if PlayerData.inventory[i].count > 0 then
						haveItem = true
					else
						haveItem = false
					end
				end
			end	
		end		
	end
end)

local IsPaused = false
CreateThread(function()
	while true do
		Citizen.Wait(1)
		if Loaded then
			if PlayerData.job ~= nil and PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' and haveItem then
				if IsPauseMenuActive() and not IsPaused then
					IsPaused = true
					TriggerEvent('bodycam:closee')
				elseif not IsPauseMenuActive() and IsPaused then
					IsPaused = false
					TriggerEvent('bodycam:showw')
				end
			end
		end
	end
end)

RegisterNetEvent("bodycam:showw")
AddEventHandler("bodycam:showw", function()
	local text = ''
	ESX.TriggerServerCallback('xk3ly-bodycam:getPlayerName', function(result)
	if PlayerData.job.name == 'sheriff' then
		text = 'LOS SANTOS SHERIFF DEPARTMENT'
	elseif PlayerData.job.name == 'ambulance' then
		text = 'EMERGENCY MEDICAL SERVICES'
	elseif PlayerData.job.name == 'police' then
		text = 'LOS SANTOS POLICE DEPARTMENT'
	end
		SendNUIMessage({
			action = 'updatecam',
			odznaka = result.name,
			napis = text,
		})
	end)
end)

RegisterNetEvent("bodycam:closee")
AddEventHandler("bodycam:closee", function()
	SendNUIMessage({
		action = 'closecam'
	})
end)