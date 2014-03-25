SpriteBack = class(Sprite)
SpriteBack.initSprite = SpriteBack.super.init

function SpriteBack:init(base, baseY)
    local name = ""
    if base then
        name = "Background_Base.png"
    else
        name = "Background_Loop.png"
    end
    self.baseY = baseY
    self:initSprite()
    self.z = 0
    self:setImage(Cache:loadImage(name))
end

function SpriteBack:update()
    self.x = 0
    self.y = self.baseY + math.round(MapManager.height * 2 / 7)
end