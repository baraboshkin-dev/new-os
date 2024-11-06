
-- apps/browser.lua
local function drawBrowser()
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.yellow)
    term.write("Simple Browser")
    term.setTextColor(colors.white)
    term.setCursorPos(1,3)
    term.write("Enter URL (or 'exit' to return to main menu): ")
end

local function getBrowserInput()
    return read()
end

local function fetchPage(url)
    local response = http.get(url)
    if response then
        local content = response.readAll()
        response.close()
        return content
    else
        return "Error: Could not fetch page"
    end
end

local function displayPage(content)
    term.clear()
    term.setCursorPos(1,1)
    local w, h = term.getSize()
    local y = 1
    for line in content:gmatch("[^\n]+") do
        term.setCursorPos(1, y)
        term.write(line:sub(1, w))
        y = y + 1
        if y > h - 2 then break end
    end
    term.setCursorPos(1, h-1)
    term.setTextColor(colors.yellow)
    term.write("Press any key to return to browser")
    term.setTextColor(colors.white)
    os.pullEvent("key")
end

local function run()
    while true do
        drawBrowser()
        local url = getBrowserInput()
        if url:lower() == "exit" then
            break
        end
        local content = fetchPage(url)
        displayPage(content)
    end
end

return {
    run = run
}
