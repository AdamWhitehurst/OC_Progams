local TREE_WIDTH = 2
local robot = require('robot')
local component = require('component')
local sides = require('sides')
local geo = component.geolyzer
local nav = component.navigation

local startX, startY, startZ = nil

function init ()

	-- TODO: Find Trunk
  -- TODO: scan tree trunk for dimensions
  startX, startY, startZ = nav.getPosition()
  loop()
end

function loop()
  local shouldEnd = false
  while not shouldEnd do
    -- TODO: checkInventory()

    local harvestSuccess = harvestWoodLayer()
    if harvestSuccess then
      if detectBlock(sides.up, 'minecraft:leaves') then
        robot.swingUp()
      end

      moveToNextLayer()
    else
      shouldEnd = true
      returnToBase()
    end
  end
end

-- Harvests a whole layer of the tree.
-- Ends at same pos, orient as start.
-- Returns true if any blocks were 
-- successfully harvested; false if none
-- or failed to move forward.
function harvestWoodLayer()
  local success = false

	for i = 1, 4 do
		if harvestWoodLine() then
      success = true
    end

    if not tryForward() then
      success = false
      return success -- Abort
    end

		robot.turnLeft()
	end

  return success
end

-- Harvests a line of logs
-- Returns true if any blocks were
-- harvested; false if none or failed to harvest
-- full line
-- TODO: return failure string?
function harvestWoodLine()
  local success = false
  -- Why the hell are LUA for-loops inclusive?
	for x = 1, TREE_WIDTH do 
		if logFound() then
			if harvestLog() then
        success = true
      end
		end

    -- try to move over
		robot.turnRight()
    if not tryForward() then
      success = false
      return success -- Abort
    end
		robot.turnLeft()
	end

  return success
end

-- Tries to move robot forward, if can't, it will try
-- to break whatever is in front of it
function tryForward()
  local success = robot.forward()
  -- if we can't move forward, try to break
  -- the block and try again. Can't break:
  -- WTH are you trying to move thru??
  if not success then
    -- save power, don't detect
    robot.swing()

    if robot.forward() then
      success = true
    end
  end

  return success
end

-- Helper function that returns whether a log
-- block is in front of the robot
function logFound()
	return detectBlock(sides.front, 'minecraft:log')
end

-- Once we've detected a log in front of us, try to
-- harvest it. Returns whether this was successful
function harvestLog()
	if robot.swing() then
    robot.suck()
    return true
  end

  return false
end

function moveToNextLayer()
  if robot.up() then
    return true
  end

  return false
end

-- Returns whether the given block id is detected
-- on the given side.
function detectBlock(side, blockID)
  local detectSuccessful = false -- only for detect(), not analyze()

  if side == sides.up then
    detectSuccessful = robot.detectUp()
  elseif side == sides.front then
    detectSuccessful = robot.detect()
  end

  if detectSuccessful then
    local analysis = geo.analyze(side)
    if analysis.name == blockID then
      return true
    end
  end

  return false
end

-- Go back to starting point. For now, simply
-- moves robot down until same y-level as start.
-- TODO: Waypoint-based movement
function returnToBase()
  local x, y, z = nav.getPosition()
  while y ~= startY do
    robot.down()
    y = y - 1
  end
end

init()