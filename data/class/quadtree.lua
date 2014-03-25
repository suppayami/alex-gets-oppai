QuadTree = class(Object)
QuadTree.maxObject = 16
QuadTree.maxLevel  = 8

function QuadTree:init(level, x, y, width, height)
    self.x = x
    self.y = y
    self.width   = width * oppai.scale
    self.height  = height * oppai.scale
    self.level   = level
    self.objects = {}
    self.nodes   = {}
end

function QuadTree:clear()
    for k,v in pairs(self.objects) do self.objects[k] = nil end
    for k,v in pairs(self.nodes) do
        for k2,v2 in pairs(v.objects) do v.objects[k2] = nil end
        self.nodes[k] = nil
    end
end

function QuadTree:split()
    local level = self.level + 1
    local x, y  = self.x, self.y
    local width, height = self.width / 2, self.height / 2

    self.nodes[#self.nodes+1] = QuadTree:new(level, x, y, width, height)
    self.nodes[#self.nodes+1] = QuadTree:new(level, x+width, y, width, height)
    self.nodes[#self.nodes+1] = QuadTree:new(level, x+width, y+height, width, height)
    self.nodes[#self.nodes+1] = QuadTree:new(level, x, y+height, width, height)
end

function QuadTree:getIndex(block)
    local x, y, width, height = block.x, block.y, block.width, block.height
    local index      = 0
    local midPointX  = self.x + self.width / 2
    local midPointY  = self.y + self.height / 2
    local topQuad    = (y < midPointY) and (y + height < midPointY)
    local botQuad    = y > midPointY
    local leftQuad   = (x < midPointX) and (x + width < midPointX)
    local rightQuad  = x > midPointX

    if topQuad then
        if leftQuad then index = 1 end
        if rightQuad then index = 2 end
    end

    if botQuad then
        if leftQuad then index = 4 end
        if rightQuad then index = 3 end
    end

    return index
end

function QuadTree:add(block)
    if #self.nodes > 0 then
        local index = self:getIndex(block)
        if index > 0 then
            self.nodes[index]:add(block)
            return true
        end
    end

    self.objects[#self.objects+1] = block

    if (#self.objects > self.maxObject) and (self.level < self.maxLevel) then
        local hash = self.objects
        if #self.nodes == 0 then self:split() end
        self.objects = {}
        for k,v in pairs(hash) do
            local index = self:getIndex(v)
            if index > 0 then 
                self.nodes[index]:add(v)
            else
                self.objects[#self.objects+1] = v
            end
        end
    end
end

function QuadTree:checkingObjects(hash, block)
    if not hash then hash = {} end
    local index = self:getIndex(block)
    if (index > 0) and (#self.nodes > 0) then
        self.nodes[index]:checkingObjects(hash, block)
    end
    for k,v in pairs(self.objects) do
        hash[#hash+1] = v
    end
    return hash
end