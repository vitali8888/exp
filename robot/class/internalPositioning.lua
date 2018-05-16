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
class.isInit = false



function class.init(posFrom, posTo, maxHeight, upsidedown, hovering) --relative coords, number, boolean
    class.posFrom = posFrom
    class.posTo = posTo
    class.zoneLength = posTo.z - posFrom.z + 1
    class.zoneWidth = posTo.x - posFrom.x + 1
    class.zoneDepth = posTo.y - posFrom.y + 1
    class.maxHeight = maxHeight
    class.balance = class.getBalance(class.zoneDepth, class.maxHeight)
    class.upsidedown = upsidedown
    class.hovering = hovering

    if (upsidedown) then
       local y = class.posFrom.y
        class.posFrom.y = class.posTo.y
        class.posTo.y = y
    end

    class.calcLayers()
    class.isInit = true

end

function class.toInternal(pos) --relative coords
    local ipos = {}
    ipos.x = pos.x - class.posFrom.x
    ipos.y = pos.y - class.posFrom.y
    ipos.z = pos.z - class.posFrom.z

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
    local balance = Depth - (floor*maxHeight)
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
    local layerID = class.findLayerByPos(pos)
    if layerID == false then return "to wz!" end
    local direction = ""



    if (class.isEven(class.zoneLength-1)) then
        if (pos.x == class.posTo.x and pos.z == class.posTo.z and class.isEven(layerID) == false) then direction = "changelayer" end
        if (pos.x == class.posFrom.x and pos.z == class.posFrom.z and class.isEven(layerID) == true) then direction = "changelayer" end
        else
        if (pos.x == class.posFrom.x and pos.z == class.posTo.z and class.isEven(layerID) == false) then direction = "changelayer" end
        if (pos.x == class.posFrom.x and pos.z == class.posFrom.z and class.isEven(layerID) == true) then direction = "changelayer" end
    end

    if direction == "changelayer" and layerID == class.topLayer then return "mission ends"
        elseif direction == "changelayer" then return "changelayer"
    end




    if (class.isEven(layerID)) then
        if (class.isEven(ipos.z) == true) then direction = "xn" end
        if (class.isEven(ipos.z) == false) then direction = "xp" end
        if (pos.x == class.posFrom.x and class.isEven(ipos.z) == true) or (pos.x == class.posTo.x and class.isEven(ipos.z) == false) then direction = "zn" end

        else
        if (class.isEven(ipos.z) == true) then direction = "xp" end
        if (class.isEven(ipos.z) == false) then direction = "xn" end
        if (pos.x == class.posTo.x and class.isEven(ipos.z) == true) or (pos.x == class.posFrom.x and class.isEven(ipos.z) == false) then direction = "zp" end
    end

    return direction
end

function class.changeLayer(func, atm)

    local move = nil
    local robot = require("robot")

    if (class.upsidedown) then
        move = robot.down
        else
        move = robot.up
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
        startY = class.posTo.y + depth - 1 - class.hovering
        else
        startY = class.posFrom.y + class.hovering
    end

    return startY --relative
end

function class.calcLayers()

    local var = class.getInt(class.zoneDepth, class.maxHeight)
    if (class.balance > 0) then var = var + 1 end
    local segment = class.maxHeight
    if (class.upsidedown)  then segment = 0 - class.maxHeight end
    local startWorkingHeight = class.getStartWorkingHeight()
    local hovering = class.hovering
    if (class.upsidedown) then hovering = 0 - hovering end
    local factor = 1
    if (class.upsidedown) then factor = 0 - 1 end

    for i=1, var do
        local a = {}
        a.workingHeight = startWorkingHeight + (segment*(i-1))

        if (i == var and class.balance ~= 0)
            then a.thickness = class.balance
            else a.thickness = class.maxHeight
        end

        a.startY = startWorkingHeight - hovering + (segment*(i-1))
        a.toY = startWorkingHeight + (segment*i) - factor

        class.layers[i] = a
        class.topLayer = i
    end

    if (class.upsidedown) then
        local temp = 0
        temp = class.layers[1].thickness
        class.layers[1].thickness = class.layers[class.topLayer].thickness
        class.layers[class.topLayer].thickness = temp
    end


end

function class.findLayerByPos(pos)

    local y = pos.y

    for key, value in pairs(class.layers) do
    if (y == value.workingHeight)
            then return key end
    end

    y = y + class.hovering

    for key,value in pairs(class.layers) do
    if ((y - class.hovering) <= value.startY and (y - class.hovering) >= value.toY) or ((y + class.hovering) >= value.startY and (y + class.hovering) <= value.toY)
        then return key end
    end

    return false
end

function class.doAction(actions)

    local classother = require("class/singleton")
    local pos = {}
    obj = classother.new()
    pos = obj.pC.getRelativePosition()
    local layerID = class.findLayerByPos(pos)

    if (layerID == false) then print("Error! pos fail") end
    layer = class.layers[layerID]

    for i=1, layer.thickness do
        local aa = actions[i]
        aa()
    end
end

function class.getDistToBorder(direction, pos)

    local dist = 0

    if direction == "xp" then dist = class.posTo.x - pos.x end
    if direction == "xn" then dist = pos.x - class.posFrom.x end
    if direction == "zn" or direction == "zp" then dist = 1 end

    if dist < 0 then dist = 0 end

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

function class.getVolume()
    local volume = class.zoneLength*class.zoneWidth*class.zoneDepth
    return volume
end

function class.getCurrentVolumeDone(pos)
    if class.positionAdjustment(pos) == false then return false end
    local layerID = class.findLayerByPos(pos)
    if layerID == false then return false end
    local j = layerID - 1
    local volume = 0
    local direction = class.getDirection(pos)
    if direction == "mission ends" then return class.getVolume() end
    if j ~= 0 then
        for i=1, j do
            volume = volume + class.zoneWidth*class.zoneLength*class.layers[i].thickness
        end
    end

    if direction == "changelayer" then
        volume = volume + class.zoneWidth*class.zoneLength*class.layers[layerID].thickness
        return volume
    end


    local ipos = class.toInternal(pos)
    if class.isEven(layerID) then
        volume = volume + class.zoneWidth*(class.zoneLength - ipos.z - 1)*class.layers[layerID].thickness
        else
        volume = volume + class.zoneWidth*(ipos.z-1)*class.layers[layerID].thickness
        end

    if direction == "zp" or direction == "zn" then
        volume = volume + class.zoneWidth*class.layers[layerID].thickness
        return volume
    end

    if direction == "xp" then
        volume = volume + (ipos.x + 1)*class.layers[layerID].thickness
        return volume
    end

    if direction == "xn" then
        volume = volume + (class.posTo.x - pos.x + 1)*class.layers[layerID].thickness
        return volume
    end

    return volume

end

return class