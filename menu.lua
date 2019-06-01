
local composer = require( "composer" )
local applovin = require( "plugin.applovin" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function gotoDifficulty()
composer.gotoScene("difficulty")
end
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


--[[local myInterstitialAdUnitId = "ca-app-pub-3940256099942544/1033173712"
local function adListener( event )
    local json = require( "json" )
    print("Ad event: ")
    print( json.prettify( event ) )
  
    if ( event.phase == "init" ) then  -- Successful initialization
        print( event.provider )
        admob.load( "interstitial", { adUnitId = myInterstitialAdUnitId, hasUserConsent = true } )
        --admob.load( "banner", { adUnitId = myBannerAdUnitId, hasUserConsent = true } )
        --admob.load( "rewardedVideo", { adUnitId = myRewardedAdUnitId, hasUserConsent = true } )
		end
	end
	
admob.init( adListener, { appId="ca-app-pub-1258085176998082~1254332573" ,testMode=true} )
--]]
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    applovin.load( "interstitial" )
    applovin.show( "interstitial" )
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	halfW=display.contentWidth*0.5
    halfH=display.contentHeight*0.5
	local background=display.newImage(sceneGroup,"background.png",500,600)
    local title=display.newImage(sceneGroup,"6g.png",display.contentCenterX,display.contentCenterY)
	local playButton=display.newText(sceneGroup,"Start Game for real",display.contentCenterX, 480,native.systemFont, 30)
	--local Playbutton=display.newImage(sceneGroup,"play.png",display.contentCenterX, 400)
	
	
	playButton:setFillColor( 1, 0.2, 0.2 )
	playButton:addEventListener("tap",gotoDifficulty)
	

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		local isAdLoaded = applovin.isLoaded( "interstitial" )
        if ( isAdLoaded == true ) then
            applovin.show( "interstitial" )
        end

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
