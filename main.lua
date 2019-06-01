
local composer=require("composer")

display.setStatusBar(display.hiddenStatusBar)

math.randomseed(os.time())
audio.reserveChannels( 1 )
audio.setVolume( 0.5, { channel=1 } )
composer.gotoScene("menu")

-- Abstract: AppLovin
-- Version: 1.1
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
local applovin = require( "plugin.applovin" )
local widget = require( "widget" )

local sdkKey = "Juhv87U4-66DeBwZXgvE6kwbhAw_3uELkNhSBIuA2R0cIVBigG56y6sb-qGrWlXVN76dscG-SWGFLpCmySi_Qk"
local mainGroup = display.newGroup()
-- Set local variables
local setupComplete = false
local useRewarded = false
local alertRewarded = true
local loadButton
local showButton

local prompt = display.newPolygon( mainGroup, 142, 170, { 0,-12, 12,0, 0,12 } )
prompt:setFillColor( 0.8 )
prompt.alpha = 0

-- Create spinner widget for indicating ad status
local spinner = widget.newSpinner( { x=display.contentCenterX, y=275, deltaAngle=10, incrementEvery=10 } )
mainGroup:insert( spinner )
spinner.alpha = 0


-- Function to manage spinner appearance/animation
local function manageSpinner( action )
	if ( action == "show" ) then
		spinner:start()
		transition.cancel( "spinner" )
		transition.to( spinner, { alpha=1, tag="spinner", time=((1-spinner.alpha)*320), transition=easing.outQuad } )
	elseif ( action == "hide" ) then
		transition.cancel( "spinner" )
		transition.to( spinner, { alpha=0, tag="spinner", time=((1-(1-spinner.alpha))*320), transition=easing.outQuad,
			onComplete=function() spinner:stop(); end } )
	end
end


-- Function to prompt/alert user for setup
local function checkSetup()

	if ( system.getInfo( "environment" ) ~= "device" ) then return end

	if ( tostring(sdkKey) == "[YOUR-SDK-KEY]" ) then
		local alert = native.showAlert( "Important", 'Confirm that you have specified your unique AppLovin SDK key within "main.lua" on line 35. See our documentation for details on where to find this key within the AppLovin developer portal.', { "OK", "documentation" },
			function( event )
				if ( event.action == "clicked" and event.index == 2 ) then
					system.openURL( "https://docs.coronalabs.com/plugin/applovin/" )
				end
			end )
	else
		setupComplete = true
	end
end


-- Function to update button visibility/state
local function updateUI( params )

	-- Disable inactive buttons
	if ( params["disable"] ) then
		for i = 1,#params["disable"] do
			params["disable"][i]:setEnabled( false )
			params["disable"][i].alpha = 0.3
		end
	end

	-- Move/transition prompt
	if ( params["promptTo"] ) then
		transition.to( prompt, { y=params["promptTo"].y, alpha=1, time=400, transition=easing.outQuad } )
	end

	-- Enable new active buttons
	if ( params["enable"] ) then
		timer.performWithDelay( 400,
			function()
				for i = 1,#params["enable"] do
					params["enable"][i]:setEnabled( true )
					params["enable"][i].alpha = 1
				end
			end
		)
	end
end


-- Ad listener function
local function adListener( event )

	-- Exit function if user hasn't set up testing parameters
	if ( setupComplete == false ) then return end

	-- Successful initialization of the AppLovin plugin
	if ( event.phase == "init" ) then
		print( "AppLovin event: initialization successful" )
		updateUI( { enable={ loadButton }, disable={ showButton }, promptTo=loadButton } )

	-- An ad loaded successfully
	elseif ( event.phase == "loaded" ) then
		print( "AppLovin event: " .. tostring(event.type) .. " ad loaded successfully" )
		updateUI( { enable={ showButton }, disable={ loadButton }, promptTo=showButton } )
		manageSpinner( "hide" )

	-- The ad was displayed/played
	elseif ( event.phase == "displayed" or event.phase == "playbackBegan" ) then
		print( "AppLovin event: " .. tostring(event.type) .. " ad displayed" )
		updateUI( { disable={ showButton } } )

	-- The ad was closed/hidden
	elseif ( event.phase == "hidden" or event.phase == "playbackEnded" ) then
		print( "AppLovin event: " .. tostring(event.type) .. " ad closed/hidden" )
		updateUI( { enable={ loadButton }, disable={ showButton }, promptTo=loadButton } )

	-- The user clicked/tapped an ad
	elseif ( event.phase == "clicked" ) then
		print( "AppLovin event: " .. tostring(event.type) .. " ad clicked/tapped" )

	-- The ad failed to load
	elseif ( event.phase == "failed" ) then
		print( "AppLovin event: " .. tostring(event.type) .. " ad failed to load" )
		manageSpinner( "hide" )

	-- The user declined to view a rewarded/incentivized video ad
	elseif ( event.phase == "declinedToView" ) then
		print( "AppLovin event: user declined to view " .. tostring(event.type) .. " ad" )
		updateUI( { enable={ loadButton }, disable={ showButton }, promptTo=loadButton } )

	-- The user viewed a rewarded/incentivized video ad
	elseif ( event.phase == "validationSucceeded" ) then
		print( "AppLovin event: " .. tostring(event.type) .. " ad viewed and reward approved by AppLovin server" )
		local alert = native.showAlert( "Note", "AppLovin reward of " .. tostring(event.data.amount) .. " " .. tostring(event.data.currency) .. " registered!", { "OK" } )
		updateUI( { disable={ showButton } } )

	-- The incentivized/rewarded video ad and/or reward exceeded quota, failed, or was rejected
	elseif ( event.phase == "validationExceededQuota" or event.phase == "validationFailed" or event.phase == "validationRejected" ) then
		print( "AppLovin event: " .. tostring(event.type) .. " ad and/or reward exceeded quota, failed, or was rejected" )
	end
