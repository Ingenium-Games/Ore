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

function c.bank.RunRoutines()
    c.bank.CalculateInterest()
    c.bank.CalculateRePayments()
end

function c.bank.CalculateInterest()
    local function Do()


    end
end

function c.bank.CalculateRePayments()
    local function Do()


    end
end

function c.bank.EmergancyBlackout()

end

function c.bank.TheftOrRandsom()

end