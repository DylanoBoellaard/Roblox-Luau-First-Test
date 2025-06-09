local Tree = {}

function Tree.ApplyDamage(part, damage, hitPosition, player)
	local health = part:GetAttribute("Health") or 100
	health -= damage
	part:SetAttribute("Health", health)

	print("[Tree] Damaged", part:GetFullName(), "New Health:", health)

	if health <= 0 then
		Tree.SplitLog(part, hitPosition)
	end
end

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

-- New branch system (DOESN'T WORK)
local function isStillConnectedToTree(part)
	local current = part
	while current do
		if current:GetAttribute("Root") then
			return true -- we found a root
		end
		local weld = current:FindFirstChild("ParentPart")
		if weld and weld:IsA("WeldConstraint") then
			current = weld.Part0
		else
			break
		end
	end
	return false
end

-- Always detach branches from the tree whenever and wherever it's split in pieces.
local function DetachBranchesFrom(part)
	local branchFolder = part:FindFirstChild("BranchParts")
	if not branchFolder then
		return
	end

	for _, branch in ipairs(branchFolder:GetChildren()) do
		branch.Anchored = false
		branch:SetAttribute("Detached", true)

		local weld = branch:FindFirstChild("ParentPart")
		if weld then
			weld:Destroy()
		end

		local treeFolder = part
		while treeFolder and treeFolder.Name ~= "Trees" and treeFolder.Parent ~= workspace.Trees do
			treeFolder = treeFolder.Parent
		end
		branch.Parent = treeFolder or workspace.Trees
	end

	branchFolder:Destroy()
end

-- New branch system (DOESN'T WORK)
local function DetachBranchesIfDetached(part)
	if isStillConnectedToTree(part) then
		return -- it's still part of the tree
	end

	local branchFolder = part:FindFirstChild("BranchParts")
	if not branchFolder then
		return
	end

	for _, branch in ipairs(branchFolder:GetChildren()) do
		branch.Anchored = false
		branch:SetAttribute("Detached", true)

		local weld = branch:FindFirstChild("ParentPart")
		if weld then
			weld:Destroy()
		end

		local treeFolder = part
		while treeFolder and treeFolder.Name ~= "Trees" and treeFolder.Parent ~= workspace.Trees do
			treeFolder = treeFolder.Parent
		end
		branch.Parent = treeFolder or workspace.Trees
	end

	branchFolder:Destroy()
end

function Tree.SplitLog(part, hitPosition)
	assert(part.Parent ~= nil, "[Tree] SplitLog called on a part with no parent.")
	local size = part.Size
	local localHit = part.CFrame:PointToObjectSpace(hitPosition)
	local relativeY = (localHit.Y + part.Size.Y / 2) / part.Size.Y
	relativeY = math.clamp(relativeY, 0.2, 0.8)

	local topSize = Vector3.new(size.X, size.Y * (1 - relativeY), size.Z)
	local bottomSize = Vector3.new(size.X, size.Y * relativeY, size.Z)

	local cframe = part.CFrame

	local function createHalf(size, offsetY, applyImpulse)
		local newPart = Instance.new("Part")
		copyVisualProperties(part, newPart)
		newPart.Size = size
		newPart.CFrame = cframe * CFrame.new(0, offsetY, 0)
		newPart.Anchored = false -- enable physics!
		newPart.Name = part.Name
		newPart:SetAttribute("Health", 100)
		newPart.Parent = part.Parent

		-- Optional: give it some impulse to make it react
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

	-- For old branch splitting system
	local topPart = createHalf(topSize, (size.Y * relativeY) / 2)
	local bottomPart = createHalf(bottomSize, -(size.Y * (1 - relativeY)) / 2)

	-- New branch splitting system (DOESN't WORK)
	-- local topPart = createHalf(topSize, (size.Y * relativeY) / 2, true)
	-- local bottomPart = createHalf(bottomSize, -(size.Y * (1 - relativeY)) / 2, true)

	-- Old branch splitting system
	DetachBranchesFrom(part)

	-- New branch splitting system (DOESN'T WORK)
	-- Only detach branches from parts that are now disconnected from the tree
	-- DetachBranchesIfDetached(topPart)
	-- DetachBranchesIfDetached(bottomPart)

	part:Destroy()
end

return Tree
