-- OVERRIDES.LUA
-- by Garran Plum
--
-- Overrides for built-in buildings.
-- IMPORT GP OBJECT
local myMod, GP = ...

-- 1st CLASS FUNCTION Override
-- Applies free and moveable overrides to a single part.
-- FUNCTIONAL, GAME EFFECT
function GP.override(partId)

    -- Override the part's resource requirements
    myMod:overrideAsset({
        Id = partId,
        Cost = {BuildRightTaxes = {}, UpkeepCost = {}, ResourceNeededList = {}},
        IsMovableWhenBuilt = true,
        IsOnlyAttached = false,
        HasMaximumInstancePerBuilding = false,
        BuildingZone = {
            ZoneEntryList = {
                {
                    Polygon = polygon.createCircle(1, {0, 0}, 6),
                    Type = {
                        DEFAULT = true,
                        NAVIGABLE = false,
                        GRASS_CLEAR = true
                    }
                }
            }
        }
    })

    -- No returns. Function is called only for side effects.

end

