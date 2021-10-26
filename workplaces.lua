-- MODULE WORKPLACES.LUA
-- by Garran Plum
--
-- Collects fish from crate and offers them for transport pickup.
--
-- IMPORT GP OBJECT
local myMod, GP = ...

-- FUNCTION Register All Workplaces
-- FUNCTIONAL, GAME EFFECT CALL
function GP:registerAllWorkplaces()

    -- Sugar for GP:config()
    local config = GP:config()

    -- Sugar for config.workplaces
    local workplaceList = config.workplaces

    for workplaceName, workplaceConfig in pairs(workplaceList) do

        if (workplaceConfig.Job) then
            GP:registerWorkplace(workplaceName, workplaceConfig)
        else
            GP:registerGenerator(workplaceConfig)
        end

    end
end

-- FUNCTION Register Workplace
-- FUNCTIONAL, GAME EFFECT
function GP:registerWorkplace(workplaceName, workplaceConfig)

    local resourceProducedList = {}
    if workplaceConfig.Produces then
        for oneResource, qty in pairs(workplaceConfig.Produces) do
            local resourceProducedItem = {
                Resource = oneResource,
                Quantity = qty
            }
            table.insert(resourceProducedList, resourceProducedItem)
        end
    end

    local resourceRequiredList = {}
    if workplaceConfig.Requires then
        for oneResource, qty in pairs(workplaceConfig.Requires) do
            local resourceRequiredItem = {
                Resource = oneResource,
                Quantity = qty
            }
            table.insert(resourceRequiredList, resourceRequiredItem)
        end
    end

    local finalRegistration = {
        DataType = GP:datatypes().workplace.registrationType,
        Id = workplaceName,
        Name = workplaceName,
        WorkerCapacity = workplaceConfig.Positions,
        RelatedJob = {
            Job = workplaceConfig.Job,
            Behavior = workplaceConfig.Behavior or GP.datatypes().job.behavior
        },
        ResourceProduced = resourceProducedList,
        ResourceListNeeded = resourceRequiredList
    }

    GP:register(finalRegistration)
end

