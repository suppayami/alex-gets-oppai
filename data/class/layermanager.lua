-- singleton
LayerManager = class(Object)
LayerManager.layer = {}
LayerManager.sort  = {}

function LayerManager:clearAll()
    for k,v in pairs(self.layer) do
        for i,s in pairs(v) do
            s:unsetImage()
            v[i] = nil
        end
        self.layer[k] = nil
    end
end

function LayerManager:clearLayer(layer)
    if self.layer[layer] == nil then return 0 end
    local l = self.layer[layer]
    for k,v in pairs(l) do
        v:unsetImage()
        l[k] = nil
    end
    self.layer[layer] = nil
end

function LayerManager:removeSprite(layer, spriteName)
    if self.layer[layer] == nil then return 0 end
    local l = self.layer[layer]
    if l[spriteName] == nil then return 0 end
    l[spriteName]:unsetImage()
    l[spriteName] = nil
end

function LayerManager:addSprite(layer, spriteName, spriteClass, ...)
    if self.layer[layer] == nil then self.layer[layer] = {} end
    --
    local l = self.layer[layer]
    if l[spriteName] then l[spriteName]:unsetImage() end
    l[spriteName] = spriteClass:new(...)
    self.sort[layer] = sortFunc.sortTable(l, function (a,b) return a.z < b.z end)
    return l[spriteName]
end

function LayerManager:sortSprite(layer)
    local l = self.layer[layer]
    self.sort[layer] = sortFunc.sortTable(l, function (a,b) return a.z < b.z end)
end

function LayerManager:draw(layer)
    if self.sort[layer] == nil then self.sort[layer] = {} end
    --
    local l = self.sort[layer]
    for i,s in pairs(l) do s:draw() end
end

function LayerManager:drawAll()
    for k,v in pairs(self.layer) do
        self:draw(k)
    end
end

function LayerManager:update(layer, dt)
    if self.layer[layer] == nil then self.layer[layer] = {} end
    --
    local l = self.layer[layer]
    for i,s in pairs(l) do s:update(dt) end
end

function LayerManager:updateAll(dt)
    for k,v in pairs(self.layer) do
        self:update(k, dt)
    end
end

function LayerManager:getSprite(layer, spriteName)
    return self.layer[layer][spriteName]
end

function LayerManager:getSprites(layer)
    return self.layer[layer]
end