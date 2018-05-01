local function me(...)


local class = require ("class/singleton")
obj = class.new()

local test = obj.pC.points

for key, value in pairs(test) do
    print(key)
    print(value)
end


end

return me