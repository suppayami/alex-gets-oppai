SpriteGround = class(Sprite)
SpriteGround.initSprite = SpriteGround.super.init

function SpriteGround:init()
    self:initSprite()
    self:setImage(Cache:loadImage("Wall_Base.png"))
end

function SpriteGround:update()
    self.x = 0
    self.y = 224 + math.round(MapManager.height)
end