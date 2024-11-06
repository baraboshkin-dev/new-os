
-- api/users.lua
local users = {}
local userFile = "users.db"

function users.addUser(username, password)
    local file = fs.open(userFile, "a")
    file.writeLine(username .. ":" .. password)
    file.close()
end

function users.authenticate(username, password)
    local file = fs.open(userFile, "r")
    for line in file.readLine do
        local user, pass = line:match("([^:]+):([^:]+)")
        if user == username and pass == password then
            file.close()
            return true
        end
    end
    file.close()
    return false
end

return users
