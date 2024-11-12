local msg = "LootSpy: " .. (LootSpy:toggle() and "on" or "off")
if DevTools then
    DevTools:print(msg)
else
    log(msg)
end