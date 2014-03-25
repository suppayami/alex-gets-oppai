PlayerBlock = class(Block)
PlayerBlock.blockInit = PlayerBlock.super.init

function PlayerBlock:init(playerId, x, y)
    local data = DataManager.players[playerId]
    local width, height = 15, 22
    self:blockInit(x, y, width, height)
    self.fallSpeed = 0
    self.fallAccel = 0.5
    self.is_player = true
    self.left      = false
    self.move      = false
    self.slide     = false
    self.wall      = nil
    self.wJump     = 0
    self.maxY      = 0
    self.destroyed = false
end

function PlayerBlock:update()
    local quad = MapManager.quad
    local hash = MapManager:getObjects()
    local left  = 6
    local right = 6
    local coll  = false
    local d = 0
    if self:is_destroyed() then return end
    self.move  = false
    self.slide = false
    self.wall  = nil

    if self.wJump ~= 0 then
        if self.wJump < 0 then d = math.max(-6, self.wJump) end
        if self.wJump > 0 then d = math.min(6, self.wJump) end
        self.wJump = self.wJump - d
    end

    for k,v in pairs(hash) do
        if self ~= v then
            local inWidth  = (self.x + self.width > v.x) and (self.x < v.x + v.width)
            local upHeight = (self.y + self.fallSpeed) <= (v.y + v.height) and self.fallSpeed < 0 and self.y > v.y
            local doHeight = (self.y + self.fallSpeed + self.height) >= v.y and self.fallSpeed >= 0 and self.y < v.y
            if inWidth and (upHeight or doHeight) and not v.is_oppai then
                self.fallSpeed = 0
                if doHeight then self.fallAccel = 0 end
                if upHeight then self.y = v.y + v.height end
                if doHeight then self.y = v.y - self.height end
                coll = true
            end
            if not coll then self.fallAccel = 0.5 end

            local tWidth   = ((self.x > v.x) and (self.x - 6 <= (v.x + v.width))) or ((self.x < v.x) and ((self.x + self.width + 6) >= v.x))
            local tHeight  = (math.abs(self.y + self.height / 2 - v.y - v.height / 2) < (self.height / 2 + v.height / 2))
            if tWidth and tHeight then
                if (self.x > v.x and (self.x - 6) <= (v.x + v.width)) then
                    left  = math.max(self.x - v.x - v.width, 0)
                    if left == 0 then self.wall = v end
                end
                if (self.x < v.x and (self.x + self.width + 6) >= v.x) then
                    right = math.max(v.x - (self.x + self.width), 0)
                    if right == 0 then self.wall = v end
                end
                if (self.x > v.x and (self.x + d) <= (v.x + v.width)) then
                    self.wJump = 0
                    d = -math.max(self.x - v.x - v.width, 0)
                end
                if (self.x < v.x and (self.x + self.width + d) >= v.x) then
                    self.wJump = 0
                    d = math.max(v.x - (self.x + self.width), 0)
                end
            end
        end
    end

    if self.fallSpeed == 0 and self.fallAccel == 0 then
        for k,v in pairs(hash) do
            v.is_jump = false
        end
        self.wall = nil
    end

    if love.keyboard.isDown("left") and self.wJump == 0 and d == 0 then
        self.x = self.x - left
        self.left = true
        if left > 0 then self.move = true end
        if self.fallAccel > 0 and self.fallSpeed >= 0 and left == 0 then
            self.slide = true
            self.fallSpeed = 2
        end
    end
    if love.keyboard.isDown("right") and self.wJump == 0 and d == 0 then
        self.x = self.x + right
        self.left = false
        if right > 0 then self.move = true end
        if self.fallAccel > 0 and self.fallSpeed >= 0 and right == 0 then
            self.slide = true
            self.fallSpeed = 2
        end
    end

    self.y = self.y + self.fallSpeed
    self.fallSpeed = self.fallSpeed + self.fallAccel
    self.x = self.x + d
    if d ~= 0 then
        self.wall = nil
    end

    local h = 556 - self.y
    self.maxY = math.max(self.maxY, h)

    for k,v in pairs(hash) do
        if self ~= v then
            local inWidth  = (self.x + self.width > v.x) and (self.x < v.x + v.width)
            local upHeight = (self.y) <= (v.y + v.height) and self.y > v.y
            local doHeight = (self.y + self.height) >= v.y and self.y < v.y
            if inWidth and (upHeight or doHeight) then
                if v.is_oppai then v:destroy() end
                if v.is_ice then v:touchMelt() end
                if v.is_ninja then 
                    scene = "gotFuck"
                    local dieSE = love.audio.newSource("Dying SE.ogg", "stream")
                    love.audio.play(dieSE)
                    return
                end
                if not v:is_destroyed() and doHeight then
                    self.y = v.y - self.height
                end
            end

            local tWidth   = ((self.x > v.x) and (self.x - 6 <= (v.x + v.width))) or ((self.x < v.x) and ((self.x + self.width + 6) >= v.x))
            local tHeight  = (math.abs(self.y + self.height / 2 - v.y - v.height / 2) < (self.height / 2 + v.height / 2))
            if tWidth and tHeight then
                if (self.x > v.x and (self.x - 6) <= (v.x + v.width)) then
                    left  = math.max(self.x - v.x - v.width, 0)
                    if left == 0 and v.is_oppai then v:destroy() end
                    if left == 0 and v.is_ice then v:touchMelt() end
                    if left == 0 and v.is_ninja then
                        scene = "gotFuck"
                        local dieSE = love.audio.newSource("Dying SE.ogg", "stream")
                        love.audio.play(dieSE)
                        return
                    end
                end
                if (self.x < v.x and (self.x + self.width + 6) >= v.x) then
                    right = math.max(v.x - (self.x + self.width), 0)
                    if right == 0 and v.is_oppai then v:destroy() end
                    if right == 0 and v.is_ice then v:touchMelt() end
                    if right == 0 and v.is_ninja then
                        scene = "gotFuck"
                        local dieSE = love.audio.newSource("Dying SE.ogg", "stream")
                        love.audio.play(dieSE)
                        return
                    end
                end
            end
        end
    end

    if self:realY() > 642 then
        --scene = "over"
        local dieSE = love.audio.newSource("Dying SE.ogg", "stream")
        love.audio.play(dieSE)
        --OverScene:setup()
        scene = "gotFuck"
        return
    end
end

function PlayerBlock:is_destroyed()
    return self.destroyed
end