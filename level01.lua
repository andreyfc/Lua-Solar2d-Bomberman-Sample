local perspective = require("perspective")
local composer = require( "composer" )

local fisica = require( "physics" )
fisica.start()
fisica.setGravity( 0, 0 )
-- fisica.setDrawMode ( "hybrid" )
 
local scene = composer.newScene()

-- orientação da tela
local larguraTela = display.contentWidth
local alturaTela = display.contentHeight
local centroX = display.contentWidth /2
local centroY = display.contentHeight /2

-- Define o tamanho dos objetos e espaços entre eles
local tamanhoCelula = 24
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then

        -- AQUI VAI O CODIGO DA MINHA FASE

        --------------------------------------------------------------------------------
        -- Constroi Camera
        --------------------------------------------------------------------------------
        local camera = perspective.createView()

        local bg = display.newImageRect( "images/bg.png", 480, 320 )
        bg.x = centroX
        bg.y = centroY
        camera:add( bg, 2 )

        --__Limites do cenário__
        local function criaParedesHorizontal( quantidade, salto, linha )
            for i=1,quantidade, salto do
                local parede = display.newImageRect( "images/block_01.png", tamanhoCelula, tamanhoCelula )
                parede.x = (tamanhoCelula * i) - tamanhoCelula
                parede.y =  tamanhoCelula * linha
                parede.id = "parede"
                camera:add( parede, 1 )
                fisica.addBody( parede, "static" )
            end
        end
        criaParedesHorizontal( 21, 1, 0 )
        criaParedesHorizontal( 21, 1, 14 )

        local function criaParedesVertical( quantidade, salto, coluna, id )
            for i=1,quantidade, salto do
                local parede = display.newImageRect( "images/block_01.png", tamanhoCelula, tamanhoCelula )
                parede.x = tamanhoCelula * coluna
                parede.y = (tamanhoCelula * i) - tamanhoCelula
                parede.id = id
                camera:add( parede, 1 )
                fisica.addBody( parede, "static" )
            end
        end
        criaParedesVertical( 14, 1, 0, "paredeEsquerda" )
        criaParedesVertical( 14, 1, 20, "paredeDireita" )
        
        --__Fim limites do cenário
 
        
        -- Level Atual
        local levelName = display.newText( "level 01", centroX, 50, nil, 20 )

        
        -- __Cria Player e controles__
        local spriteSheetPersonagem = graphics.newImageSheet( "images/player.png", { width=120, height=120, numFrames=48 } )
        local spriteSheetPersonagemConfiguracao =
        {
            { name = "parado_frente", start = 1, count = 4, time = 500 , loopCount = 0},
            { name = "parado_costas", start = 5, count = 8, time = 500 , loopCount = 0},
            { name = "andando", frames = { 9,10,11,12,13,14,15,16 }, time = 500 , loopCount = 0},
            { name = "andando_baixo", frames = { 17,18,19,20 }, time = 500 , loopCount = 0},
            { name = "andando_cima", frames = { 21,22,23,24 }, time = 500 , loopCount = 0},
        }
        local direcao = "" -- player parado
        local player

        local function criaPlayer()
            player = display.newSprite( spriteSheetPersonagem, spriteSheetPersonagemConfiguracao )
            player.x = centroX
            player.y = centroY
            player.id = "player"
            player:setSequence( "parado_frente" )
            player:play()
            player:scale( 0.3, 0.3 )

            camera:add( player, 1 )
            fisica.addBody( player, "dynamic", {radius = 12} )
            player.anchorY = 0.62
            player.isFixedRotation = true
            camera.damping = 10 -- A bit more fluid tracking
            camera:setFocus( player ) -- Set the focus to the player
            camera:track() -- Begin auto-tracking
        end
        
        criaPlayer()

        local function moveDireita( event )
            if ( event.phase == "began" ) then
                direcao = "direita"
                print( "toquei no botao!" )
                player:setSequence( "andando" )
                player:play()
                player.xScale = 0.3

            elseif ( event.phase == "ended" ) then
                direcao = ""
                player:setLinearVelocity( 0, 0 )
                player:setSequence( "parado_frente" )
                player:play()

            end
            
        end

        local botaoDireita = display.newCircle( 100, alturaTela-50, 15 )
        botaoDireita:addEventListener( "touch", moveDireita )

        local function moveEsquerda( event )
            if ( event.phase == "began" ) then
                direcao = "esquerda"
                print( "toquei no botao!" )
                player:setSequence( "andando" )
                player:play()
                player.xScale = -0.3

            elseif ( event.phase == "ended" ) then
                direcao = ""
                player:setLinearVelocity( 0, 0 )
                player:setSequence( "parado_frente" )
                player:play()

            end
            
        end

        local botaoEsquerda = display.newCircle( 50, alturaTela-50, 15 )
        botaoEsquerda:addEventListener( "touch", moveEsquerda )

        local function moveBaixo( event )
            if ( event.phase == "began" ) then
                direcao = "baixo"
                print( "toquei no botao!" )
                player:setSequence( "andando_baixo" )
                player:play()

            elseif ( event.phase == "ended" ) then
                direcao = ""
                player:setLinearVelocity( 0, 0 )
                player:setSequence( "parado_frente" )
                player:play()

            end
            
        end

        local botaoBaixo = display.newCircle( 75, alturaTela-25, 15 )
        botaoBaixo:addEventListener( "touch", moveBaixo )

        local function moveCima( event )
            if ( event.phase == "began" ) then
                direcao = "cima"
                print( "toquei no botao!" )
                player:setSequence( "andando_cima" )
                player:play()

            elseif ( event.phase == "ended" ) then
                direcao = ""
                player:setLinearVelocity( 0, 0 )
                player:setSequence( "parado_frente" )
                player:play()

            end
            
        end

        local botaoCima = display.newCircle( 75, alturaTela-75, 15 )
        botaoCima:addEventListener( "touch", moveCima )

        local function checarDirecao()

            if ( player.isVisible == true ) then

                if ( direcao == "direita" ) then
                    print( "indo para direita!" )
                    player:setLinearVelocity( 100, 0 )

                elseif ( direcao == "esquerda" ) then
                    player:setLinearVelocity( -100, 0 )

                elseif ( direcao == "baixo" ) then
                    player:setLinearVelocity( 0, 100 )

                elseif ( direcao == "cima" ) then
                    player:setLinearVelocity( 0, -100 )
                
                end

            end
        end
        Runtime:addEventListener( "enterFrame", checarDirecao )
        --__Fim cria player__

        -- __Cria eventos e objetos da bomba__
        local botaoBomba = display.newCircle( larguraTela-50, alturaTela-50, 20 )

        local spriteSheetBomba = graphics.newImageSheet( "images/bomb_02.png", { width=125, height=125, numFrames=10 } )
        local spriteSheetBombaConfiguracao =
        {
            { name = "parada", start = 1, count = 2, time = 500 , loopCount = 0},
            { name = "destroi", start = 1, count = 10, time = 300 , loopCount = 1}
        }

        local spriteSheetExplosao = graphics.newImageSheet( "images/explosion.png", { width=270/2, height=212/2, numFrames=20 } )
        local spriteSheetExplosaoConfiguracao =
        {
            { name = "explosao", start = 1, count = 20, time = 500 , loopCount = 1}
        }

        local function criaExplosao( x, y )
            local explosao = display.newSprite( spriteSheetExplosao, spriteSheetExplosaoConfiguracao )
            explosao.x, explosao.y = x, y
            explosao:setSequence( "explosao" )
            explosao:play()
            explosao.id = "explosao"
            camera:add( explosao, 1 )
            fisica.addBody( explosao, "dynamic", { isSensor=true, radius=12 } )
            timer.performWithDelay( 500, function ()
                display.remove( explosao )                        
            end, 1 )

            return explosao
        end

        local function criaBomba( event )
           if ( event.phase == "began" ) then
                local bomba = display.newSprite( spriteSheetBomba, spriteSheetBombaConfiguracao )
                bomba.x, bomba.y = player.x, player.y
                bomba:setSequence( "parada" )
                bomba:play()
                camera:add( bomba, 1 )

                fisica.addBody( bomba, "dynamic", { isSensor=true, radius = 16 } )
                
                timer.performWithDelay( 3000, function()
                    bomba:setSequence( "destroi" )
                    bomba:play()
                    transition.to( bomba, { alpha=0, time=500, onComplete=function()
                        display.remove( bomba )
                    end} )
                    
                    local explosaoDireita = criaExplosao( bomba.x+tamanhoCelula, bomba.y)

                    local explosaoEsquerda = criaExplosao( bomba.x-tamanhoCelula, bomba.y )

                    local explosaoCima = criaExplosao( bomba.x, bomba.y-tamanhoCelula )
                    
                    local explosaoBaixo = criaExplosao( bomba.x, bomba.y+tamanhoCelula )

                end, 1 )
           end
        end
        botaoBomba:addEventListener( "touch", criaBomba )
        -- __Fim dos eventos e objetos bomba


        -- __Montagem do cenário__
        local function criaObstaculos( quantidade, salto, linha  )
            for i=1,quantidade, salto do
                local obstaculo = display.newImageRect( "images/block_02.png", tamanhoCelula, tamanhoCelula )
                obstaculo.x, obstaculo.y = tamanhoCelula+(i*tamanhoCelula), tamanhoCelula*linha
                print( tamanhoCelula*linha )
                obstaculo:setFillColor( 0.4, 0.4, 0 )
                obstaculo.id = "obstaculo"
                fisica.addBody( obstaculo, "static", { isSensor=false } )
                camera:add( obstaculo, 1 )
            end
        end
        criaObstaculos( 17, 2, 1 )
        criaObstaculos( 17, 2, 3 )
        criaObstaculos( 17, 2, 5 )
        criaObstaculos( 17, 2, 7 )
        criaObstaculos( 17, 2, 9 )
        criaObstaculos( 17, 2, 11)
        -- Fim da montagem do cenário

        local function criaInimigo ( x, y )
            local inimigo = display.newSprite( spriteSheetPersonagem, spriteSheetPersonagemConfiguracao )
            inimigo.x = x
            inimigo.y = y
            -- inimigo.fill.effect = "filter.invert"
            inimigo:scale( 0.3, 0.3 )
            inimigo.id = "inimigo"
            fisica.addBody( inimigo, "dynamic", { isSensor=true, radius=10 } )
            inimigo.isFixedRotation = true
            inimigo.anchorY = 0.62
            camera:add( inimigo, 1 )
            inimigo.direcao = "direita"
            inimigo:setSequence( "andando" )
            inimigo:play()
            inimigo.xScale = 0.3

            local function movimenta()
                -- print( inimigo.direcao )
                if ( inimigo.isVisible == true ) then

                    if ( inimigo.direcao == "direita" ) then
                        inimigo:setLinearVelocity( 100, 0 )


                    elseif ( inimigo.direcao == "esquerda" ) then
                        inimigo:setLinearVelocity( -100, 0 )
                        
                    end

                end
            end
            Runtime:addEventListener( "enterFrame", movimenta )
        end
        -- criaInimigo( 48, 48*1 )
        -- criaInimigo( 48, 48*2 )
        -- criaInimigo( 48, 48*4 )
        -- criaInimigo( 48, 48*5 )
        for i=1,5 do
            criaInimigo( 48, 48*i )
        end

        local function adicionaEventosToque()
            botaoDireita:addEventListener( "touch", moveDireita )
            botaoEsquerda:addEventListener( "touch", moveEsquerda )
            botaoBaixo:addEventListener( "touch", moveBaixo )
            botaoCima:addEventListener( "touch", moveCima )
            botaoBomba:addEventListener( "touch", criaBomba )
        end

        local function removeEventosToque()
            botaoDireita:removeEventListener( "touch", moveDireita )
            botaoEsquerda:removeEventListener( "touch", moveEsquerda )
            botaoBaixo:removeEventListener( "touch", moveBaixo)
            botaoCima:removeEventListener( "touch", moveCima )
            botaoBomba:removeEventListener( "touch", criaBomba )
        end

        --__Colisão de objtos
        local function colisao( event )
           if ( event.phase == "began" ) then
                    print( "colidiu!", event.object1.id )
                    print( "colidiu!", event.object2.id )

                if ( event.object1.id == "obstaculo" and event.object2.id == "explosao" ) then
                    print( "colidiu!" )
                    display.remove( event.object1 )

                elseif ( event.object1.id == "player" and event.object2.id == "explosao" or
                            event.object1.id == "explosao" and event.object2.id == "player" ) then
                    camera:cancel()
                    display.remove( event.object1 )
                    display.remove( event.object2 )
                    removeEventosToque()
                    timer.performWithDelay( 1000, criaPlayer, 1 )
                    timer.performWithDelay( 1000, adicionaEventosToque, 1 )

                elseif ( event.object1.id == "player" and event.object2.id == "inimigo" or
                            event.object1.id == "inimigo" and event.object2.id == "player" ) then
                    camera:cancel()
                    display.remove( event.object1 )
                    display.remove( event.object2 )
                    removeEventosToque()
                    timer.performWithDelay( 1000, criaPlayer, 1 )
                    timer.performWithDelay( 1000, adicionaEventosToque, 1 )

                elseif ( event.object1.id == "inimigo" and event.object2.id == "explosao" or
                            event.object1.id == "explosao" and event.object2.id == "inimigo" ) then
                        display.remove( event.object1 )
                        display.remove( event.object2 )

                elseif ( event.object1.id == "paredeDireita" and event.object2.id == "inimigo" ) then
                    event.object2.direcao = "esquerda"
                    event.object2:setSequence( "andando" )
                    event.object2:play()
                    event.object2.xScale = -0.3


                elseif ( event.object1.id == "paredeEsquerda" and event.object2.id == "inimigo" ) then
                    event.object2.direcao = "direita"
                    event.object2:setSequence( "andando" )
                    event.object2:play()
                    event.object2.xScale = 0.3

                end
            end 
        end

        Runtime:addEventListener( "collision", colisao )

        camera:add( player, 1 )
        camera:prependLayer()

        camera:setParallax( 1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3 ) -- Parallax em ordem decrescente

        camera.damping = 10 -- A bit more fluid tracking
        camera:setFocus( player ) -- Set the focus to the player
        camera:track() -- Begin auto-tracking
       

    elseif ( phase == "did" ) then

    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene