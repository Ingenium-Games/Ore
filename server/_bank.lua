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
    
    
end

TriggerEvent('Server:Cron:NewTask', conf.loanpayment.h, conf.loanpayment.m, c.bank.CalculatePayments)
--

-- Updates the characters loan to add the interest on the outstanding amount each day.
function c.bank.CalculateInterest()


end

TriggerEvent('Server:Cron:NewTask', conf.loaninterest.h, conf.loaninterest.m, c.bank.CalculateInterest)
--




function c.bank.EmergancyBlackout()

end


function c.bank.TheftOrRandsom()

end