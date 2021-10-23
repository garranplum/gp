-- OVERRIDES.LUA
-- by Garran Plum
--
-- Overrides for built-in buildings.
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("overrides.lua")

-- FUNCTION Override
-- Applies free and moveable overrides to a single part.
-- FUNCTIONAL, GAME EFFECT
function GP:override(partId)

    -- Build this part's entry for the list.
    local onePartEntry = {BuildingPart = partId}

    -- Setup for override ID. Creates unique IDs for each registration.
    local overrideId = GP:magicWords().part.overrides .. partId

    -- Register a cost list for this part with no required resources.
    GP:register({
        DataType = "BUILDING_PART_COST_LIST",
        Id = randomId,
        BuildingPartCostList = {
            {
                BuildingPart = overrideId,
                BuildingPartCost = {
                    BuildRightTaxes = {},
                    UpkeepCost = {},
                    ResourceNeededList = {}
                }
            }
        }
    })

    -- Override the game's balancing rules with this new empty cost/resource list.
    myMod:overrideAsset({
        Id = "DEFAULT_BALANCING",
        BuildingCostOverrideList = {Action = "APPEND", randomId}
    })

    -- Override the part's moveable.
    myMod:overrideAsset({
        Id = partId,
        IsMovableWhenBuilt = true,
        IsOnlyAttached = false,
    })

    -- No returns. Function is called only for side effects.

end

