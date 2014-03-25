RandomNinja = class(Block)
RandomNinja.blockInit = RandomNinja.super.init

function RandomNinja:init()
    local width, height = 21, 23
    local x, y = 0, 0
    x = randomNumber:random(64, 540)
    y = - MapManager.height - 64
    self:blockInit(x, y, width, height)
    self.fallSpeed = 4 + randomNumber:random(0, 2)
    self.fallAccel = 0.1
    self.destroyed = false
end

function RandomNinja:is_ninja()
    return true
end

function RandomNinja:is_destroyed()
    return self.destroyed
end

function RandomNinja:update()
    self.y = self.y + self.fallSpeed
    self.fallSpeed = self.fallSpeed + self.fallAccel
end