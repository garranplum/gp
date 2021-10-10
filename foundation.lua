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
        logMessage = logMessage .. " " .. tostring(message)
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

-- GP FOUNDATION FUNCTION Register
-- Log and call a generic game component registration.
-- GAME EFFECT
function GP:register(registrationTable)

    -- Extract the ID being registered.
    local regId = registrationTable.Id

    -- Create a filename.
    local regFile = regId .. ".log"

    -- Log it.
    GP:writeTable(registrationTable, regFile)

    -- Do the registration.
    myMod:register(registrationTable)

end

-- GP FOUNDATION FUNCTION Register Asset
-- Log and register an asset from a file path.
-- GAME EFFECT
function GP:registerAsset(path, regId, assetType)

    -- Do the registration.
    myMod:registerAssetId(path, regId, assetType)

end