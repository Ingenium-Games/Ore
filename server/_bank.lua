-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.bank = {}
--[[
NOTES.
    - These Banking functions utlizie the cron resource to plan and execute events or funtions 
    - at a specific time each day, to run on a schedual.
    - 
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

-- Pulls all characters with loans and deducts money to pay the loan, can go negitive.
function c.bank.CalculatePayments()
    local xJob = c.data.GetJob("bank")
    -- To run independant of active players and debit accounts via sql.
end

TriggerEvent('Server:Cron:NewTask', conf.loanpayment.h, conf.loanpayment.m, c.bank.CalculatePayments)
--

-- Updates the characters loan to add the interest on the outstanding amount each day.
function c.bank.CalculateInterest()
    local xJob = c.data.GetJob("bank")
    -- To run independant of active players and debit accounts via sql.
end

TriggerEvent('Server:Cron:NewTask', conf.loaninterest.h, conf.loaninterest.m, c.bank.CalculateInterest)
--

--- func desc
function c.bank.CheckNegativeBalances()
    local xJob = c.data.GetJob("bank")
    local xPlayers = c.data.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = c.data.GetPlayer(i)
        if xPlayer then
            local bank = xPlayer.GetBank()
            if bank < 0 then
                TriggerClientEvent("Client:Notify", i, "Your Bank account is in negative. \nCurrent Balance is: $ "..bank..". \nOver Draw Fee Charged at: $"..conf.bankoverdraw..". \nThese fees apply every hour, on the hour, until balanced.", "error", 17500)
                xPlayer.RemoveBank(conf.bankoverdraw)
                xJob.AddBank(conf.bankoverdraw)
            end
        end
    end
    c.debug("Active clients notified of negative bank balances and Fees charged at $"..conf.bankoverdraw)
end

-- Set so the server will debit bank accounts on the hour every hour if in negative balance.
AddEventHandler("onResourceStart",function()
    for i=1, 23, 0 do
        TriggerEvent('Server:Cron:NewTask', i, 0, c.bank.CheckNegativeBalances)
    end
end)
