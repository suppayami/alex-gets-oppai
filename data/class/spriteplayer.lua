SpritePlayer = class(Sprite)
SpritePlayer.initSprite = SpritePlayer.super.init

function SpritePlayer:init(block, id)
    self.block  = block
    self.playerId = id
    self.frame  = 2
    self.tick   = 6
    self:initSprite()
    self:setImage(Cache:loadImage(DataManager.players[id].name.." - Act.png"))
    self:setQuad(0, 0, DataManager.players[id].size[1], DataManager.players[id].size[2])
    self.dieFall  = -12
    self.dieAccel = 1
    self.z = 1000000
    LayerManager:addSprite("main", "player_slide", SpriteSlide, self)
    LayerManager:addSprite("main", "player_bubble", SpriteBubble, self)
end

function SpritePlayer:update()
    if scene == "map" then
        self.x = self.block:realX() - 18
        self.y = self.block:realY() - 12
        if math.abs(self.block.fallSpeed) + self.block.fallAccel > 0 then
            self:setImage(Cache:loadImage(DataManager.players[self.playerId].name.." - Act.png"))
            if self.block.slide then
                self:setQuad(68, 0, 34, 34)
            else
                self:setQuad(34, 0, 34, 34)
            end
            self.frame = 3
        else
            if self.block.move then
                self:setImage(Cache:loadImage(DataManager.players[self.playerId].name.." - Run.png"))
                self:setQuad(34 * self.frame, 0 , 34, 34)
                if self.tick <= 0 then
                    self.tick = 6
                    self.frame = (self.frame + 1) % 6
                end
                self.tick = self.tick - 1
            else
                self:setImage(Cache:loadImage(DataManager.players[self.playerId].name.." - Act.png"))
                self:setQuad(0, 0, 34, 34)
                self.frame = 3
            end
        end
        if self.block.slide then
            self:faceLeft(not self.block.left)
        else
            self:faceLeft(self.block.left)
        end
        return
    end

    if scene == "gotFuck" then
        self:setImage(Cache:loadImage("Die.png"))
        self.y = self.y + self.dieFall
        self.dieFall = self.dieFall + self.dieAccel
        self.z = 1000000
        if self.y > 640 then
            scene = "over"
            OverScene:setup()
        end
        return
    end
end

function SpritePlayer:faceLeft(flag)
    self.mirror = flag
    if flag then self.ox = self:width() / 2 else self.ox = 0 end
end