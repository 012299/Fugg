local name, Fugg = ...;

local link_pattern = '%[.+%]'
local _match = _G["string"]["match"]
local _upper = _G["string"]["upper"]
local _lower = _G["string"]["lower"]
local _str_find = _G["string"]["find"]
local _gsub = _G["gsub"]
local _ipairs = _G["ipairs"]
local _random = _G["math"]["random"]

local additional_patterns = Fugg.additional_patterns
local additional_replacements = Fugg.additional_replacements
local additional_len = #additional_patterns

local consume_patterns = Fugg.requested_pats
local consume_len = #consume_patterns

local patterns = {}
local patterns_len = #patterns
local replacements = {}
local sub_patterns = {}
local sub_patterns_len = #sub_patterns



function Fugg:PrepCaseInsensitivity(patterns)
    for index, pattern in _ipairs(patterns) do
        patterns[index], _ = _gsub(pattern, '(%l)', function(v) return '[' .. strupper(v) .. strlower(v) .. ']' end)
    end
end

local function TranslateMessageSub(chatMessage)
    for index = 1, patterns_len do
        local pattern = patterns[index]
        chatMessage, _ = _gsub(chatMessage, pattern, replacements[index])
    end
    return chatMessage
end


local function TranslateMessageSubTable(chatMessage)
    -- replace matching patterns with a placeholder to avoid modifying modified items
    for index = 1, patterns_len do
        local pattern = patterns[index]
        chatMessage, _ = _gsub(chatMessage, pattern, sub_patterns[index])
    end
    -- replace placeholders with the final value
    for index = 1, sub_patterns_len do
        local pattern = sub_patterns[index]
        local sub_table = replacements[index]
        local repl = sub_table[_random(#sub_table)]
        chatMessage, _ = _gsub(chatMessage, pattern, repl)
    end
    return chatMessage
end

local _TranslateMessageSub = TranslateMessageSub

function Fugg:update_patterns()
    if Fugg.MODE == "fugg" then
        patterns = Fugg.fugg_patterns
        replacements = Fugg.fugg_replacements
        sub_patterns = {}
        _TranslateMessageSub = TranslateMessageSub
    else
        patterns = Fugg.dolan_patterns
        replacements = Fugg.dolan_replacements
        sub_patterns = Fugg.dolan_sub_patterns
        _TranslateMessageSub = TranslateMessageSubTable
    end
    patterns_len = #patterns
    sub_patterns_len = #sub_patterns
end

function Fugg:Consume(msg)
    if _random(100) <= 4 then
        local msg_table = consume_patterns[_random(consume_len)]
        local amount = msg_table[1]
        return true, msg_table, amount
    else
        return false, msg, nil
    end
end

function Fugg:RollDice(msg)
    for index = 1, additional_len do
        local patterns = additional_patterns[index]
        for i = 1, #patterns do
            local pattern = patterns[i]
            if _str_find(_lower(msg), pattern) then
                if _random(100) <= 9 then
                    local replacements = additional_replacements[index]
                    return true, replacements[_random(#replacements)]
                else
                    return false, msg
                end
            end
        end
    end
    return false, msg
end



function Fugg:TranslateMessage(chatMessage)
    if _match(chatMessage, link_pattern) then
        return chatMessage
    end
    local chatMessage = chatMessage
    local isUpper = _upper(chatMessage) == chatMessage

    chatMessage = _TranslateMessageSub(chatMessage)
    if isUpper then
        chatMessage = _upper(chatMessage)
    end
    return chatMessage
end