--[[
		Defines the behavior and stats for the Iron Axe
--]]

local AxeBase = require(script.Parent.AxeBaseModule)

local IronAxe = {}

IronAxe.Damage = 50 		-- Base damage
IronAxe.Name = "Iron Axe" 	-- Name of the axe

-- Old stuff, ignore
-- function IronAxe.OnHit(part, hitPosition, player)
--     AxeBase.DefaultHitBehavior(part, IronAxe.Damage, hitPosition, player)
-- end

-- AxeBase.OnHit = function(part, hitPosition, player)
-- 	AxeBase.DefaultHitBehavior(part, IronAxe.Damage, hitPosition, player)
-- end

--[[
	Function called when this axe hits a part
	Delegates to the shared DefaultHitBehavior from AxeBase
	
	@param part (Instance) - The hit tree/log part
	@param hitPosition (Vector3) - Exact world position of the hit
	@param player (Player) - The player who used the axe
--]]

IronAxe.OnHit = function(part, hitPosition, player)
	AxeBase.DefaultHitBehavior(part, IronAxe.Damage, hitPosition, player)
end

return IronAxe
