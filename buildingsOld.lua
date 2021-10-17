-- MODULE BUILDINGS.LUA
-- by Garran Plum
--
-- Functions that register monuments and buildings.
-- 
-- FUNCTION ASSIGNMENTS

-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("buildings.lua", GP:version())

-- FUNCTION Register Monument List
-- Register all the monuments in the config.
-- FUNCTIONAL, GAME EFFECT CALL
function GP:registerMonumentList()

    -- Sugar for GP:config()
    local config = GP:config()

    -- Map over the monument list, registering each building on the list.
    GP:map(config.monuments, GP.registerMonument, config)
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

    -- Sort categories by Order
    local orderedCategoryKeys = {}
    for categoryKey, categoryConfig in pairs(buildingConfig.Categories) do
        if (categoryConfig.Order) then
            orderedCategoryKeys[categoryConfig.Order] = categoryKey
        else
            table.insert(orderedCategoryKeys, categoryKey)
        end
    end

    -- For each category in the monument...
    for index, categoryKey in ipairs(
        orderedCategoryKeys) do

        categoryConfig = config.monuments[buildingName].Categories[categoryKey]     

        -- Create a monument part set for the category
        local categoryPartSet = {
            Name = GP:magicWords().category.namePrefix .. categoryKey,
            BuildingPartList = {}
        }

        -- Get the parts in this category.
        local categoryPartsList = config.categories[categoryKey]

        -- Sort parts by Order
        local orderedPartKeys = {}
        for partKey, partConfig in pairs(categoryPartsList) do
            if (partConfig.Order) then
                orderedPartKeys[partConfig.Order] = partKey
            else   
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

            -- If not a GP part, override it's cost, resources, moveable.
            if partConfig.BuildingRegistered then
                GP:override(partKey)
            end

            -- Add the part to the category parts list
            table.insert(categoryPartSet.BuildingPartList,
                         partPrefix .. partKey)
        end

        -- Add the category parts list to the monument
        table.insert(buildingPartsList, categoryPartSet)

        -- Add category part requirements, if any
        if (categoryConfig.Min) then
            table.insert(requiredPartsList,
                         {Category = categoryKey, Min = categoryConfig.Min})
        end

    end

    myMod:register({
        DataType = GP.datatypes().building.registrationType,
        Id = GP:magicWords().building.idPrefix .. buildingName,
        Name = buildingName,
        Description = buildingName .. GP:magicWords().building.descSuffix,
        BuildingType = buildingConfig.Type,
        -- AssetBuildingFunction = buildingConfig.Function,
        AssetCoreBuildingPart = GP:ids().monumentPole,
        BuildingPartSetList = buildingPartsList,
        RequiredPartList = requiredPartsList
    })
end