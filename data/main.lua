-- common modules
JSON = require 'common/json'
require 'common/object'
require 'common/sort'
require 'common/round'
-- core engine
require 'config'
require 'core/run'
-- classes & objects
require 'class/cache'
require 'class/datamanager'
require 'class/layermanager'
require 'class/sprite'
require 'class/spritebox'
require 'class/spriteground'
require 'class/spritewall'
require 'class/spriteplayer'
require 'class/spriteback'
require 'class/spriteoppai'
require 'class/quadtree'
require 'class/mapmanager'
require 'class/block'
require 'class/box'
require 'class/playerblock'
require 'class/oppaiblock'
require 'class/titlescene'
require 'class/spritelogo'
require 'class/aboutscene'
require 'class/overscene'
require 'class/spriteslide'
require 'class/slideninja'
require 'class/randomninja'
require 'class/spriteninja'
require 'class/spritebubble'

function love.load()
    scene = "title"
    bgm = love.audio.newSource("BGM.ogg", "stream")
    overSE = love.audio.newSource("Game Over SE.ogg", "stream")
    --sysFont = love.graphics.newFont("fonts/OpenSans-Semibold.ttf", 26)
    --love.graphics.setFont(sysFont)
    love.createDatabase()
    love.createTesting()
    bgm:setVolume(0.4)
    bgm:play()
    bgm:setLooping(true)
end

function love.draw()
    LayerManager:drawAll()
    if scene == "title" then TitleScene:draw() end
    if scene == "over" then OverScene:draw() end
    if scene == "map" or scene == "gotFuck" then drawHighscore() end
end

function drawHighscore()
    local score = math.round(MapManager.objects[4].maxY * 10) + MapManager.bonusPoints
    local img = Cache:loadImage("Numbers.png")
    if score == 0 then
        love.graphics.draw(img, love.graphics.newQuad(9 * 16, 0, 16, 16, 160, 16), 48, 8, 0, 2.0, 2.0)
    else
        local n = math.floor(score)
        local x = math.floor(math.log10(n))
        while n > 0 do
            local i = n % 10
            if i == 0 then i = 9 else i = i - 1 end
            love.graphics.draw(img, love.graphics.newQuad(i * 16, 0, 16, 16, 160, 16), 48 + x * 18, 8, 0, 2.0, 2.0)
            n = math.floor(n / 10)
            x = x - 1
        end
    end
end

function love.update(dt)
    if scene == "map" then MapManager:update() end
    if scene == "title" then TitleScene:update() end
    if scene == "over" then OverScene:update() end
    LayerManager:updateAll()
end

function love.createTesting()
    DataManager:setup()
    MapManager:setup()
    TitleScene:setup()
end

function love.createDatabase()
    do
        local file = io.open("highscore.vl0z","r")
        if file then
            local str = file:read("*all")
            local fin = ""
            for i=1,str:len() do
                fin = fin..string.char(bit.bxor(str:byte(i), 2))
            end
            local data = JSON:decode(fin)
            if data == nil then
                love.highscore = 0
            else
                love.highscore = tonumber(data["highscore"])
            end
            file:close()
        else
            local file = io.open("highscore.vl0z", "w")
            local data = {}
            local str = ""
            local fin = ""
            data["highscore"] = 0
            str = JSON:encode(data)
            for i=1,str:len() do
                fin = fin..string.char(bit.bxor(str:byte(i), 2))
            end
            file:write(fin)
            file:close()
            love.highscore = 0
        end
    end
end

function love.keypressed(key)
    if scene == "map" then
        local p = MapManager.objects[4]
        local hash = MapManager:getObjects()
        local wall = p.wall
        if p:is_destroyed() then return end
        if key == " "
          and ((p.fallSpeed == 0 and p.fallAccel == 0) 
          or (wall and not wall.is_jump and not wall.is_wall)) then
            if wall and (math.abs(p.fallSpeed) + p.fallAccel > 0) then
                for k,v in pairs(hash) do
                    v.is_jump = false
                end
                --wall.is_jump = true
                p.wall = nil
                p.fallSpeed = -10
                p.fallAccel = 0.5
                if wall.x > p.x then p.wJump = -64; p.left = true end
                if wall.x < p.x then p.wJump = 64; p.left = false end
            else
                p.fallSpeed = -12
                p.fallAccel = 0.5
                p.wall      = nil
            end
            local jumpSE = love.audio.newSource("[Jump SE] 8-bit Jump.ogg", "stream")
            jumpSE:setVolume(0.4)
            love.audio.play(jumpSE)
        end
        return
    end

    if scene == "title" then
        if key == "up" then
            TitleScene.index = math.max(0, TitleScene.index - 1)
            local cursorSE = love.audio.newSource("Cursor SE.wav", "stream")
            love.audio.play(cursorSE)
        end
        if key == "down" then
            TitleScene.index = math.min(1, TitleScene.index + 1)
            local cursorSE = love.audio.newSource("Cursor SE.wav", "stream")
            love.audio.play(cursorSE)
        end
        if key == "return" then
            if scene == "title" then
                local cursorSE = love.audio.newSource("Select SE.wav", "stream")
                love.audio.play(cursorSE)
                LayerManager:clearLayer("title")
                if TitleScene.index == 0 then
                    MapManager:setup()
                    MapManager:initPlayer()
                    scene = "map"
                end
                if TitleScene.index == 1 then
                    scene = "about"
                    AboutScene:setup()
                end
            end
        end
        return
    end

    if scene == "about" then
        LayerManager:clearLayer("about")
        scene = "title"
        TitleScene:setup()
        return
    end

    if scene == "over" then
        if key == "up" then
            OverScene.index = math.max(0, OverScene.index - 1)
            local cursorSE = love.audio.newSource("Cursor SE.wav", "stream")
            love.audio.play(cursorSE)
        end
        if key == "down" then
            OverScene.index = math.min(1, OverScene.index + 1)
            local cursorSE = love.audio.newSource("Cursor SE.wav", "stream")
            love.audio.play(cursorSE)
        end
        if key == "return" then
            if scene == "over" then
                LayerManager:clearLayer("over")
                if OverScene.index == 0 then
                    local cursorSE = love.audio.newSource("Select SE.wav", "stream")
                    love.audio.play(cursorSE)
                    MapManager:setup()
                    MapManager:initPlayer()
                    scene = "map"
                end
                if OverScene.index == 1 then
                    local cursorSE = love.audio.newSource("Select SE.wav", "stream")
                    love.audio.play(cursorSE)
                    scene = "title"
                    TitleScene:setup()
                end
            end
        end
        return
    end
end