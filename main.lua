function love.load()

    --Libraries
    cameralib=   require 'Libraries/camera'                 --Camera Library
    sti=         require 'Libraries/sti'                    --Simple Tilled Implementation Library
    anim8=       require 'Libraries/anim8'                  --Animation Library
    bump=        require 'Libraries/bump'                   --Collission Detection Library
    roomy=       require 'Libraries/roomy'                  --Scene Management Library
    
    love.graphics.setDefaultFilter('nearest','nearest')     --Scale Factor Blurness Remover

    camera=cameralib()                                      --Defined Camera Function


    world = bump.newWorld()                                 --Collission Physics World
    gameMap = sti('Maps/Map.lua', { 'bump' } )              --Game Map
    gameMap:bump_init(world)                                --Adding Collission To Game Map
    player={}                                               --Player Object/Table

    player.spriteSheet=love.graphics.newImage('/Sprites/player-sheet.png')                         --Player Spritesheet
    player.grid=anim8.newGrid(12,18,player.spriteSheet:getWidth(),player.spriteSheet:getHeight())  --Spritesheet Grid  

    player.animations={}                                                 --Player Sprite Animation and more
    player.animations.down=anim8.newAnimation(player.grid('1-4',1),0.2)  --down movement animation
    player.animations.left=anim8.newAnimation(player.grid('1-4',2),0.2)  --left movement animation
    player.animations.right=anim8.newAnimation(player.grid('1-4',3),0.2) --right movement animation
    player.animations.up=anim8.newAnimation(player.grid('1-4',4),0.2)    --up movement animation
  
    player.x=100                                   --Player X Coordinates
    player.y=100                                  --Player Y Coordinates
    player.speed=0                                 --Player Speed
    player.currentAnimation=player.animations.up   --Current Animation to play

    player.collider = world:add(player,player.x,player.y,12,18)
    player.moving = false

    camera:zoom(3)
    
end

function love.update(dt)
    
    player.currentAnimation:update(dt)                                   --Update Animation Each Frame 

    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        
        player.x=player.x-player.speed
        player.currentAnimation= player.animations.left
        playerMovementChecker()
    end
    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        
        player.x=player.x+player.speed
        player.currentAnimation=player.animations.right    
        playerMovementChecker()
    end
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        
        player.y=player.y-player.speed
        player.currentAnimation=player.animations.up    
        playerMovementChecker()
    end
    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        
        player.y=player.y+player.speed
        player.currentAnimation=player.animations.down    
        playerMovementChecker()
    end
    if player.moving == true then
        playerMovementChecker()
        player.speed=2
    end

    if player.moving == false then 
        playerMovementChecker()
        player.speed=0
        player.currentAnimation:gotoFrame(2)
    end
    
    

    movePlayer(player,dt)
    camera:lookAt(player.x,player.y)
    gameMap:update(dt)


end

function love.draw()
 camera:attach()

 
 gameMap:drawLayer(gameMap.layers['Object Layer 1']) 
 gameMap:drawLayer(gameMap.layers['Tile Layer 1'])
 gameMap:drawLayer(gameMap.layers['Tile Layer 2'])
 player.currentAnimation:draw(player.spriteSheet,player.x,player.y,nil,1.4  )

 camera:detach()
end

function playerMovementChecker()
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') or love.keyboard.isDown('right') or love.keyboard.isDown('d') or love.keyboard.isDown('up') or love.keyboard.isDown('w') or love.keyboard.isDown('down') or love.keyboard.isDown('s')   then
    player.moving = true
    else
    player.moving = false
    end   
end


function movePlayer(player, dt)
    local goalX, goalY = player.x + player.speed * dt, player.y + player.speed * dt
    local actualX, actualY, cols, len = world:move(player, goalX, goalY)
    player.x, player.y = actualX, actualY
    -- deal with the collisions
  end