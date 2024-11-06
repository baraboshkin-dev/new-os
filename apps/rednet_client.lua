
-- apps/rednet_client.lua
local function drawClient()
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.yellow)
    term.write("RedNet Client")
    term.setTextColor(colors.white)
    term.setCursorPos(1,3)
    term.write("Enter message (or 'exit' to return to main menu): ")
end

local function getInput()
    return read()
end

local function sendMessage(message)
    rednet.broadcast(message)
    print("Message sent: " .. message)
    sleep(2)
end

local function run()
    -- Find a modem
    local modem = peripheral.find("modem")
    if not modem then
        print("No modem found. Please attach a modem and try again.")
        sleep(3)
        return
    end
    
    -- Open the modem
    rednet.open(peripheral.getName(modem))
    
    print("RedNet client started. Press any key to continue.")
    os.pullEvent("key")
    
    while true do
        drawClient()
        local message = getInput()
        if message:lower() == "exit" then
            break
        end
        sendMessage(message)
    end
    
    rednet.close(peripheral.getName(modem))
end

return {
    run = run
}
