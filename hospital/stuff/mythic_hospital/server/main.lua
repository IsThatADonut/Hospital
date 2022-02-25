local beds = {
    { x = 359.54, y = -586.23, z = 42.84, h = 250.00, taken = false, model = 1631638868 },
	{ x = 366.52, y = -581.66, z = 42.85, h = 250.00, taken = false, model = 1631638868 },
	{ x = 364.96, y = -585.94, z = 42.85, h = 250.00, taken = false, model = 1631638868 },
	{ x = 363.80, y = -589.12, z = 42.85, h = 250.00, taken = false, model = 1631638868 },
	{ x = 324.26, y = -582.80, z = 42.84, h = 340.00, taken = false, model = 1631638868 },
	{ x = 319.41, y = -581.04, z = 42.84, h = 340.00, taken = false, model = 1631638868 },

}

local bedsTaken = {}
local injuryBasePrice = 100
ESX             = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('playerDropped', function()
    if bedsTaken[source] ~= nil then
        beds[bedsTaken[source]].taken = false
    end
end)

AddEventHandler('playerDropped', function()
    if bedsTaken[source] ~= nil then
        beds[bedsTaken[source]].taken = false
    end
end)

RegisterServerEvent('mythic_hospital:server:RequestBed')
AddEventHandler('mythic_hospital:server:RequestBed', function()
    for k, v in pairs(beds) do
        if not v.taken then
            v.taken = true
            bedsTaken[source] = k
            TriggerClientEvent('mythic_hospital:client:SendToBed', source, k, v)
            return
        end
    end

    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'No beds available.' })
end)

RegisterServerEvent('mythic_hospital:server:RPRequestBed')
AddEventHandler('mythic_hospital:server:RPRequestBed', function(plyCoords)
    local foundbed = false
    for k, v in pairs(beds) do
        local distance = #(vector3(v.x, v.y, v.z) - plyCoords)
        if distance < 3.0 then
            if not v.taken then
                v.taken = true
                foundbed = true
                TriggerClientEvent('mythic_hospital:client:RPSendToBed', source, k, v)
                return
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'This bed is occupied' })
            end
        end
    end

    if not foundbed then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You are not near a hospital bed.' })
    end
end)

RegisterServerEvent('mythic_hospital:server:EnteredBed')
AddEventHandler('mythic_hospital:server:EnteredBed', function()
    local src = source
    local injuries = GetCharsInjuries(src)

    local totalBill = injuryBasePrice

    if injuries ~= nil then
        for k, v in pairs(injuries.limbs) do
            if v.isDamaged then
                totalBill = totalBill + (injuryBasePrice * v.severity)
            end
        end

        if injuries.isBleeding > 0 then
            totalBill = totalBill + (injuryBasePrice * injuries.isBleeding)
        end
    end

    -- YOU NEED TO IMPLEMENT YOUR FRAMEWORKS BILLING HERE
	local xPlayer = ESX.GetPlayerFromId(src)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You have been billed' .. totalBill ..'.' })
    TriggerClientEvent('mythic_hospital:client:FinishServices', src)
end)

RegisterServerEvent('mythic_hospital:server:LeaveBed')
AddEventHandler('mythic_hospital:server:LeaveBed', function(id)
    beds[id].taken = false
end)
