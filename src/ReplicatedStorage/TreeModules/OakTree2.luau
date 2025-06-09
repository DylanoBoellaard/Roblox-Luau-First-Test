-- Looks absolutely beautiful

local TreeGenerator = require(game.ReplicatedStorage.TreeModules.TreeGenerator)

local OakTree = {}

function OakTree.Spawn(position)
	local config = {
		name = "OakTree",
		trunkSize = Vector3.new(2, 10, 2),
		branchingDepth = 3,
		branchesPerLevel = 2,
		minRotation = Vector3.new(-40, 0, -40),
		maxRotation = Vector3.new(40, 360, 40),
		minScale = Vector3.new(0.4, 0.5, 0.4),
		maxScale = Vector3.new(0.8, 0.9, 0.8),
	}
	TreeGenerator.SpawnProceduralTree(position, config)
end

return OakTree