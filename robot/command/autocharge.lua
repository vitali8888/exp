return function (message)
local class = require ("class/singleton")
local sender = require ("actions/messageSender")
local eac = require ("actions/enableAutoCharge")
obj = class.new()

    if (message[2] == "off") then
        obj.eC.dropTimer("autocharge")
        sender("autocharge disable")
    elseif (message[2] == "on") then

        if (eac()) then sender("autocharge enable") end

    end


end