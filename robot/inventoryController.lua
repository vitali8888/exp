local class = {}
local robot = require("robot")


function class.calcMaterial()
    local selected = robot.select()
    local materials = 0

    for i=1, robot.inventorySize() do
        robot.select(i)
        materials = materials + robot.count()
    end
    robot.select(selected)
    return materials
end





return class