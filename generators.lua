-- MODULE GENERATORS.LUA
-- by Garran Plum
--
--
-- IMPORT GP OBJECT
local myMod, GP = ...

-- CLASS Building Resource Generator
local BUILDING_RESOURCE_GENERATOR = {
    TypeName = GP:datatypes().building.generator,
    ParentType = "BUILDING_FUNCTION",
    Properties = {
        {
            Name = "ResourceGenerator",
            Type = GP:datatypes().building.generatorFunction,
            Default = "BUILDING_FUNCTION_WELL"
        }, {Name = "MaxQuantity", Type = "integer", Default = 50},
        {Name = "GrowRate", Type = "float", Default = 1.0}
    }
}

-- EVENT Activate Building w/ This Generator 
function BUILDING_RESOURCE_GENERATOR:activateBuilding(gameObject)
    resourceGenerator = gameObject:getOrCreateComponent(
                            "COMP_RESOURCE_GENERATOR")
    resourceGenerator:setResourceGeneratorData(self.ResourceGenerator)
    resourceGenerator:setMaxQuantity(self.MaxQuantity)
    resourceGenerator.GrowRate = self.GrowRate
    return true
end

-- EVENT Reload Building w/ This Generator 
function BUILDING_RESOURCE_GENERATOR:reloadBuildingFunction(gameObject)
    self:activateBuilding(gameObject)
end

-- REGISTER Class
GP:registerClass(BUILDING_RESOURCE_GENERATOR)

function GP:registerGenerator(generatorConfig)

    for resource, maxQty in pairs(generatorConfig.Produces) do

        -- BUILDING FUNCTION RESOURCE GENERATOR (Parent) Properties
        GP:register({
            DataType = GP:datatypes().building.generatorFunction,
            Id = resource .. GP:magicWords().generator.functionIdSuffix,
            ResourceGenerated = resource,
            IsForConsumer = false,
            IsInfinite = false
        })

        -- BUILDING RESOURCE GENERATOR (New) Properties
        GP:register({
            DataType = GP:datatypes().building.generator,
            Id = resource .. GP:magicWords().generator.idSuffix,
            Name = resource .. GP:magicWords().generator.idSuffix,
            ResourceGenerator = resource ..
                GP:magicWords().generator.functionIdSuffix,
            MaxQuantity = maxQty,
            GrowRate = generatorConfig.Rate
        })

    end

end
