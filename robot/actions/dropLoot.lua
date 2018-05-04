return function(lootchest) --table x y z values (relative position)

local class = require("class/singleton")
obj = class.new()


if (obj.pC.comparePositions(obj.pC.getRelativePosition(), lootchest)) then

        local robot = require ("robot")
        local size = robot.inventorySize()

        for i=1, size do
            robot.select(i)
            robot.dropDown()
        end
            return true
 else
    return false
end

end