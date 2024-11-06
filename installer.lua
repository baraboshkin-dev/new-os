
-- installer.lua
local function downloadFile(url, path)
    local response = http.get(url)
    if response then
        local file = fs.open(path, "w")
        file.write(response.readAll())
        file.close()
        response.close()
        return true
    else
        return false
    end
end

local function install()
    print("Installing CC:Tweaked OS...")
    
    -- Create directories
    if not fs.exists("api") then
        fs.makeDir("api")
    end
    if not fs.exists("apps") then
        fs.makeDir("apps")
    end
    
    -- Download files
    local baseUrl = "https://raw.githubusercontent.com/baraboshkin-dev/new-os/main/"
    local files = {
        "startup.lua",
        "loader.lua",
        "api/system.lua",
        "api/users.lua",
        "apps/browser.lua",
        "apps/rednet_client.lua"
    }
    
    for _, file in ipairs(files) do
        print("Downloading " .. file .. "...")
        if downloadFile(baseUrl .. "os/" .. file, file) then
            print(file .. " downloaded successfully.")
        else
            print("Failed to download " .. file)
            return
        end
    end
    
    print("Installation complete. Rebooting in 3 seconds...")
    sleep(3)
    os.reboot()
end

install()
