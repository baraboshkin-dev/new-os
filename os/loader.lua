
-- /os/loader.lua
local function loadAPI(name)
    local path = "/os/api/" .. name .. ".lua"
    if fs.exists(path) then
        os.loadAPI(path)
        return true
    else
        return false
    end
end

local function loadApps()
    local apps = {}
    local files = fs.list("/os/apps")
    for _, file in ipairs(files) do
        local name = file:match("(.+)%.lua$")
        if name then
            apps[name] = require("/os/apps/" .. name)
        end
    end
    return apps
end

local function drawMenu(apps)
    term.clear()
    term.setCursorPos(1,1)
    print("CC:Tweaked OS")
    print("-------------")
    for name, _ in pairs(apps) do
        print("- " .. name)
    end
    print("- exit")
    print("
Enter app name: ")
end

local function run()
    -- Load APIs
    loadAPI("system")
    loadAPI("users")
    
    -- Load apps
    local apps = loadApps()
    
    while true do
        drawMenu(apps)
        local input = read()
        if input == "exit" then
            break
        elseif apps[input] then
            apps[input].run()
        else
            print("Invalid app name. Press any key to continue.")
            os.pullEvent("key")
        end
    end
    
    print("Shutting down...")
    sleep(1)
end

return {
    run = run
}
