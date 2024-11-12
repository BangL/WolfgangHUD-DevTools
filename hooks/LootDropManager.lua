local plant_loot_on_level_original = LootDropManager.plant_loot_on_level

function LootDropManager:plant_loot_on_level(world_id, total_value, job_id, ...)
	self:init_loot_waypoints(world_id)
	return plant_loot_on_level_original(self, world_id, total_value, job_id, ...)
end

function LootDropManager:init_loot_waypoints(world_id)
	if not Network:is_server() or Application:editor() then
		return
	end

	for _, data in ipairs(self._registered_loot_units[world_id] or {}) do
		if data.unit and alive(data.unit) then
			LootSpy:register_item("dogtag", data)
		end
	end
end
