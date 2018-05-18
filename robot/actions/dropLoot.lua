return function(lootchest) --table x y z values (relative position)

local class = require("class/singleton")
obj = class.new()


if (obj.pC.comparePositions(obj.pC.getRelativePosition(), lootchest)) then

        obj.iC.dropAll(nil)
        return true
    else
    return false
end

end