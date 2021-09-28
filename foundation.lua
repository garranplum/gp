-- MODULE FOUNDATION.LUA
-- by Garran Plum
--
-- Foundation-specific utility functions for all GP mods.
-- 
-- FUNCTION ASSIGNMENTS
-- IMPORT GP OBJECT
local myMod, GP = ...

myMod:log("GP | " .. "foundation.lua " .. GP:version())

-- GP FOUNDATION FUNCTION Load
-- Loads and executes a Lua file from disk.
-- UKNOWN EFFECTS (FILE LOAD & EXECUTE)
function GP:load(fileName)
    myMod:dofile(fileName, GP)
end

-- GP FOUNDATION FUNCTION Log
-- Writes a concatenated series of messages to the `foundation.log` file.
-- GAME EFFECT
function GP:log(...)
    local messages = {...}
    local logMessage = ""
    for index, message in pairs(messages) do
        logMessage = logMessage .. " " .. message
    end
    myMod:log("GP |" .. logMessage)
end

-- GP FOUNDATION FUNCTION Log Table
-- Logs all the keys in incomingTable. Default label is `keys`.
-- GAME EFFECT CALL
function GP:logTable(label, incomingTable)
    if (not incomingTable) then incomingTable, label = label, "keys" end
    myMod:log(label .. ":", GP:serializeTable(incomingTable))
end

-- GP FOUNDATION FUNCTION Write
-- Writes a string to a file. Default = "GP.log".
-- I/O EFFECT
function GP:write(fileContent, fileName)

    -- Set a default fileName if one isn't provided.
    fileName = fileName or "GP.log"

    -- Setup for return status.
    local isWriteSuccessful = false

    -- Call the Foundation function to write the file and grab the return boolean.
    isWriteSuccessful = myMod:writeFileAsString(fileName, fileContent)
end

-- GP FOUNDATION FUNCTION Write Table
-- Writes a table to a file. Default = "GP {tableID}.log".
-- I/O EFFECT
function GP:writeTable(incomingTable, fileName)

    -- Set a default fileName if one isn't provided.
    fileName = fileName or "GPtable.log"

    -- Write the table serialized as a string.
    GP:write(GP:serializeTable(incomingTable), fileName)
end


