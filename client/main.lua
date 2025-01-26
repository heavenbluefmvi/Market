-- client/main.lua
local isMarketOpen = false

-- Mở UI
function OpenWoodMarket()
    QBCore.Functions.TriggerCallback('qb-woodmarket:getPrice', function(priceData)
        SendNUIMessage({
            action = 'open',
            currentPrice = priceData.current,
            lastPrice = priceData.last
        })
        SetNuiFocus(true, true)
        isMarketOpen = true
    end)
end

-- Đóng UI
RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    isMarketOpen = false
    cb('ok')
end)

-- Xử lý bán hàng
RegisterNUICallback('sell', function(data, cb)
    local amount = tonumber(data.amount)
    if amount and amount > 0 then
        TriggerServerEvent('qb-woodmarket:sellWood', amount)
    end
    cb('ok')
end)

-- Cập nhật giá realtime
RegisterNetEvent('qb-woodmarket:updatePrice', function(current, last)
    if isMarketOpen then
        SendNUIMessage({
            action = 'updatePrice',
            currentPrice = current,
            lastPrice = last
        })
    end
end)

-- Tạo điểm bán hàng
CreateThread(function()
    local blip = AddBlipForCoord(1201.35, -1313.51, 35.23)
    SetBlipSprite(blip, 52)
    SetBlipColour(blip, 2)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Chợ Gỗ")
    EndTextCommandSetBlipName(blip)

    exports['qb-target']:AddBoxZone("wood_market", vector3(1201.35, -1313.51, 35.23), 1.5, 1.5, {
        name = "wood_market",
        heading = 0,
        debugPoly = false,
        minZ = 34.23,
        maxZ = 36.23
    }, {
        options = {
            {
                type = "client",
                action = function() OpenWoodMarket() end,
                icon = "fas fa-tree",
                label = "Mở Chợ Gỗ"
            }
        },
        distance = 2.5
    })
end)
