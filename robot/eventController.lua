local me = {}

events = {}

function me.add(name, signal, handler)

    events[name] = {}
    events[name]["signal"] = signal
    events[name]["handler"] = handler

    local eventHandler = require ("eventHandler/"..handler)

    local event = require ("event")
    event.listen(signal, eventHandler.do)

end

function me.drop(name)

    local event = require("event")

    event.ignore(events[name]["signal"], events[name]["handler"])
end

function me.dropAll()

    local event = require ("event")

    for key,value in pairs(events) do
        event.ignore(value["signal"], value["handler"])
    end

    events = nil

end

local class = require ("class/singleton")
setmetatable(me, class)
return me
