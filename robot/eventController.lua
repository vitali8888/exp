local me = {}

local events = {}

function me.add(name, signal, handler)

    events[name] = {}
    events[name].signal = signal
    events[name].handler = handler

    local eventHandler = require ("eventHandler/"..handler)

    local event = require ("event")
    event.listen(signal, "eventHandler.do")

    return eventHandler

end

function me.drop(name)

    local event = require("event")

    event.ignore(events[name].signal, events[name].handler)
    events[name] = nil

end

function me.dropAll()

    local event = require ("event")

    for key,value in pairs(events) do
        event.ignore(value["signal"], value["handler"])
    end

    events = nil

end

local classa = require ("class/singleton")
local classb = classa.class.new()
classb.eC = me
return classb
