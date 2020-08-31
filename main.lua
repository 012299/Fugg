local name, Fugg = ...;

local MSG_LIMIT = 255
local _len = _G['string']['len']
local _sub = _G['string']['sub']
local _SendChatMessage = SendChatMessage
local _BNSendWhisper = BNSendWhisper

Fugg.MODE = "fugg"

local function __SendChatMessage(msg, chatType, language, channel, ...)
    local trans = Fugg:TranslateMessage(msg)
    if _len(trans) > MSG_LIMIT then
        trans = _sub(trans, 1, MSG_LIMIT)
    end
    return _SendChatMessage(trans, chatType, language, channel, ...)
end

local function __BNSendWhisper(presenceID, messageText, ...)
    local trans = Fugg:TranslateMessage(messageText)
    return _BNSendWhisper(presenceID, trans, ...)
end

local function ToggleFugg(cmd)

    if cmd == 'off' then
        SendChatMessage = _SendChatMessage
        BNSendWhisper = _BNSendWhisper
        print('Fugg disabled')
    else
        SendChatMessage = __SendChatMessage
        BNSendWhisper = __BNSendWhisper
        print('Fugg enabled')
    end
end

local function ToggleSpecific(cmd)
    if cmd == 'chat' then
        if SendChatMessage == _SendChatMessage then
            SendChatMessage = __SendChatMessage
            print('Fugg chat enabled')
        else
            SendChatMessage = _SendChatMessage
            print('Fugg chat disabled')
        end
    else
        if BNSendWhisper == _BNSendWhisper then
            BNSendWhisper = __BNSendWhisper
            print('Fugg BN enabled')
        else
            BNSendWhisper = _BNSendWhisper
            print('Fugg BN disabled')
        end
    end
end

local function ToggleDolan(cmd)
    Fugg.MODE = Fugg.MODE == "fugg" and "dolan" or "fugg"
    Fugg:update_patterns()
    print(Fugg.MODE)
end

local fuggMapping = {
    ['off'] = ToggleFugg,
    ['on'] = ToggleFugg,
    ['chat'] = ToggleSpecific,
    ['bn'] = ToggleSpecific,
    ['dolan'] = ToggleDolan
}

SLASH_FUGG1 = '/fugg'

function SlashCmdList.FUGG(msg, ...)
    local caller = fuggMapping[msg]
    if caller then
        caller(msg)
    else
        print('Fugg wrong command :DD')
        print('\'/fugg off\' to disable fugg')
        print('\'/fugg on\' to enable fugg')
        print('\'/fugg chat\' to toggle regular chatchannel functionality')
        print('\'/fugg bn\' to toggle Battle.net whisper functionality')
        print('\'/dolan \' to swap to dolan functionality')
    end
end

local function LoadFugg(frame, event, ...)
    SendChatMessage = __SendChatMessage
    BNSendWhisper = __BNSendWhisper
    Fugg:PrepCaseInsensitivity(Fugg.fugg_patterns)
    Fugg:PrepCaseInsensitivity(Fugg.dolan_patterns)
    Fugg:update_patterns()
    Fugg:init_sub_patterns()
end

local frame = CreateFrame("FRAME", "FuggFrame")
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript("OnEvent", LoadFugg)
