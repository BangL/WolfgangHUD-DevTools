local init_original = CoreWorldCollection.init
local _plant_loot_on_spawned_levels_original = CoreWorldCollection._plant_loot_on_spawned_levels
local level_transition_started_original = CoreWorldCollection.level_transition_started

function CoreWorldCollection:init(params, ...)
    LootSpy:reset()
    return init_original(self, params, ...)
end

function CoreWorldCollection:_plant_loot_on_spawned_levels(...)
    local result = _plant_loot_on_spawned_levels_original(self, ...)
    LootSpy:init_waypoints()
    return result
end

function CoreWorldCollection:level_transition_started(...)
    LootSpy:reset()
    return level_transition_started_original(self, ...)
end
