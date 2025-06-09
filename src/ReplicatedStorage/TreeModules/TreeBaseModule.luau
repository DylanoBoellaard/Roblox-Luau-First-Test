local Tree = {}

function Tree.ApplyDamage(part, damage, hitPosition, player)
	local health = part:GetAttribute("Health") or 100
	health -= damage
	part:SetAttribute("Health", health)

	if health <= 0 then
		Tree.SplitLog(part, hitPosition)
	end
end

function Tree.SplitLog(part, hitPosition)
	local size = part.Size
	local localHit = part.CFrame:PointToObjectSpace(hitPosition)
	local relativeY = (localHit.Y + part.Size.Y / 2) / part.Size.Y

	-- Limit to range [0.2, 0.8] to avoid super-thin pieces
	relativeY = math.clamp(relativeY, 0.2, 0.8)

	local topSize = Vector3.new(size.X, size.Y * (1 - relativeY), size.Z)
	local bottomSize = Vector3.new(size.X, size.Y * relativeY, size.Z)

	local cframe = part.CFrame
	local center = part.Position

	local topPart = part:Clone()
	topPart.Size = topSize
	topPart.CFrame = cframe * CFrame.new(0, (size.Y * relativeY) / 2, 0)
	topPart:SetAttribute("Health", 100)
	topPart.Parent = workspace.Trees

	local bottomPart = part:Clone()
	bottomPart.Size = bottomSize
	bottomPart.CFrame = cframe * CFrame.new(0, -(size.Y * (1 - relativeY)) / 2, 0)
	bottomPart:SetAttribute("Health", 100)
	bottomPart.Parent = workspace.Trees

	-- -- Before destroying the original part, reparent any branches
	local function DetachBranchesFrom(part)
		local branchFolder = part:FindFirstChild("BranchParts")
		if not branchFolder then
			return
		end

		for _, branch in ipairs(branchFolder:GetChildren()) do
			branch.Anchored = false
			branch:SetAttribute("Detached", true) -- Optional flag for future logic
			local weld = branch:FindFirstChild("ParentPart")
			if weld then
				weld:Destroy()
			end
			branch.Parent = workspace.Trees
		end

		branchFolder:Destroy()
	end

	DetachBranchesFrom(part)

	part:Destroy()
end

return Tree
