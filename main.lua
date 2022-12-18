function love.load()
    anim8 = require("libraries/anim8/anim8")
    --bg = love.graphics.newImage("sprites/rt1a.png")
    --ash = love.graphics.newImage("sprites/playerSheet1.png")
    sprites = {}
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet1.png')
    sprites.bg = love.graphics.newImage("sprites/rt1a.png")
    player = {}
    player.x = (love.graphics.getWidth() / 2)
    player.y = (love.graphics.getHeight() / 2)
    --player.animSpeed = 0.14
    player.grid = anim8.newGrid(32, 46, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
    player.animations = {}
    player.animations.walkDown = anim8.newAnimation(player.grid('1-8',1), 0.2)
    player.animations.walkLeft = anim8.newAnimation(player.grid('1-8',2), 0.2)
    player.animations.walkRight = anim8.newAnimation(player.grid('1-8',3), 0.2)
    player.animations.walkUp = anim8.newAnimation(player.grid('1-8',4), 0.2)
    player.anim = player.animations.walkDown
    
    
end



function love.update(dt)
    --Store player location
    local previousX = player.x
    local previousY = player.y
     -- Move Player Left or Right
     if love.keyboard.isDown("left") then
        player.x = player.x - 200 * dt
        player.anim = player.animations.walkLeft
        
    elseif love.keyboard.isDown("right") then
        player.x = player.x + 200 * dt
        player.anim = player.animations.walkRight
    end
    -- Move Player Up or Down
    if love.keyboard.isDown("up") then
        player.y = player.y - 200 * dt
        player.anim = player.animations.walkUp
    elseif love.keyboard.isDown("down") then
        player.y = player.y + 200 * dt
        player.anim = player.animations.walkDown
    end
    --check to see if player is moving
    if previousX ~= player.x or previousY ~= player.y then
        player.isMoving = true
    else
        player.isMoving = false
        --set animation to standing image
        player.anim:gotoFrame(3)
    end
    if player.isMoving then
        player.anim:update(dt)
    end
end

function love.draw()
    love.graphics.draw(sprites.bg, 0, 0, 0, 2, 2)
    --love.graphics.draw(ash, player.x, player.y, 0, 1.5, 1.5)
    if player.anim == player.animations.walkDown then
        player.animations.walkDown:draw(
            sprites.playerSheet, player.x, player.y, 0, 1.5, 1.5
        )

    elseif player.anim == player.animations.walkUp then
        player.animations.walkUp:draw(
            sprites.playerSheet, player.x, player.y, 0, 1.5, 1.5
        )

    elseif player.anim == player.animations.walkLeft then
        player.animations.walkLeft:draw(
            sprites.playerSheet, player.x, player.y, 0, 1.5, 1.5
        )

    elseif player.anim == player.animations.walkRight then
        player.animations.walkRight:draw(
            sprites.playerSheet, player.x, player.y, 0, 1.5, 1.5
        )
    end

end

