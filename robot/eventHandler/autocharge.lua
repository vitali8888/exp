return function()

local computer = require("computer")
local minEn = 0.82 --minimum energy level before charging needs
local curEn = computer.energy() / computer.maxEnergy()


if (curEn < minEn) then

    local reserveParams = {}
    local class = require ("class/singleton")
    local charge = require ("actions/charge")
    obj = class.new()
    local mis = obj.mission

    reserveParams.events = obj.eC.events
    reserveParams.timers = obj.eC.timers
    obj.eC.dropAllEvents()
    obj.eC.dropAllTimers()

    obj.eC.addEvent("charging", "modem_message", "chargingmessage")


    mis.saveCondition()
        repeat
        obj.mC.moveTo(obj.pC.points.charger)
        until obj.pC.comparePositions(obj.pC.points.charger, obj.pC.getRelativePosition())

    charge()

    mis.afterCharge()
    obj.eC.dropEvent("charging")
    obj.eC.restoreTimers(reserveParams.timers)
    obj.eC.restoreEvents(reserveParams.events)
    mis.restoreCondition()

end

end