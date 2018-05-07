return function(message)
local class = require("class/singleton")
local shell = require("shell")
local filesystem = require ("filesystem")
local sender = require("actions/messageSender")
obj = class.new()
local wD = shell.getWorkingDirectory()

if (filesystem.exists(wD.."/missions/"..message[2]..".lua"))
    then
    local mis = require("missions/"..message[2])
    obj.mission.close()
    sender("mission "..obj.mission.getName().." closed...")
    obj.mission = mis

    local file = io.open("reserveData/mission", "w")
    file:write(tostring(obj.mission.getName()).."\r\n")
    file:close()

    sender("...mission "..obj.mission.getName().." begins.")
    else
    sender("no missions havnt this name :(")
end

end