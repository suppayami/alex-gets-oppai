OppaiBlock = class(Block)
OppaiBlock.blockInit = OppaiBlock.super.init

function OppaiBlock:init(x, y)
    local width, height = 16, 16
    self:blockInit(x, y, width, height)
    self.fallSpeed = 4 + randomNumber:random(0, 4)
    self.fallAccel = 0.1
    self.destroyed = false
end

function OppaiBlock:is_oppai()
    return true
end

function OppaiBlock:is_destroyed()
    return self.destroyed
end

function OppaiBlock:destroy()
    if self.destroyed then return end
    self.destroyed = true
    local points = 500 + math.floor(MapManager.height - MapManager.minHeightOppai)
    MapManager.bonusPoints = MapManager.bonusPoints + points
    local oppaiSE = love.audio.newSource("[Oppai SE] Woohoo.ogg", "stream")
    love.audio.play(oppaiSE)
    LayerManager:getSprite("main", "player_bubble"):show()
end

function OppaiBlock:forceDestroy()
    self.destroyed = true
end

function OppaiBlock:update()
    local quad = MapManager.quad
    local hash = MapManager:getObjects()
    local collide = false
    if self.destroyed then return end
    self.y = self.y + self.fallSpeed
    self.fallSpeed = self.fallSpeed + self.fallAccel
    if self.fallAccel > 0 then self.fallSpeed = self.fallSpeed + MapManager.boost end
    for k,v in pairs(hash) do
        if (self ~= v) then
            local inWidth  = (self.x + self.width > v.x) and (self.x < v.x + v.width)
            local inHeight = self.y <= v.y and self.y + self.height >= v.y
            if inWidth and inHeight and self.fallSpeed > 0 then
                self.y = v.y - self.height
                if v.is_base then self.fallSpeed, self.fallAccel = 0, 0 end
                if v.fallSpeed == 0 and not v.is_player and not v.is_oppai then self.fallSpeed, self.fallAccel = 0, 0 end
                if v.is_player then self:destroy() end
            end
            if self.destroyed then return end
            if inWidth and inHeight then collide = true end
            if not collide then
                self.fallAccel = 0.1
                if self.fallSpeed == 0 then 
                    self.fallSpeed = 4
                end
            end
        end
    end
end