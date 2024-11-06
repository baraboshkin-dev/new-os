
-- /os/apps/browser.lua
local function drawBrowser()
    term.clear()
    term.setCursorPos(1,1)
    term.write("Simple Browser")
    term.setCursorPos(1,3)
    term.write("Enter URL: ")
end

local function getBrowserInput()
    local input = read()
    return input
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
    print(content)
    print("
Press any key to return to browser")
    os.pullEvent("key")
end

local function run()
    while true do
        drawBrowser()
        local url = getBrowserInput()
        if url == "exit" then
            break
        end
        local content = fetchPage(url)
        displayPage(content)
    end
end

return {
    run = run
}
