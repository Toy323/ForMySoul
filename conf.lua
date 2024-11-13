function love.conf(t)
    t.window.width = 1920
    t.window.height = 1080
end

-- love.window.setMode way
love.window.setMode(1920, 1080, settings)

-- love.window.updateMode way
love.window.updateMode(1920, 1080)