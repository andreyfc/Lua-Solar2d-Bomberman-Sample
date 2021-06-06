local composer = require( "composer" )
 
local scene = composer.newScene()

-- orientação da tela
local larguraTela = display.contentWidth
local alturaTela = display.contentHeight
local centroX = display.contentWidth /2
local centroY = display.contentHeight /2
 
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
 



        local function irParaCena( event )
            if ( event.phase == "began" ) then
                
                -- event.target é o objeto que eu cliquei
                composer.gotoScene( "level01" )

            end
        end

        local startGame = display.newText( sceneGroup, "Start Game", centroX, centroY, nil, 32 )
        startGame:addEventListener( "touch", irParaCena )


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