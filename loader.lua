-- MODULE LOADER.LUA
-- by Garran Plum
--
-- Setup GPS.
-- 
-- IMPORT GP OBJECT
local myMod, GP, configFile = ...

-- DECLARE: GPS Version
local version = "3.1"

-- FUNCTION: Version
-- Return GPS version number inside GP functions.
-- CLOSURE
function GP:version() return version end

-- LOGGING: GPS Running
GP.mod:log("GPS " .. GP:version() .. " by Garran Plum")
GP.mod:log("GP | " .. "https://mod.io/members/garranplum")

-- EXECUTE FILE: Global Foundation Functions
-- Defines Foundation-specific functions used by all GP mods.
GP.mod:dofile("gp/foundation.lua", GP)

-- EXECUTE FILE: Global I/O Functions
-- Defines Foundation-specific I/O functions used by all GP mods.
GP.mod:dofile("gp/io.lua", GP)

-- EXECUTE FILE: Global Utility Functions
-- Defines general Lua functions used by all GP mods.
GP:load("gp/utility.lua")

-- EXECUTE FILE: Global Magic Word Declarations & Functions
-- Declares string literals used by all GP mods.
GP:load("gp/magic.lua")

-- EXECUTE FILE: Global Datatype Declarations & Functions
-- Defines functions that return string literals for Foundation datatypes.
GP:load("gp/datatypes.lua")

-- EXECUTE FILE: Prefab Functions
-- Defines prefab registration functions used by all GP mods.
GP:load("gp/prefabs.lua")

-- EXECUTE FILE: Attach Functions
-- Defines attach point registration functions used by all GP mods.
GP:load("gp/attach.lua")

-- EXECUTE FILE: Path Functions
-- Defines path registration functions used by all GP mods.
GP:load("gp/paths.lua")

-- EXECUTE FILE: Model File Functions
-- Defines .fbx model file functions used by all GP mods.
GP:load("gp/models.lua")

-- EXECUTE FILE: Building Part Functions
-- Defines building part registration functions used by all GP mods.
GP:load("gp/parts.lua")

-- EXECUTE FILE: Building & Monument Functions
-- Defines building and monument registration functions used by all GP mods.
GP:load("gp/buildings.lua")

-- EXECUTE FILE: Custom Configuration
-- Declares custom settings for this individual mod.
GP:load("settings/" .. configFile)

-- LOGGING: Custom Config
GP:writeTable(GP:config(), "remixConfig.lua")

-- EXECUTE FILE: Job Registration Functions
-- Registers all jobs named in the config.
GP:load("gp/jobs.lua")

-- EXECUTE FILE: Resource Generator Registration Functions
-- Registers all generator functions named in the config.
GP:load("gp/generators.lua")

-- EXECUTE FILE: Workplace Registration Functions
-- Defines all workplace functions named in the config.
GP:load("gp/workplaces.lua")

-- EXECUTE FILE: Override Functions
-- Defines all override functions used by all GP mods.
GP:load("gp/overrides.lua")

-- EXECUTE FILE: Startup Sequence
-- Defines the startup sequence for this mod.
GP:load("gp/startup.lua")

-- CALL: Start your engines!
-- Calls the defined functions in sequence to start the mod.
GP:startMod()

-- EXECUTE FILE: Apply Custom Overrides, If Any
-- Applies custom overrides to any built-in or defined objects.
local overridesPath = GP:magicWords().overrides.folder .. "/" ..
                          "customOverrides.lua"
if GP.mod:fileExists(overridesPath) then 
    GP:load(overridesPath)
end

-- CALL: Log Finished Loading
GP:log("Finished Loading", GP:config().modName, GP:version())
