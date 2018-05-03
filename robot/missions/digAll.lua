--following class/missionInterface

local mission = {}

local class = require ("class/singleton")
obj = class.new()
local robot = require("robot")


function mission.barrier(direction)

    if (direction == "up")
        then
        return mission.barrierGateUp()
        elseif (direction == "down") then
        return mission.barrierGateDown()
        elseif (direction == "straight") then
        return mission.barrierGateStraight()
    end
end

function mission.barrierGateUp()

    local pos = obj.pC.getRelativePosition()
    pos.y = pos.y + 1


    if (robot.durability() ~= nil and obj.pC.isWorkingZone(pos))
        then
        robot.swingUp()
        robot.up()
        else
        return true
        end
end

function mission.barrierGateDown()
    local pos = obj.pC.getRelativePosition()
    pos.y = pos.y - 1

    if (robot.durability() ~= nil and obj.pC.isWorkingZone(pos))
        then
        robot.swingDown()
        robot.down()
        else
        return true
        end
end

function mission.barrierGateStraight()
    local pos = obj.pC.getRelativePosition()
    pos = mission.posAcToFacing(pos)

    if (robot.durability() ~= nil and obj.pC.isWorkingZone(pos))
        then
        robot.swing()
        robot.forward()
        else
        return true
        end
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
    print("unbelivable error! unreal facing!")
end

function mission.saveCondition()
    local class = require ("class/singleton")
    obj = class.new()
    obj.pC.setPosition(obj.pC.getPosition(), "lastaction")
end

function mission.fail()
    return true
end

function mission.afterCharge()
    return true
end

function mission.restoreCondition()
    local class = require ("class/singleton")
    obj = class.new()
    obj.mC.moveTo(obj.pC.points.lastaction)
end

function mission.start()
    local eac = require("actions/enableAutoCharge")
    local sender = require("actions/messageSender")
    if (eac()) then
        sender ("autocharging enabled, please dont disable it before mission ends")
    end

end



return mission