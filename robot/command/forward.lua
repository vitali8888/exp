local function me(message)
    local robot = require("robot")
    local times = tonumber(message[2])
    for i=1, times do
        robot.forward()
    end
end
return me