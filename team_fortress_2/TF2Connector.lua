scriptId = 'com.dougbrion.scripts.teamfortress2'
scriptTitle = 'Team Fortress 2 Connector'
scriptDetailsUrl = ''

description = [[
Team Fortress 2 Script

Enjoy playing classic good ol' TF2 with your Myo Armband...the myo does mouse
and weapon control, however you will still need to use WASD to move around.

Have a fab time!
]]

link = [[ ]]

controls = [[
Controls:
 - Move arm around to control where you are looking. (Like using the mouse)
 - Make a fist to shoot/attack.
 - Double Tap to use weapons special power. (eg Scope - Sniper, Airblast - Pyro)
 - Wave in/out to switch between weapons.
 - Hold Fingers Spread pose to clutch mouse control
 - Punch to reload weapon
 ]]

knownIssues = [[
    When running on MacOS the script will always be active as Mac does not
    identify Valve games for some reason...
 ]]

punchTime = 0

function activeAppName()
    return scriptTitle
end

-------------------------------------------
-- Helper Functions
function conditionallySwapWave(pose)
    if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end

function unlatchMouseButtons()
    myo.mouse("left", "up")
    myo.mouse("right", "up")
end

--------------------------------------------
-- Weapon Functions
function cycleWeaponForwards()
    myo.mouseScrollBy("1")
    myo.vibrate("short")
end

function cycleWeaponBackwards()
    myo.mouseScrollBy("-1")
    myo.vibrate("short")
end

function fireWeapon()
    myo.mouse("left", "down")
end

function specialWeapon()
    myo.mouse("right", "down")
end

function reload()
    myo.keyboard("r", "press")
end

function clutch()
    onLock()
end

-------------------------------------------
-- Myo Accelerometer
function onPeriodic()

    local x,y,z = myo.getAccel()

    currentTime = myo.getTimeMilliseconds()

    if (x < -1.0 and punchTime < time - 1000) then
        punchTime = currentTime
        reload()
    end

end

------------------------------------------
-- Myo Poses
function onPoseEdge(pose, edge)

    pose = conditionallySwapWave(pose)

    if edge == "on" and  myo.isUnlocked() then

        if pose == "fingersSpread" then
            clutch()

        elseif pose == "fist" then
            fireWeapon()

        elseif pose == "waveIn" then
            cycleWeaponForwards()

        elseif pose == "waveOut" then
            cycleWeaponBackwards()

        elseif pose == "doubleTap" then
            specialWeapon()

        elseif pose == "rest" then
            onUnlock()
        end

    elseif edge == "off" then
        unlatchMouseButtons()
    end
end

function onActiveChange(isActive)
    myo.unlock("hold")
    myo.controlMouse(isActive)
    myo.mouse("left", "up");
    myo.mouse("right", "up");
end

---------------------------------------
-- Locking Functions
myo.setLockingPolicy("none")

function onLock()
    myo.controlMouse(false)
end

function onUnlock()
    myo.controlMouse(true)
end

---------------------------------------
-- Only activate when playing TF2
function onForegroundWindowChange(app, title)
    if platform == "MacOS" then
        return true

    elseif platform == "Windows" and app == "hl2.exe" then
        return true
    end
end
