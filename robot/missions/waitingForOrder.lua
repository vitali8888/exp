local mission = {}

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

return mission