-- server/main.lua
local currentPrice = 15
local lastPrice = 15
local priceUpdateInterval = 300 -- 5 phút

QBCore = exports['qb-core']:GetCoreObject()

-- Hệ thống biến động giá
CreateThread(function()
    while true do
        Wait(priceUpdateInterval * 1000)
        lastPrice = currentPrice
        currentPrice = math.random(5, 25)
        TriggerClientEvent('qb-woodmarket:updatePrice', -1, currentPrice, lastPrice)
    end
end)

-- Lấy thông tin giá
QBCore.Functions.CreateCallback('qb-woodmarket:getPrice', function(source, cb)
    cb({current = currentPrice, last = lastPrice})
end)

-- Bán gỗ
RegisterNetEvent('qb-woodmarket:sellWood', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local woodItem = Player.Functions.GetItemByName('wood')
    
    if not woodItem or woodItem.amount < amount then
        TriggerClientEvent('QBCore:Notify', src, 'Không đủ gỗ!', 'error')
        return
    end
    
    Player.Functions.RemoveItem('wood', amount)
    local total = amount * currentPrice
    Player.Functions.AddMoney('cash', total)
    TriggerClientEvent('QBCore:Notify', src, 'Đã bán '..amount..' gỗ được $'..total, 'success')
end)
