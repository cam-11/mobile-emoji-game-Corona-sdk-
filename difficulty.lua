
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoGame1()
 composer.gotoScene("easy")
 end
 local function gotoGame2()
 composer.gotoScene("meduim")
 end
 local function gotoGame3()
 composer.gotoScene("hard")
 end




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	
	halfW=display.contentWidth*0.5
    halfH=display.contentHeight*0.5
	local background=display.newImage(sceneGroup,"background.png",halfW,halfH)
	local playButton1=display.newText(sceneGroup,"Select Difficulty",display.contentCenterX, 50,native.systemFont, 44)
    local playButton1=display.newText(sceneGroup,"Easy",display.contentCenterX, 200,native.systemFont, 40)
	local playButton2=display.newText(sceneGroup,"Medium",display.contentCenterX, 300,native.systemFont, 40)
	local playButton3=display.newText(sceneGroup,"Hard",display.contentCenterX, 400,native.systemFont, 40)
	
	playButton1:addEventListener("tap",gotoGame1)
	playButton2:addEventListener("tap",gotoGame2)
	playButton3:addEventListener("tap",gotoGame3)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
