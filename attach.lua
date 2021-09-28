-- MODULE ATTACH.LUA
-- by Garran Plum
--
-- Functions that register attachment points.
-- 
-- FUNCTION ASSIGNMENTS
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("attach.lua", GP:version())

-- GP FUNCTION Register Attach Node Types
-- Register all the attach node types in config.nodeTypes
-- FUNCTIONAL, GAME EFFECT CALL
function GP:registerAttachNodeTypes(config)

    -- Sugar for config.nodeTypes
    local nodeTypeList = config.nodeTypes

    -- For each node type...
    for nodeType, categoryKeyList in pairs(nodeTypeList) do

        -- For each category on that node type list...
        for index, categoryKey in ipairs(categoryKeyList) do

            -- Get the list of parts in that category.
            local partList = GP:copyTable(config.categories[categoryKey])

            -- Map over the parts list, registering each part to the node type.
            GP:map(partList, GP.registerPrefabAttachPointType, nodeType)
        end
    end
end

-- 1ST CLASS FUNCTION Register Prefab Attach Point Type
-- Register a single part to an attach point type.
-- FUNCTIONAL, GAME EFFECT CALL
function GP.registerPrefabAttachPointType(partKey, nodeType)

    GP.mod:registerPrefabComponent(GP:prefabId(partKey), {
        DataType = GP:datatypes().part.registrationType,
        BuildingPartType = ATTACH_NODE_TYPE[nodeType]
    })

end