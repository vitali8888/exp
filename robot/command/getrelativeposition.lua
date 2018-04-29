local function me()

local component = require ("component")
local sender = require ("actions/messageSender")

local x, y, z = component.navigation.getPosition()
local message = x..":"..y..":"..z
sender(message)

end

return me