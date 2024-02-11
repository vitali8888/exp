local component = require("component")

local geo = component.geolyzer

clist = component.list()

for key, value in pairs(clist) do
    print ("key: " .. key .. " value: " .. value)
end

