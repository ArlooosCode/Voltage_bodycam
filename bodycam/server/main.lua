ESX = nil

TriggerEvent('esx:getShtestaredObjtestect', function(obj) ESX = obj end)

ESX.RegisterServerCallback('xk3ly-bodycam:getPlayerName', function(source, cb)
	local data = {
		name = GetCharacterName(source),
	}
	cb(data)
end)

function GetCharacterName(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, odznaka FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	
	local odznaka = ''
	if result[1] and result[1].firstname and result[1].lastname then
		if result[1].odznaka == nil then
			odznaka = '[Brak odznaki]'
		else
			odznaka = result[1].odznaka
		end
		return ('%s %s %s'):format(result[1].firstname, result[1].lastname, odznaka)
	else
		return ('%s %s %s'):format('Brak', 'Brak', '[Brak odznaki]')
	end
end