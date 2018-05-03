local me = {}

me.goal = {}
me.maxAttempts = 7
me.range = 15

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
    if (obj.pC.getFacing() ~= 5)
        then
            repeat
                robot.turnRight()
            until obj.pC.getFacing() == 5
        end

    if (X < 0)
        then
        robot.turnAround()
        X = 0 - X
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
    if (obj.pC.getFacing() ~= 3)
        then
            repeat
                robot.turnRight()
            until obj.pC.getFacing() == 3
        end

    if (Z < 0)
        then
        robot.turnAround()
        Z = 0 - Z
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



return me

