local function me(mes)

local sender = require ("actions/messageSender")
local class = require ("class/singleton")
obj = class.new()

local pos = {}
pos.x = mes[2]
pos.y = mes[3]
pos.z = mes[4]
obj.mC.moveToRP(pos)

sender("bit mozhet priehali")

end

return me