end


-- Button handler function
local function uiEvent( event )

	if ( event.target.id == "load" ) then
		if ( useRewarded == true ) then
			applovin.load( "rewardedVideo" )
		else
			applovin.load( "interstitial" )
		end
		manageSpinner( "show" )
	elseif ( event.target.id == "show" ) then
		if ( useRewarded == true and applovin.isLoaded( "rewardedVideo" ) ) then
			applovin.show( "rewardedVideo" )
		elseif ( useRewarded == false and applovin.isLoaded( "interstitial" ) ) then
			applovin.show( "interstitial" )
		end
	elseif ( event.target.id == "useRewarded" ) then
		if ( event.target.isOn == true ) then
			useRewarded = true
			-- Initially alert for incentivized/rewarded setup
			if ( alertRewarded == true ) then
				alertRewarded = false
				local alert = native.showAlert( "Note", 'To receive incentivized/rewarded video ads in your app, ensure that you have enabled the feature in the AppLovin developer portal. Also note that activation of this feature does not take effect instantaneously, so it may require some time before these ads can be served.', { "OK" } )
			end
		else
			useRewarded = false
		end
	end
	return true
end

-- Create rewarded/incentivized switch/label
--local irLabel = display.newText( mainGroup, "Use Incentivized/Rewarded", display.contentCenterX+16, 105, appFont, 16 )
--[[local irSwitch = widget.newSwitch(
	{
		sheet = assets,
		width = 35,
		height = 35,
		frameOn = 1,
		frameOff = 2,
		x = irLabel.contentBounds.xMin-22,
		y = irLabel.y,
		style = "checkbox",
		id = "useRewarded",
		initialSwitchState = false,
		onPress = uiEvent
	})--]]
--mainGroup:insert( irSwitch )

-- Create buttons
loadButton = widget.newButton(
	{
		label = "press me",
		id = "load",
		shape = "roundedRect",
		x = display.contentCenterX ,
		y = 70,
		width = 220,
		height = 50,
		font = appFont,
		fontSize = 29,
		fillColor = {default={1,0,0,1}, over={1,0.1,0.7,0.4}},--{ default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
		strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
		labelColor = { default={ 1,1,1 }, over={ 0, 0, 0, 0.5 } },
		onRelease = uiEvent
	})
loadButton:setEnabled( false )
loadButton.alpha = 0.3
mainGroup:insert( loadButton )

showButton = widget.newButton(
	{
		label = "Press me again",
		id = "show",
		shape = "roundedRect",
		x = display.contentCenterX,
		y = 410,
		width = 220,
		height = 50,
		font = appFont,
		fontSize = 29,
		fillColor = {default={1,0,0,1}, over={1,0.1,0.7,0.4}},--{ default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
		strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
		labelColor = { default={ 1,1,1}, over={ 0, 0, 0, 0.5 } },
		onRelease = uiEvent
	})
showButton:setEnabled( false )
showButton.alpha = 0.3
mainGroup:insert( showButton )


-- Initially alert user to set up device for testing
checkSetup()

applovin.init( adListener, { sdkKey="Juhv87U4-66DeBwZXgvE6kwbhAw_3uELkNhSBIuA2R0cIVBigG56y6sb-qGrWlXVN76dscG-SWGFLpCmySi_Qk",verboseLogging=false, testMode=true} )


--[[local function adListener( event )
 
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
end--]]

 
-- Initialize the AppLovin plugin
