--following class/missionInterface

--this mission class uses positioning patterns of class internalPositioning

local mission = {}
mission.IN = require ("class/internalPositioning")
local class = require ("class/singleton")
obj = class.new()
local robot = require("robot")
local component = require("component")
mission.name = "fillAll"
mission.stop = false
local sender = require ("actions/messageSender")


function mission.barrier(direction)
    return true
end



function mission.posAcToFacing(pos)
    local facing = obj.pC.getFacing()

    if (facing == 2)
        then
        pos.z = pos.z - 1
        return pos
        elseif(facing == 3) then
        pos.z = pos.z + 1
        return pos
        elseif (facing == 4) then
        pos.x = pos.x - 1
        return pos
        elseif (facing == 5) then
        pos.x = pos.x + 1
        return pos
    end
    print("uDnbelivable error! unreal facing!")
end

function mission.saveCondition()
    return true
end

function mission.fail(reason)
    print(reason)
    obj.eC.dropTimer("autocharge")
end

function mission.afterCharge()
   return true
end

function mission.afterDrop()
    return true
end

function mission.afterEquip()
 return true
end

function mission.restoreCondition()
        repeat
        obj.mC.moveTo(obj.pC.points.lastaction)
        until obj.pC.comparePositions(obj.pC.points.lastaction, obj.pC.getRelativePosition())
end

function mission.getProgress()
 local math = require ("math")
 if mission.IN.isInit == false then return "mission has not yet begun" end
 local curvol = mission.IN.getCurrentVolumeDone(obj.pC.points.lastaction)
 if curvol == false then return "wrong position, restart the mission" end
 local prog = curvol/mission.IN.getVolume()
 prog = prog * 10000
 prog = math.floor(prog)
 local strprog = tostring(prog/100).."%"
 return strprog
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
    mission.IN.init(obj.pC.points.borderfirst, obj.pC.points.bordersecond, 1, false, 1)


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

    mission.setSlot()
    mission.stop = false
    sender("moving to position...")



    repeat

    local posadj = mission.IN.positionAdjustment(obj.pC.points.lastaction)

        repeat
        obj.mC.moveTo(posadj)
        until obj.pC.comparePositions(posadj, obj.pC.getRelativePosition())

    if (mission.directionControll() == false) then break end
    local direction = mission.IN.getDirection(obj.pC.getRelativePosition())

    local actions = {}
    actions[1] = robot.placeDown


    if (mission.IN.positionAdjustment(obj.pC.getRelativePosition()) ~= false) then

        local dist = mission.IN.getDistToBorder(direction, obj.pC.getRelativePosition())
        if (dist > 64) then dist = 64 end
        mission.setSlot()
        if (dist > robot.count()) then dist = robot.count() end


        for i=1, dist do
            mission.IN.doAction(actions)
            robot.forward()
        end

    end


    if (mission.IN.positionAdjustment(obj.pC.getRelativePosition()) ~= false) then
                obj.pC.setPositionRelative(mission.IN.positionAdjustment(obj.pC.getRelativePosition()), "lastaction")
    end

    os.sleep(0.3)

    until mission.stop == true

end

function mission.setSlot()
    if (robot.count() == 0) then
        local try = 0

        if (obj.iC.calcMaterial(nil) == 0) then
            mission.fillInv()
            robot.select(1)
            return true
        end

        repeat
            local selected = robot.select()
            if (selected == robot.inventorySize()) then robot.select(1)
                else
                robot.select(selected + 1)
            end
            try = try + 1
            if try > robot.inventorySize() then
                mission.fillInv()
                robot.select(1)
                break
            end

        until robot.count() ~= 0


    else return true end

end

function mission.directionControll()
    local direction = mission.IN.getDirection(obj.pC.getRelativePosition())
    if (direction == "changelayer") then
        mission.setSlot()
        robot.placeDown()
        mission.setSlot()
        mission.IN.changeLayer(robot.placeDown, false) -- second argument mean "action then move", change Down to Up if upsidedown change
        direction = mission.IN.getDirection(obj.pC.getRelativePosition())
        elseif(direction == "mission ends") then
        mission.setSlot()
        robot.placeDown()
        obj.pC.setPosition(obj.pC.getPosition(), "lastaction")
        sender("mission done")
        print("mission done")
        mission.stop = true
        return false
    end
    obj.mC.turnTo(direction)
    return true
end


function mission.fillInv()
    if (mission.IN.positionAdjustment(obj.pC.getRelativePosition()) ~= false) then
            obj.pC.setPositionRelative(mission.IN.positionAdjustment(obj.pC.getRelativePosition()), "lastaction")
    end

    repeat
            obj.mC.moveTo(obj.pC.points.lootchest)
    until obj.pC.comparePositions(obj.pC.points.lootchest, obj.pC.getRelativePosition())


    for i = 1, robot.inventorySize() do
         robot.suckDown()
    end

    if (obj.iC.calcMaterial(nil) == 0) then
        print("the materials ended")
        mission.stop = true
        return true
    end

    obj.mC.moveTo(obj.pC.points.charger)
    local charge = require ("actions/charge")
    charge()

    repeat
                obj.mC.moveTo(obj.pC.points.lastaction)
    until obj.pC.comparePositions(obj.pC.points.lastaction, obj.pC.getRelativePosition())
    mission.directionControll()
end



return mission