return function (message)
local sender = require ("actions/messageSender")
local class = require("class/singleton")
obj = class.new()

if (obj.pC.isWorkingZone(obj.pC.getRelativePosition())) then sender("yeeep") else sender("nope") end

end