local plant_document_on_level_original = ConsumableMissionManager.plant_document_on_level

function ConsumableMissionManager:plant_document_on_level(world_id, ...)
	self:init_intel_waypoints(world_id)
	return plant_document_on_level_original(self, world_id, ...)
end

function ConsumableMissionManager:init_intel_waypoints(world_id)
	if not Network:is_server() or Application:editor() then
		return
	end

	for _, data in ipairs(self._registered_intel_documents[world_id] or {}) do
		if data.unit and alive(data.unit) then
			LootSpy:register_item("intel", data)
		end
	end
end
