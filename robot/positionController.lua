local me = {}

local shell = require("shell")

me.correction = {}
me.validThings = {"toolchest", "lootchest", "charger", "lastaction", "borderfirst", "bordersecond"}
me.points = {}
me.wD = shell.getWorkingDirectory()

function me.init()
    local sender = require("actions/messageSender")
    local filesystem = require ("filesystem")
    local component = require("component")
    for key,value in pairs(me.validThings) do
        if (filesystem.exists(me.wD.."/reserveData/"..value) == true)
            then
             local file = io.open("reserveData/"..value, "r")
             me.points[value].x = file:read()
             me.points[value].y = file:read()
             me.points[value].z = file:read()
        end
    end

    if (filesystem.exists(me.wD.."/reserveData/correction") == true)
        then
        local file = io.open("reserveData/correction", "r")
        if (component.navigation.address == file:read())
            then
            me.correction.x = file:read()
            me.correction.y = file:read()
            me.correction.z = file:read()
            else
                sender("navigation upgrade has been changed, need to set real position")
                print("navigation upgrade has been changed, need to set real position")
        end
        else
         sender("need to set real position")
         print("need to set real position")
    end

end

function me.clearSavedPositions()
    local filesystem = require ("filesystem")
    for key, value in pairs(me.validThings) do
        filesystem.remove(me.wD.."/reserveData/"..value)
    end
    me.points = {}
    print("all saved positions has been deleted")
end

function me.cSP(name)
    local filesystem = require("filesystem")
    if me.validateThing(name) == true then
        filesystem.remove(me.wD.."/reserveData/"..name)
        print("saved position "..name.."has been deleted")
        me.points[name] = nil
    end





end

function me.validateThing(Thing)
    for key, value in pairs(me.validThings) do
        if value == Thing then return true end
    end
    return false
end

function me.setPosition(pos, Thing)
    local sender = require ("actions/messageSender")
    if me.validateThing == false then sender("Error! invalid name of point for set position") do return end end
    local rp = me.positionToRelative(pos)
    if me.checkRange(rp) == false then sender("Error! position is out of range NU") do return end end
    me.points[Thing] = rp

    local file = io.open("reserveData/"..Thing, "w")
    file:write(tostring(rp.x).."\r\n")
    file:write(tostring(rp.y).."\r\n")
    file:write(tostring(rp.z).."\r\n")
    file:close()

end

function me.setRealPosition(pos)
    local component = require ("component")
    local sender = require ("actions/messageSender")

    local rp = {}
    rp = me.getRelativePosition()
    if (rp.x == nil or rp.y == nil or rp.z == nil) then sender("Error! out of the navigation range!") do return end end

    me.correction.x = pos.x - rp.x
    me.correction.y = pos.y - rp.y
    me.correction.z = pos.z - rp.z

    local file = io.open("reserveData/correction", "w")
    file:write(component.navigation.address.."\r\n")
    file:write(tostring(me.correction.x).."\r\n")
    file:write(tostring(me.correction.y).."\r\n")
    file:write(tostring(me.correction.z).."\r\n")
    file:close()

end

function me.getRelativePosition()
    local component = require ("component")
    local x, y, z, str = component.navigation.getPosition()

    local pos = {}
    pos.x = x
    pos.y = y
    pos.z = z

    return pos
end

function me.getPosition()
    local sender = require ("actions/messageSender")
    local rp = {}
    rp = me.getRelativePosition()
    if (rp.x == nil or rp.y == nil or rp.z == nil) then sender("Error! out of the navigation range!") do return end end
    if (me.correction.x == nil or me.correction.y == nil or me.correction.z == nil) then sender("Error! need to correct position!") do return end end

    local pos = {}
    pos.x = rp.x + me.correction.x
    pos.y = rp.y + me.correction.y
    pos.z = rp.z + me.correction.z

    return pos

end

function me.getFacing()
    local component = require ("component")
    local x = component.navigation.getFacing()
    return x
end

function me.positionToRelative(pos) --transform real position to relative (table)
    local sender = require ("actions/messageSender")
    if (me.correction.x == nil or me.correction.y == nil or me.correction.z == nil) then sender("Error! need to correct position!") do return end end
    if (pos.x == nil or pos.y == nil or pos.z == nil) then sender("Error! there is no real position!") do return end end

    local rp = {}
    rp.x = pos.x - me.correction.x
    rp.y = pos.y - me.correction.y
    rp.z = pos.z - me.correction.z

    return rp
end

function me.checkRange(pos) --table relative position
    local component = require ("component")
    local positive = component.navigation.getRange()
    local negative = 0 - positive

    for key, value in pairs(pos) do
        if (value > positive or value < negative)
            then return false end
        return true
    end
end

return me