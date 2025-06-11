--[[
		Handles tree damage, splitting, and branch detachment logic.
		Uses CutLineManager to visually represent cutlines and determine cut type.
--]]

local Tree = {}

-- OLD System
-- function Tree.ApplyDamage(part, damage, hitPosition, player)
-- 	local health = part:GetAttribute("Health") or 100
-- 	health -= damage
-- 	part:SetAttribute("Health", health)

-- 	print("[Tree] Damaged", part:GetFullName(), "New Health:", health)

-- 	if health <= 0 then
-- 		Tree.SplitLog(part, hitPosition)
-- 	end
-- end

-- New cutline system:
local CutLineManager = require(script.Parent.CutLineManager)

-- Applies damage to a tree part and spawns a cut line if it doesn't exist yet
function Tree.ApplyDamage(part, damage, hitPosition, player)
	local health = part:GetAttribute("Health") or 100
	health -= damage
	part:SetAttribute("Health", health)

	-- Create a visual cut line if this is the first hit on this part
	if #CutLineManager.GetAllCutLinesFor(part) == 0 then
		CutLineManager.CreateCutLine(part, hitPosition)
	end

	-- Debug print to check if a part of a tree is properly being damaged
	print("[Tree] Damaged", part:GetFullName(), "New Health:", health)

	-- If health reaches zero, split the log
	if health <= 0 then
		Tree.SplitLog(part, hitPosition)
	end
end

-- Utility function to copy visual properties from one part to another
local function copyVisualProperties(from, to)
	to.Material = from.Material
	to.Color = from.Color
	to.Transparency = from.Transparency
	to.Reflectance = from.Reflectance
	to.Anchored = from.Anchored
	to.CastShadow = from.CastShadow
	to.Shape = from.Shape
	to.Name = from.Name
	to.Size = from.Size
	to:SetAttribute("Health", 100)
end

-- Detaches all branches from a part, removing welds and unparenting them
local function DetachBranchesFrom(part)
	local branchFolder = part:FindFirstChild("BranchParts")

	-- If nothing needs detaching, return nothing.
	if not branchFolder then
		return
	end

	-- Detaches and unparents all branches
	for _, branch in ipairs(branchFolder:GetChildren()) do
		branch.Anchored = false
		branch:SetAttribute("Detached", true)

		local weld = branch:FindFirstChild("ParentPart")
		if weld then
			weld:Destroy()
		end

		-- Find the tree root folder
		local treeFolder = part
		while treeFolder and treeFolder.Name ~= "Trees" and treeFolder.Parent ~= workspace.Trees do
			treeFolder = treeFolder.Parent
		end
		branch.Parent = treeFolder or workspace.Trees
	end

	print("DetachBranchesFrom triggered")
	branchFolder:Destroy()
end

-- Splits a tree log into two parts based on the position of the hit
function Tree.SplitLog(part, hitPosition)
	-- Cutline system:
	local CutLineManager = require(script.Parent.CutLineManager)

	assert(part.Parent ~= nil, "[Tree] SplitLog called on a part with no parent.")
	local size = part.Size
	local localHit = part.CFrame:PointToObjectSpace(hitPosition)
	local relativeY = (localHit.Y + part.Size.Y / 2) / part.Size.Y
	-- relativeY = math.clamp(relativeY, 0.2, 0.8) -- Limit the split to 20% of the tree height IGNORE

	-- Cutline system:
	-- Check if this is a snap cut line near the top of the part (used to detach connected branches)
	local snapCut = false
	for _, line in ipairs(CutLineManager.GetAllCutLinesFor(part)) do
		if CutLineManager.ShouldSnap(line) then
			snapCut = true
			break
		end
	end

	-- Calculate sizes for top and bottom parts
	local topSize = Vector3.new(size.X, size.Y * (1 - relativeY), size.Z)
	local bottomSize = Vector3.new(size.X, size.Y * relativeY, size.Z)
	local cframe = part.CFrame

	-- Cutline system:
	local topPart, bottomPart

	-- Creates a half-sized part with the given size and offset and apply physics for when it detaches from the tree
	local function createHalf(size, offsetY, applyImpulse)
		local newPart = Instance.new("Part")
		copyVisualProperties(part, newPart)
		newPart.Size = size
		newPart.CFrame = cframe * CFrame.new(0, offsetY, 0)
		newPart.Anchored = false -- enable physics!
		newPart.Name = part.Name
		newPart:SetAttribute("Health", 100)
		-- Cutline attribute:
		newPart:SetAttribute("TreeUUID", part:GetAttribute("TreeUUID"))
		newPart.Parent = part.Parent

		-- Optional: give it some impulse to make it react to being detached
		if applyImpulse then
			local bodyVelocity = Instance.new("LinearVelocity")
			bodyVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.World
			bodyVelocity.MaxForce = math.huge
			bodyVelocity.Velocity = Vector3.new(math.random(-5, 5), math.random(10, 15), math.random(-5, 5))
			bodyVelocity.Attachment0 = Instance.new("Attachment", newPart)
			bodyVelocity.Parent = newPart

			-- Clean up the velocity after a short moment
			game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
		end

		return newPart
	end

	-- Create new split parts
	local topPart = createHalf(topSize, (size.Y * relativeY) / 2)
	local bottomPart = createHalf(bottomSize, -(size.Y * (1 - relativeY)) / 2)

	-- Old system:
	-- DetachBranchesFrom(part)

	-- New Cutline system:
	local branchFolder = part:FindFirstChild("BranchParts")
	if snapCut then
		-- Full detachment (branches fall)
		DetachBranchesFrom(part)
		print("snapCut triggered")

	elseif branchFolder then
		-- Reparent branches to top part and reattach welds
		branchFolder.Parent = topPart
		print("branchFolder triggered")

		-- Recreate welds to topPart
		for _, branch in ipairs(branchFolder:GetChildren()) do
			-- Destroy the old weld if present
			local oldWeld = branch:FindFirstChild("ParentPart")
			if oldWeld then
				oldWeld:Destroy()
			end

			-- Create a new weld to topPart
			local weld = Instance.new("WeldConstraint")
			weld.Name = "ParentPart"
			weld.Part0 = branch
			weld.Part1 = topPart
			weld.Parent = branch
		end
	end

	part:Destroy()

	-- Cutline system:
	CutLineManager.ClearCutLines(part)
end

return Tree
