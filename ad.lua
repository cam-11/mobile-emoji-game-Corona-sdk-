
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local applovin = require( "plugin.applovin" )

 
local function adListener( event )
 
    if ( event.phase == "init" ) then  -- Successful initialization
        print( event.isError )
		  applovin.load( "interstitial" )
 
    elseif ( event.phase == "loaded" ) then  -- The ad was successfully loaded
        print( event.type )
 
    elseif ( event.phase == "failed" ) then  -- The ad failed to load
        print( event.type )
        print( event.isError )
        print( event.response )
	 elseif ( event.phase == "displayed" or event.phase == "playbackBegan" ) then  -- The ad was displayed/played
        print( event.type )
 
    elseif ( event.phase == "hidden" or event.phase == "playbackEnded" ) then  -- The ad was closed/hidden
        print( event.type )
 
    elseif ( event.phase == "clicked" ) then  -- The ad was clicked/tapped
        print( event.type )
    end
end



local isAdLoaded = applovin.isLoaded( "interstitial" )
print( isAdLoaded )
local isAdLoaded = applovin.isLoaded( "interstitial" )
if ( isAdLoaded == true ) then
    applovin.show( "interstitial" )
end
-- Init the Applovin plugin
applovin.init( adListener, { sdkKey="Juhv87U4-66DeBwZXgvE6kwbhAw_3uELkNhSBIuA2R0cIVBigG56y6sb-qGrWlXVN76dscG-SWGFLpCmySi_Qk",verboseLogging=false, testMode=true} )



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

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
