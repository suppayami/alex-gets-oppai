Block = class(Object)

function Block:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width  = width * oppai.scale
    self.height = height * oppai.scale
end

function Block:update()
    -- reserved
end

function Block:realX()
    return self.x
end

function Block:realY()
    return self.y + math.round(MapManager.height)
end

function Block:is_destroyed()
    return false
end