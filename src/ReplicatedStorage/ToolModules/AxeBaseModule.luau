--[[
        Shared utility module for common axe behavior
--]]

local AxeBase = {}

--[[
	Default behavior for when an axe hits a part
	Called by specific axe modules (e.g., IronAxe)
	Delegates damage handling to the TreeBaseModule
	
	@param part (Instance) - The tree/log part hit
	@param damage (number) - Amount of damage to apply
	@param hitPosition (Vector3) - Exact world position of the hit
	@param player (Player) - The player who caused the hit
--]]

function AxeBase.DefaultHitBehavior(part, damage, hitPosition, player)
	local treeModule = require(game.ReplicatedStorage.TreeModules.TreeBaseModule)
	treeModule.ApplyDamage(part, damage, hitPosition, player)
end

return AxeBase
