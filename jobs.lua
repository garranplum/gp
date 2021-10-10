-- JOBS.LUA
-- by Garran Plum
--
-- 
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("jobs.lua")

-- FUNCTION Register All Jobs
-- FUNCTIONAL, GAME EFFECT CALL
function GP:registerAllJobs()

    -- Sugar for GP:config()
    local config = GP:config()

    -- Sugar for config.jobsList
    local jobsList = config.jobs

    for jobName, jobConfig in pairs(jobsList) do
        GP:registerJob(jobName, jobConfig)
    end


    GP:log("registering comp resource container")
-- RESOURCE CONTAINER Berries
myMod:registerPrefabComponent("PREFAB_BASKET_BERRIES_PART", {
    DataType = "COMP_RESOURCE_CONTAINER",
    ResourceData = "BERRIES",
    IsReplenishable = true,
    ReplenishDurationInDays = 7,
    ReplenishQuantity = 10,
    ResourceValue = 5.0, -- How many to pick each time?
    AvailableQuantity = 50, -- Maximum storage.
    Radius = .55, -- Villager stands this far away to pick.
    IsDestroyWhenEmpty = false
})

end

-- FUNCTION Register Job
-- FUNCTIONAL, GAME EFFECT
function GP:registerJob(jobName, jobConfig)

    myMod:register({
        DataType = GP:datatypes().job.registrationType,
        Id = jobName,
        JobName = jobName,
        JobDescription = jobName .. GP:magicWords().job.descSuffix,
        IsLockedByDefault = false,
        ProductionDelay = jobConfig.Delay,
        AssetJobProgression = GP:ids().jobProgression,
        CharacterSetup = {
            DataType = GP:datatypes().job.character,
            WalkAnimation = jobConfig.Walk,
            IdleAnimation = jobConfig.Work

        }
    })

    -- Job Allowed for Newcomers
    myMod:override({
        Id = GP:ids().newcomer,
        CompatibleJobList = {Action = GP:datatypes().action.append, jobName}
    })

    -- Job Allowed for Serfs
    myMod:override({
        Id = GP:ids().serf,
        CompatibleJobList = {Action = GP:datatypes().action.append, jobName}
    })

end
