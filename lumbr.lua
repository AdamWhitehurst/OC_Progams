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
  -- TODO: checkInventory()

  local blocksHarvested = harvestWoodLayer()
  if blocksHarvested then
    if detectBlock(sides.up, 'minecraft:leaves') then
      robot.swingUp()
    end

    moveToNextLayer()
  else
    returnToBase()
  end
end

-- Harvests a whole layer of the tree.
-- Ends at same pos, orient as start.
-- Returns whether any blocks were 
-- successfully harvested
function harvestWoodLayer()
  local success = false

	for i = 1, 4 do
		success = harvestWoodLine()

    -- TODO: Handle failures
		robot.forward()
		robot.turnLeft()
	end

  return success
end

-- Harvests a line of logs
-- Returns whether any blocks were
-- successfully harvested
function harvestWoodLine()
  local success = false
  -- Why the hell are LUA for-loops inclusive?
	for x = 1, TREE_WIDTH do 
		if logFound() then
			if harvestLog() then
        success = true
      end
		end

    -- TODO: Handle failures
		robot.turnRight()
		robot.forward()
		robot.turnLeft()
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
  local detectSuccessful = false

  if side == sides.up then
    detectSuccessful = robot.detectUp()
  elseif side == sides.front then
    detectSuccessful = robot.detect()
  end

  if detectSuccessful then
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
  while y != 
end

init()