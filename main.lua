function love.load()
    anim8 = require("libraries/anim8/anim8")
    wf = require("libraries/windfield")
    require("obstacles")
    --bg = love.graphics.newImage("sprites/rt1a.png")
    --ash = love.graphics.newImage("sprites/playerSheet1.png")
    world = wf.newWorld()
    world:addCollisionClass('Button')
    world:addCollisionClass('Player')
    world:addCollisionClass('Wall')
    world:addCollisionClass('Sign')
    world:setQueryDebugDrawing(true)
    sprites = {}
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')
    sprites.bg = love.graphics.newImage("sprites/rt1a.png")
    sprites.pokeballSheet = love.graphics.newImage("sprites/pokeballSheet.png")
    sprites.sign = love.graphics.newImage("sprites/sign.png")
    sprites.text = love.graphics.newImage("sprites/text.png")
    sprites.text1 = love.graphics.newImage("sprites/text1.png")
    sprites.text2 = love.graphics.newImage("sprites/text2.png")
    sprites.text3 = love.graphics.newImage("sprites/text3.png")
    sprites.signText = love.graphics.newImage("sprites/sign_text.png")
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
    player.animations.jump = anim8.newAnimation(player.grid('9-12',1), 0.2)
    player.anim = player.animations.walkDown
    player.collider = world:newCircleCollider(player.x, player.y, 20)
    player.collider:setCollisionClass("Player")
    player.dir = "down"
    player.isJumping = false
    pokeball = {}
    pokeball.grid = anim8.newGrid(250, 240, sprites.pokeballSheet:getWidth(), sprites.pokeballSheet:getHeight(), 40, 90)
    pokeball.animations = {}
    pokeball.animations.open = anim8.newAnimation(pokeball.grid('1-3',1),0.1)
    pokeball.anim = pokeball.animations.open
    pokeball.collider = world:newRectangleCollider(540, 45, 30, 30)
    pokeball.collider:setCollisionClass("Button")
    pokeball.collider:setType("static")
    pokeball.state = 0
    sign = {}
    sign.collider = world:newRectangleCollider(368, 372, 60, 30)
    sign.collider:setCollisionClass("Sign")
    sign.collider:setType("static")
    sign.read = 0
    gamestate = 0
    timer = 0
    timer1 = 0
    timer2 = 0
    timer3 = 0
    timer4 = 0
    create()

end



