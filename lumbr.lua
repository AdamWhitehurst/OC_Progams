local TREE_WIDTH = 1
local robot = require('robot')
local component = require('component')
local sides = require('sides')
local geo = component.geolyzer
local nav = component.navigation

local startPos = nav.getPosition()

function init ()

	-- TODO: Find Trunk
  -- TODO: scan tree trunk for dimensions

  loop()
end

function loop()
  -- TODO: checkInventory()

  local blocksHarvested = harvestLayer()
  -- if blocksHarvested then
  --   if detectBlock(sides.up, 'minecraft:leaves') then
  --     robot.swingUp()
  --   end

  --   moveToNextLayer()
  -- else
  --   returnToBase()
  -- end
end

-- Harvests a whole layer of the tree
-- Returns whether any blocks were 
-- successfully harvested
function harvestLayer()
  local success = false

	for i = 1, 4 do
		success = harvestWidth()
		robot.forward()
		robot.turnLeft()
	end

  return success
end

-- Harvests a line of logs
-- Returns whether any blocks were
-- successfully harvested
function harvestWidth()
  local success = false

	for x = 0, TREE_WIDTH do
		if logFound() then
			if harvestLog() then
        success = true
      end
		end

		robot.turnRight()
		robot.forward()
		robot.turnLeft()
	end

  return success
end

-- Returns whether a log block is in front
-- of the robot
function logFound()
	if robot.detect() then
		local analysis = geo.analyze(sides.front)
		if analysis.name == 'minecraft:log' then
			return true
		end
	end

	return false
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

init()