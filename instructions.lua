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

    osmkdir("tablet")
    oswget("tablet/turnaround")
    osmv("turnaround", "tablet/turnaround")

    osmkdir("robot")
    oswget("robot/start")
    osmv("start", "robot/start")

end

return me