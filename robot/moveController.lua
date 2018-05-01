local me = {}

me.goal = {}
local class = require("class/singleton")
local sender = require("actions/messageSender")
local robot = require ("robot")
obj = class.new()

function me.moveTo(pos) --table (pos.x, pos.y, pos.z) relative position
    me.goal = pos
    if (me.checkRange(pos) == false)
        then
            sender("Error! goal for move is out of range!")
            do return end
        end

    local currentPos = {}
    currentPos = obj.pC.getRelativePosition()

    repeat
        currentPos = obj.pC.getRelativePosition()
        me.moveY()
        me.moveX()
        me.moveZ()
        newCurrentPos = obj.pC.getRelativePosition()

        if (currentPos.x == newCurrentPos.x and currentPos.y == newCurrentPos.y and currentPos.z == newCurrentPos.z)
            then
                sender("Error! robot stuck")
                break
            end

    until me.checkGoal()

end

function me.checkGoal()
    local pos = obj.pC.getRelativePosition()

    if (pos.x == me.goal.x and pos.y == me.goal.y and pos.z == me.goal.z)
        then
            return true
        end
    return false
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

function me.moveY()
    local currentPos = {}
    currentPos = obj.pC.getRelativePosition()
    local Y = me.goal.y - currentPos.y

    if (Y > 0) then
        for i=1, Y do
        if robot.up() == false then return true end
        end
    elseif (Y < 0) then
        Y = 0 - Y
        for i=1, Y do
        if robot.down() == false then return true end
        end
    end

end

function me.moveX()
    local currentPos = {}
    currentPos = obj.pC.getRelativePosition()
    local X = me.goal.x - currentPos.x

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
        if robot.forward() == false then return true end
    end

end

function me.moveZ()
    local currentPos = {}
    currentPos = obj.pC.getRelativePosition()
    local Z = me.goal.z - currentPos.z

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
        if robot.forward() == false then return true end
    end
end

function me.moveToRP(pos)
    local rp = {}
    rp = obj.pC.positionToRelative(pos)
    me.moveTo(rp)
end



return me

