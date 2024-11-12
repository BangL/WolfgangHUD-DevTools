LootSpy = LootSpy or class()
LootSpy._enable = false

LootSpy.TYPES = {
    ["dogtag"] = {
        texture = "ui/atlas/raid_atlas_missions",
        texture_rect = { 398, 2, 64, 64 }
    },
    ["loot"] = {
        texture = "ui/atlas/raid_atlas_missions",
        texture_rect = { 8, 68, 64, 64 }
    },
    ["greed_cache"] = {
        texture = "ui/atlas/raid_atlas_hud",
        texture_rect = { 677, 1317, 32, 32 }
    },
    ["intel"] = {
        texture = "ui/atlas/raid_atlas_hud",
        texture_rect = { 963, 175, 56, 56 }
    }
}

function LootSpy:reset()
    for _, id in ipairs(self._waypoints or {}) do
        managers.waypoints:remove_waypoint(id)
    end
    self._items = {}
    self._waypoints = {}
end

function LootSpy:register_item(type, data)
    if not self.TYPES[type] then
        log(string.format("[LootSpy] ERROR: bad type: %s", type))
        return
    end
    table.insert(self._items,
        {
            type = type,
            position = self:_get_unit_pos(data.unit),
            key = tostring(data.unit:key()),
            editor_id = data.unit:editor_id()
        })
end

function LootSpy:_get_unit_pos(unit)
    return unit:movement() and unit:movement():m_head_pos() or
        unit:interaction() and unit:interaction():interact_position() or unit:position()
end

function LootSpy:init_waypoints()
    for _, item in ipairs(self._items or {}) do
        self:make_waypoint(item.type, item.position, item.key, item.editor_id, item.unit)
    end
end

function LootSpy:make_waypoint(type, position, key, editor_id, unit)
    local is_ignored = false
    local lookup = GameInfoManager._INTERACTIONS.IGNORE_IDS
    local job_id = managers.raid_job:current_job_id()
    if lookup[job_id] and lookup[job_id][editor_id % 1000000] then
        is_ignored = true
    end
    if managers.raid_job:current_job_type() == OperationsTweakData.JOB_TYPE_OPERATION then
        local level_id = managers.raid_job:current_operation_event().level_id
        if lookup[job_id] and lookup[job_id][level_id] and lookup[job_id][level_id][editor_id % 1000000] then
            is_ignored = true
        end
    end

    local waypoint_params = {
        show = true,
        position = position,
        offset = Vector3(0, 0, 15),
        visible_through_walls = true,
        scale = 1.25,
        alpha = 1,
        color = is_ignored and Color.red or ((unit and alive(unit)) and Color.white or Color.gray),
        icon = {
            type = "icon",
            show = true,
            std_wp = self.TYPES[type].std_icon,
            texture = self.TYPES[type].texture,
            texture_rect = self.TYPES[type].texture_rect,
        },
        debug_txt = {
            type = "label",
            show = true,
            text = string.format("%s: %s", type, (editor_id ~= -1 and editor_id or "N/A")),
        },
        component_order = { { "icon" }, { "debug_txt" } },
    }

    self._waypoints["LootSpyItem_" .. key] = waypoint_params
    self:refresh()
end

function LootSpy:refresh()
    for id, waypoint_params in pairs(self._waypoints or {}) do
        managers.waypoints:remove_waypoint(id)
        if self._enable then
            managers.waypoints:add_waypoint(id, "CustomWaypoint", waypoint_params)
        end
    end
end

function LootSpy:toggle()
    self._enable = not self._enable
    self:refresh()
    return self._enable
end

LootSpy:reset()
