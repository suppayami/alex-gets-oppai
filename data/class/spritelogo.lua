SpriteLogo = class(Sprite)
SpriteLogo.initSprite = SpriteLogo.super.init

function SpriteLogo:init()
    self:initSprite()
    self:setImage(Cache:loadImage("Logo_171x98.png"))
    self.index = 0
    self.count = 8
    self.x = love.window.getWidth() / 2 - 171
    self.y = 128
    self:setQuad(self.index * 171, 0, 171, 98)
end

function SpriteLogo:update()
    self.count = self.count - 1
    if self.count <= 0 then
        self.count = 8
        self.index = (self.index + 1) % 12
        self:setQuad(self.index * 171, 0, 171, 98)
    end
end