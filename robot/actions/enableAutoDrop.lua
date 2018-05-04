return function ()

local class = require ("class/singleton")
local sender = require ("actions/messageSender")
obj = class.new()

if (obj.pC.points.lootchest == nil) then
    sender("please, set loot chest position")
    return false
end

        obj.eC.addTimer("autodrop", 16, "autodrop")
        return true

end