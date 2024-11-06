
-- /os/apps/rednet_client.lua
local function drawClient()
    term.clear()
    term.setCursorPos(1,1)
    term.write("RedNet Client")
    term.setCursorPos(1,3)
    term.write("Enter message (or 'exit' to quit): ")
end

local function getInput()
    local input = read()
    return input
end

local function sendMessage(message)
    rednet.broadcast(message)
    print("Message sent: " .. message)
    sleep(2)
end

local function run()
    rednet.open("back")  -- Открываем модем (предполагается, что он сзади компьютера)
    print("RedNet client started. Press any key to continue.")
    os.pullEvent("key")
    
    while true do
        drawClient()
        local message = getInput()
        if message == "exit" then
            break
        end
        sendMessage(message)
    end
    
    rednet.close("back")
end

return {
    run = run
}
