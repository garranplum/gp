-- MODULE IO.LUA
-- by Garran Plum
--
-- Foundation-specific I/O functions for all GP mods.
-- 
-- FUNCTION ASSIGNMENTS
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("io.lua", GP:version())


-- GP FOUNDATION FUNCTION Write
-- Writes a string to a file. Default = "GP.log".
-- I/O EFFECT
function GP:write(fileContent, fileName)

    -- Set a default fileName if one isn't provided.
    fileName = fileName or "GP.log"

    -- Setup for return status.
    local isWriteSuccessful = false

    -- Setup file path.
    local filePath = GP:magicWords().log.folder .. '/' .. fileName

    -- Call the Foundation function to write the file and grab the return boolean.
    isWriteSuccessful = myMod:writeFileAsString(filePath, fileContent)

    GP:log("wrote", filePath, isWriteSuccessful)
end

-- GP FOUNDATION FUNCTION Write Table
-- Writes a table to a file. Default = "GPtable.log".
-- I/O EFFECT
function GP:writeTable(incomingTable, fileName)

    -- Set a default fileName if one isn't provided.
    -- Uses GP.loaded instead of GP:config() to preclude looping if config() calls writeTable().
    fileName = fileName or GP.loaded.modName .. ".log"

     -- Setup file path.
     local filePath = GP:magicWords().log.folder .. '/' .. fileName

    -- Write the table serialized as a string.
    GP:write(GP:serializeTable(incomingTable), fileName)
end


