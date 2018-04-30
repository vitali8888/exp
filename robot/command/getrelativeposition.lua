local function me()

local component = require ("component")
local sender = require ("actions/messageSender")

local x, y, z, str = component.navigation.getPosition()
local message = "X="..tostring(x).." Y="..tostring(y).." Z="..tostring(z).." data="..tostring(str)
sender(message)

end

return me