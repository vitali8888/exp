local class = {}

class.posFrom = {}
class.posTo = {}
class.zoneLength = nil
class.zoneWidth = nil
class.zoneDepth = nil
class.maxHeight = nil
class.upsidedown = nil -- Time Part I 19:38 :)
class.balance = nil



function class.init(posFrom, posTo, maxHeight, upsidedown) --relative coords, number, boolean
    class.posFrom = posFrom
    class.posTo = posTo
    class.zoneLength = posTo.z - posFrom.z + 1
    class.zoneWidth = posTo.x - posFrom.x + 1
    class.zoneDepth = posTo.y - posFrom.y + 1
    class.maxHeight = maxHeight
    class.upsidedown = upsidedown

    if (upsidedown) then
       local y = class.posFrom.y
        class.posFrom.y = class.posTo.y
        class.posTo.y = y
    end

    class.balance = class.getBalance(class.zoneDepth, class.maxHeight)

end

function class.toInternal(pos) --relative coords
    local ipos = {}
    ipos.x = pos.x - class.posFrom.x
    ipos.y = pos.y - class.posFrom.y
    ipos.z = pos.z - class.posFrom.z

    if (ipos.x >= class.zoneWidth or ipos.z >= class.zoneLength or ipos.y >= class.zoneDepth) then
        return false, "out of working zone, upper"
    end

    if (ipos.x < 0 or ipos.z < 0 or ipos.y < 0) then
            return false, "out of working zone, lower"
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
    local float = math.float(Depth/maxHeight)
    local balance = Depth - float
    return balance
end

function class.getHeight(y, depth, ) -- internal

end

function class.getStartPosition(pos)

end



return class