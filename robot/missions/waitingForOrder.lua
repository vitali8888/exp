local mission = {}

mission.name = "waitingForOrder"

function mission.barrier(direction)
   return true
end

function mission.saveCondition()
    local class = require ("class/singleton")
    obj = class.new()
    obj.pC.setPosition(obj.pC.getPosition(), "lastaction")
end

function mission.fail()
    return true
end

function mission.pause()
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
    return true
end

function mission.afterDrop()
    return true
end

function mission.afterEquip()
    return true
end

function mission.getProgress()
 return "100%"
end

function mission.getName()
 return mission.name
end

function mission.close()
    local class = require("class/singleton")
    obj = class.new()
    if (obj.pC.points.lastaction ~= nil) then
        obj.pC.unset("lastaction")
    end
    return true
end


return mission