local function me(message)
    local class = require ("class/singleton")
    obj = class.new()
    local pos = obj.pC.getPosition()
    local thing = tostring(message[2])
    obj.pC.setPosition(pos, thing)
end
return me