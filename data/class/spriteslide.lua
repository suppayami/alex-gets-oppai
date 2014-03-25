SpriteSlide = class(Sprite)
SpriteSlide.initSprite = SpriteSlide.super.init

function SpriteSlide:init(actor)
    self.actor = actor
    self.frame = 0
    self.tick  = 4
    self.z = self.actor.z + 100
    self:initSprite()
    self:setImage(Cache:loadImage("Sliding Effect.png"))
    self:setQuad(0, 0, 34, 34)
end

function SpriteSlide:update()
    if self.actor.block.slide then
        self.alpha = 255
    else
        self.alpha = 0
    end
    if self.actor.mirror then
        self.x = self.actor.x + 8
    else
        self.x = self.actor.x - 8
    end
    self.y = self.actor.y - 24
    self:setQuad(34 * self.frame, 0 , 34, 34)
    if self.tick <= 0 then
        self.tick = 4
        self.frame = (self.frame + 1) % 4
    end
    self.tick = self.tick - 1
    self:faceLeft(self.actor.mirror)
end

function SpriteSlide:faceLeft(flag)
    self.mirror = flag
    if flag then self.ox = self:width() / 2 else self.ox = 0 end
end