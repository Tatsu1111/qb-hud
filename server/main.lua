local esx = GetResourceState('es_extended') == 'started'
local qb = GetResourceState('qb-core') == 'started'
if esx then
    ESX = exports['es_extended']:getSharedObject()

    ESX.RegisterCommand('cash', 'user', function(xPlayer, args, showError)
        local cash = xPlayer.getAccount('money').money
        TriggerClientEvent('hud:client:ShowAccounts', xPlayer.source, 'cash', cash)
    end, true, { help = 'Check Cash Balance', validate = true, arguments = {} })

    ESX.RegisterCommand('bank', 'user', function(xPlayer, args, showError)
        local bank = xPlayer.getAccount('bank').money
        TriggerClientEvent('hud:client:ShowAccounts', xPlayer.source, 'bank', bank)
    end, true, { help = 'Check Bank Balance', validate = true, arguments = {} })
elseif qb then
    QBCore = exports['qb-core']:GetCoreObject()
    QBCore.Commands.Add('cash', 'Check Cash Balance', {}, false, function(source, args)
        local Player = QBCore.Functions.GetPlayer(source)
        local cashamount = Player.PlayerData.money.cash
        TriggerClientEvent('hud:client:ShowAccounts', source, 'cash', cashamount)
    end)

    QBCore.Commands.Add('bank', 'Check Bank Balance', {}, false, function(source, args)
        local Player = QBCore.Functions.GetPlayer(source)
        local bankamount = Player.PlayerData.money.bank
        TriggerClientEvent('hud:client:ShowAccounts', source, 'bank', bankamount)
    end)
end
