SpriteBox = class(Sprite)
SpriteBox.initSprite = SpriteBox.super.init

function SpriteBox:init(block)
    self.block = block
    self:initSprite()
end

function SpriteBox:update()
    self.x = self.block:realX()
    self.y = self.block:realY()
    self.alpha = 255 * self.block.melting / 120
    if self.block:is_destroyed() then
        self:unsetImage()
    end
end