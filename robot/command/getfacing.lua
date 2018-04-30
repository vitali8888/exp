local function me()

local component = require ("component")
local sender = require ("actions/messageSender")

local x = component.navigation.getFacing()
local message = "Facing ="..tostring(x)
sender(message)

end

return me