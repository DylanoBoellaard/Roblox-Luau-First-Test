--[[
		Handles axe hit events sent from clients
--]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent used for sending axe hit data from the client
local AxeHitEvent = ReplicatedStorage:WaitForChild("AxeHitEvent")

-- Folder that stores all ToolModules (like IronAxe, GoldenAxe, etc.)
local ToolModules = ReplicatedStorage:WaitForChild("ToolModules")

--[[
	Triggered when a client fires the AxeHitEvent RemoteEvent
	Performs validation and then executes the hit logic for the correct axe

	@param player (Player) - The player who used the axe
	@param axeName (string) - Name of the axe used (used to find the module)
	@param part (Instance) - The tree part that was hit.
	@param hitPosition (Vector3) - Exact world position of the hit
--]]
AxeHitEvent.OnServerEvent:Connect(function(player, axeName, part, hitPosition)
	-- Sanity checks: Ensure all critical data is present
	if not (player and part and hitPosition) then
		return
	end

	-- Filter out parts that are not tree logs (parts must have a "Health" attribute) - !!!Needs changing, currently only checks for Health attribute. Check also for TreeUUID attribute or "Trunk" / "Branch" names to prevent triggering on non-tree objects?
	if not part:GetAttribute("Health") then
		return
	end

	-- Load axe module dynamically by name
	local axeModule = require(ToolModules:FindFirstChild(axeName))
	if not axeModule then
		return print(string.format("[AxeHitHandler] %s axe not found", axeModule))
	end

	-- Call the axe's OnHit function if it exists
	if axeModule and axeModule.OnHit then
		axeModule.OnHit(part, hitPosition, player)
	end
end)
