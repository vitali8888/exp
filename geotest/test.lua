local component = require("component")

--local geo = component.geolyzer

local address = ''

for key, value in pairs(component.list()) do
    print ("key: " .. key .. " value: " .. value)
    if value == "geolyzer" then address = key end
end

print (address)

