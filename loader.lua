
-- loader.lua
local function loadAPI(name)
    local path = "api/" .. name .. ".lua"
    if fs.exists(path) then
        os.loadAPI(path)
        return true
    else
        return false
    end
end

local function loadApps()
    local apps = {}
    local files = fs.list("apps")
    for _, file in ipairs(files) do
        local name = file:match("(.+)%.lua$")
        if name then
            apps[name] = require("apps/" .. name)
        end
    end
    return apps
end

local function drawButton(x, y, text, selected)
    local width = #text + 4
    local bg = selected and colors.blue or colors.lightGray
    local fg = selected and colors.white or colors.black
    
    term.setCursorPos(x, y)
    term.setBackgroundColor(bg)
    term.setTextColor(fg)
    term.write(string.rep(" ", width))
    
    term.setCursorPos(x + 2, y)
    term.write(text)
    
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end

local function drawMenu(apps, selected)
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.yellow)
    print("CC:Tweaked OS")
    print("-------------")
    term.setTextColor(colors.white)
    
    local y = 4
    for name, _ in pairs(apps) do
        drawButton(2, y, name, selected == name)
        y = y + 2
    end
    drawButton(2, y, "Exit", selected == "Exit")
end

local function run()
    -- Load APIs
    loadAPI("system")
    loadAPI("users")
    
    -- Load apps
    local apps = loadApps()
    local appNames = {}
    for name, _ in pairs(apps) do
        table.insert(appNames, name)
    end
    table.insert(appNames, "Exit")
    
    local selected = 1
    while true do
        drawMenu(apps, appNames[selected])
        local event, key = os.pullEvent("key")
        if key == keys.up and selected > 1 then
            selected = selected - 1
        elseif key == keys.down and selected < #appNames then
            selected = selected + 1
        elseif key == keys.enter then
            if appNames[selected] == "Exit" then
                break
            elseif apps[appNames[selected]] then
                apps[appNames[selected]].run()
            end
        end
    end
    
    term.clear()
    term.setCursorPos(1,1)
    print("Shutting down...")
    sleep(1)
end

return {
    run = run
}
