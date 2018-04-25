local me = {}

local function oswget(data)
    os.execute("wget -f https://raw.githubusercontent.com/OrlaithMichael/-experimental/master/"..data)
end

local function osmkdir(data)
    os.execute("mkdir data")
end

local function osmv(data1, data2)
    os.execute("mv data1, data2")
end

local function osrm(data)
    os.execute("rm -v data")
end

function me.up()

    oswget(helloworld)
    oswget(tablet/followme)
    osmkdir(tablet)
    osmv(followme, tablet/followme)

    osrm(upgrade-list.lua)
    osrm(download-list)

end

return me