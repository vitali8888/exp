local me = {}

function me.do(qw, qq, qe ,qr)


    if (qr == 197) then
        local eventController = require ("eventController")
        eC = eventController.new()
        eC.dropAll()
    end

end

return me

