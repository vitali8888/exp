return function(message)
local class = require("class/singleton")
local shell = require("shell")
local filesystem = require ("filesystem")
local sender = require("actions/messageSender")
obj = class.new()
me.wD = shell.getWorkingDirectory()

if (filesystem.exists(me.wD.."/missions/"..message[2]..".lua")
    then
    local mission = require("missions/"..message[2])
    obj.mission = mission
    sender("...has new mission")
    else
    sender("no missions havnt this name :(")
end

end