TitleScene = class(Object)

function TitleScene:setup()
    self:initVariables()
    self:initSprites()
end

function TitleScene:initVariables()
    self.index = 0
end

function TitleScene:initSprites()
    local sprite = LayerManager:addSprite("title", "title", Sprite)
    sprite:setImage(Cache:loadImage("Title.png"))
    LayerManager:addSprite("title", "logo", SpriteLogo)
    local sprite = LayerManager:addSprite("title", "cmd1", Sprite)
    sprite:setImage(Cache:loadImage("Title_NewGame.png"))
    sprite.x = 251
    sprite.y = 450
    local sprite = LayerManager:addSprite("title", "cmd2", Sprite)
    sprite:setImage(Cache:loadImage("Title_About.png"))
    sprite.x = 266
    sprite.y = 490
end

function TitleScene:update()
    if self.index == 0 then
        local sprite = LayerManager:getSprite("title", "cmd1")
        sprite:setImage(Cache:loadImage("Title_NewGameSelected.png"))
        local sprite = LayerManager:getSprite("title", "cmd2")
        sprite:setImage(Cache:loadImage("Title_About.png"))
    else
        local sprite = LayerManager:getSprite("title", "cmd1")
        sprite:setImage(Cache:loadImage("Title_NewGame.png"))
        local sprite = LayerManager:getSprite("title", "cmd2")
        sprite:setImage(Cache:loadImage("Title_AboutSelected.png"))
    end
end

function TitleScene:draw()
    if love.highscore == nil then return end
    if love.highscore == 0 then
        love.graphics.draw(Cache:loadImage("Numbers.png"), love.graphics.newQuad(9 * 16, 0, 16, 16, 160, 16), 306, 348, 0, 2.0, 2.0)
    else
        local n = love.highscore
        local x = math.floor(math.log10(n))
        local m = x
        while n > 0 do
            local i = n % 10
            if i == 0 then i = 9 else i = i - 1 end
            love.graphics.draw(Cache:loadImage("Numbers.png"), love.graphics.newQuad(i * 16, 0, 16, 16, 160, 16), (600 - 18 * m) / 2 + 18 * x, 348, 0, 2.0, 2.0)
            n = math.floor(n / 10)
            x = x - 1
        end
    end
end