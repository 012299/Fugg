local name, Fugg = ...;

local MSG_LIMIT = 255
local _len = _G['string']['len']
local _sub = _G['string']['sub']
local _C_TimerAfter = _G["C_Timer"]["After"]

local MasterSendChatmessage = SendChatMessage
local MasterBNSendWhisper = BNSendWhisper
local _SendChatMessage = SendChatMessage
local _BNSendWhisper = BNSendWhisper



Fugg.MODE = "fugg"
Fugg.ADDITIONAL = true
Fugg.ENABLED_CHAT = true
Fugg.ENABLED_BN = true



local function WrapperSendChatmessage(msg, chatType, language, channel, ...)
    local success, msg = Fugg:RollDice(msg)
    if success then
        return MasterSendChatmessage(msg, chatType, language, channel, ...)
    else
        local success, msg, amount = Fugg:Consume(msg)
        if success then
            for line = 2, amount do
                _C_TimerAfter(line/7, function() MasterSendChatmessage(msg[line], chatType, language, channel) end)
            end
        else
            return _SendChatMessage(msg, chatType, language, channel, ...)
        end
    end
end

local function WrapperBNSendWhisper(presenceID, messageText, ...)
    local success, msg = Fugg:RollDice(messageText)
    if success then
        return MasterBNSendWhisper(presenceID, msg, ...)
    else
        local success, msg, amount = Fugg:Consume(msg)
        if success then
            for line = 2, amount do
                _C_TimerAfter(line/7, function() MasterBNSendWhisper(presenceID, msg[line]) end)
            end
        else
            return _BNSendWhisper(presenceID, msg, ...)
        end
    end
end



local function __SendChatMessage(msg, chatType, language, channel, ...)
    local trans = Fugg:TranslateMessage(msg)
    if _len(trans) > MSG_LIMIT then
        trans = _sub(trans, 1, MSG_LIMIT)
    end
    return MasterSendChatmessage(trans, chatType, language, channel, ...)
end

local function __BNSendWhisper(presenceID, messageText, ...)
    local trans = Fugg:TranslateMessage(messageText)
    return MasterBNSendWhisper(presenceID, trans, ...)
end

local function ToggleAdditional(cmd)
    if cmd == "additionaltoggle" then
        Fugg.ADDITIONAL = not Fugg.ADDITIONAL
        print('secret')
        print(Fugg.ADDITIONAL)
    end
    if Fugg.ADDITIONAL then
        SendChatMessage = WrapperSendChatmessage
        BNSendWhisper = WrapperBNSendWhisper
    else
        SendChatMessage = _SendChatMessage
        BNSendWhisper = _BNSendWhisper
    end
end

local function ToggleFugg(cmd)
    local enabled = cmd == "on" and true or false
    Fugg.ENABLED_CHAT = enabled
    Fugg.ENABLED_BN = enabled

    if Fugg.ENABLED_CHAT then
        _SendChatMessage = __SendChatMessage
        _BNSendWhisper = __BNSendWhisper
        print('Fugg enabled')
    else
        _SendChatMessage = MasterSendChatmessage
        _BNSendWhisper = MasterBNSendWhisper
        print('Fugg disabled')
    end
    ToggleAdditional(".")
end



local function ToggleSpecific(cmd)
    if cmd == 'chat' then
        local enabled_chat = not Fugg.ENABLED_CHAT
        Fugg.ENABLED_CHAT = enabled_chat
        if enabled_chat then
            _SendChatMessage = __SendChatMessage
            print('Fugg chat enabled')
        else
            _SendChatMessage = MasterSendChatmessage
            print('Fugg chat disabled')
        end
    else
        local enabled_chat = not Fugg.ENABLED_BN
        Fugg.ENABLED_BN = not enabled_chat
        if enabled_chat then
            _BNSendWhisper = __BNSendWhisper
            print('Fugg BN enabled')
        else
            _BNSendWhisper = MasterBNSendWhisper
            print('Fugg BN disabled')
        end
    end
end

local function ToggleDolan(cmd)
    Fugg.MODE = Fugg.MODE == "fugg" and "dolan" or "fugg"
    print("Using " .. Fugg.MODE .. "dialect")
    Fugg:update_patterns()
end

local FuggCmdMapping = {
    ['off'] = ToggleFugg,
    ['on'] = ToggleFugg,
    ['chat'] = ToggleSpecific,
    ['bn'] = ToggleSpecific,
    ['dolan'] = ToggleDolan,
    ['additionaltoggle'] = ToggleAdditional
}

SLASH_FUGG1 = '/fugg'

function SlashCmdList.FUGG(msg, ...)
    local caller = FuggCmdMapping[msg]
    if caller then
        caller(msg)
    else
        print('Fugg wrong command :DD')
        print('\'/fugg off\' to disable fugg')
        print('\'/fugg on\' to enable fugg')
        print('\'/fugg chat\' to toggle regular chatchannel functionality')
        print('\'/fugg bn\' to toggle Battle.net whisper functionality')
        print('\'/fugg dolan \' to toggle dolan translation')
    end
end

local function LoadFugg(frame, event, ...)
    SendChatMessage = WrapperSendChatmessage
    BNSendWhisper = WrapperBNSendWhisper
    ToggleFugg("on")
    Fugg:PrepCaseInsensitivity(Fugg.fugg_patterns)
    Fugg:PrepCaseInsensitivity(Fugg.dolan_patterns)
    Fugg:update_patterns()
    Fugg:init_sub_patterns()
    ToggleDolan()
end

local frame = CreateFrame("FRAME", "FuggFrame")
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript("OnEvent", LoadFugg)
