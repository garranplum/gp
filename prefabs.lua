-- MODULE PREFABS.LUA
-- by Garran Plum
--
-- Functions that register prefabs.
-- 
-- FUNCTION ASSIGNMENTS
-- IMPORT GP OBJECT
local myMod, GP = ...

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
-- FUNCTIONAL, GAME EFFECT CALL
function GP:registerPrefab(modelFileName, partName)
    GP:registerAssetId(GP:prefabPath(modelFileName, partName),
                       GP:prefabId(partName),
                       GP:datatypes().prefab.registrationType)
end

-- 1st CLASS FUNCTION Register Prefab Containers
-- Registers all prefab resource containers in a category.
-- FUNCTIONAL, GAME EFFECT CALL
function GP.registerPrefabContainers(category, config)

    -- Sugar for category parts
    local categoryParts = config.categories[category]

    -- Map over parts in the category, registering any resource container
    GP:map(categoryParts, GP.registerResourceContainer, config)
end

-- 1st CLASS FUNCTION Register Resource Container
-- Register a single prefab as a resource container.
-- FUNCTIONAL, GAME EFFECT
function GP.registerResourceContainer(partName, config)

    -- Sugar for partConfig
    local partConfig = config.categories[category][partName]

    -- Not a resource container? Early return.
    if not partConfig.Produces then return end

    -- Extract unitsPerWeek
    local partProduces, unitsPerWeek = next(partConfig.Produces)

    -- Calculate production rate. Magic numbers.
    local pickRate = unitsPerWeek / 2
    local maxStorage = unitsPerWeek * 5

    GP:alert(partName, "produces", unitsPerWeek, partProduces)

    local finalRegistration = {
        DataType = GP:datatypes().resource.container,
        ResourceData = partProduces,
        IsReplenishable = true,
        ReplenishDurationInDays = 7,
        ReplenishQuantity = unitsPerWeek,
        ResourceValue = pickRate, -- How many to pick each time?
        AvailableQuantity = maxStorage, -- Maximum storage.
        Radius = .55, -- Villager stands this far away to pick.
        IsDestroyWhenEmpty = false
    }

    myMod:registerPrefabComponent(partName, finalRegistration)
end
