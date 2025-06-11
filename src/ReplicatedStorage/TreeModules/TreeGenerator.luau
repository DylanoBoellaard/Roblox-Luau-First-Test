-- Use code: require(game.ReplicatedStorage.TreeModules.OakTree2).Spawn(Vector3.new(10, 5, 10)) to spawn a tree (serverside)

--[[
		Spawns procedural trees with configurable branching using a recursive algorithm.
		Each part gets a unique TreeUUID to track related branches and cut lines.
--]]

local Tree = {}

-- Cutline system:
local HttpService = game:GetService("HttpService")

-- Returns a Vector3 with random values between minVec and maxVec
local function randomVector(minVec, maxVec)
	return Vector3.new(
		math.random() * (maxVec.X - minVec.X) + minVec.X,
		math.random() * (maxVec.Y - minVec.Y) + minVec.Y,
		math.random() * (maxVec.Z - minVec.Z) + minVec.Z
	)
end

-- Creates a branch part and welds it to its parent
function Tree.CreateBranch(config, parentPart, parentCFrame, currentDepth, treeFolder)
	local scale = randomVector(config.minScale, config.maxScale)
	local size = parentPart.Size * scale

	local branch = Instance.new("Part")
	branch.Size = size
	branch.Anchored = false
	branch.Name = "Branch"
	branch.Material = config.material or Enum.Material.Wood
	branch.Color = config.color or BrickColor.new("Brown")
	branch:SetAttribute("Health", math.floor((parentPart:GetAttribute("Health") or 100) * 0.75))
	-- Cutline attribute:
	branch:SetAttribute("TreeUUID", HttpService:GenerateGUID(false))

	local parentVal = Instance.new("ObjectValue")
	parentVal.Name = "ParentPart"
	parentVal.Value = parentPart
	parentVal.Parent = branch

	-- Position the branch at the top of the parent with random rotation
	local attachOffset = Vector3.new(0, parentPart.Size.Y / 2, 0)
	local rotation = randomVector(config.minRotation, config.maxRotation)

	branch.CFrame = parentCFrame
		* CFrame.new(attachOffset)
		* CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
		* CFrame.new(0, size.Y / 2, 0) -- move it up by half its size so it hangs down from attach point

	-- Create or reuse branch folder
	local branchFolder = parentPart:FindFirstChild("BranchParts") or Instance.new("Folder")
	branchFolder.Name = "BranchParts"
	branchFolder.Parent = parentPart
	branch.Parent = branchFolder
	-- branch.Parent = treeFolder

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = parentPart
	weld.Part1 = branch
	weld.Parent = branch

	return branch
end

-- Recursively generates branches for a parent part
function Tree.GenerateBranches(config, parentPart, currentDepth, treeFolder)
	if currentDepth >= config.branchingDepth then
		return
	end

	for _ = 1, config.branchesPerLevel do
		local branch = Tree.CreateBranch(config, parentPart, parentPart.CFrame, currentDepth, treeFolder)

		Tree.GenerateBranches(config, branch, currentDepth + 1, treeFolder)
	end
end

-- Spawns a tree at a given position using provided config
function Tree.SpawnProceduralTree(position, config)
	local treeFolder = Instance.new("Folder", workspace.Trees)
	treeFolder.Name = config.name or "ProceduralTree"

	local trunk = Instance.new("Part")
	trunk.Size = config.trunkSize or Vector3.new(2, 10, 2)
	trunk.Position = position
	trunk.Anchored = true
	trunk.Name = "Trunk"
	trunk.Material = config.material or Enum.Material.Wood
	trunk.Color = config.color or BrickColor.new("Brown")
	trunk:SetAttribute("Health", 100)
	-- Cutline attribute:
	trunk:SetAttribute("TreeUUID", HttpService:GenerateGUID(false))
	trunk.Parent = treeFolder

	Tree.GenerateBranches(config, trunk, 0, treeFolder)

	return treeFolder
end

return Tree
