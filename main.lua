function love.load()
    anim8 = require("libraries/anim8/anim8")
    wf = require("libraries/windfield")
    require("obstacles")
    --bg = love.graphics.newImage("sprites/rt1a.png")
    --ash = love.graphics.newImage("sprites/playerSheet1.png")
    world = wf.newWorld()
    world:addCollisionClass('Platform')
    world:addCollisionClass('Player')
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
    player.collider = world:newCircleCollider(player.x, player.y, 20)
    create()
    
end



function love.update(dt)
    
    --move collider
    -- store collider vector info
    local vectorX = 0
    local vectorY = 0
    
     -- Move Player Left or Right
     if love.keyboard.isDown("left") then
        vectorX = -1
        player.anim = player.animations.walkLeft

    elseif love.keyboard.isDown("right") then
        vectorX = 1
        player.anim = player.animations.walkRight
    end

    -- Move Player Up or Down
    if love.keyboard.isDown("up") then
        vectorY = -1
        player.anim = player.animations.walkUp
        
    elseif love.keyboard.isDown("down") then
        vectorY = 1
        player.anim = player.animations.walkDown
    end
    --check to see if player collider is moving
    if vectorX == 0 and vectorY == 0 then
        player.isMoving = false
        --set animation to standing image
        player.anim:gotoFrame(3)
    else
        player.isMoving = true
    end
    if player.isMoving then
        -- player.x = player.x + 200 * vectorX * dt
        -- player.y = player.y + 200 * vectorY * dt
        player.collider:setLinearVelocity(vectorX * 200, vectorY * 200)
        player.anim:update(dt)
        world:update(dt)
    end
    
    
end

function love.draw()
    -- local px = player:getX()
    -- local py = player:getY()+1
    love.graphics.draw(sprites.bg, 0, 0, 0, 2, 2)
    --love.graphics.draw(ash, player.x, player.y, 0, 1.5, 1.5)
    if player.anim == player.animations.walkDown then
        player.animations.walkDown:draw(
            sprites.playerSheet, player.collider:getX() - 24 , player.collider:getY() - 38, 0, 1.5, 1.5
        )

    elseif player.anim == player.animations.walkUp then
        player.animations.walkUp:draw(
            sprites.playerSheet, player.collider:getX() - 24, player.collider:getY() - 38, 0, 1.5, 1.5
        )

    elseif player.anim == player.animations.walkLeft then
        player.animations.walkLeft:draw(
            sprites.playerSheet, player.collider:getX() - 24, player.collider:getY() - 38, 0, 1.5, 1.5
        )

    elseif player.anim == player.animations.walkRight then
        player.animations.walkRight:draw(
            sprites.playerSheet, player.collider:getX() - 24, player.collider:getY() - 38, 0, 1.5, 1.5
        )
    end
    -- world:draw()

end

