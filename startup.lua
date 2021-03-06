-- MODULE STARTUP.LUA
-- by Garran Plum
--
-- Load game assets and create mod buildings.
-- 
-- IMPORT GP OBJECT
local myMod, GP = ...

-- FUNCTION Start Mod
-- FUNCTIONAL, GAME EFFECT CALL
function GP:startMod()

    -- Sugar for GP:config()
    local config = GP:config()

    -- LOGGING Erase Log Folder
    myMod:deleteDirectory(GP:magicWords().log.folder)

    -- LOGGING Log Remix Config
    GP:writeTable(config, GP:magicWords().log.gps .. "/" .. GP:config().modName)

    -- STARTUP Register Model Files
    GP:registerModelFiles()

    -- STARTUP Register Jobs
    GP:registerAllJobs()

    -- STARTUP Register Generators
    GP:registerAllGenerators()

    -- STARTUP Register Workplaces
    GP:registerAllWorkplaces()

    -- STARTUP Register Monument
    GP:registerMonumentList()

end

