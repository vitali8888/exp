return function (message)

local sender = require("actions/messageSender")
local posF = {}
local posS = {}

posF.x = tonumber(message[2])
posF.y = tonumber(message[4])
posF.z = tonumber(message[6])

posS.x = tonumber(message[3])
posS.y = tonumber(message[5])
posS.z = tonumber(message[7])

if (posF.x == nil or posF.y == nil or posF.z == nil) then sender("Error! invalid position!") do return end end
if (posS.x == nil or posS.y == nil or posS.z == nil) then sender("Error! invalid position!") do return end end

local class = require ("class/singleton")
    obj = class.new()
    obj.pC.setWorkingZone(posF, posS)

end