return function(message)
    local robot = require("robot")
    local component = require("component")
    component.modem.broadcast(888, robot.name()..": "..message)

end
