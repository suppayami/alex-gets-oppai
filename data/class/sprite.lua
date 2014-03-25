Sprite = class(Object)

function Sprite:init()
    self.x, self.y, self.z = 0, 0, 5
    self.ox, self.oy = 0, 0
    self.zoom_x, self.zoom_y = 1, 1
    self.red, self.green, self.blue, self.alpha = 255, 255, 255, 255
    self.angle = 0
    self.image = nil
    self.quad  = nil
    self.blendMode = "alpha"
    self.shader = nil
    self.mirror = false
end

function Sprite:width()
    local x, y, w, h = self.quad:getViewport()
    return w * math.abs(self:realZoomX())
end

function Sprite:height()
    local x, y, w, h = self.quad:getViewport()
    return h * math.abs(self:realZoomY())
end

function Sprite:quadX()
    local x, y, w, h = self.quad:getViewport()
    return x 
end

function Sprite:quadY()
    local x, y, w, h = self.quad:getViewport()
    return y 
end

function Sprite:realZoomX()
    local result = self.zoom_x * oppai.scale
    if self.mirror then result = result * -1 end
    return result
end

function Sprite:realZoomY()
    return self.zoom_y * oppai.scale
end

function Sprite:draw()
    if self.image then
        if self.x > love.window.getWidth()
            or self.x + self:width() < 0
            or self.y > love.window.getHeight()
            or self.y + self:height() < 0 then
            return false
        end
        love.graphics.setShader(self.shader)
        love.graphics.setBlendMode(self.blendMode)
        love.graphics.setColor(self.red, self.green, self.blue, self.alpha)
        love.graphics.draw(self.image, self.quad, self.x, self.y, self.angle, 
            self:realZoomX(), self:realZoomY(), self.ox, self.oy)
    end
end

function Sprite:setImage(image)
    local iw, ih = image:getWidth(), image:getHeight()
    self.image = image
    self.quad  = love.graphics.newQuad(0, 0, iw, ih, iw, ih)
end

function Sprite:unsetImage()
    self.image = nil
    self.quad  = nil
end

function Sprite:update(dt)
    -- reserved
end

function Sprite:setQuad(x, y, w, h)
    if not x then x = self:quadX() end
    if not y then y = self:quadY() end
    if not w then w = self:width() end
    if not h then h = self:height() end
    self.quad:setViewport(x, y, w, h)
end