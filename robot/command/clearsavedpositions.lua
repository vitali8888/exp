local function me (message)
local class = require("class/singleton")
obj = class.new()

if message[2] == "all" then
    obj.pC.clearSavedPositions()
    else
    obj.pC.cSP(message[2])
end



end
return me