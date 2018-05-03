return function ()

    local class = require("class/singleton")
    local sender = require("action/messageSender")
    obj = class.new()

    sender("ok, lets try...")
    obj.mission.start()

end