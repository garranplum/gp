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

    -- Build a ResourceProduced list from the {Produces} section.
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

    -- Build a ResourceRequired list from the {Requires} section.
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

    -- Build an InputInventoryCapacity list from the {Carries} section.
    local inputCapacityList = {}
    if workplaceConfig.Carries then
        for oneResource, qty in pairs(workplaceConfig.Carries) do
            local inputItem = {Resource = oneResource, Quantity = qty}
            table.insert(inputCapacityList, inputItem)
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
        InputInventoryCapacity = inputCapacityList,
        ResourceProduced = resourceProducedList,
        ResourceListNeeded = resourceRequiredList
    }

    GP:register(finalRegistration)
end

