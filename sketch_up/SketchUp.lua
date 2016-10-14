scriptId = 'com.dougbrion.scripts.sketchup'
scriptTitle = 'Sketch Up Connector'
scriptDetailsUrl = ''

description = [[

]]

link = [[

]]

controls = [[

]]

knownIssues = [[

]]

-------------------------------------------
-- Variables and Constants

zoomVal = 0

-------------------------------------------
-- Helper Functions

function activeAppName()
	return scriptTitle
end

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

function getMyoRollDegrees()
    local rollValue = math.deg(myo.getRoll())
    return rollValue
end

function degreeDiff(value, base)
    local diff = value - base

    if diff > 180 then
        diff = diff - 360
    elseif diff < -180 then
        diff = diff + 360
    end

    return diff
end

-------------------------------------------
-- User Functions

function zoomIn()
	myo.mouseScrollBy(zoomVal)
end

function zoomOut()

end



-------------------------------------------
-- Myo Poses

function onPoseEdge(pose, edge)
	local time = myo.getTimeMilliseconds()

	-- Zoom in/out
	if pose == "fist" then
		zoomActive = edge == "on"
		rollReference = getMyoRollDegrees()
		zoomSince = time
		myo.unlock(edge == "on" and "hold" or "timed")
		myo.notifyUserAction()
	end

end

SHUTTLE_CONTINUOUS_TIMEOUT = 800
SHUTTLE_CONTINUOUS_PERIOD = 250

FAST_ZOOM_THRESHOLD = 34 -- degrees
FAST_ZOOM_PERIOD = 100

SLOW_ZOOM_THRESHOLD = 11.5 -- degrees
SLOW_ZOOM_PERIOD = 330

-------------------------------------------
-- Myo Data

function onPeriodic()
	local time = myo.getTimeMilliseconds()

	if zoomActive then
        local relativeRoll = degreeDiff(getMyoRollDegrees(), rollReference)
        if math.abs(relativeRoll) > FAST_ZOOM_THRESHOLD then
            if time - zoomSince > FAST_ZOOM_PERIOD then
                if relativeRoll > 0 then
                    zoomIn()
                else
                    zoomOut()
                end
                zoomSince = time
            end
        elseif math.abs(relativeRoll) > SLOW_ZOOM_THRESHOLD then
            if time - zoomSince > SLOW_ZOOM_PERIOD then
                if relativeRoll > 0 then
                    zoomIn()
                else
                    zoomOut()
                end
                zoomSince = time
            end
        end
    end
end
