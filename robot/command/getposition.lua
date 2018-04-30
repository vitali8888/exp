local function me(...)

local sender = require ("actions/messageSender")
local class = require ("class/singleton")
obj = class.new()

local pos = obj.pC.getPosition()

local message = nil
message = "X:"..pos.x.." Y:"..pos.y.." Z:"..pos.z

sender(message)

end

return me