local URLS = {
    Combat = "https://raw.githubusercontent.com/GetConsist/combat/refs/heads/main/.lua",
    Visual = "https://raw.githubusercontent.com/GetConsist/visual/refs/heads/main/.lua",
    Player = "https://raw.githubusercontent.com/GetConsist/player/refs/heads/main/.lua",
    Movement = "https://raw.githubusercontent.com/GetConsist/movement/refs/heads/main/.lua",
    World = "https://raw.githubusercontent.com/GetConsist/world/refs/heads/main/.lua",
}

local function fetchAndCompile(name)
    local okFetch, source = pcall(game.HttpGet, game, URLS[name])
    if not okFetch then
        return nil, "HTTP error: " .. tostring(source)
    end

    local chunk, compileError = loadstring(source, "Consist_" .. name)
    if not chunk then
        return nil, "compile error: " .. tostring(compileError)
    end

    return chunk
end

do
    local chunk, err = fetchAndCompile("Combat")
    assert(chunk, "Failed to load Consist Combat: " .. tostring(err))

    local ok, result = pcall(chunk)
    assert(ok, "Failed to run Consist Combat: " .. tostring(result))
end

for _, name in ipairs({"Visual", "Player", "Movement", "World"}) do
    local chunk, err = fetchAndCompile(name)

    if not chunk then
        warn("[Consist] " .. name .. " failed: " .. tostring(err))
    else
        local ok, result = pcall(chunk)
        if not ok then
            warn("[Consist] " .. name .. " failed: " .. tostring(result))
        end
    end
end

local environment = type(getgenv) == "function" and getgenv() or _G
local Shared = environment.__CONSIST_SHARED

if Shared and Shared.Consist then
    Shared.Consist:SelectPage("Combat")
    return Shared.Consist
end
