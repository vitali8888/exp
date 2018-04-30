local function me(...)

local component = require ("component")
local sender = require ("actions/messageSender")

local x = component.navigation.getRange()
local message = "Range ="..tostring(x)
sender(message)

end

return me