local me = {}

me.correction = {}

function me.setRealPosition(pos)
    local component = require ("component")
    local sender = require ("actions/messageSender")

    local rp = {}
    rp = me.getRelativePosition()
    if (rp.x == nil or rp.y == nil or rp.z == nil) then sender("Error! out of the navigation range!") do return end end

    me.correction.x = pos.x - rp.x
    me.correction.y = pos.y - rp.y
    me.correction.z = pos.z - rp.z

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

return me