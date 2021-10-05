-- MODULE PARTS.LUA
-- by Garran Plum
--
-- Functions that register building parts.
-- 
-- FUNCTION ASSIGNMENTS
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("parts.lua", GP:version())

-- 1ST CLASS FUNCTION Register Category Buildings
-- Register all the building parts in a single category in a model file.
-- FUNCTIONAL, GAME EFFECT CALL
function GP.registerCategoryBuildingParts(category, config)

      -- Sugar for categoryParts
      local categoryParts = config.categories[category]

    for partName, partConfig in pairs(categoryParts) do

        -- Register resource containers, if any
        -- GP:registerResourceContainer(category, partName, config)

        if (not partConfig.BuildingRegistered) then
            GP:log("calling register", partName)
            GP.registerBuildingPart(category, partName, config)
        else
            GP:log("calling override", partName)
            GP:override(partName)
        end
    end
end





-- 1ST CLASS FUNCTION Register Building Part Type
-- Register a single building part type enum value.
-- FUNCTIONAL, GAME EFFECT
function GP.registerBuildingPartType(category)
    GP.mod:registerEnumValue(GP:datatypes().part.type, category)
end

-- 1ST CLASS FUNCTION Register Building Part
-- Register a single building part within a category.
-- FUNCTIONAL, GAME EFFECT
function GP.registerBuildingPart(category, partName, config)

      -- Sugar for partConfig
      local partConfig = config.categories[category][partName]

    local partId = GP:partId(partName)
    GP:log("registering part", partId)
    local prefabId = partName
    if not partConfig.AssetRegistered then 
        prefabId = GP:prefabId(partName) 
    end
    GP:log("using prefab", prefabId)
    local buildingFunction = partConfig.Function

    local finalRegistration = {
        DataType = GP:datatypes().building.part,
        Id = partId,
        Name = partName,
        Description = partName .. GP:magicWords().part.descSuffix,
        ConstructorData = {
            DataType = GP:datatypes().building.constructor,
            CoreObjectPrefab = prefabId
        },
        AssetBuildingFunction = buildingFunction,
        IsMovableWhenBuilt = true, 
        -- Category = category,
   
        -- BuildingZone = {
        --     ZoneEntryList = {
        --         {
        --             Polygon = polygon.createCircle(1, {0, 0}, 6),
        --             Type = {
        --                 DEFAULT = true,
        --                 NAVIGABLE = false,
        --                 GRASS_CLEAR = true
        --             }
        --         }
        --     }
        -- }
    }

    GP:register(finalRegistration)

end
