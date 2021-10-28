-- MODULE DEPENDENCY.LUA
-- by Garran Plum
--
--
-- IMPORT GP OBJECT
local myMod, GP = ...

local myModName = GP:config().modName

if myModName == "GPUniversal" then

    -- CLASS GP Object
    local GP_OBJECT_CLASS = {
        TypeName = GP:datatypes().building.object,
        ParentType = GP:datatypes().building.component,
        Properties = {{Name = "Universal", Type = "table"}}
    }

    function GP_OBJECT_CLASS:init() self.Universal = GP end

    GP:register({DataType = GP:datatypes().building.object, Id = "UNIVERSAL_GP"})

    myMod:registerClass(GP_OBJECT_CLASS)

end
