-- MODULE STARTUP.LUA
-- by Garran Plum
--
-- Load game assets and create mod buildings.
-- 
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("startup.lua", GP:version())

-- FUNCTION Start Mod
-- FUNCTIONAL, GAME EFFECT CALL
function GP:startMod()

    -- Sugar for GP:config()
    local config = GP:config()

    -- LOGGING: Custom Config
    GP:writeTable(config, "remixConfig.lua")

    GP:log("Starting", config.modName, GP:version(), _VERSION)

    -- Log remixed config for diagnostics and development.
    GP:writeTable(config, "remixConfig.log")

    -- STARTUP Register Model Files
    GP:registerModelFiles()

    -- STARTUP Register Jobs
    GP:registerAllJobs()

    -- STARTUP Register Workplaces
    GP:registerAllWorkplaces()

    -- STARTUP Register Monument
    GP:registerMonumentList()

    for key, value in pairs(_G) do
        if GP:isTable(value) and not key == "_G" then
            GP:writeTable(value, key .. ".log")
        end
    end

end

