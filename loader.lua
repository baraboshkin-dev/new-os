
-- loader.lua
local function loadAPI(name)
    local path = "api/" .. name .. ".lua"
    if fs.exists(path) then
        local success, err = pcall(os.loadAPI, path)
        if not success then
            printError("Error loading API " .. name .. ": " .. err)
            return false
        end
        return true
    else
        printError("API file not found: " .. path)
        return false
    end
end

local function loadApps()
    local apps = {}
    if not fs.exists("apps") or not fs.isDir("apps") then
        printError("Apps directory not found")
        return apps
    end
    local files = fs.list("apps")
    for _, file in ipairs(files) do
        local name = file:match("(.+)%.lua$")
        if name then
            local success, app = pcall(require, "apps/" .. name)
            if success then
                apps[name] = app
            else
                printError("Error loading app " .. name .. ": " .. app)
            end
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
    if not loadAPI("system") or not loadAPI("users") then
        printError("Failed to load essential APIs")
        return
    end
    
    -- Load apps
    local apps = loadApps()
    if next(apps) == nil then
        printError("No apps loaded")
        return
    end
    
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
                term.clear()
                term.setCursorPos(1,1)
                print("Exiting CC:Tweaked OS...")
                break
            elseif apps[appNames[selected]] then
                term.clear()
                term.setCursorPos(1,1)
                local success, err = pcall(apps[appNames[selected]].run)
                if not success then
                    printError("Error running app " .. appNames[selected] .. ": " .. err)
                    os.pullEvent("key")
                end
            end
        end
    end
end

return {
    run = run
}
