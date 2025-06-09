local AxeBase = require(script.Parent.AxeBaseModule)

local IronAxe = {}
IronAxe.Damage = 10
IronAxe.Name = "Iron Axe"

function IronAxe.OnHit(part, hitPosition, player)
    AxeBase.DefaultHitBehavior(part, IronAxe.Damage, hitPosition, player)
end

return IronAxe
