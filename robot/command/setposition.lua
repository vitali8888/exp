local function me(message)
    local sender = require("actions/messageSender")

    local pos = {}
    pos.x = tonumber(message[3])
    pos.y = tonumber(message[4])
    pos.z = tonumber(message[5])
    
    local thing = tostring(message[2])

    if (pos.x == nil or pos.y == nil or pos.z == nil) then sender("Error! invalid position!") do return end end

    local class = require ("class/singleton")
    obj = class.new()
    obj.pC.setPosition(pos, thing)



end
return me