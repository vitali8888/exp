return function()
local sender = require("actions/messageSender")
local robot = require("robot")
local computer = require("computer")
local class = require("class/singleton")
local math = require("math")
obj = class.new()
local pos = obj.pC.getPosition()

sender("energy: "..(math.floor(computer.energy()/computer.maxEnergy()*10000)/100).."%")
sender("tool durability: "..(math.floor(robot.durability()*10000)/100.."%")
sender("position: X="..pos.x.." Y="..pos.y.." Z="..pos.z)
sender("mission progress: "..obj.mission.getProgress())

end