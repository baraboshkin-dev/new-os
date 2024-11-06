
-- api/system.lua
local system = {}

function system.getVersion()
    return "1.0"
end

function system.shutdown()
    os.shutdown()
end

function system.reboot()
    os.reboot()
end

return system
