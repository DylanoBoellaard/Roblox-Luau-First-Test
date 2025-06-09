-- OLD TREEGENERATOR CODE

-- Use local TreeGenerator = require(game.ReplicatedStorage.TreeModules.TreeGenerator)  TreeGenerator.SpawnProceduralTree(Vector3.new(0, 5, 25), { 	branchingDepth = 3, 	branchesPerLevel = 2, 	scaleFactor = 0.8, 	offsetRange = 6, }) to spawn a tree

-- local Tree = {}
-- local RunService = game:GetService("RunService")

-- -- Helper function to create and attach a branch
-- function Tree.CreateBranch(parentPart, sizeMultiplier, offset, treeFolder)
-- 	local branch = Instance.new("Part")
-- 	branch.Size = parentPart.Size * sizeMultiplier
-- 	branch.CFrame = parentPart.CFrame
-- 		* CFrame.new(offset)
-- 		* CFrame.Angles(math.rad(math.random(-30, 30)), math.rad(math.random(0, 360)), math.rad(math.random(-30, 30)))
-- 	branch.Anchored = true
-- 	branch.Name = "Branch"

-- 	local health = math.floor((parentPart:GetAttribute("Health") or 100) * 0.75)
-- 	branch:SetAttribute("Health", health)

-- 	local parentVal = Instance.new("ObjectValue")
-- 	parentVal.Name = "ParentPart"
-- 	parentVal.Value = parentPart
-- 	parentVal.Parent = branch

-- 	local branchFolder = parentPart:FindFirstChild("BranchParts")
-- 	if not branchFolder then
-- 		branchFolder = Instance.new("Folder")
-- 		branchFolder.Name = "BranchParts"
-- 		branchFolder.Parent = parentPart
-- 	end

-- 	branch.Parent = branchFolder
-- 	-- branch.Parent = treeFolder

-- 	local weld = Instance.new("WeldConstraint")
-- 	weld.Part0 = parentPart
-- 	weld.Part1 = branch
-- 	weld.Parent = branch

-- 	return branch
-- end

-- -- Recursive branch generator
-- function Tree.GenerateBranches(parentPart, currentDepth, maxDepth, branchesPerLevel, sizeMultiplier, offsetRange, treeFolder)
-- 	if currentDepth >= maxDepth then
-- 		return
-- 	end

-- 	for _ = 1, branchesPerLevel do
-- 		local offset = Vector3.new(
-- 			math.random(-offsetRange, offsetRange),
-- 			math.random(2, offsetRange), -- upward bias
-- 			math.random(-offsetRange, offsetRange)
-- 		)

-- 		local branch = Tree.CreateBranch(
-- 			parentPart,
-- 			Vector3.new(sizeMultiplier, sizeMultiplier, sizeMultiplier),
-- 			offset,
-- 			treeFolder
-- 		)

-- 		-- Recurse to next level
-- 		Tree.GenerateBranches(branch, currentDepth + 1, maxDepth, branchesPerLevel, sizeMultiplier * 0.75, offsetRange, treeFolder)
-- 	end
-- end

-- function Tree.SpawnProceduralTree(position, settings)
-- 	local treeFolder = Instance.new("Folder", workspace.Trees)
-- 	treeFolder.Name = "ProceduralTree"

-- 	local trunk = Instance.new("Part")
-- 	trunk.Size = Vector3.new(2, 10, 2)
-- 	trunk.Position = position
-- 	trunk.Anchored = true
-- 	trunk.Name = "Trunk"
-- 	trunk:SetAttribute("Health", 100)
-- 	trunk.Parent = treeFolder

-- 	-- Attach branches recursively
-- 	Tree.GenerateBranches(
-- 		trunk,
-- 		0, -- currentDepth
-- 		settings.branchingDepth or 2,
-- 		settings.branchesPerLevel or 2,
-- 		settings.scaleFactor or 0.7,
-- 		settings.offsetRange or 5,
-- 		treeFolder
-- 	)

-- 	return trunk
-- end

-- return Tree

-- NEW TREEGENERATOR CODE

-- Use code: require(game.ReplicatedStorage.TreeModules.OakTree).Spawn(Vector3.new(0, 5, 0)) to spawn a tree

local Tree = {}

local function randomVector(minVec, maxVec)
	return Vector3.new(
		math.random() * (maxVec.X - minVec.X) + minVec.X,
		math.random() * (maxVec.Y - minVec.Y) + minVec.Y,
		math.random() * (maxVec.Z - minVec.Z) + minVec.Z
	)
end

function Tree.CreateBranch(config, parentPart, parentCFrame, currentDepth, treeFolder)
	local scale = randomVector(config.minScale, config.maxScale)
	local size = parentPart.Size * scale

	local branch = Instance.new("Part")
	branch.Size = size
	branch.Anchored = true
	branch.Name = "Branch"
	branch:SetAttribute("Health", math.floor((parentPart:GetAttribute("Health") or 100) * 0.75))

	local parentVal = Instance.new("ObjectValue")
	parentVal.Name = "ParentPart"
	parentVal.Value = parentPart
	parentVal.Parent = branch

	-- Attach at top of parent
	local attachOffset = Vector3.new(0, parentPart.Size.Y / 2, 0)
	local rotation = randomVector(config.minRotation, config.maxRotation)

	branch.CFrame =
		parentCFrame
		* CFrame.new(attachOffset)
		* CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
		* CFrame.new(0, size.Y / 2, 0) -- move it up by half its size so it hangs down from attach point

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

function Tree.GenerateBranches(config, parentPart, currentDepth, treeFolder)
	if currentDepth >= config.branchingDepth then return end

	for _ = 1, config.branchesPerLevel do
		local branch = Tree.CreateBranch(config, parentPart, parentPart.CFrame, currentDepth, treeFolder)

		Tree.GenerateBranches(config, branch, currentDepth + 1, treeFolder)
	end
end

function Tree.SpawnProceduralTree(position, config)
	local treeFolder = Instance.new("Folder", workspace.Trees)
	treeFolder.Name = config.name or "ProceduralTree"

	local trunk = Instance.new("Part")
	trunk.Size = config.trunkSize or Vector3.new(2, 10, 2)
	trunk.Position = position
	trunk.Anchored = true
	trunk.Name = "Trunk"
	trunk:SetAttribute("Health", 100)
	trunk.Parent = treeFolder

	Tree.GenerateBranches(config, trunk, 0, treeFolder)

	return treeFolder
end

return Tree
