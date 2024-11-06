
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
    
    -- Create OS directory
    if not fs.exists("os") then
        fs.makeDir("os")
        fs.makeDir("os/api")
        fs.makeDir("os/apps")
    end
    
    -- Download files
    local baseUrl = "https://raw.githubusercontent.com/baraboshkin-dev/new-os/main/"
    local files = {
        "os/startup.lua",
        "os/loader.lua",
        "os/api/system.lua",
        "os/api/users.lua",
        "os/apps/browser.lua",
        "os/apps/rednet_client.lua"
    }
    
    for _, file in ipairs(files) do
        print("Downloading " .. file .. "...")
        if downloadFile(baseUrl .. file, file) then
            print(file .. " downloaded successfully.")
        else
            print("Failed to download " .. file)
            return
        end
    end
    
    -- Copy startup.lua to root directory
    fs.copy("os/startup.lua", "startup.lua")
    print("Copied startup.lua to root directory")
    
    print("Installation complete. Rebooting in 3 seconds...")
    sleep(3)
    os.reboot()
end

install()
