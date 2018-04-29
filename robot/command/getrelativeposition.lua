local function me()

local component = require ("component")
local sender = require ("actions/messageSender")

local x, y, z, str = component.navigation.getPosition()
local message = "x="..tostring(x).." y="..tostring(y).." z="..tostring(z).." data="..tostring(str)
sender(message)

end

return me