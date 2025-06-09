local AxeBase = {}

function AxeBase.DefaultHitBehavior(part, damage, hitPosition, player)
    local treeModule = require(game.ReplicatedStorage.TreeModules.TreeBaseModule)
    treeModule.ApplyDamage(part, damage, hitPosition, player)
end

return AxeBase
