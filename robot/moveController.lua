local me = {}

me.goal = {}
me.maxAttempts = 7
me.range = 15
me.directions = {}
me.directions.xp = 5
me.directions.xn = 4
me.directions.zp = 3
me.directions.zn = 2
me.facings = {}
me.facings[2] = "zn"
me.facings[3] = "zp"
me.facings[4] = "xn"
me.facings[5] = "xp"

local class = require("class/singleton")
local sender = require("actions/messageSender")
local robot = require ("robot")
obj = class.new()

function me.moveTo(pos) --table (pos.x, pos.y, pos.z) relative position
    me.goal = pos
    if (obj.pC.checkRange(pos) == false)
        then
            sender("Error! goal for move is out of range!")
            do return end
        end

    local currentPos = {}
    currentPos = obj.pC.getRelativePosition()
    local attempt = 0

    repeat
        currentPos = obj.pC.getRelativePosition()
        me.moveY(nil)
        me.moveX(nil)
        me.moveZ(nil)
        newCurrentPos = obj.pC.getRelativePosition()

        if (currentPos.x == newCurrentPos.x and currentPos.y == newCurrentPos.y and currentPos.z == newCurrentPos.z)
            then
                if (attempt == me.maxAttempts)
                    then
                    sender("Error! robot stuck")
                    break
                end
                me.bypass(attempt)
                attempt = attempt + 1
            end

    until me.checkGoal()

end

function me.bypass(mp)

    local math = require ("math")
    local lower = math.floor(0 - me.range*(1/(me.maxAttempts - mp)))
    local upper = 0 - lower

    me.moveY(math.random(lower, upper))
    me.moveX(math.random(lower, upper))
    me.moveZ(math.random(lower, upper))

end

function me.checkGoal()
    local pos = obj.pC.getRelativePosition()

    if (pos.x == me.goal.x and pos.y == me.goal.y and pos.z == me.goal.z)
        then
            return true
        end
    return false
end


function me.moveY(Y)
    local currentPos = {}
    currentPos = obj.pC.getRelativePosition()
    if (Y == nil) then Y = me.goal.y - currentPos.y end

    if (Y == 0) then return true end

    if (Y > 0) then
            for i=1, Y do
                if robot.up() == nil then
                        if (obj.mission.barrier("up")) then
                            do return end
                        end

                end
            end
    elseif (Y < 0) then
        Y = 0 - Y
        for i=1, Y do
            if robot.down() == nil then
                if (obj.mission.barrier("down")) then
                     do return end
                end
            end
        end

    end

end

function me.moveX(X)
    local currentPos = {}
    currentPos = obj.pC.getRelativePosition()
    if (X == nil) then X = me.goal.x - currentPos.x end

    if (X == 0) then return true end

    if (X < 0)
        then
        me.turnTo("xn")
        X = 0 - X
        else
        me.turnTo("xp")
        end

    for i=1, X do
        if robot.forward() == nil then
            if (obj.mission.barrier("straight")) then
                do return end
            end
        end
    end

end

function me.moveZ(Z)
    local currentPos = {}
    currentPos = obj.pC.getRelativePosition()
    if (Z == nil) then Z = me.goal.z - currentPos.z end

    if (Z == 0) then return true end


    if (Z < 0)
        then
        me.turnTo("zn")
        Z = 0 - Z
        else
        me.turnTo("zp")
        end

    for i=1, Z do
        if robot.forward() == nil then
                    if (obj.mission.barrier("straight")) then
                        do return end
                    end
        end
    end
end

function me.moveToRP(pos)
    local rp = {}
    rp = obj.pC.positionToRelative(pos)
    me.moveTo(rp)
end

function me.turnTo(direction) -- xp = x positive...
    if (direction ~= "xp" or direction ~= "xn" or direction ~= "zp" or direction ~= "zn") then return false end
    local facing = me.directions[direction]
    local curFacing = obj.pC.getFacing()
    if (curFacing == facing) then return true end

    if(string.sub(direction, 1, 1) == string.sub(me.facings[curFacing], 1, 1)) then
        robot.turnAround()
        return true
    end

    if  (string.sub(direction, 1, 1) == "x" and string.sub(direction, 2, 2) ~= string.sub(me.facings[curFacing], 2, 2))
        or (string.sub(direction, 1, 1) ~= "x" and string.sub(direction, 2, 2) == string.sub(me.facings[curFacing], 2, 2))
        then
        robot.turnLeft()
        else
        robot.turnRight()
    end

    return true
end



return me

