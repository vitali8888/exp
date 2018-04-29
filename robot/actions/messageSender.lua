local function me(message)
    local robot = require("robot")
    local component = require("component")
    component.modem.open(888)
    component.modem.broadcast(robot.name()..": "..message)

end

return me

