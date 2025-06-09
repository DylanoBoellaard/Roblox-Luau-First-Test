local Tree = {}

function Tree.Spawn(position)
    local treeFolder = Instance.new("Folder", workspace.Trees)
    treeFolder.Name = "OakTree"

    local trunk = Instance.new("Part")
    trunk.Size = Vector3.new(2, 10, 2)
    trunk.Position = position
    trunk.Anchored = true
    trunk.Name = "Trunk"
    trunk:SetAttribute("Health", 100)
    trunk.Parent = treeFolder

    -- Add branches similarly
end

return Tree
