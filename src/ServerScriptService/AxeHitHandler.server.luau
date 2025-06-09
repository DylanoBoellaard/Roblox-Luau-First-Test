local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AxeHitEvent = ReplicatedStorage:WaitForChild("AxeHitEvent")
local ToolModules = ReplicatedStorage:WaitForChild("ToolModules")

AxeHitEvent.OnServerEvent:Connect(function(player, axeName, part, hitPosition)
	if not (player and part and hitPosition) then return end
	if not part:GetAttribute("Health") then return end

	-- Load axe module dynamically by name
	local axeModule = require(ToolModules:FindFirstChild(axeName))
	if axeModule and axeModule.OnHit then
		axeModule.OnHit(part, hitPosition, player)
	end
end)
