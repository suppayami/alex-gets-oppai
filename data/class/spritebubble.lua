SpriteBubble = class(Sprite)
SpriteBubble.initSprite = SpriteBubble.super.init

function SpriteBubble:init(actor)
    self.actor = actor
    self.frame = 0
    self.tick  = 4
    self.per   = 12
    self.z = self.actor.z + 100
    self:initSprite()
    self:setImage(Cache:loadImage("Heart Bubble.png"))
    self:setQuad(0, 0, 34, 34)
    self.alpha = 0
end

function SpriteBubble:update()
    self:faceLeft(self.actor.mirror)
    if self.alpha <= 0 then return end
    if self.actor.mirror then
        self.x = self.actor.x - 12
    else
        self.x = self.actor.x + 12
    end
    self.y = self.actor.y - 46
    self:setQuad(34 * self.frame, 0 , 34, 34)
    if self.frame == 3 then
        self.per = self.per - 1
        self.alpha = math.min((self.per + 24) / 12 * 255, 255)
        return
    end
    if self.tick <= 0 then
        self.tick = 4
        self.frame = (self.frame + 1) % 4
    end
    self.tick = self.tick - 1
end

function SpriteBubble:faceLeft(flag)
    self.mirror = flag
    if flag then self.ox = self:width() / 2 else self.ox = 0 end
end

function SpriteBubble:show()
    self.per = 12
    self.frame = 0
    self.alpha = 255
end