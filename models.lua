-- MODULE MODELS.LUA
-- by Garran Plum
--
-- Functions that process .fbx model files.
-- 
-- FUNCTION ASSIGNMENTS
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("models.lua", GP:version())

-- GP FUNCTION Register Model Files
-- Register all model files in config.models.
-- FUNCTIONAL, GAME EFFECT CALL
function GP:registerModelFiles()

    -- Sugar for GP:config()
    local config = GP:config()

    -- Sugar for config.modelFiles
    local modelFiles = config.modelFiles

    for modelFile, categoryKeyArray in pairs(modelFiles) do

        local modelFileName =
            GP:magicWords().model.folder .. "/" .. modelFile ..
                GP:magicWords().model.extension

        -- Register building part types for each category in the file.           
        GP:registerBuildingPartTypes(categoryKeyArray)

        -- Register prefabs for each category in the file.
        for index, categoryKey in ipairs(categoryKeyArray) do

            -- Get a list of parts for the category.
            local categoryPartsList = config.categories[categoryKey]

            -- Register all prefabs in the category.
            GP:registerCategoryPrefabs(modelFileName, categoryKey, config)
        end

        -- Register one asset processor for the entire file.
        GP.mod:registerAssetProcessor(modelFileName, {
            DataType = GP:datatypes().building.processor,
        })

        -- Register all attach node types in entire mod.
        GP:registerAttachNodeTypes(config)

        -- Register all path nodes, path types, and building parts for each category.
        for index, categoryKey in ipairs(categoryKeyArray) do

            -- Get a list of parts for the category.
            local categoryPartsList = config.categories[categoryKey]

            -- Register all path nodes and types to all parts in the category.
            GP:registerPartPaths(modelFileName, categoryKey, config)

            -- Register all building parts in the category.
            GP:registerCategoryBuildingParts(modelFileName, categoryKey,
                                             categoryPartsList)
        end
    end
end
