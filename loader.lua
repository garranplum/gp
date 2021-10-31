-- MODULE LOADER.LUA
-- by Garran Plum
--
-- Setup GPS.
-- 
-- IMPORT GP OBJECT
local myMod, GP, configFile = ...

-- DECLARE: GPS Version
local version = "3.3.0"

-- FUNCTION: Version
-- Return GPS version number inside GP functions.
-- CLOSURE
function GP:gpsVersion() return version end

-- GP FOUNDATION FUNCTION Log
-- Writes a concatenated series of messages to the `foundation.log` file.
-- GAME EFFECT
function GP:log(...)
    local messages = {...}
    local logMessage = ""
    for index, message in pairs(messages) do
        logMessage = logMessage .. " " .. tostring(message)
    end
    GP.mod:log("GP |" .. logMessage)
end

-- LOGGING: GPS Running
GP:log("GPS", GP:gpsVersion(), "by Garran Plum",
       "https://mod.io/members/garranplum")

-- EXECUTE FILE: Global Foundation Functions
-- Defines Foundation-specific functions used by all GP mods.
GP.mod:dofile("gp/foundation.lua", GP)

-- LOGGING: Environment Versions
GP:log("Foundation", GP:gameVersion(), GP:luaVersion())

-- EXECUTE FILE: Global I/O Functions
-- Defines Foundation-specific I/O functions used by all GP mods.
GP.mod:dofile("gp/io.lua", GP)

-- EXECUTE FILE: Global Utility Functions
-- Defines general Lua functions used by all GP mods.
GP:load("gp/utility.lua")

-- EXECUTE FILE: Global Magic Word Declarations & Functions
-- Declares string literals used by all GP mods.
GP:load("gp/magic.lua")

-- CLOSURE: Turn config file closure into config table closure.
local configPath = GP:magicWords().config.folder .. "/" .. configFile
local config = GP:load(configPath)

-- GP Function Config
-- Returns a copy of the remixed, canonized configuration.
-- CLOSURE, IDEMPOTENT
function GP:config()

    -- Sugar for config.modName
    local modName = config.modName

    -- Remix each category on the list.
    for category, partsList in pairs(config.remix) do

        -- Add the category in config.categories.
        config.categories[category] = config.categories[category] or {}

        -- Remix each part in the category.
        for index, partId in ipairs(partsList) do

            -- Build a partEntry
            local partEntry = config.categories[category][partId] or {}

            -- Remixed parts are asset registered and building registered by default.
            partEntry.AssetRegistered = partEntry.AssetRegistered or true
            partEntry.BuildingRegistered = partEntry.BuildingRegistered or true

            -- Add the partEntry to the config category
            config.categories[category][partId] = partEntry

        end
    end

    -- Determine number of categories and parts in remix.
    local categoryCount = GP:tableLength(config.categories)
    local firstCategoryKey = next(config.categories)
    local partsCount = GP:tableLength(config.categories[firstCategoryKey])
    local firstPart = config.categories[firstCategoryKey]

    -- If more than one category or part, create a monument.
    if categoryCount > 1 or partsCount > 1 then
        if not next(config.monuments) then
            config.monuments[modName] = config.monuments[modName] or {
                Categories = {},
                Logo = config.logo or
                    config.categories[firstCategoryKey][firstPart]
            }
        end
    end

    -- If only one part and category, create a default building.
    if categoryCount == 1 and partsCount == 1 then
        config.buildings[modName] = config.buildings[modName] or
                                        config.categories[firstCategoryKey][firstPart]
    end

    -- Add parts to building or monument for each category on the list.
    for category, partsList in pairs(config.remix) do
        -- Using a monument?
        if config.monuments[modName] then
            -- Add the category to the monument if not already in config.
            if not (config.monuments[modName].Categories[category]) then
                config.monuments[modName].Categories[category] = {}
            end
        end
    end

    -- Return canonized copy.
    return GP:copyTable(config)
end

-- IMPERATIVE: Load Config
GP:config();

-- LOGGING: GPS Configured
GP:log("Configured", GP:config().modName, GP:modVersion())

local loadList = {
    "datatypes", "prefabs", "attach", "paths", "models", "parts", "buildings",
    "jobs", "generators", "workplaces", "overrides", "startup", "dependency"
}

local loaderFunction =
    function(fileName) GP:load("gp/" .. fileName .. ".lua") end

GP:mapArray(loadList, loaderFunction)

-- CALL: Start your engines!
-- Calls the defined functions in sequence to start the mod.
GP:startMod()

-- EXECUTE FILE: Apply Custom Overrides, If Any
-- Applies custom overrides to any built-in or defined objects.
local overridesPath = GP:magicWords().overrides.folder .. "/" ..
                          "customOverrides.lua"
if GP.mod:fileExists(overridesPath) then GP:load(overridesPath) end

-- CALL: Log Finished Loading
GP:log("Loaded", GP:config().modName)
