--[[
		Spawns an pine tree with configurable branching, scale, and rotation.
		Uses TreeGenerator to spawn the tree.
--]]

local TreeGenerator = require(game.ReplicatedStorage.TreeModules.TreeGenerator)

local PineTree = {}

function PineTree.Spawn(position)
	local config = {
		name = "PineTree",
		trunkSize = Vector3.new(1.5, 12, 1.5),
		branchingDepth = 4,
		branchesPerLevel = 3,
		minRotation = Vector3.new(-10, 0, -10),
		maxRotation = Vector3.new(10, 360, 10),
		minScale = Vector3.new(0.3, 0.4, 0.3),
		maxScale = Vector3.new(0.5, 0.6, 0.5),
		material = Enum.Material.Wood,
		color = Color3.fromRGB(66, 49, 40),
	}
	TreeGenerator.SpawnProceduralTree(position, config)
end

return PineTree
