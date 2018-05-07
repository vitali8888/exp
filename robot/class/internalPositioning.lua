local class = {}

class.posFrom = {}
class.posTo = {}
class.zoneLength = nil
class.zoneWidth = nil
class.zoneDepth = nil
class.maxHeight = nil
class.upsidedown = nil -- Time Part I 19:38 :)
class.balance = nil
class.layers = {}
class.topLayer = nil



function class.init(posFrom, posTo, maxHeight, upsidedown) --relative coords, number, boolean
    class.posFrom = posFrom
    class.posTo = posTo
    class.zoneLength = posTo.z - posFrom.z + 1
    class.zoneWidth = posTo.x - posFrom.x + 1
    class.zoneDepth = posTo.y - posFrom.y + 1
    class.maxHeight = maxHeight
    class.balance = class.getBalance(class.zoneDepth, class.maxHeight)
    class.upsidedown = upsidedown

    if (upsidedown) then
       local y = class.posFrom.y
        class.posFrom.y = class.posTo.y
        class.posTo.y = y
    end

    class.calcLayers()


end

function class.toInternal(pos) --relative coords
    local ipos = {}
    ipos.x = pos.x - class.posFrom.x
    ipos.y = pos.y - class.posFrom.y
    ipos.z = pos.z - class.posFrom.z

    if (ipos.x >= class.zoneWidth or ipos.z >= class.zoneLength or ipos.y >= class.zoneDepth + maxHeight) then
        print("out of working zone, upper")
        return false
    end

    if (ipos.x < 0 or ipos.z < 0 or ipos.y + maxHeight < 0) then
        print("out of working zone, lower")
        return false
    end
    return ipos
end

function class.toRelative(pos) --internal coords
    local rpos = {}
    rpos.x = pos.x + class.posFrom.x
    rpos.y = pos.y + class.posFrom.y
    rpos.z = pos.z + class.posFrom.z

    return rpos
end

function class.getBalance(Depth, maxHeight)
    local math = require ("math")
    local floor = math.floor(Depth/maxHeight)
    local balance = Depth - floor
    balance = math.abs(balance)
    return balance
end

function class.getInt(a, b)
    local math = require("math")
    local floor = math.floor(a/b)
    floor = math.abs(floor)
    return floor
end

function class.getDirection(pos) --relative

    local ipos = class.toInternal(pos)
    local layerID = class.findLayerByPos()
    local direction = nil

    if (layerID == class.topLayer and pos.x == posTo.x and pos.y == posTo.y) then return "mission ends" end

    if (pos.x == posTo.x and pos.z == posTo.z and class.isEven(layerID) == false) then return "changelayer" end
    if (pos.x == posFrom.x and pos.z == posFrom.z and class.isEven(layerID) == true) then return "changelayer" end

    if (pos.x == posTo.x and class.isEven(ipos.z) == true) or (pos.x == posFrom.x and class.isEven(ipos.z) == false) then direction = "zp" end
    if (pos.x == posFrom.x and class.isEven(ipos.z) == true) then direction = "xp" end
    if (pos.x == posTo.x and class.isEven(ipos.z) == false) then direction = "xn" end

    if (class.isEven(layerID)) then direction = class.invertDirection(direction) end

    return direction
end

function class.changeLayer(func, atm)

    local move = nil
    local robot = require("robot")

    if (class.upsidedown) then
        move = robot.down()
        else
        move = robot.up()
    end


    if (atm) then
        for i=1, class.maxHeight do
            func()
            move()
        end

        else
        for i=1, class.maxHeight do
            move()
            func()
        end
    end

end

function class.getStartWorkingHeight()

    local depth = class.zoneDepth --virtual depth

    if class.balance ~= 0 then
        depth = class.zoneDepth + class.maxHeight - class.balance
    end

    if (class.upsidedown) then
        startY = class.posTo.y + depth - 2
        else
        startY = class.posFrom.y + 1
    end

    return startY --relative
end

function class.calcLayers()

    local var = class.getInt(class.zoneDepth, class.maxHeight)
    if (class.balance > 0) then var = var + 1 end
    local segment = class.maxHeight
    if (class.upsidedown)  then segment = 0 - class.maxHeight end
    local startWorkingHeight = class.getStartWorkingHeight()


    for i=1, var do
        local a = {}
        a.workingHeight = startWorkingHeight + (segment*(i-1))

        if (i == var and class.balance ~= 0)
            then a.thickness = class.balance
            else a.thickness = class.maxHeight
        end

        a.startY = class.posFrom.y + (segment*(i-1))

        a.toY = a.startY + a.thickness
        if (class.upsidedown) then a.toY = a.startY - a.thickness end

        class.layers[i] = a
        class.topLayer = i
    end

end

function class.findLayerByPos(pos)

    local y = pos.y
    for key,value in pairs(class.layers) do

    if (y <= value.startY and y >= value.toY) or (y >= value.startY and y <= value.toY)
        then return key end
    end

    return false
end

function class.doAction(actions)

    local class = require("class/singleton")
    local pos = nil
    obj = class.new()
    pos = obj.pC.getRelativePosition()
    layerID = class.findLayerByPos(pos)

    if (layerID == false) then print("Error! pos fail") end
    layer = class.layers[layerID]

    for i=1, layer.thickness do
        local aa = actions[i]
        aa()
    end
end

function class.getDistToBorder(pos)
    local ipos = class.toInternal(pos)
    local layerID = class.getLayerByPos(pos)
    local dist = 1

    if layerID == false then print("Error! out of wz!") end
    layer = class.layers[layerID]
    if (isEven(layer) and isEven(ipos.x)) or (isEven(layer) == false and isEven(ipos.x) == false) then dist = class.posFrom.x - pos.x
        else
        dist = class.posTo.x - pos.x
    end

    if dist < 1 then dist = 1 end

    return dist

end


function class.positionAdjustment(pos)

    local newPos = {}

    if (pos == nil) then
        newPos.x = class.posFrom.x
        newPos.z = class.posFrom.z
        newPos.y = class.getStartWorkingHeight()

        return newPos
    end

    if (pos.x > class.posTo.x or pos.x < class.posFrom.x)
        then
        print("Error! invalid position (x)")
        return false
    end

    if (pos.z > class.posTo.z or pos.z < class.posFrom.z)
        then
        print("Error! invalid position (z)")
        return false
    end

    local layer = class.findLayerByPos(pos)

    if (layer == false) then print ("Error! invalid position (y)") return false end

    layer = class.layers[layer]

    pos.y = layer.workingHeight

    return pos

end

function class.invertDirection(direction)
    if (direction == "xp") then return "xn" end
    if (direction == "xn") then return "xp" end
    if (direction == "zp") then return "zn" end
    if (direction == "zn") then return "zp" end

    print ("Error! direction fail")
    return direction
end

function class.isEven(num)
    if (class.getBalance(num, 2) == 0) then return true end
    return false
end

return class