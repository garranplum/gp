-- MODULE MAGIC.LUA
-- by Garran Plum
--
-- Lua functions that return magic words for all GP mods.
-- 
-- FUNCTION ASSIGNMENTS
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("magic.lua", GP:version())

local magicWords = {
    building = {idPrefix = "BUILDING_", descSuffix = "_DESC", icon = "GP_ICON"},
    part = {
        separator = "_Part",
        idPrefix = "BUILDING_PART_",
        descSuffix = "_DESC",
        overrides = "GP_OVERRIDE_PART_LIST"
    },
    prefab = {folder = "Prefab", idPrefix = "PREFAB_"},
    model = {folder = "models", extension = ".fbx"},
    path = {namePrefix = "Path_"},
    category = {namePrefix = "CATEGORY_"},
    generator = {idSuffix = "_GENERATOR", functionIdSuffix = "_GENERATOR_BASE"},
    job = {descSuffix = "_DESC"},
    log = {folder = "logs"},
    overrides = {folder = "settings"},
    config = {folder = "settings"},
}

-- GP FUNCTION Magic Words
-- Returns a copy of the magic words table.
-- FUNCTIONAL, CLOSURE
function GP:magicWords() return GP:copyTable(magicWords) end

-- GP UTILITY FUNCTION fbx Name
-- PURE LUA
-- PURE FUNCTIONAL, MAGIC WORDS
function GP:fbxName(partName) return partName .. GP:magicWords().part.separator end

-- GP UTILITY FUNCTION Prefab Path
-- PURE LUA
-- PURE FUNCTIONAL, MAGIC WORDS
function GP:prefabPath(modelFile, partName)
    local prefabPath =
        "/" .. modelFile .. "/" .. GP:magicWords().prefab.folder .. "/" ..
            GP:fbxName(partName) .. "/"
    return prefabPath
end

-- GP UTILITY FUNCTION Prefab ID
-- PURE LUA
-- PURE FUNCTIONAL, MAGIC WORDS
function GP:prefabId(partName)
    return GP:magicWords().prefab.idPrefix .. GP:fbxName(partName)
end

-- GP UTILITY FUNCTION Part ID
-- PURE LUA
-- PURE FUNCTIONAL, MAGIC WORDS
function GP:partId(partName) return GP:magicWords().part.idPrefix .. partName end
