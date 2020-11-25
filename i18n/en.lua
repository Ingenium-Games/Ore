--====================================================================================--
--  MIT License 2020 : Twiitchter
--====================================================================================--
i18n = {}
--
if type(i18n) ~= 'table' then
    i18n = {}
end
--
i18n['en'] = {
    --[[Key/Value]]--
    -- Generic
    ['missing_locale'] = 'i18n Missing.',
    ['not_boolean'] = 'Variable is not a boolean.',
    ['not_string'] = 'Variable is not a string.',
    ['not_number'] = 'Variable is not a number.',
    ['not_float'] = 'Variable is not a float.',
    ['not_table'] = 'Variable is not a table.',
    ['not_multi'] = 'Variables are multiple and one or more is an issue.',
    -- 
    ['switch_case'] = 'Error occoured in switch statement, this is the default funciton.',
    ['cash_less_zero'] = 'Error occoured in cash function inside PlayerClass, player would be minus cash/an item.',
    --
    ['server_onResourceStart'] = 'Starting Core Framework',
    ['server_disconnection_saved'] = 'User Dissconected . Cleaning tables.',
}