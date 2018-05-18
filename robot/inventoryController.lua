local class = {}
local robot = require("robot")
local filesystem = require ("filesystem")
local shell = require ("shell")

class.internalDB = {}
class.inventorySize = robot.inventorySize()
class.materials = {}

    --init
function class.init()
    class.wd = shell.getWorkingDirectory()
    if filesystem.exists(class.wd.."/reserveData/inventory") then
        local file = io.open("reserveData/inventory", "r")
        for i = 1, class.inventorySize do
            local temp = file:read()
            local j = 1
            local arr = {}
            if type(temp) == "string" then
                for w in string.gmatch(temp, "%S+") do
                    arr[j] = w
                    j = j+1
                end
                internalDB[arr[1]] = arr[2]
            end

        end
        file:close()
    end
end


function class.calcMaterial(material)
    local selected = robot.select()
    local materials = 0

    for i=1, robot.inventorySize() do
        robot.select(i)
        materials = materials + robot.count()
    end
    robot.select(selected)
    return materials
end

function class.saveCondition()

    local file = io.open("reserveData/inventory", "w")

    for key, value in pairs(class.internalDB) do
        file:write(tostring(key).." "..tostring(value).."\r\n")
    end

    file:close()

end

function class.hasEmptySlot(material)
    local selected = robot.select()

    for i=1, class.inventorySize() do
        robot.select(i)
        if robot.count() == 0 then return true end
    end
    robot.select(selected)
    return false
end

function class.selectEmptySlotFor(material)

    local selected = robot.select()

    for i=1, class.inventorySize do
        robot.select(i)
        if (class.internalDB[i] == material) and (robot.count() == 0) then
        return true end
    end

    robot.select(selected)
    return false
end

function class.countSlots(material)
    local counter = 0
    for i = 1, class.invetorySize do
        if class.internalDB[i] == material then counter = counter + 1 end
    end
    return counter
end

function class.selectNotEmptySlotFor(material)

    local selected = robot.select()

    for i = 1, class.inventorySize do
        robot.select(i)
        if class.internalDB[i] == material and robot.count() ~= 0 then
        return true end
    end
    robot.select(selected)
    return false
end

function class.dropAll(material)
    local selected = robot.select()

    for i = 1, class.inventorySize do
        if (class.internalDB[i] == material) then
            robot.select(i)
            robot.dropDown()
        end
    end

    robot.select(selected)
end

function class.fillAll(material)
    local selected = robot.select()

    for i = 1, class.inventorySize do
        if class.selectEmptySlotFor(material) == true then
            robot.suckDown()
            else
            break
        end
    end

    robot.select(selected)
end

function class.selectEmptySlot()
    local selected = robot.select()

    for i=1, class.inventorySize do
        robot.select(i)
        if count == 0 then return true end
    end

    robot.select(selected)
    return false
end

function class.setSlotFor(slot, material)
    class.internalDB[slot] = material
end



return class