function love.update(dt)
    
    --move collider
    -- store collider vector info
    local vectorX = 0
    local vectorY = 0

    --intro messages
    if love.keyboard.isDown("space") then
        gamestate = 1
    end
    
    if gamestate == 1 then
    timer3 = timer3 + dt
        if timer3 > 0.5 then 
            if love.keyboard.isDown("space") then
                gamestate = 2
            end
        end
    end
    --sign read
    -- if sign.read % 2 == 1 and love.keyboard.isDown("space") then
    --     timer4 = timer4 + dt
    --     if timer4 > 0.2 then 
    --         sign.read = sign.read + 1
    --     end
    -- end
    --let player pass through sign hitbox
    if player.collider:enter('Sign') then  
        player.collider:setPreSolve(function(collider_1, collider_2, contact)
            contact:setEnabled(false)      
        end)
    end
    if player.collider:exit('Sign') then  
        player.collider:setPreSolve(function(collider_1, collider_2, contact)
            contact:setEnabled(true)      
        end)
    end

    --pokeball open animation
    if pokeball.state == 1 then
        pokeball.anim:update(dt)
    end
    --pokeball message 0
    if pokeball.state == 2 then
        pokeball.anim:gotoFrame(3)
        timer = timer + dt
        if timer > 0.5 then 
            if timer > 5 or love.keyboard.isDown("space") then
                pokeball.state = 3
            end
        end
    end
    --pokeball message 1
    if pokeball.state == 3 then
        timer1 = timer1 + dt
        if timer1 > 0.5 then 
            if timer1 > 5 or love.keyboard.isDown("space") then
                pokeball.state = 4
            end
        end
    end
     -- Move Player Left or Right
     if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        vectorX = -1
        player.anim = player.animations.walkLeft
        player.dir = "left"

    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        vectorX = 1
        player.anim = player.animations.walkRight
        player.dir = "right"
    end

    -- Move Player Up or Down
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        vectorY = -1
        player.anim = player.animations.walkUp
        player.dir = "up"
        
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        vectorY = 1
        player.anim = player.animations.walkDown
        player.dir = "down"
        --check if player hits wall to jump
        if player.collider:enter('Wall') then     
            print("yee")                   
            player.isJumping = true
            timer2 = 0                
        end

    end
    --jump when you are above a wall going down
    if player.isJumping == true then
        player.anim = player.animations.jump
                    
        player.collider:setPreSolve(function(collider_1, collider_2, contact)
            contact:setEnabled(false)
            
            timer2 = timer2 + dt
            if timer2 > 0.5 then
                contact:setEnabled(true)      
                player.isJumping = false
            end           
        end)    
    end
    --check to see if player collider is moving
    if vectorX == 0 and vectorY == 0 then
        player.isMoving = false
        --set animation to standing image
        player.anim:gotoFrame(3)
    else
        player.isMoving = true
    end
    if player.isMoving and player.isJumping == false then
        -- player.x = player.x + 200 * vectorX * dt
        -- player.y = player.y + 200 * vectorY * dt
        player.collider:setLinearVelocity(vectorX * 200, vectorY * 200)
        player.anim:update(dt)
        world:update(dt)
    elseif player.isJumping then
        player.collider:setLinearVelocity(vectorX * 100, vectorY * 100)
        player.anim:update(dt)
        world:update(dt)
    end
    -- print(player.collider:getY())
end



function love.draw()
    -- local px = player:getX()
    -- local py = player:getY()+1
    love.graphics.draw(sprites.bg, 0, 0, 0, 2, 2)
    pokeball.animations.open:draw(
            sprites.pokeballSheet,530 , 40, 0, 0.2, 0.2
        )
    --love.graphics.draw(ash, player.x, player.y, 0, 1.5, 1.5)
    if player.anim == player.animations.walkDown then
        player.animations.walkDown:draw(
            sprites.playerSheet, player.collider:getX() - 24 , player.collider:getY() - 38, 0, 1.5, 1.5
        )
    elseif player.anim == player.animations.jump then
        player.animations.jump:draw(
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
    if pokeball.state == 2 then
        love.graphics.draw(sprites.text, 50, 250, 0, 2, 2)
    end
    if pokeball.state == 3 then
        love.graphics.draw(sprites.text1, 50, 250, 0, 2, 2)
    end
    if gamestate == 0 then
        love.graphics.draw(sprites.text2, 50, 250, 0, 2, 2)
    end
    if gamestate == 1 then
        love.graphics.draw(sprites.text3, 50, 250, 0, 2, 2)
    end
    if sign.read % 2 == 1 then
        love.graphics.draw(sprites.signText, 50, 250, 0, 2, 2)
    end
    -- print(sign.read)
    -- world:draw()
    
end

function love.keypressed(key)
    --trigger query if spacebar pressed
    if key == 'space' then
        --set up query area
        local px, py = player.collider:getPosition()
        if player.dir == "right" then
            px = px + 60
        elseif player.dir == "left" then
            px = px - 60
        elseif player.dir == "up" then
            py = py - 60
        elseif player.dir == "down" then
            py = py + 60
        end
        --draw query area
        local colliders = world:queryCircleArea(px, py, 40, {"Button"})
        --check for collision with pokeball
        if #colliders > 0 then
            pokeball.state = 1
            pokeball.state = 2
        end

        local signtouch = world:queryCircleArea(px, py, 40, {"Sign"})
        --check for collision with sign
        if #signtouch > 0 then
            sign.read = sign.read + 1
        end
    
        -- print(sign.read)
    end
    
end