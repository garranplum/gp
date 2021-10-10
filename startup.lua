-- MODULE STARTUP.LUA
-- by Garran Plum
--
-- Load game assets and create mod buildings.
-- 
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("startup.lua")

-- FUNCTION Start Mod
-- FUNCTIONAL, GAME EFFECT CALL
function GP:startMod()

    -- Sugar for GP:config()
    local config = GP:config()

    GP:log("Starting", config.modName, GP:version(), _VERSION)
    GP:writeTable(config)

    -- STARTUP Register Model Files
    GP:registerModelFiles()

    -- STARTUP Register Jobs
    GP:registerAllJobs()

    -- STARTUP Register Workplaces
    GP:registerAllWorkplaces()

    -- STARTUP Register Monument
    GP:registerMonumentList()

end

