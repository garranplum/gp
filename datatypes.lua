-- MODULE DATATYPES.LUA
-- by Garran Plum
--
-- Lua functions that return Foundation datatypes and built-in IDs for all GP mods.
-- 
-- FUNCTION ASSIGNMENTS
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("datatypes.lua", GP:version())

local datatypes = {
    building = {
        registrationType = "BUILDING",
        part = "BUILDING_PART",
        constructor = "BUILDING_CONSTRUCTOR_DEFAULT",
        processor = "BUILDING_ASSET_PROCESSOR",
        generatorFunction = "BUILDING_FUNCTION_RESOURCE_GENERATOR",
        generator = "BUILDING_RESOURCE_GENERATOR",

    },
    part = {
        registrationType = "COMP_BUILDING_PART",
        type = "BUILDING_PART_TYPE",
        costList = "BUILDING_PART_COST_LIST",
    },
    workplace = {registrationType = "BUILDING_FUNCTION_WORKPLACE"},
    job = {
        registrationType = "JOB",
        character = "CHARACTER_SETUP",
        behavior = "BEHAVIOR_WORK",
    },
    action = {append = "APPEND"},
    override = {balancing = "DEFAULT_BALANCING"},
}

local datatype
ids = {
    monumentPole = "BUILDING_PART_MONUMENT_POLE",
    jobProgression = "DEFAULT_JOB_PROGRESSION",
    serf = "SERF",
    newcomer = "NEWCOMER",
}

-- GP FUNCTION Datatypes
-- Returns a copy of the Foundation built-in datatypes table.
-- FUNCTIONAL, CLOSURE
function GP:datatypes()
    return GP:copyTable(datatypes)
end

-- GP FUNCTION IDs
-- Returns a copy of the Foundation built-in words table.
-- FUNCTIONAL, CLOSURE
function GP:ids()
    return GP:copyTable(ids)
end
