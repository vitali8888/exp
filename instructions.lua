local me = {}

function oswget(data)
    os.execute("wget -f https://raw.githubusercontent.com/OrlaithMichael/-experimental/master/"..data)
end

function osmkdir(data)
    os.execute("mkdir "..data)
end

function osmv(data1, data2)
    os.execute("mv "..data1.." "..data2)
end

function osrm(data)
    os.execute("rm -v "..data)
end

function me.up()


    print("creating directories")

    osmkdir("tablet")
    osmkdir("robot")
    osmkdir("robot/command")

    print ("getting data")

    oswget("tablet/turnaround")
    oswget("robot/start")
    oswget("robot/command/turnaround.lua")


    print ("moooving data")

    osmv("turnaround", "tablet/turnaround")
    osmv("start", "robot/start")
    osmv("turnaround.lua", "robot/command/turnaround.lua")

end

return me