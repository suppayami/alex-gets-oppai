-- singleton
DataManager = class(Object)

function DataManager:setup()
    self:initDatabase()
end

function DataManager:initDatabase()
    self:loadData("general.json", "general")
    self:loadData("boxes.json", "boxes")
    self:loadData("players.json", "players")
end

function DataManager:loadData(filename, key)
    local file = love.filesystem.newFile("database/"..filename)
    file:open("r")
    local read = file:read()
    self[key]  = JSON:decode(read)
end