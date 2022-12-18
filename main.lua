function love.load()
    anim8 = require("libraries/anim8/anim8")
    wf = require("libraries/windfield")
    require("obstacles")
    --bg = love.graphics.newImage("sprites/rt1a.png")
    --ash = love.graphics.newImage("sprites/playerSheet1.png")
    world = wf.newWorld()
    world:addCollisionClass('Button')
    world:addCollisionClass('Player')
    world:setQueryDebugDrawing(true)
    sprites = {}
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet1.png')
    sprites.bg = love.graphics.newImage("sprites/rt1a.png")
    sprites.pokeball = love.graphics.newImage("sprites/pokeball.png")
    sprites.pokeballSheet = love.graphics.newImage("sprites/pokeballSheet.png")
    sprites.sign = love.graphics.newImage("sprites/sign.png")
    player = {}
    player.x = (love.graphics.getWidth() / 2)
    player.y = 700
    --player.animSpeed = 0.14
    player.grid = anim8.newGrid(32, 46, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
    player.animations = {}
    player.animations.walkDown = anim8.newAnimation(player.grid('1-8',1), 0.2)
    player.animations.walkLeft = anim8.newAnimation(player.grid('1-8',2), 0.2)
    player.animations.walkRight = anim8.newAnimation(player.grid('1-8',3), 0.2)
    player.animations.walkUp = anim8.newAnimation(player.grid('1-8',4), 0.2)
    player.anim = player.animations.walkDown
    player.collider = world:newCircleCollider(player.x, player.y, 20)
    player.collider:setCollisionClass("Player")
    pokeball = {}
    pokeball.grid = anim8.newGrid(250, 240, sprites.pokeballSheet:getWidth(), sprites.pokeballSheet:getHeight(), 40, 90)
    pokeball.animations = {}
    pokeball.animations.open = anim8.newAnimation(pokeball.grid('1-3',1),0.1)
    pokeball.anim = pokeball.animations.open
    pokeball.collider = world:newRectangleCollider(540, 45, 30, 30)
    pokeball.collider:setCollisionClass("Button")
    pokeball.collider:setType("static")
    pokeball.state = 0
    create()
    -- colliders = {}
    
    
end



function love.update(dt)
    
    --move collider
    -- store collider vector info
    local vectorX = 0
    local vectorY = 0
    
    if pokeball.state == 1 then
        pokeball.anim:update(dt)
    end
    if pokeball.state == 2 then
        pokeball.anim:gotoFrame(3)
    end
     -- Move Player Left or Right
     if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        vectorX = -1
        player.anim = player.animations.walkLeft

    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        vectorX = 1
        player.anim = player.animations.walkRight
    end

    -- Move Player Up or Down
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        vectorY = -1
        player.anim = player.animations.walkUp
        
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
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
    pokeball.animations.open:draw(
            sprites.pokeballSheet,530 , 40, 0, 0.2, 0.2
        )
    -- love.graphics.draw(sprites.pokeball, 830, 40, 0, 0.3, 0.3)
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
    love.graphics.draw(sprites.sign, 368, 372, 0, 2, 2)
    -- world:draw()
    
end

function love.keypressed(key)
    if key == 'space' then
        
        local px, py = player.collider:getPosition()
        local colliders = world:queryCircleArea(px, py, 40, {"Button"})
        if #colliders > 0 then
            pokeball.state = 1
            pokeball.state = 2
        end
        
    end
    
end