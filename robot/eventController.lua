local obj = {}

local event = require ("event")
obj.events = {}
obj.timers = {}

function obj.addEvent(name, signal, handler)

    obj.events[name] = {}
    obj.events[name].signal = signal

    local eventHandler = require ("eventHandler/"..handler)

    obj.events[name].handler = eventHandler
    obj.events[name].handlerstr = handler
    event.listen(signal, eventHandler)

end

function obj.dropEvent(name)

    if (obj.events[name] ~= nil) then
        event.ignore(obj.events[name].signal, obj.events[name].handler)
        obj.events[name] = nil
    end

end

function obj.dropAllEvents()

        for key,value in pairs(obj.events) do
           event.ignore(value.signal, value.handler)
        end

    obj.events = {}
end

function obj.addTimer(name, interval, handler)

    local eventHandler = require ("eventHandler/"..handler)
    local math = require ("math")
    local id = event.timer(interval, eventHandler, math.huge)
    obj.timers[name]={}
    obj.timers[name].id = id
    obj.timers[name].interval = interval
    obj.timers[name].handlerstr = handler

end

function obj.dropTimer(name)

    if (obj.times[name] ~= nil) then
        event.cancel(obj.timers[name].id)
        obj.timers[name] = nil
    end
end

function obj.dropAllTimers()
    for key, value in pairs(obj.timers) do
        event.cancel(value.id)
    end

    obj.timers = {}
end

function obj.restoreTimers(timers)
    for key,value in pairs(timers) do
        obj.addTimer(key, value.interval, value.handlerstr)
    end
end

function obj.restoreEvents(events)
    for key,value in pairs(events) do
        obj.addEvent(key, value.signal, value.handlerstr)
    end
end

return obj
