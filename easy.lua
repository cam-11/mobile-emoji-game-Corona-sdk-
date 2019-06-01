
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics=require("physics")
physics.start()
--local explosionSound
--explosionSound=audio.loadSound("audio/explosionwave.wav")

  
math.randomseed(os.time())

local rain
local sun1
local sun2
local livesText
local lives
local explosionSound
local musicTrack
local back
halfW=display.contentWidth*0.5
halfH=display.contentHeight*0.5

local bkg=display.newImage("background.png",halfW,halfH) 
score=0
lives=3
scoreText=display.newText("score:"..score,halfW,10)
--livesText=display.newText("lives:"..lives,halfW,30)
local function poopTouched(event)
 if(event.phase =="began") then
 Runtime:removeEventListener("enterFrame",event.self)
 event.target:removeSelf()
 --transition.fadeOut(rain,{time=500})
 audio.play(explosionSound)
 score=score + 1
 scoreText.text="score:"..score
 end
end

local function doublePoints(event)
if(event.phase =="began") then
 Runtime:removeEventListener("enterFrame",event.self)
 event.target:removeSelf()
 --transition.fadeOut(rain,{time=500})
 --audio.play(explosionSound)
 score=score + 10
 scoreText.text="score:"..score
 end
end


local function androidguyTouched(event)
 if(event.phase=="began") then
 Runtime:removeEventListener("enterFrame",event.self)
 event.target:removeSelf()
 audio.play(explosionSound)
 score=math.floor(score*0.5)
 scoreText.text="score:"..score
 lives=lives-1
 --livesText.text="Lives : "..lives
 audio.play(explosionSound)
 end
end
--local function poopguy()
  
local function endgame()
composer.gotoScene("difficulty")

end

local function offscreen(self, event)
if(self.y==nil)then
 return
end
if(self.y>display.contentHeight + 50)then
Runtime:removeEventListener("enterFrame",self)
self:removeSelf()
 end
 end
 


local function addnewpooporandroidguy()

local startX=math.random(display.contentWidth*0.1,display.contentWidth*0.9)
if(math.random(1,5)==1)then
 sun1=display.newImage("poop10.png",startX,-300)
physics.addBody(sun1)
sun1.enterFrame=offscreen
Runtime:addEventListener("enterFrame",sun1)
sun1:addEventListener("touch",androidguyTouched)



--livesText.text="Lives : "..lives


--elseif(math.random(1,5)==3)then
--local poop=display.newImage("poop.jpeg",startX,-300)
--physics.addBody(poop)
--sun.enterFrame=offscreen
--Runtime:addEventListener("enterFrame",sun)
--sun:addEventListener("touch",androidguyTouched)

else
 rain=display.newImage("inlove.png",startX,-300)
physics.addBody(rain)
rain.enterFrame=offscreen
Runtime:addEventListener("enterFrame",rain)
rain:addEventListener("touch",poopTouched)


if(math.random(1,5)==2)then
sun2=display.newImage("superthumb.png",startX,-300)
physics.addBody(sun2)
sun2.enterFrame=offscreen
Runtime:addEventListener("enterFrame",sun2)
sun2:addEventListener("touch",doublePoints)

--if(lives==0)then
 
 --physics.pause()
 
 
  --composer.gotoScene("highScores",{time=800,effect="crossFade"})
  --if(score==5)then
  
 --physics.pause()
--composer.removeScene("easy")
  --timer.performWithDelay(2000,endgame)
 -- physics.pause()
  --display.remove(sun1)
   --display.remove(sun2)
 --display.remove(rain
 --local GameOver=display.newText("Game Over",display.contentCenterX, 200,native.systemFont, 44)
 
  --composer.gotoScene("highScores")
end
end
end
--end
--back=display.newText("Main Menu",160, -9,native.systemFont, 30)
--back:addEventListener("tap",endgame)


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()



function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	local startX=math.random(display.contentWidth*0.1,display.contentWidth*0.9)
	sun1=display.newImage(sceneGroup,"poop10.png",startX,-300)
	physics.addBody(sun1)
   sun1.enterFrame=offscreen
   Runtime:addEventListener("enterFrame",sun1)	
   sun1:addEventListener("touch",androidguyTouched)
   
   rain=display.newImage("superthumb.png",startX,-300)
   physics.addBody(rain)
   rain.enterFrame=offscreen
   
   rain:addEventListener("touch",poopTouched)

    Runtime:addEventListener("enterFrame",rain)
	addnewpooporandroidguy()
	timer.performWithDelay(500,addnewpooporandroidguy,0)
	
	back=display.newText(sceneGroup,"Main Menu",160, -9,native.systemFont, 30)
	back:addEventListener("tap",endgame)
	if(score==5)then
	local GameOver=display.newText("Game Over",display.contentCenterX, 200,native.systemFont, 44)
	end
	explosionSound = audio.loadSound( "audio/explosion.wav" )
	musicTrack = audio.loadStream( "audio/80s-Space-Game_Looping.wav")
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	  audio.play( musicTrack, { channel=1, loops=-1 } )
	  

	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  

	
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
           physics.pause()
		   composer.removeScene("easy")
		   --composer.removeScene("meduim")
		   --composer.removeScene("hard")
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
