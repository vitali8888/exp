return function()

local computer = require("computer")
local robot = require("robot")
local selectedSlot = robot.select()
local size = robot.inventorySize()
robot.select(size)
local count = robot.count()
robot.select(selectedSlot)


if (count > 0) then

    local reserveParams = {}
    local class = require ("class/singleton")
    obj = class.new()
    local mis = obj.mission
    local dropLoot = require ("actions/dropLoot")

    reserveParams.events = obj.eC.events
    reserveParams.timers = obj.eC.timers
    obj.eC.dropAllEvents()
    obj.eC.dropAllTimers()

    obj.eC.addEvent("charging", "modem_message", "chargingmessage")


    mis.saveCondition()
    obj.mC.moveTo(obj.pC.points.lootchest)

    if (dropLoot(obj.pC.points.lootchest) ~= true) then
            sender("Error! mission failed (miss the way to lootchest")
            mis.fail("drop loot")
    end

    robot.select(selectedSlot)

    mis.afterDrop()
    obj.eC.dropEvent("charging")
    obj.eC.restoreTimers(reserveParams.timers)
    obj.eC.restoreEvents(reserveParams.events)
    mis.restoreCondition()

end

end