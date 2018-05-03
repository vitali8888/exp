local function me(...)


local class = require ("class/singleton")
obj = class.new()

local test = obj.pC.points

for key, value in pairs(test) do
    print(key)
    for key, value2 in pairs(value) do
    print (key.."--"..value2)
    end
end


end

return me