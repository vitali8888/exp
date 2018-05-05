--not for using, just for example

local mission = {}


function mission.barrier(direction)
--returns true if not moving

function mission.saveCondition()
--saves coords and some data before events handles
--nothing returns

function mission.fail()
--some actions when error happens

function mission.afterCharge()
--some actions after visit charger

function mission.restoreCondition()
function mission.start()
function mission.afterDrop()
function mission.afterEquip()
function mission.getProgress()
-- get progress of mission

function mission.getName()

function mission.close()
--close mission before new starts
--example: cleaning point "lastaction"
--be sure do it before obj.mission = "new mission"




return mission