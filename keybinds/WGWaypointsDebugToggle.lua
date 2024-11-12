if WolfgangHUD and HUDManager and HUDManager.CUSTOM_WAYPOINTS and managers.hud and managers.hud.set_custom_waypoint_debugging then
    managers.hud:set_custom_waypoint_debugging(not HUDManager.CUSTOM_WAYPOINTS.DEBUGGING)
    local msg = "WolfgangHUD CUSTOM_WAYPOINTS Debug: " .. (HUDManager.CUSTOM_WAYPOINTS.DEBUGGING and "on" or "off")
    if DevTools then
        DevTools:print(msg)
    else
        log(msg)
    end
end