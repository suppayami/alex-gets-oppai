SpriteNinja = class(Sprite)
SpriteNinja.initSprite = SpriteNinja.super.init

function SpriteNinja:init(block)
    self.block  = block
    self:initSprite()
    self.z = 500
    if self.block.slide then
        self:setImage(Cache:loadImage("Sliding Ninja.png"))
    else
        self:setImage(Cache:loadImage("Jumping Ninja.png"))
    end
    if self.block.slide then
        if self.block.x == 564 then
            self:faceLeft(true)
        end
    end
    if not self.block.slide then
        if randomNumber:random(0, 100) < 50 then
            self:faceLeft(true)
        end
    end
    LayerManager:addSprite("main", "ninja_slide"..#MapManager.objects, SpriteSlide, self)
end

function SpriteNinja:update()
    if scene == "map" then
        self.x = self.block:realX()
        self.y = self.block:realY()
        return
    end
end

function SpriteNinja:faceLeft(flag)
    self.mirror = flag
    if flag then self.ox = self:width() / 2 else self.ox = 0 end
end