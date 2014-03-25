SlideNinja = class(Block)
SlideNinja.blockInit = SlideNinja.super.init

function SlideNinja:init(leftWall)
    local width, height = 18, 27
    local x, y = 0, 0
    if leftWall then
        x = 40
    else
        x = 564
    end
    y = - MapManager.height - 64
    self:blockInit(x, y, width, height)
    self.fallSpeed = 2 + randomNumber:random(1, 2)
    self.destroyed = false
    self.slide = true
end

function SlideNinja:is_ninja()
    return true
end

function SlideNinja:is_destroyed()
    return self.destroyed
end

function SlideNinja:update()
    self.y = self.y + self.fallSpeed
end