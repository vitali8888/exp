return function()

local computer = require("computer")
local counter = 0
local class = require("class/singleton")
local sender = require ("actions/messageSender")
obj = class.new()
local mis = obj.mission

repeat

        os.sleep(0.5)
        counter = counter + 0.5
        if (counter > 60) then
        sender("Error! charging failed")
        mis.fail("charging")
        return false
        end

until computer.energy() / computer.maxEnergy() > 0.99

end