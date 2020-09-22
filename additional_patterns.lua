local name, Fugg = ...;

Fugg.additional_patterns = {
    { "don't think so", "dont think so", "prolly not", "probably not" },
    { "never" },
    { "yeah", "sure", "ok", "yes", "ye", "shure", " y ", "yea", "oke" }
}

Fugg.additional_replacements = {
    {"Sure!", "I would love to!", "Ok!", "absolutely", "let's go!", "yes", "hell yeah"},
    {"I'd love nothing more"},
    {"No", "don't think so", "absolutely not", "hell no", "You must be out of your damn mind", "doubt it"}
}



