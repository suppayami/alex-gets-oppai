SpriteOppai = class(Sprite)
SpriteOppai.initSprite = SpriteOppai.super.init

function SpriteOppai:init(block)
    self.block = block
    self:initSprite()
    self:setImage(Cache:loadImage("Oppai.png"))
end

function SpriteOppai:update()
    self.x = self.block:realX()
    self.y = self.block:realY()
    if self.block:is_destroyed() then
        self:unsetImage()
    end
end