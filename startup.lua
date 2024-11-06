
-- startup.lua
local function loadFile(file)
    local f, err = loadfile(file)
    if f then
        return f()
    else
        printError("Error loading " .. file .. ": " .. err)
        return nil
    end
end

local success, loader = pcall(loadFile, "loader.lua")
if success and loader then
    loader.run()
else
    printError("Failed to load loader.lua")
end
