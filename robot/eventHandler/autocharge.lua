return function()

local computer = require("computer")
local minEn = 0.93 --minimum energy level before charging needs
local curEn = computer.energy() / computer.maxEnergy()

if (curEn < minEn) then

    local reserveParams = {}
    local class = require ("class/singleton")
    obj = class.new()
    local mis = obj.mission

    reserveParams.events = obj.eC.events
    reserveParams.timers = obj.eC.timers
    obj.eC.dropAllEvents()
    obj.eC.dropAllTimers()

    obj.eC.addEvent("charging", "modem_message", "chargingmessage")


    mis.saveCondition()
    obj.mC.moveTo(obj.pC.points.charger)

    local counter = 0

    repeat

        os.sleep(0.5)
        counter = counter + 0.5
        if (counter > 60) then
        sender("Error! charging failed")
        mis.fail()
        break
        end

    until computer.energy() / computer.maxEnergy() > 0.99

    mis.afterCharge()
    obj.eC.dropEvent("charging")
    obj.eC.restoreTimers(reserveParams.timers)
    obj.eC.restoreEvents(reserveParams.events)
    mis.restoreCondition()

end


end