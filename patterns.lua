local name, Fugg = ...;
local patterns = {
    "epic",
    "america",
    "right",
    "your",
    "have",
    "god",
    "age",
    "%. ",
    "%.$",
    "%.([^0-9 ])",
    "'",
    ",",
    "wh",
    "th",
    "af",
    "ap",
    "ca",
    "ck",
    "co",
    "ev",
    "ex",
    "et",
    "iv",
    "it",
    "ke",
    "nt",
    "op",
    "ot",
    "po",
    "pe",
    "pi",
    "up",
    "va",
    "ck",
    "cr",
    "kn",
    "lt",
    "mm",
    "nt",
    "pr",
    "ts",
    "tr",
    "bs",
    "ds",
    "es",
    "fs",
    "gs",
    " is ",
    "as",
    "ls",
    "ms",
    "ns",
    "rs",
    "ss",
    "ts",
    "us",
    "ws",
    "ys",
    "alk",
    "ing",
    "ic",
    "ng",
}

local replacements = {
    "ebin",
    "clapistan",
    "rite",
    "ur",
    "hab",
    "dog",
    "aeg",
    " :DD ",
    " :DD",
    " :DD %1",
    "",
    " Xdd",
    "w",
    "d",
    "ab",
    "ab",
    "ga",
    "gg",
    "go",
    "eb",
    "egz",
    "ed",
    "ib",
    "id",
    "ge",
    "nd",
    "ob",
    "od",
    "bo",
    "be",
    "bi",
    "ub",
    "ba",
    "gg",
    "gr",
    "gn",
    "ld",
    "m",
    "dn",
    "br",
    "dz",
    "dr",
    "bz",
    "dz",
    "es",
    "fz",
    "gz",
    " iz ",
    "az",
    "lz",
    "mz",
    "nz",
    "rz",
    "sz",
    "tz",
    "uz",
    "wz",
    "yz",
    "olk",
    "ign",
    "ig",
    "nk"
}


local link_pattern = '%[.+%]'
local _match = _G["string"]["match"]
local _upper = _G["string"]["upper"]
local _gsub = _G["gsub"]
local _ipairs = _G["ipairs"]


function Fugg:PrepCaseInsensitivity()
    for index, pattern in _ipairs(patterns) do
        patterns[index], _ = _gsub(pattern, '(%l)', function(v) return '[' .. strupper(v) .. strlower(v) .. ']' end)
    end
end

function Fugg:TranslateMessage(chatMessage)
    if _match(chatMessage, link_pattern) then
        return chatMessage
    end
    local chatMessage = chatMessage
    local isUpper = _upper(chatMessage) == chatMessage

    for index, pattern in _ipairs(patterns) do
        chatMessage, _ = _gsub(chatMessage, pattern, replacements[index])
    end
    if isUpper then
        chatMessage = _upper(chatMessage)
    end
    return chatMessage
end