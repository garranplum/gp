-- MODULE LOADER.LUA
-- by Garran Plum
--
-- Setup GPS.
-- 
-- IMPORT GP OBJECT
local myMod, GP = ...

-- DECLARE: GPS Version
local version = "3.0"

-- FUNCTION: Version
-- Return GPS version number inside GP functions.
-- CLOSURE
function GP:version()
    return version
end

-- LOGGING: GPS Running
GP.mod:log("GPS " .. GP:version() .. " by Garran Plum")
GP.mod:log("GP | " .. "https://mod.io/members/garranplum")