return function ()

local class = require ("class/singleton")
local sender = require ("actions/messageSender")
obj = class.new()

if (obj.pC.points.toolchest == nil) then
    sender("please, set tool chest position")
    return false
end

        obj.eC.addTimer("autoequip", 17, "autoequip")
        return true

end