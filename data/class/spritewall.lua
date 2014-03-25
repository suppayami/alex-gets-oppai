SpriteWall = class(Sprite)
SpriteWall.initSprite = SpriteWall.super.init

function SpriteWall:init(baseY)
    self.baseY = baseY
    self:initSprite()
    self:setImage(Cache:loadImage("Wall_Loop.png"))
end

function SpriteWall:update()
    self.x = 0
    self.y = self.baseY + math.round(MapManager.height)
end