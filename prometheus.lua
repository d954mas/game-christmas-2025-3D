return {
    -- The default LuaVersion is Lua51
    LuaVersion = "Lua51"; -- or "LuaU"
    -- All Variables will start with this prefix
    VarNamePrefix = "";
    -- Name Generator for Variables that look like this: b, a, c, D, t, G
    NameGenerator = "MangledShuffled";
    PrettyPrint = true;
    -- Seed is generated based on current time
    -- When specifying a seed that is not 0, you will get the same output every time
    Seed = 1050;
    -- Obfuscation steps
    Steps = {}
}