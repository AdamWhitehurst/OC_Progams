
-- Define the width of the tree's trunk
local TREE_WIDTH = 1
local component = require('component')
local sides = require('sides')
local geo = component.geolyzer

function init ()
	-- Equip Axe
	-- Find Trunk
	harvestLoop()
end

function harvestLoop()
	for i = 1, 4 do
		harvestWidth()
		robot.forward()
		robot.turnLeft()
	end

	robot.up()
end

function harvestWidth()
	for x = 0, TREE_WIDTH do
		if logFound() then
			harvestLog()
		end

		robot.turnRight()
		robot.forward()
		robot.turnLeft()
	end
end

function logFound()
	if robot.detect() then
		local analysis = geo.analyze(sides.front)
		if analysis.name == 'minecraft:log' then
			return true
		end
	end

	return false
end

-- Once we've detected a log in front of us, harvest it
function harvestLog()
	robot.swing()
end


init()