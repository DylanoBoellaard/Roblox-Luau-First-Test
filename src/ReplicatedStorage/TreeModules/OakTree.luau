-- OLD OAK TREE CODE

-- local Tree = {}

-- function Tree.CreateBranch(parentPart, offset, sizeMultiplier)
-- 	local branch = Instance.new("Part")
-- 	branch.Size = parentPart.Size * sizeMultiplier
-- 	branch.CFrame = parentPart.CFrame * CFrame.new(offset)
-- 	branch.Anchored = true
-- 	branch.Name = "Branch"

-- 	local health = math.floor((parentPart:GetAttribute("Health") or 100) * 0.75)
-- 	branch:SetAttribute("Health", health)

-- 	local parentVal = Instance.new("ObjectValue")
-- 	parentVal.Name = "ParentPart"
-- 	parentVal.Value = parentPart
-- 	parentVal.Parent = branch

-- 	branch.Parent = workspace.Trees

-- 	-- Attach to parent branch folder
-- 	local branchFolder = parentPart:FindFirstChild("BranchParts")
-- 	if not branchFolder then
-- 		branchFolder = Instance.new("Folder")
-- 		branchFolder.Name = "BranchParts"
-- 		branchFolder.Parent = parentPart
-- 	end
-- 	branchFolder:AddChild(branch)

-- 	return branch
-- end

-- function Tree.Spawn(position)
-- 	local treeFolder = Instance.new("Folder", workspace.Trees)
-- 	treeFolder.Name = "OakTree"

-- 	local trunk = Instance.new("Part")
-- 	trunk.Size = Vector3.new(2, 10, 2)
-- 	trunk.Position = position
-- 	trunk.Anchored = true
-- 	trunk.Name = "Trunk"
-- 	trunk:SetAttribute("Health", 100)
-- 	trunk.Parent = treeFolder

-- 	-- Add a branch to trunk
-- 	local branch1 = Tree.CreateBranch(trunk, Vector3.new(3, 5, 0), Vector3.new(0.6, 0.6, 0.6))

-- 	-- Add a sub-branch to branch1
-- 	Tree.CreateBranch(branch1, Vector3.new(2, 2, 0), Vector3.new(0.6, 0.6, 0.6))
-- end

-- return Tree

-- NEW OAK TREE CODE
local TreeGenerator = require(game.ReplicatedStorage.TreeModules.TreeGenerator)

local OakTree = {}

function OakTree.Spawn(position)
	local config = {
		name = "OakTree",
		trunkSize = Vector3.new(2, 10, 2),
		branchingDepth = 3,
		branchesPerLevel = 2,
		minRotation = Vector3.new(-20, 0, -20),
		maxRotation = Vector3.new(20, 360, 20),
		minScale = Vector3.new(0.4, 0.5, 0.4),
		maxScale = Vector3.new(0.6, 0.7, 0.6),
	}
	TreeGenerator.SpawnProceduralTree(position, config)
end

return OakTree
