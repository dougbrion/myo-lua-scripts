scriptId = 'com.dougbrion.scripts.warthunder'
scriptTitle = 'Warthunder Connector'
scriptDetailsUrl = ''

description = [[
Warthunder Script

]]

link = [[ ]]

controls = [[
Controls:

 ]]

knownIssues = [[

 ]]

recoilTime = 0

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
-- Tank Functions

function fireMainGun()
    --myo.vibrate("short")
    myo.mouse("down")
    myo.debug("BANG")
end

function fireSecondGun()
    --myo.keyboard("space", "down")
    myo.debug("RATATATA")
end

function zoom()
    --myo.keyboard("left_shift", "down")
    myo.debug("ZOOM")
end

function cycleAmmoForwards()
    --myo.mouseScrollBy("1")
    myo.vibrate("short")
end

function cycleAmmoBackwards()
    --myo.mouseScrollBy("-1")
    myo.vibrate("short")
end

function clutch()
    onLock()
end

-------------------------------------------
-- Myo Accelerometer

function onPeriodic()

    local x,y,z = myo.getAccel()

    currentTime = myo.getTimeMilliseconds()

    if (x < -1.0 and recoilTime < currentTime - 1000) then
        recoilTime = currentTime
        fireMainGun()
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
            fireSecondGun()

        elseif pose == "waveIn" then
            cycleAmmoForwards()

        elseif pose == "waveOut" then
            cycleAmmoBackwards()

        elseif pose == "doubleTap" then
            zoom()

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
myo.unlock("hold")


function onLock()
    myo.controlMouse(false)
end

function onUnlock()
    myo.controlMouse(true)
end

---------------------------------------
-- Only activate when playing Warthunder


function onForegroundWindowChange(app, title)

        return true

end
