-- OVERRIDES.LUA
-- by Garran Plum
--
-- Overrides for built-in buildings.
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("overrides.lua", GP:version())

-- FUNCTION Override
-- Applies free and moveable overrides to a single part.
-- FUNCTIONAL, GAME EFFECT
function GP:override(partId)

    -- Build this part's entry for the list.
    local onePartEntry = {BuildingPart = partId}

    -- Setup for random ID. Creates unique IDs for each registration.
    local randomValue = "_" .. math.random(1, 100000000)
    local randomId = GP:magicWords().part.overrides .. randomValue

    -- Register a cost list for this part with no required resources.
    myMod:register({
        DataType = "BUILDING_PART_COST_LIST",
        Id = randomId,
        BuildingPartCostList = {
            {
                BuildingPart = partId,
                BuildingPartCost = {
                    BuildRightTaxes = {},
                    UpkeepCost = {},
                    RessourcesNeeded = {}
                }
            }
        }
    })

    -- Override the game's balancing rules with this new empty cost/resource list.
    myMod:override({
        Id = "DEFAULT_BALANCING",
        BuildingCostOverrideList = {Action = "APPEND", randomId}
    })

    -- Override the part's moveable.
    myMod:override({
        Id = partId,
        IsMovableWhenBuilt = true,
        IsOnlyAttached = false,
    })

    -- No returns. Function is called only for side effects.

end

