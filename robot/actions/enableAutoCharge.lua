return function ()

local class = require ("class/singleton")
local sender = require ("actions/messageSender")
obj = class.new()

if (obj.pC.points.charger == nil) then
    sender("please, set charger position")
    return false
end

        obj.eC.addTimer("autocharge", 15, "autocharge")
        return true

end