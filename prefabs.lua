-- MODULE PREFABS.LUA
-- by Garran Plum
--
-- Functions that register prefabs.
-- 
-- FUNCTION ASSIGNMENTS

-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("prefabs.lua", GP:version())

-- GP FUNCTION Register Category Prefabs
-- Register all the prefabs in a single category in a model file.
-- FUNCTIONAL, GAME EFFECT CALL
function GP:registerCategoryPrefabs(modelFileName, category, config)

    -- Sugar for config.categories[category]
    local categoryPartsList = config.categories[category]

    -- For each part on the category list...
    for partName in pairs(categoryPartsList) do

        -- If not already registered, register the prefab.
        if (not categoryPartsList[partName].AssetRegistered) then
            GP:registerPrefab(modelFileName, partName)
        end
    end
end

-- GP FUNCTION Register Prefab
-- Register a single prefab in a model file.
-- FUNCTIONAL, GAME EFFECT
function GP:registerPrefab(modelFileName, partName)
    GP.mod:registerAssetId(GP:prefabPath(modelFileName, partName), GP:prefabId(partName))
end