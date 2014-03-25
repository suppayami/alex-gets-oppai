-- singleton
MapManager = class(Object)

function MapManager:setup()
    self:initVariable()
    self:initWall()
    --self:initPlayer()
end

function MapManager:initVariable()
    self.height    = 0 -- init camera Y
    self.scroll    = DataManager.general.scrollSpeed * oppai.scale -- init scrolling speed
    self.accel     = DataManager.general.scrollAccel * oppai.scale
    self.objects   = {}
    self.dropFrame = 60
    self.dropOppaiF = 150
    self.lastX     = 0
    self.boost     = 0
    self.startFrame = 72
    self.bonusPoints = 0
    self.forceScroll = 0
    self.dropNinjaF = 200

    self.delayOppai = 20 * 60
    self.delayNinja = 60 * 60
end

function MapManager:initWall()
    local image = Cache:loadImage("Background_Base.png")
    LayerManager:clearLayer("main")
    Cache:loadImage("Background_Loop.png")
    self.objects[1] = Block:new(0, 600, 640, 40)
    self.objects[1].is_base = true
    self.objects[2] = Block:new(0, -100, 20, 370)
    self.objects[2].is_wall = true
    self.objects[3] = Block:new(600, -100, 20, 370)
    self.objects[3].is_wall = true
    --
    LayerManager:addSprite("main", "background", SpriteBack, true, love.window.getHeight() - 2400)
    LayerManager:addSprite("main", "ground", SpriteGround)
    LayerManager:addSprite("main", "wall"..self.height, SpriteWall, -416)
    self.wall = 0
    self.back = 0
end

function MapManager:initPlayer()
    self.objects[4] = PlayerBlock:new(1, 300, 556)
    LayerManager:addSprite("main", "player", SpritePlayer, self.objects[4], 1)
end

function MapManager:update()
    self:updateObjects()
    self:updateScroll()
    self:updateDrop()
    self:updateOppai()
    self:updateNinja()
end

function MapManager:updateObjects()
    for k,v in pairs(self.objects) do
        v:update()
    end
end

function MapManager:updateScroll()
    self.startFrame = self.startFrame - 1
    if self.startFrame > 0 then return end
    self.height = self.height + self.scroll
    self.scroll = self.scroll + self.accel
    self.boost  = self.boost + 0.000005
    if self.objects[4].y + math.round(self.height) <= 150 then
        --self.height = self.height + 0.8
        self.forceScroll = 120
    end
    if self.forceScroll > 0 then
        local h = math.min(self.forceScroll, 0.8)
        self.height = self.height + h
        self.forceScroll = self.forceScroll - h
    end
    if self.boost >= 0.5 then self.boost = 0.5 end
    if self.scroll >= 0.75 then self.scroll = 0.75 end
    if self.height >= 416 + self.wall * 640 then
        self.wall = self.wall + 1
        LayerManager:addSprite("main", "wall"..self.height, SpriteWall, -416 - self.wall * 640)
    end
    if self.height >= 1760 + self.back * 816 then
        self.back = self.back + 1
        LayerManager:addSprite("main", "background"..self.back, SpriteBack, false, -1760 - self.back * 816)
    end
    self.objects[2].y = -100 - self.height
    self.objects[3].y = -100 - self.height
end

function MapManager:updateDrop()
    self.dropFrame = self.dropFrame - 1
    if self.dropFrame > 0 then return end
    self.dropFrame = 120 - self.height / 240
    if self.dropFrame < 76 then self.dropFrame = 76 end
    self:dropBox()
end

function MapManager:updateOppai()
    if self.delayOppai > 0 then self.delayOppai = self.delayOppai - 1 end
    if self.delayOppai > 0 then return end
    self.dropOppaiF = self.dropOppaiF - 1
    if self.delayOppai == 0 and not self.minHeightOppai then self.minHeightOppai = math.floor(self.height) end
    if self.dropOppaiF > 0 then return end
    self.dropOppaiF = 240 - self.height / 100
    if self.dropOppaiF < 48 then self.dropOppaiF = 48 end
    self:dropOppai()
end

function MapManager:updateNinja()
    self.delayNinja = self.delayNinja - 1
    self.dropNinjaF = self.dropNinjaF - 1
    if self.delayNinja > 0 then return end
    if self.dropNinjaF > 0 then return end
    self.dropNinjaF = 200 - self.height / 240
    if self.dropNinjaF < 120 then self.dropNinjaF = 120 end
    self:dropNinja()
end

function MapManager:getObjects()
    local hash = {}
    for k,v in pairs(self.objects) do
        if (v.y + self.height <= love.window.getHeight() + 100) then 
            if not v:is_destroyed() then
                hash[#hash+1] = v 
            end
        end
    end
    return hash
end

function MapManager:getObjectsNonNinja()
    local hash = {}
    for k,v in pairs(self.objects) do
        if (v.y + self.height <= love.window.getHeight() + 100) then 
            if (not v:is_destroyed()) and (not v.is_ninja) then
                hash[#hash+1] = v 
            end
        end
    end
    return hash
end

function MapManager:dropBox()
    local hash  = {1, 4, 5}
    if self.height >= 0 then hash[4] = 2 end
    if self.height >= 0 then hash[5] = 3 end
    if self.height >= 0 then hash[6] = 7 end
    if self.height >= 0 then hash[7] = 6 end
    local index = hash[randomNumber:random(1, #hash)]
    local data  = DataManager.boxes[index]
    local x = 0
    local y = - self.height * 1.1 - data.size[2] * 2 - 100
    local grid = randomNumber:random(0, 10 - data.size[1] / 28)

    while math.floor(grid / 2) == math.floor(self.lastX / 2) do
        grid = randomNumber:random(0, 10 - data.size[1] / 28)
    end

    self.lastX = grid
    x = grid * 28 * 2 + 40

    for k,v in pairs(self:getObjects()) do
        local inWidth  = (x + data.size[1] * 2 > v.x) and (x < v.x + v.width)
        local inHeight = (y + data.size[2] * 2 >= v.y) and (y < v.y + v.width)
        if inWidth and inHeight then
            y = v.y - data.size[2] * 2
        end
    end

    local box = BoxBlock:new(index, x, y)
    self.objects[#self.objects+1] = box
    local sprite = LayerManager:addSprite("main", "sprite"..#self.objects, SpriteBox, box)
    sprite:setImage(Cache:loadImage(data.image))
end

function MapManager:dropOppai()
    local x = 0
    local y = - self.height * 1.1 - 32 - 100

    x = randomNumber:random(41, 566)

    for k,v in pairs(self:getObjects()) do
        local inWidth  = (x + 32 > v.x) and (x < v.x + v.width)
        local inHeight = (y + 32 >= v.y) and (y < v.y + v.width)
        if inWidth and inHeight then
            y = v.y - 32
        end
    end

    local box = OppaiBlock:new(x, y)
    self.objects[#self.objects+1] = box
    local sprite = LayerManager:addSprite("main", "oppai"..#self.objects, SpriteOppai, box)
end

function MapManager:dropNinja()
    local box = nil
    if randomNumber:random(1, 100) < 40 then
        if randomNumber:random(1, 100) < 50 then
            box = SlideNinja:new(true)
        else
            box = SlideNinja:new(false)
        end
    else
        box = RandomNinja:new()
    end
    self.objects[#self.objects+1] = box
    local sprite = LayerManager:addSprite("main", "ninja"..#self.objects, SpriteNinja, box)
end