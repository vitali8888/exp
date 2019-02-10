--following class/missionInterface

--this mission class uses positioning patterns of class internalPositioning

local mission = {}
mission.IN = require ("class/internalPositioning")
local class = require ("class/singleton")
obj = class.new()
local robot = require("robot")
local component = require("component")
mission.name = "useToolInf"
mission.stop = false


function mission.barrier(direction)

    return true
end


function mission.saveCondition()
    return true
end

function mission.fail(reason)
    print(reason)
    obj.eC.dropTimer("autocharge")
    obj.eC.dropTimer("autodrop")
    obj.eC.dropTimer("autoequip")
end

function mission.afterCharge()
    obj.mC.moveTo(obj.pC.points.lootchest)
    local selected = robot.select()
    local dropLoot = require("actions/dropLoot")
    dropLoot(obj.pC.points.lootchest)
    robot.select(selected)
    local durability = robot.durability()
    if durability == nil then durability = 0 end
    if (durability < 0.05) then
        obj.mC.moveTo(obj.pC.points.brokentoolchest)
        component.inventory_controller.equip()
        robot.dropDown()
        obj.mC.moveTo(obj.pC.points.toolchest)
        robot.suckDown()
        component.inventory_controller.equip()
    end



end

function mission.afterDrop()

    local durability = robot.durability()
    if durability == nil then durability = 0 end
        if (durability < 0.05) then
            obj.mC.moveTo(obj.pC.points.brokentoolchest)
            component.inventory_controller.equip()
            robot.dropDown()
            obj.mC.moveTo(obj.pC.points.toolchest)
            robot.suckDown()
            component.inventory_controller.equip()
        end

    obj.mC.moveTo(obj.pC.points.charger)
    local charge = require("actions/charge")
    charge()

end

function mission.afterEquip()
    obj.mC.moveTo(obj.pC.points.charger)
    local charge = require("actions/charge")
    charge()
end

function mission.restoreCondition()
        repeat
        obj.mC.moveTo(obj.pC.points.lastaction)
        until obj.pC.comparePositions(obj.pC.points.lastaction, obj.pC.getRelativePosition())
end

function mission.getProgress()
 return mission.step
end

function mission.getName()
 return mission.name
end

function mission.close()

    if (obj.pC.points.lastaction ~= nil) then
        obj.pC.unset("lastaction")
    end
    mission.fail("")
    return true
end

function mission.pause()
    mission.stop = true
end

function mission.start()

    local eac = require("actions/enableAutoCharge")
    local ead = require("actions/enableAutoDrop")
    local eae = require("actions/enableAutoEquip")
    local sender = require("actions/messageSender")
    local component = require("component")

    if (eac()) then
        sender ("autocharging enabled, please dont disable it before mission ends")
        else
        sender ("Error! mission aborting...")
        return false
    end

    os.sleep(0.5)


    if (obj.pC.points.lootchest == nil) then
            sender("Error! cant find lootchest")
            sender("mission failed :(")
            mission.fail("checking systems fail")
            return false
            else
            sender("lootchest is found..")
    end

    if (obj.pC.points.brokentoolchest == nil) then
                sender("Error! cant find brokentoolchest")
                sender("mission failed :(")
                mission.fail("checking systems fail")
                return false
                else
                sender("brokentoolchest is found..")
    end

    if (obj.pC.points.toolchest == nil) then
            sender ("Error! where are the toolchest?!")
            sender ("mission ends... mb next time? :(")
            mission.fail("checking systems fail")
            return false
            else
            sender("toolchest is found..")
    end



    if (ead()) then
        sender ("autodrop loot enabled..")
        else
        sender ("Error! mission aborting...")
        mission.fail("checking systems fail")
        return false
    end

    os.sleep(0.5)

    if (eae()) then
        sender ("autoequip tool enabled...")
        else
        sender ("Error! mission aborting...")
        mission.fail("checking systems fail")
        return false
    end

    os.sleep(2)

    if (component.isAvailable("inventory_controller") == false) then
        sender("robot must have inventory controller for this mission")
        mission.fail("checking systems fail")
        return false
    end

    if (obj.pC.points.wzstart == nil or obj.pC.points.wzend == nil) then
        sender ("Error! pls set working zone!")
        sender ("Mission aborting...")
        mission.fail("checking systems fail")
        return false
    end


    obj.pC.reCalcWZ()
    sender("working zone ready, pls dont change it before mission ends!")
    os.sleep(5)

    os.sleep(1)
    sender ("init internal navigation...")
    mission.IN.init(obj.pC.points.borderfirst, obj.pC.points.bordersecond, 1, true, 0)


    if (mission.IN.positionAdjustment(obj.pC.points.lastaction) ~= false) then
          sender("calculating start position")
          obj.pC.setPositionRelative(mission.IN.positionAdjustment(obj.pC.points.lastaction), "lastaction")
          else
          sender("generating starting position")
          obj.pC.setPositionRelative(mission.IN.positionAdjustment(nil), "lastaction")

    end
    os.sleep(1)


    robot.select(1)
    os.sleep(6)

    mission.stop = false
    sender("moving to position...")


    step = 0

    repeat
        step = 1
    local posadj = mission.IN.positionAdjustment(obj.pC.points.lastaction)

        repeat
        obj.mC.moveTo(posadj)
        until obj.pC.comparePositions(posadj, obj.pC.getRelativePosition())
        step = 2
    local direction = mission.IN.getDirection(obj.pC.getRelativePosition()) step = 3
    if (direction == "changelayer") then step = 4
        robot.swingUp()
        mission.IN.changeLayer(mission.doNothing, true) -- second argument mean "action then move", change Down to Up if upsidedown change
        direction = mission.IN.getDirection(obj.pC.getRelativePosition()) step = 5
        elseif(direction == "mission ends") then step = 6
        obj.pC.setPositionRelative(mission.IN.positionAdjustment(nil), "lastaction") step = 7
        repeat step = 8
        obj.mC.moveTo(obj.pC.points.lastaction) step = 9
        until obj.pC.comparePositions(obj.pC.points.lastaction, obj.pC.getRelativePosition()) step = 10
        direction = mission.IN.getDirection(obj.pC.getRelativePosition()) step = 11
    end
    obj.mC.turnTo(direction) step = 12


    local actions = {}
    actions[1] = robot.useDown
        step = 13


    if (mission.IN.positionAdjustment(obj.pC.getRelativePosition()) ~= false) then
        step = 14
        local dist = mission.IN.getDistToBorder(direction, obj.pC.getRelativePosition())
        if (dist > 30) then dist = 30 end

        step = 15
        for i=1, dist do
            mission.IN.doAction(actions)
            robot.forward()
        end
        step = 16
    end

        step = 17
    if (mission.IN.positionAdjustment(obj.pC.getRelativePosition()) ~= false) then
                obj.pC.setPositionRelative(mission.IN.positionAdjustment(obj.pC.getRelativePosition()), "lastaction")
    end

    os.sleep(0.15)


    sender("free memory: "..computer.freeMemory())
    

    until mission.stop == true





end

function mission.doNothing()
    return true
end



return mission