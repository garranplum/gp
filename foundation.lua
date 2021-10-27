-- MODULE FOUNDATION.LUA
-- by Garran Plum
--
-- Foundation-specific utility functions for all GP mods.
-- 
-- FUNCTION ASSIGNMENTS
-- IMPORT GP OBJECT
local myMod, GP = ...

-- GP FOUNDATION FUNCTION Load
-- Loads and executes a Lua file from disk.
-- UNKNOWN EFFECTS (FILE LOAD & EXECUTE)
function GP:load(fileName) myMod:dofile(fileName, GP) end

-- GP FOUNDATION FUNCTION Mod Version
-- Gets the mod's version number.
function GP:modVersion() return foundation.getModVersion(GP:magicWords().mod.id) end

-- GP FOUNDATION FUNCTION Game Version
-- Gets the Foundation version number.
function GP:gameVersion() return foundation.getGameVersion() end

-- GP FOUNDATION FUNCTION Game Minimum Version
-- Returns true if the game is at least the supplied version.
function GP:gameMinimumVersion(minVersion)
    return version.cmp(GP:gameVersion(), minVersion) >= 0
end

-- GP FUNCTION Lua Version
function GP:luaVersion() return _VERSION end

-- GP FOUNDATION FUNCTION Alert
-- Writes a concatenated series of messages to an alert dialog.
-- GAME EFFECT
function GP:alert(...)
    local messages = {...}
    local logMessage = ""
    for index, message in pairs(messages) do
        logMessage = logMessage .. " " .. tostring(message)
    end
    myMod:msgBox("GP |" .. logMessage)
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
    local regFile = regId or "unknown-reg"

    -- Log it.
    GP:writeTable(registrationTable, regFile)

    -- Do the registration.
    myMod:registerAsset(registrationTable)

end

-- GP FOUNDATION FUNCTION Register Class
-- Log and call a custom class registration.
-- GAME EFFECT
function GP:registerClass(registrationTable)

    -- Extract the new TypeName being registered.
    local regId = registrationTable.TypeName

    -- Create a filename.
    local regFile = regId or "unknown-class"

    -- Log into CLASS folder.
    regFile = GP:magicWords().log.class .. "/" .. regFile

    -- Log it.
    GP:writeTable(registrationTable, regFile)

    -- Do the registration.
    myMod:registerClass(registrationTable)

end

-- GP FOUNDATION FUNCTION Register Asset
-- Log and register an asset from a file path.
-- GAME EFFECT
function GP:registerAssetId(path, regId, assetType)

    -- Create a filename.
    local regFile = regId or "unknown-asset"

    -- Log into ASSET folder.
    regFile = GP:magicWords().log.asset .. "/" .. regFile

    -- Create a fake table for logging.
    local registrationTable = {}

    registrationTable[regId] = {Path = path, Type = assetType}

    -- Log it.
    GP:writeTable(registrationTable, regFile)

    -- Do the registration.
    myMod:registerAssetId(path, regId, assetType)
end

-- GP FOUNDATION FUNCTION Register Prefab Component
-- Log and register a prefab component's properties (like worker paths) from a file path.
-- GAME EFFECT
function GP:registerPrefabComponent(path, regId, registrationTable)

    -- Create a filename.
    local regFile = regId or "unknown-prefab"

    -- Log it.
    GP:writeTable(registrationTable, regFile)

    -- Do the registration.
    myMod:registerPrefabComponent(path, registrationTable)
end
