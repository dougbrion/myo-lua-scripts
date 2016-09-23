scriptId = 'com.dougbrion.scripts.elitedangerous'
scriptTitle = 'Elite Dangerous Connector'
scriptDetailsUrl = ''

description = [[
Elite Dangerous Script

]]

link = [[ ]]

controls = [[
Controls:

 ]]

knownIssues = [[

]]

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

function navigationPanel()
    myo.keyboard("1", "down")
end

function missionPanel()
    myo.keyboard("4", "down")
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
            navigationPanel()

        elseif pose == "waveOut" then
            missionPanel()

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
-- Only activate when playing Elite Dangerous


function onForegroundWindowChange(app, title)
    --if platform == "MacOS" then
        --return true

    --elseif platform == "Windows" and app == "EliteDangerous32.exe" then
        return true
    --end
end
