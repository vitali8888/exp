local component = require("component")

local geo = component.geolyzer
--[[
local address = ''

for key, value in pairs(component.list()) do
    --print ("key: " .. key .. " value: " .. value)
    if value == "geolyzer" then address = key end
end

--[[
local tableOfMethods = component.methods(address);

for key, value in pairs(tableOfMethods) do
    print ("key: " .. key)
end


for key, value in pairs(geo) do
    print (key)
end


local doc = component.doc(address, "scan")
print (doc)
--]]

local tableOne = geo.scan(0, 0)
local tableTwo = geo.scan(1, 0)

for key, value in pairs(tableOne) do
    print("key: " .. key .. " value: " .. value)
end



