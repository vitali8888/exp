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
    osmkdir("robot/eventHandler")
    osmkdir("robot/class")

    print ("getting data")

    oswget("tablet/turnaround")
    oswget("robot/start")
    oswget("robot/command/turnaround.lua")
    oswget("robot/eventController.lua")
    oswget("robot/eventHandler/tabletmessage.lua")
    oswget("robot/eventHandler/break.lua")
    oswget("robot/class/singleton.lua")
    oswget("robot/command/forward.lua")
    oswget("robot/command/turnleft.lua")
    oswget("robot/command/turnright.lua")
    oswget("robot/command/up.lua")
    oswget("robot/command/down.lua")
    oswget("tablet/command")


    print ("moooving data")

    osmv("turnaround", "tablet/turnaround")
    osmv("start", "robot/start")
    osmv("turnaround.lua", "robot/command/turnaround.lua")
    osmv("eventController.lua", "robot/eventController.lua")
    osmv("tabletmessage.lua", "robot/eventHandler/tabletmessage.lua")
    osmv("break.lua", "robot/eventHandler/break.lua")
    osmv("singleton.lua", "robot/class/singleton.lua")
    osmv("forward.lua", "robot/command/forward.lua")
    osmv("turnleft.lua", "robot/command/turnleft.lua")
    osmv("turnright.lua", "robot/command/turnright.lua")
    osmv("up.lua", "robot/command/up.lua")
    osmv("down.lua", "robot/command/down.lua")
    osmv("command", "tablet/command")

    print("deleting data")

    osrm("tablet/turnaround")

end

return me