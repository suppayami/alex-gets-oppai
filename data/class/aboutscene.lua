AboutScene = class(Object)

function AboutScene:setup()
    self:initSprites()
end

function AboutScene:initSprites()
    local sprite = LayerManager:addSprite("about", "main", Sprite)
    sprite:setImage(Cache:loadImage("About Screen.png"))
end