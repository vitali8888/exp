local me = {}

function oswget(data)
    os.execute("wget -f https://raw.githubusercontent.com/OrlaithMichael/-experimental/master/"..data)
end

function osmkdir(data)
    os.execute("mkdir "..data)
end

function osmv(data1, data2)
    os.execute("wget -f https://raw.githubusercontent.com/OrlaithMichael/-experimental/master/"..data2)
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
    osmkdir("robot/actions")
    osmkdir("robot/reserveData")
    osmkdir("robot/missions")


    print ("getting and moooving data")

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
    osmv("following", "tablet/following")
    osmv("messageSender.lua", "robot/actions/messageSender.lua")
    osmv("getrelativeposition.lua", "robot/command/getrelativeposition.lua")
    osmv("getrange.lua", "robot/command/getrange.lua")
    osmv("getfacing.lua", "robot/command/getfacing.lua")
    osmv("positionController.lua", "robot/positionController.lua")
    osmv("setrealposition.lua", "robot/command/setrealposition.lua")
    osmv("getposition.lua", "robot/command/getposition.lua")
    osmv("moveto.lua", "robot/command/moveto.lua")
    osmv("moveController.lua", "robot/moveController.lua")
    osmv("here.lua", "robot/command/here.lua")
    osmv("setposition.lua", "robot/command/setposition.lua")
    osmv("test.lua", "robot/command/test.lua")
    osmv("clearsavedpositions.lua", "robot/command/clearsavedpositions.lua")
    osmv("isworkingzone.lua", "robot/command/isworkingzone.lua")
    osmv("setworkingzone.lua", "robot/command/setworkingzone.lua")
    osmv("recalcworkingzone.lua", "robot/command/recalcworkingzone.lua")
    osmv("digAll.lua", "robot/missions/digAll.lua")
    osmv("waitingForOrder.lua", "robot/missions/waitingForOrder.lua")
    osmv("mission.lua", "robot/command/mission.lua")
    osmv("autocharge.lua", "robot/eventHandler/autocharge.lua")
    osmv("chargingmessage.lua", "robot/eventHandler/chargingmessage.lua")
    osmv("autocharge.lua", "robot/command/autocharge.lua")
    osmv("enableAutoCharge.lua", "robot/actions/enableAutoCharge.lua")
    osmv("startmission.lua", "robot/command/startmission.lua")
    osmv("charge.lua", "robot/actions/charge.lua")
    osmv("dropLoot.lua", "robot/actions/dropLoot.lua")
    osmv("enableAutoDrop.lua", "robot/actions/enableAutoDrop.lua")
    osmv("enableAutoEquip.lua", "robot/actions/enableAutoEquip.lua")
    osmv("autodrop.lua", "robot/eventHandler/autodrop.lua")
    osmv("autoequip.lua", "robot/eventHandler/autoequip.lua")
    osmv("info.lua", "robot/command/info.lua")
    osmv("internalPositioning.lua", "robot/class/internalPositioning.lua")
    osmv("pausemission.lua", "robot/command/pausemission.lua")
    osmv("connect.lua", "robot/command/connect.lua")

    print("deleting data")

    osrm("tablet/turnaround")

end

return me