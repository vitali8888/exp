return function()
local sender = ("actions/sender")
local robot = require("robot")
local computer = require("computer")
local class = require("class/singleton")
obj = class.new()
local pos = obj.pC.getPosition()

sender("energy: "..computer.energy()/computer.maxEnergy)
sender("tool durability: "..robot.durability())
sender("position: X="..pos.x.." Y="..pos.y.." Z="..pos.z)
sender("mission progress: "..obj.mission.getProgress())

end