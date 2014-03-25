-- Singleton
Cache = class(Object)
Cache.cache = {}

function Cache:loadImage(filename)
    local hash = self.cache
    if hash[filename] then return hash[filename] end
    hash[filename] = love.graphics.newImage(filename)
    hash[filename]:setFilter("nearest", "nearest")
    return hash[filename]
end

function Cache:flush()
    local hash = self.cache
    for k,v in pairs(hash) do hash[k] = nil end
end

function Cache:flushImage(filename)
    local hash = self.cache
    hash[filename] = nil
end