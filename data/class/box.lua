BoxBlock = class(Block)
BoxBlock.blockInit = BoxBlock.super.init

function BoxBlock:init(boxId, x, y)
    local boxData = DataManager.boxes[boxId]
    local width, height = boxData.size[1], boxData.size[2]
    self:blockInit(x, y, width, height)
    self.fallSpeed = boxData.fallSpeed + math.random(2)
    self.fallAccel = boxData.fallAccel
    self.backupAccel = boxData.fallAccel
    self.backupFall  = self.fallSpeed
    self.melting = 120
    self.startMelt = false
    self.destroyed = false
    self.killPlayer = false
    if boxId == 6 or boxId == 7 then self.is_ice = true end
end

function BoxBlock:update()
    local quad = MapManager.quad
    local hash = MapManager:getObjectsNonNinja()
    local collide = false
    if self.destroyed then return end
    if self.startMelt then
        self.melting = self.melting - 1
        if self.melting <= 0 then
            self:destroy()
        end
    end
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
                if v.is_player and v.fallSpeed < self.fallSpeed and (v.fallSpeed ~= 0 or v.fallAccel ~= 0) then v.fallSpeed = self.fallSpeed; v.y = v.y + 1 end
                if v.is_player and v.fallSpeed == 0 and v.fallAccel == 0 then
                    local sprite = LayerManager:getSprite("main", "player")
                    --sprite.z = -100
                    --sprite.alpha = 0
                    --LayerManager:drawAll()
                    --v.destroyed = true
                    self.killPlayer = true
                end
                if v.is_oppai then v:forceDestroy() end
            end
            if inWidth and inHeight then collide = true end
            if not collide then
                self.fallAccel = self.backupAccel
                if self.fallSpeed == 0 then
                    self.fallSpeed = self.backupFall
                end
            end
        end
    end
    if self:realY() + self.height >= love.window.getHeight() and self.fallSpeed > 0 and MapManager.height > 40 then
        --self.y = love.window.getHeight() - self.height - MapManager.height
        self.fallSpeed = 0
        self.fallAccel = 0
    end
    if self.killPlayer then
        local dieSE = love.audio.newSource("Dying SE.ogg", "stream")
        love.audio.play(dieSE)
        scene = "gotFuck"
        return
        -- scene = "over"
        -- OverScene:setup()
    end
end

function BoxBlock:touchMelt()
    self.startMelt = true
end

function BoxBlock:is_destroyed()
    return self.destroyed
end

function BoxBlock:destroy()
    if self.destroyed then return end
    self.destroyed = true
end