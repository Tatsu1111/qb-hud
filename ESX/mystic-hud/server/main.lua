local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterCommand('cash', 'user', function(xPlayer, args, showError)
    local cash = xPlayer.getAccount('money').money
    TriggerClientEvent('hud:client:ShowAccounts', xPlayer.source, 'cash', cash)
end, true, {help = 'Check Cash Balance', validate = true, arguments = {}})

ESX.RegisterCommand('bank', 'user', function(xPlayer, args, showError)
    local bank = xPlayer.getAccount('bank').money
    TriggerClientEvent('hud:client:ShowAccounts', xPlayer.source, 'bank', bank)
end, true, {help = 'Check Bank Balance', validate = true, arguments = {}})
