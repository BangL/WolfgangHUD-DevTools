local plant_greed_items_on_level_original = GreedManager.plant_greed_items_on_level

function GreedManager:plant_greed_items_on_level(world_id, ...)
	self:init_greed_waypoints(world_id)
	return plant_greed_items_on_level_original(self, world_id, ...)
end

function GreedManager:init_greed_waypoints(world_id)
	if not Network:is_server() or Application:editor() then
		return
	end

	for _, data in ipairs(self._registered_greed_items[world_id] or {}) do
		if data.unit and alive(data.unit) then
			LootSpy:register_item("loot", data)
		end
	end
	for _, data in ipairs(self._registered_greed_cache_items[world_id] or {}) do
		if data.unit and alive(data.unit) then
			LootSpy:register_item("greed_cache", data)
		end
	end
end
