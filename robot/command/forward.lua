local function me(message)
    local robot = require("robot")
    local times = tonumber(message[2])
    if times == nil then times = 1 end
    if times < 2 then times = 1 end
    for i=1, times do
        robot.forward()
    end
end
return me