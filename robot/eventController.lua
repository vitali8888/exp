local obj = {}

obj.events = {}

function obj.addEvent(name, signal, handler)

    obj.events[name] = {}
    obj.events[name].signal = signal


    local eventHandler = require ("eventHandler/"..handler)
    local event = require ("event")

    obj.events[name].handler = eventHandler
    event.listen(signal, eventHandler)

end

function obj.dropEvent(name)

    local event = require("event")

    event.ignore(events[name].signal, events[name].handler)
    obj.events[name] = nil

end

function obj.dropAllEvents()

    local event = require ("event")

        for key,value in pairs(obj.events) do
           event.ignore(value.signal, value.handler)
        end

    obj.events = {}
end

return obj
