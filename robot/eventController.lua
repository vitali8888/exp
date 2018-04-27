local obj = {}

    local events = {}

    obj.__index = obj

    function obj.new(...)
        if obj._instance then
            return obj._instance
        end

        local instance = setmetatable({}, obj)
        if instance.ctor then
            instance.ctor(...)
        end

        obj._instance = instance
        return obj._instance
    end




    function obj.addEvent(name, signal, handler)

        events[name] = {}
        events[name].signal = signal
        events[name].handler = handler

        local eventHandler = require ("eventHandler/"..handler)

        local event = require ("event")
        event.listen(signal, eventHandler)


    end

    function obj.dropEvent(name)

        local event = require("event")

        event.ignore(events[name].signal, events[name].handler)
        events[name] = nil

    end

    function obj.dropAllEvents()

        local event = require ("event")

            for key,value in pairs(events) do
                event.ignore(value["signal"], value["handler"])
            end

        events = nil

    end

return obj
