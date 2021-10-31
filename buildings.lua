-- MODULE BUILDINGS.LUA
-- by Garran Plum
--
-- Functions that register monuments and buildings.
-- 
-- FUNCTION ASSIGNMENTS
-- IMPORT GP OBJECT
local myMod, GP = ...

-- FUNCTION Register Monument List
-- Register all the monuments in the config.
-- FUNCTIONAL, GAME EFFECT CALL
function GP:registerMonumentList()

    -- Sugar for GP:config()
    local config = GP:config()

    -- Map over the monument list, registering each monument.
    GP:map(config.monuments, GP.registerMonument, config)

    -- Map over single buildings, registering each building.
    GP:map(config.buildings, GP.registerBuilding, config)

    -- Map over categories, registering each part type enum.
    GP:map(config.categories, GP.registerBuildingPartType)

    -- Map over categories, registering any resource containers.
    -- GP:map(config.categories, GP.registerPrefabContainers, config)

    -- Map over categories, registering each part.
    GP:map(config.categories, GP.registerCategoryBuildingParts, config)

end

-- 1ST CLASS FUNCTION Register Monument
-- Register a single monument building.
-- FUNCTIONAL, GAME EFFECT
function GP.registerMonument(buildingName, config)

    -- Sugar for buildingConfig
    local buildingConfig = config.monuments[buildingName]

    -- Build Parts Lists
    local buildingPartsList = {}
    local requiredPartsList = {}

    -- -- Sort categories by Order
    -- local orderedCategoryKeys = {}
    -- for categoryKey, categoryConfig in pairs(buildingConfig.Categories) do
    --     if (categoryConfig.Order) then
    --         orderedCategoryKeys[categoryConfig.Order] = categoryKey
    --     else
    --         table.insert(orderedCategoryKeys, categoryKey)
    --     end
    -- end

    -- Group categories by order
    local groupedCategoryKeys = {}

    for categoryKey, categoryConfig in pairs(buildingConfig.Categories) do

        -- Support Order or Group syntax
        categoryConfig.Order = categoryConfig.Order or categoryConfig.Group

        -- Order specified?
        if (categoryConfig.Order) then

            -- Create a new group, if necessary
            if not groupedCategoryKeys[categoryConfig.Order] then
                groupedCategoryKeys[categoryConfig.Order] = {}
            end

            -- Add this key to its group
            table.insert(groupedCategoryKeys[categoryConfig.Order], categoryKey)
        else

            -- No order? Add this key to the last group.
            table.insert(groupedCategoryKeys, {categoryKey})
        end
    end

    -- Sort into final order based on groups
    local orderedCategoryKeys = {}

    -- Ungroup into a single ordered array
    for index, categoryGroup in ipairs(groupedCategoryKeys) do
        -- Add each category in the group to the final array.
        for index, categoryKey in ipairs(categoryGroup) do
            table.insert(orderedCategoryKeys, categoryKey)
        end
    end

    -- For each category in the monument...
    for index, categoryKey in ipairs(orderedCategoryKeys) do

        categoryConfig = config.monuments[buildingName].Categories[categoryKey]

        -- Create a monument part set for the category
        local categoryPartSet = {
            Name = GP:magicWords().category.namePrefix .. categoryKey,
            BuildingPartList = {}
        }

        -- Get the parts in this category.
        local categoryPartsList = config.categories[categoryKey]

        -- Group parts by Order
        local groupedPartKeys = {}

        -- Group part keys by order
        for partKey, partConfig in pairs(categoryPartsList) do

            -- Support Order or Group syntax
            partConfig.Order = partConfig.Order or partConfig.Group

            -- Order specified?
            if (partConfig.Order) then

                -- Create a new group, if necessary
                if not groupedPartKeys[partConfig.Order] then
                    groupedPartKeys[partConfig.Order] = {}
                end

                -- Add this key to its group
                table.insert(groupedPartKeys[partConfig.Order], partKey)
            else

                -- No order? Add this key to the last group.
                table.insert(groupedPartKeys, {partKey})
            end
        end

        -- Sort into final order based on groups
        local orderedPartKeys = {}

        -- Ungroup into a single ordered array
        for index, partGroup in ipairs(groupedPartKeys) do
            -- Add each part in the group to the final array.
            for index, partKey in ipairs(partGroup) do
                table.insert(orderedPartKeys, partKey)
            end
        end

        -- For each part in the category...
        for index, partKey in ipairs(orderedPartKeys) do

            -- Get the part config
            partConfig = categoryPartsList[partKey]

            -- Setup for adding part prefix, if any.
            local partPrefix = ""

            -- If GP part, use our part prefix.
            if not partConfig.BuildingRegistered then
                partPrefix = GP:magicWords().part.idPrefix
            end

            -- Add the part to the category parts list
            table.insert(categoryPartSet.BuildingPartList, partPrefix .. partKey)
        end

        -- Add the category parts list to the monument
        table.insert(buildingPartsList, categoryPartSet)

        -- Add category part requirements, if any
        if (categoryConfig.Min) then
            table.insert(requiredPartsList,
                         {Category = categoryKey, Min = categoryConfig.Min})
        end

    end

    GP:register({
        DataType = GP.datatypes().building.registrationType,
        Id = GP:magicWords().building.idPrefix .. buildingName,
        Name = buildingName,
        Description = buildingName .. GP:magicWords().building.descSuffix,
        BuildingType = buildingConfig.Type,
        AssetCoreBuildingPart = GP:ids().monumentPole,
        BuildingPartSetList = buildingPartsList,
        RequiredPartList = requiredPartsList,
        AssetMiniatureBuildingPart = buildingConfig.Logo

    })
end

-- 1ST CLASS FUNCTION Register Building
-- Register all buildings in a category as having only one part.
-- FUNCTIONAL, GAME EFFECT
function GP.registerBuilding(categoryIndex, config)

    -- Sugar for category
    local category = config.buildings[categoryIndex]

    -- Sugar for category parts
    local categoryParts = config.categories[category]

    -- Register each part in the category as a separate building.
    for partName, partConfig in pairs(categoryParts) do

        GP:register({
            DataType = GP.datatypes().building.registrationType,
            Id = GP:magicWords().building.idPrefix .. partName,
            Name = partName,
            Description = partName .. GP:magicWords().building.descSuffix,
            BuildingType = partConfig.Type,
            AssetBuildingFunction = partConfig.Function,
            AssetCoreBuildingPart = GP:partId(partName),
            IsEditable = true
        })
    end
end
