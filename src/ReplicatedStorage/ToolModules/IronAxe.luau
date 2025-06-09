local AxeBase = require(script.Parent.AxeBaseModule)

local IronAxe = {}
IronAxe.Damage = 50
IronAxe.Name = "Iron Axe"

-- function IronAxe.OnHit(part, hitPosition, player)
--     AxeBase.DefaultHitBehavior(part, IronAxe.Damage, hitPosition, player)
-- end

-- AxeBase.OnHit = function(part, hitPosition, player)
-- 	AxeBase.DefaultHitBehavior(part, IronAxe.Damage, hitPosition, player)
-- end

IronAxe.OnHit = function(part, hitPosition, player)
	AxeBase.DefaultHitBehavior(part, IronAxe.Damage, hitPosition, player)
end

return IronAxe
