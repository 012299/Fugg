local name, Fugg = ...;

local link_pattern = '%[.+%]'
local _match = _G["string"]["match"]
local _upper = _G["string"]["upper"]
local _gsub = _G["gsub"]
local _ipairs = _G["ipairs"]
local _random = _G["math"]["random"]

local patterns = {}
local replacements = {}

function Fugg:PrepCaseInsensitivity(patterns)
    for index, pattern in _ipairs(patterns) do
        patterns[index], _ = _gsub(pattern, '(%l)', function(v) return '[' .. strupper(v) .. strlower(v) .. ']' end)
    end
end

local function TranslateMessageSub(chatMessage)
    for index, pattern in _ipairs(patterns) do
        chatMessage, _ = _gsub(chatMessage, pattern, replacements[index])
    end
    return chatMessage
end

local function TranslateMessageSubTable(chatMessage)
    for index, pattern in _ipairs(patterns) do
        local sub_table = replacements[index]
        chatMessage, _ = _gsub(chatMessage, pattern, sub_table[_random(#sub_table)])
    end
    return chatMessage
end
local _TranslateMessageSub = TranslateMessageSub

function Fugg:update_patterns()
    if Fugg.MODE == "fugg" then
        patterns = Fugg.fugg_patterns
        replacements = Fugg.fugg_replacements
        _TranslateMessageSub = TranslateMessageSub
    else
        patterns = Fugg.dolan_patterns
        replacements = Fugg.dolan_replacements
        _TranslateMessageSub = TranslateMessageSubTable
    end
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