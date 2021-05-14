-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--

-- Triggered after character has been loaded from db and informaiton is passed to client
RegisterNetEvent("Server:Character:Loaded")
AddEventHandler("Server:Character:Loaded", function(data)
    local src = source
    -- Set to default instance
    c.inst.SetPlayerDefault(src)

end)

-- Triggered by the client after it has recieved its character data.
RegisterNetEvent("Server:Character:Ready")
AddEventHandler("Server:Character:Ready", function(data)
    local src = source

end)

RegisterNetEvent('Server:Instance:Player:Default')
AddEventHandler('Server:Instance:Player:Default', function(data)
    local src = source
    -- Set to default instance
    c.inst.SetPlayerDefault(src)

end)

RegisterNetEvent("Server:Character:Death")
AddEventHandler("Server:Character:Death", function(data)
    local src = source
    if (data.PlayerKill == true) then

    else

    end
end)

-- ====================================================================================--

RegisterNetEvent('Server:Packet:Update')
AddEventHandler('Server:Packet:Update', function(data)
    local src = source
    local xPlayer = c.data.GetPlayer(src)
    -- Status
    xPlayer.SetHealth(data.Health)
    xPlayer.SetArmour(data.Armour)
    xPlayer.SetHunger(data.Hunger)
    xPlayer.SetThirst(data.Thirst)
    xPlayer.SetStress(data.Stress)
    -- Coords
    xPlayer.SetCoords(data.Coords)

end)

-- ====================================================================================--

RegisterNetEvent("Server:Bank:Deposit")
AddEventHandler("Server:Bank:Deposit", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.RemoveMoney(amount)
    xPlayer.AddBank(amount)
end)

RegisterNetEvent("Server:Bank:Withdraw")
AddEventHandler("Server:Bank:Withdraw", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.RemoveBank(amount)
    xPlayer.AddMoney(amount)
end)

RegisterNetEvent("Server:Bank:Transfer")
AddEventHandler("Server:Bank:Transfer", function(data, req, id)
    local src = req or source
    local too = id
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    local tPlayer = c.data.GetPlayer(too)
    --
    xPlayer.RemoveBank(amount)
    tPlayer.AddBank(amount)
end)

RegisterNetEvent("Server:Bank:Bill")
AddEventHandler("Server:Bank:Bill", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.RemoveBank(amount)
end)

RegisterNetEvent("Server:Bank:Loan")
AddEventHandler("Server:Bank:Loan", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.AddBank(amount)
end)
