-- JOBS.LUA
-- by Garran Plum
--
-- 
-- IMPORT GP OBJECT
local myMod, GP = ...

GP:log("jobs.lua", GP:version())

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
