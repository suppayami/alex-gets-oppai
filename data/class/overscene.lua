OverScene = class(Object)

function OverScene:setup()
    self:initVariables()
    self:initSprites()
end

function OverScene:initVariables()
    self.index = 0
    self.endOver = 16
    --bgm:stop()
    --overSE:play()
    do
        local data = {}
        local str = ""
        local fin = ""
        local score = math.round(MapManager.objects[4].maxY * 10) + MapManager.bonusPoints
        if love.highscore < score then
            local file = io.open("highscore.vl0z", "w")
            data["highscore"] = score
            str = JSON:encode(data)
            for i=1,str:len() do
                fin = fin..string.char(bit.bxor(str:byte(i), 2))
            end
            file:write(fin)
            love.highscore = score
            file:close()
        end
    end
end

function OverScene:initSprites()
    
    local sprite = LayerManager:addSprite("over", "main", Sprite)
    sprite:setImage(Cache:loadImage("GameOver.png"))
    local sprite = LayerManager:addSprite("over", "cmd1", Sprite)
    sprite:setImage(Cache:loadImage("GameOver_RetrySelected.png"))
    sprite.x = 271
    sprite.y = 450
    local sprite = LayerManager:addSprite("over", "cmd2", Sprite)
    sprite:setImage(Cache:loadImage("GameOver_Menu.png"))
    sprite.x = 242
    sprite.y = 490
end

function OverScene:update()
    self.endOver = self.endOver - 1
    if self.endOver == 0 then 
        --self:initSprites()
        overSE:play()
    end
    if self.endOver > 0 then return end
    if self.index == 0 then
        local sprite = LayerManager:getSprite("over", "cmd1")
        sprite:setImage(Cache:loadImage("GameOver_RetrySelected.png"))
        local sprite = LayerManager:getSprite("over", "cmd2")
        sprite:setImage(Cache:loadImage("GameOver_Menu.png"))
    else
        local sprite = LayerManager:getSprite("over", "cmd1")
        sprite:setImage(Cache:loadImage("GameOver_Retry.png"))
        local sprite = LayerManager:getSprite("over", "cmd2")
        sprite:setImage(Cache:loadImage("GameOver_MenuSelected.png"))
    end
end

function OverScene:draw()
    --if self.endOver > 1 then return end
    self:drawScore()
end

function OverScene:drawScore()
    local score = math.round(MapManager.objects[4].maxY * 10) + MapManager.bonusPoints
    if score == 0 then
        love.graphics.draw(Cache:loadImage("Numbers.png"), love.graphics.newQuad(9 * 16, 0, 16, 16, 160, 16), 306, 300, 0, 2.0, 2.0)
    else
        local n = score
        local x = math.floor(math.log10(n))
        local m = x
        while n > 0 do
            local i = n % 10
            if i == 0 then i = 9 else i = i - 1 end
            love.graphics.draw(Cache:loadImage("Numbers.png"), love.graphics.newQuad(i * 16, 0, 16, 16, 160, 16), (600 - 18 * m) / 2 + 18 * x, 300, 0, 2.0, 2.0)
            n = math.floor(n / 10)
            x = x - 1
        end
    end
end