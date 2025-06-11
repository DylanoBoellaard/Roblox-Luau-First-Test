--[[
        Manages all visual cutlines on tree parts.
        Handles creation, lookup, snapping logic, and cleanup.
--]]

local CutLineManager = {}
local CollectionService = game:GetService("CollectionService")

-- Snap threshold (top 10% of part)
local SNAP_THRESHOLD = 0.10

-- Folder to track and store all cut lines in the workspace
local CutLinesFolder = Instance.new("Folder")
CutLinesFolder.Name = "CutLines"
CutLinesFolder.Parent = workspace

-- Creates a visual cut line and parents it to a tree part
function CutLineManager.CreateCutLine(part, hitPosition)
	local localY = part.CFrame:PointToObjectSpace(hitPosition).Y
	local height = part.Size.Y
	local relativeY = (localY + height / 2) / height

	-- Snap to top of a tree part if mouse is within the SNAP_THRESHOLD
	if 1 - relativeY < SNAP_THRESHOLD then
		relativeY = 1
	end

    -- Create a new CutLine part
	local line = Instance.new("Part")
	line.Name = "CutLine"
	line.Anchored = false
	line.CanCollide = false
	line.Size = Vector3.new(part.Size.X, 0.1, part.Size.Z)
	line.CFrame = part.CFrame * CFrame.new(0, (relativeY - 0.5) * part.Size.Y, 0)
	line.BrickColor = BrickColor.Black()
	line.Material = Enum.Material.SmoothPlastic
	line.Parent = CutLinesFolder
	line:SetAttribute("ParentUUID", part:GetAttribute("TreeUUID"))

    -- Weld the CutLine to the tree part
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = part
	weld.Part1 = line
	weld.Parent = line

	line:SetAttribute("RelativeY", relativeY)

	CollectionService:AddTag(line, "CutLine")

	return line
end

-- Returns all cut lines belonging to a specific tree part by using the custom attribute TreeUUID 
function CutLineManager.GetAllCutLinesFor(part)
	local matches = {}
	for _, line in ipairs(CutLinesFolder:GetChildren()) do
		if line:GetAttribute("ParentUUID") == part:GetAttribute("TreeUUID") then
			table.insert(matches, line)
		end
	end
	return matches
end

-- Clears all cut lines related to a part
function CutLineManager.ClearCutLines(part)
	for _, line in ipairs(CutLineManager.GetAllCutLinesFor(part)) do
		line:Destroy()
	end
end

-- Checks if a cut line should snap (is near the top of part)
function CutLineManager.ShouldSnap(line)
	return (1 - (line:GetAttribute("RelativeY") or 0)) < SNAP_THRESHOLD
end

return CutLineManager
