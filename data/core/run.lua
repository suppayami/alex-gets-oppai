love.fps = 0

function love.run()

    local resWidth = oppai.resolution.width * oppai.scale
    local resHeight = oppai.resolution.height * oppai.scale
    if love.window then
        love.window.setMode(resWidth, resHeight, {vsync=false})
    end

    if love.math then
        randomNumber = love.math.newRandomGenerator()
        local minSeed = os.clock() * 100000 + tonumber(os.date("%M%m%S"))
        local maxSeed = os.clock() * 100000 + tonumber(os.date("%S%m%M%y")) * 4
        randomNumber:setSeed(minSeed, maxSeed)
    end

    if love.event then
        love.event.pump()
    end

    if love.load then love.load(arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0
    local title = oppai.gameTitle.." | FPS: "
    local tick = 0
    local fps = 0
    local delta = 0
    local rfps = oppai.fps

    love.window.setTitle(title..love.fps)

    -- Main loop time.
    while true do
        -- Process events.
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end

        if love.timer then
            love.timer.step()
            delta = math.min(love.timer.getDelta(), 0.1)
            dt = dt + delta
            tick = tick + delta
        end

        if dt >= 1 / rfps then fps = fps + 1 end

        while dt >= 1 / rfps do
            if love.update then love.update(1 / rfps) end
            dt = dt - 1 / rfps
        end

        if tick >= 1 then
            love.window.setTitle(title..love.fps)
            love.fps = fps
            fps = 0
            tick = 0
        end

        if love.window and love.graphics and love.window.isCreated() then
            love.graphics.clear()
            love.graphics.origin()
            if love.draw then love.draw() end
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end

end