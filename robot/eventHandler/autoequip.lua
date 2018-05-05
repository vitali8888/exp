return function()

local computer = require("computer")
local robot = require("robot")
local selectedSlot = robot.select()
local durability = robot.durability()
if durability == nil then durability = 0 end



if (durability < 0.04) then

    local reserveParams = {}
    local class = require ("class/singleton")
    obj = class.new()
    local mis = obj.mission
    local dropLoot = require ("actions/dropLoot")
    local component = require("component")

    reserveParams.events = obj.eC.events
    reserveParams.timers = obj.eC.timers
    obj.eC.dropAllEvents()
    obj.eC.dropAllTimers()

    obj.eC.addEvent("charging", "modem_message", "chargingmessage")


    mis.saveCondition()
    obj.mC.moveTo(obj.pC.points.lootchest)

    if (dropLoot(obj.pC.points.lootchest) ~= true) then
            sender("Error! mission failed (miss the way to lootchest")
            mis.fail("drop loot before reequip")
    end

    robot.select(selectedSlot)

    obj.mC.moveTo(obj.pC.points.toolchest)
    robot.suckDown()
    component.inventory_controller.equip()
    obj.mC.moveTo(obj.pC.points.lootchest)
    robot.dropDown()

    mis.afterEquip()
    obj.eC.dropEvent("charging")
    obj.eC.restoreTimers(reserveParams.timers)
    obj.eC.restoreEvents(reserveParams.events)
    mis.restoreCondition()

end

end