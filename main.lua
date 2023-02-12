--[[
***********************************************************************
**
** Computer Science/Introduction to Mobile Application Development
** Name        : Alex Starosta
** Assignment  : Final Assignment - Dice Game
** Date Due    : November 5, 2021
**
***********************************************************************
]]

display.setStatusBar( display.HiddenStatusBar )

-- stage variables
 
centerX = display.contentCenterX
centerY = display.contentCenterY
screenLeft = display.screenOriginX
screenWidth = display.contentWidth - screenLeft * 2
screenRight = screenLeft + screenWidth
screenTop = display.screenOriginY
screenHeight = display.contentHeight - screenTop * 2
screenBottom = screenTop + screenHeight
display.contentWidth = screenWidth
display.contentHeight = screenHeight

-- variables 

math.randomseed(os.time(s))

local rollOne , rollTwo 
local bet = 0             
local guess = "None"      
local bank = 20    
local errorText = "error"

local highestBank = bank
local diceGuessed = 0
local correctLower = 0
local correctHigher = 0
local correctEqual = 0
local totalScore
local highScore = 0

local highestBankTemp = 0 
local diceGuessedTemp = 0
local correctLowerTemp = 0
local correctHigherTemp = 0
local correctEqualTemp = 0
local totalScoreTemp = 0

local diceOne
local diceTwo
local bankText
local bankDiffText
local bet5Button
local bet10Button
local bet15Button
local bet20Button
local rollButton
local unknownDice

local popUpBox
local popUpText

local sparkle
local sparkle2

local titleText
local randomRollerStart = math.random(1,6)
local oldTotal
local bankDifference = 0
local currentPopUp = false
local currentRoll = true
local intenseMusic = false
local titleScreenGone = false

local guessLowButton       
local guessHighButton      
local guessEqualButton   

local guessLowButtonClicked       
local guessHighButtonClicked      
local guessEqualButtonClicked  
local rollButtonClicked

local endingBackground
local endingGrp
local restartGrp
local highScoreGrp

local emitterParams = {
    startColorAlpha = 1,
    startColorRed = 1,
    startColorGreen = 1,
    startColorBlue = 1,
    
    startParticleSizeVariance = 10,
    blendFuncSource = 1,
    rotatePerSecondVariance = 200,
    particleLifespan = 1.3,

    blendFuncDestination = 1,
    startParticleSize = 50,
    
    textureFileName = "images/sparkleParticle.png",
    maxParticles = 100,
    finishParticleSize = 64,
    duration = -1,
    finishParticleSizeVariance = 164,
    speed = 200,
    angleVariance = 360,
    angle = 0
}

-- loading audio files

local diceRollSfx = audio.loadSound("audio/diceRoll.mp3")
local chipsSfx = audio.loadSound("audio/chips.wav")
local correctSfx = audio.loadSound("audio/correct.wav")
local errorSfx = audio.loadSound("audio/error.mp3")
local hiScoreSfx = audio.loadSound("audio/hiScore.mp3")
local swoopSfx = audio.loadSound("audio/swoop.mp3")
local wrongSfx = audio.loadSound("audio/wrong.mp3")
local gameOverSfx = audio.loadSound("audio/gameOver.mp3")

local gameMusic = audio.loadStream("audio/gameMusic.mp3")
local intenseGameMusic = audio.loadStream("audio/intenseGameMusic.mp3")
local resultsMusic = audio.loadStream("audio/resultsMusic.mp3")
local titleScreenMusic = audio.loadStream("audio/titleScreenMusic.mp3")

local backgroundMusic = {
    channel = 1,
    loops = -1
  }
  
  audio.setMaxVolume( 0.01, {channel = 1} )
  audio.setVolume( 0.1 , backgroundMusic )
  
local sfxMusic = {
    channel = 2,
    loops = 0
  }
  
  audio.setMaxVolume( 0.2, {channel = 2} )

-- functions

local function blinkDice (event)
  
  currentRoll = false
  rollButtonClicked.alpha = 0
  unknownDice = display.newImage ("images/unknownDice.png", centerX + 125, centerY - 300)
  unknownDice.alpha = 0
  
  local function diceChange (event)
    transition.to (unknownDice, {transition = easing.OutCubic, alpha = 1, time = 600})
    transition.to (unknownDice, {transition = easing.OutCubic, alpha = 0, time = 400, delay = 600})
  end
  
  blinkTimer = timer.performWithDelay( 1500, diceChange, -1)
  
end

local function diceSetup ()

local diceRoller = randomRollerStart
local diceHider = display.newImageRect ("images/"..diceRoller..".png", 206, 206)
local counter = 0
local finished = false

  local function rolling (event)
    diceRoller = diceRoller + 1
    if diceRoller == 7 then
      diceRoller = 1
    end

    diceHider.fill = { type="image", filename="images/"..diceRoller..".png"}

    if diceRoller == 1 then
      counter = counter + 1
    end
    
    if counter > 2 and finished == false then
      if diceRoller == rollOne then
        diceHider.alpha = 0
        diceOne.alpha = 1
        sparkle.alpha = 1
        transition.to (sparkle, { delay = 500, alpha = 0, time = 1500, onComplete = blinkDice})
        display.remove(diceHider2)
        finished = true
      end
    end
  end
  
rollTimer = timer.performWithDelay( 200, rolling, -1 )

  diceHider.x = centerX - 125
  diceHider.y = screenTop - diceHider.height
  audio.play (diceRollSfx, sfxMusic)
  transition.to (diceHider, {delay = 1000, time = 1000, y = centerY - 300, rotation = 360, transition = easing.outBounce})
  
end

local function resetGame()
  
  audio.setVolume ( 0.2, sfxMusic)
  audio.stop (backgroundMusic)
  audio.rewind (gameMusic)
  audio.play (gameMusic, backgroundMusic)
  
  intenseMusic = false
  
  highestBankTemp = 0 
  diceGuessedTemp = 0
  correctLowerTemp = 0
  correctHigherTemp = 0
  correctEqualTemp = 0
  totalScoreTemp = 0
  
  bet = 0             
  guess = "None"      
  bank = 20    
  errorText = "error"
  
  bankText.text = "BANK: $"..bank
  
  display.remove(endingBackground)
  display.remove(endingGrp)
  display.remove(restartGrp)
  display.remove(highScoreGrp)
  
  guessLowButtonClicked.alpha = 0
  guessEqualButtonClicked.alpha = 0
  guessHighButtonClicked.alpha = 0
  
  highestBank = bank
  diceGuessed = 0
  correctLower = 0
  correctHigher = 0
  correctEqual = 0
  
  sparkle.x = centerX - 125
  sparkle.y = centerY - 300
  
  display.remove(diceOne)
  display.remove(diceTwo)
  
  rollOne = math.random(1,6)
  rollTwo = math.random(1,6)

  diceOne = display.newImage ("images/"..rollOne..".png", centerX - 125, centerY - 300)
  diceTwo = display.newImage ("images/"..rollTwo..".png", centerX + 125, centerY - 300)
  diceOne.alpha = 0
  diceTwo.alpha = 0
  
  diceSetup()
  
end

local function popUp (popUpEvent)
  if currentPopUp == true then
    return true
  end
  currentPopUp = true
  local popUpTime = 1000
  if popUpEvent == "noGuess" then
    errorText = "Error: No guess selected"
    audio.play (errorSfx, sfxMusic)
  elseif popUpEvent == "noBet" then
    errorText = "Error: No bet selected" 
    audio.play (errorSfx, sfxMusic)
  elseif popUpEvent == "highBet" then
    errorText = "Error: Bet is too high" 
    audio.play (errorSfx, sfxMusic)
  elseif popUpEvent == "displayWinLoss" then
    if bankDifference < 0 then
      local invertDifference = math.abs (bankDifference)
      audio.play (wrongSfx, sfxMusic)
      errorText = "You Lost: -$"..invertDifference
      popUpTime = 3000
    elseif bankDifference > 0 then
      audio.play (correctSfx, sfxMusic)
      errorText = "You Won: $"..bankDifference
      popUpTime = 3000
    end
  end
  
  popUpText.text = errorText
  
  local function popUpDone (event)
    currentPopUp = false
    popUpTime = 1000
  end
  
  if popUpBox.alpha == 1 then
    transition.to (popUpBox, {transition = easing.outCubic, y = centerY + screenHeight/2 - 100, time = 750})
    transition.to (popUpBox, {alpha = 0, delay = popUpTime, time = 250})
    transition.to (popUpBox, {y = centerY + screenHeight/2 + 100, time = 0, alpha = 1, delay = popUpTime + 750})
    transition.to (popUpText, {transition = easing.outCubic, y = centerY + screenHeight/2 - 105, time = 750})
    transition.to (popUpText, {alpha = 0, delay = popUpTime, time = 250})
    transition.to (popUpText, {y = centerY + screenHeight/2 + 100, time = 0, alpha = 1,delay = popUpTime + 750, onComplete = popUpDone})
    end
  return true
end

local function diffText()
  
  local function sendTextBack (event)
    bankDiffText.y = centerY + 315
  end
  
  if bankDifference < 0 then
    bankDiffText.fill = {1,0,0}
    local invertDifference = math.abs (bankDifference)
    bankDiffText.text = "-$"..invertDifference
    transition.to (bankDiffText, {alpha = 1, time = 2000, transition = easing.inOutQuad, y = centerY + 355})
    transition.to (bankDiffText, {alpha = 0, delay = 3000, time = 500, transition = easing.outInQuad, y = centerY + 360, onComplete = sendTextBack})
  elseif bankDifference > 0 then
    bankDiffText.fill = {0,1,0}
    bankDiffText.text = "+$"..bankDifference
    transition.to (bankDiffText, {alpha = 1, time = 2000, transition = easing.inOutQuad, y = centerY + 275})
    transition.to (bankDiffText, {alpha = 0, delay = 3000, time = 500, transition = easing.inOutQuad, y = centerY + 270, onComplete = sendTextBack})
  end
end

local function resetChips (event)
  transition.to (bet5Button, {time = 200, x = centerX - 160, y = centerY - 60})
  transition.to (bet10Button, {time = 200, x = centerX - 50, y = centerY - 60})
  transition.to (bet15Button, {time = 200, x = centerX - 160, y = centerY + 50})
  transition.to (bet20Button, {time = 200, x = centerX - 50, y = centerY + 50})
end

local function setBet (self, event)
  
  if titleScreenGone == false then
    return true
  end
  
  resetChips()
  
  if self.value > bank + bet then
    popUp("highBet")
    bet = 0
    resetChips()
    return true
  end
  
  oldTotal = bank + bet
  
  if self.x == centerX + 140 and self.y == centerY - 5 then
    audio.play (chipsSfx, sfxMusic)
    bank = bank + bet
    bet = 0 
    bankText.text = "BANK: $"..bank
    return true
  end
  
  if self.x ~= centerX + 140 and self.y ~= centerY - 5 then
    audio.play (chipsSfx, sfxMusic)
    transition.to (self, {time = 200, x = centerX + 140, y = centerY - 5})
  end
  
  bank = bank + bet
  bet = self.value
  bank = bank - self.value
  
  return true
end

local function setGuess (self, event)
  guess = self.value
  guessLowButtonClicked.alpha = 0
  guessEqualButtonClicked.alpha = 0
  guessHighButtonClicked.alpha = 0
  
  if self == guessLowButton then
    guessLowButtonClicked.alpha = 1
  elseif self == guessEqualButton then
    guessEqualButtonClicked.alpha = 1
  elseif self == guessHighButton then
    guessHighButtonClicked.alpha = 1
  end
  
  return true
end

local function swapDice()
  
  rollOne = rollTwo
  rollTwo = math.random(1,6)
  diceOne.fill = { type="image", filename="images/"..rollOne..".png"}
  diceOne.x = centerX - 125
  diceTwo.alpha = 0
  diceTwo.x = centerX + 125
  diceTwo.fill = { type="image", filename="images/"..rollTwo..".png"}
  rollButtonClicked.alpha = 0
  currentRoll = false
  
end

local function endGame()
  
  endingBackground = display.newRect (centerX, centerY, screenWidth, screenHeight)
  endingBackground.fill = {0}
  endingBackground.alpha = 0

  local function playEndingMusic()
    audio.setVolume ( 0.05, sfxMusic)
    audio.play (gameOverSfx, sfxMusic)
    audio.setVolume ( 0.2, sfxMusic)
  end

  transition.to (endingBackground, {delay = 2000, time = 1000, alpha = 0.7, onComplete = playEndingMusic})

  endingGrp = display.newGroup()
  endingGrp.anchorChildren = true
  endingGrp.x = centerX
  endingGrp.y = centerY - screenHeight

  local endingMenu = display.newRoundedRect (endingGrp, centerX, centerY, screenWidth - (screenWidth/8), 500, 50)
  endingMenu.fill = {type="image", filename="images/background.png"}
  endingMenu.stroke = {1}
  endingMenu.strokeWidth = 5

  local endingTitle = display.newText (endingGrp, "Game Over", centerX, centerY - 170, "fonts/CasinoFlat.ttf", 70)

  local highestBankText = display.newText (endingGrp, "Highest Bank Amount: "..highestBankTemp, screenWidth/8 , centerY - 80, "fonts/Barlow-Regular.ttf", 30)
  highestBankText.anchorX = 0
  highestBankText.alpha = 0

  local diceGuessedText = display.newText (endingGrp, "Dice Guessed Correctly: "..diceGuessedTemp, screenWidth/8 , centerY - 40, "fonts/Barlow-Regular.ttf", 30)
  diceGuessedText.anchorX = 0
  diceGuessedText.alpha = 0

  local correctLowerText = display.newText (endingGrp, "Correct Lower Guesses: "..correctLowerTemp, screenWidth/8 , centerY, "fonts/Barlow-Regular.ttf", 30)
  correctLowerText.anchorX = 0
  correctLowerText.alpha = 0

  local correctHigherText = display.newText (endingGrp, "Correct Higher Guesses: "..correctHigherTemp, screenWidth/8 , centerY + 40, "fonts/Barlow-Regular.ttf", 30)
  correctHigherText.anchorX = 0
  correctHigherText.alpha = 0

  local correctEqualText = display.newText (endingGrp, "Correct Equal Guesses: "..correctEqualTemp, screenWidth/8 , centerY + 80, "fonts/Barlow-Regular.ttf", 30)
  correctEqualText.anchorX = 0
  correctEqualText.alpha = 0

  totalScore = highestBank + (diceGuessed * 10) + ((correctLower + correctHigher) * 5) + (correctEqual * 15)

  local totalScoreText = display.newText (endingGrp, "Total Score: "..totalScoreTemp, screenWidth/8 , centerY + 140, "fonts/Barlow-Regular.ttf", 30)
  totalScoreText.anchorX = 0
  totalScoreText.alpha = 0
  
  local highScoreText = display.newText (endingGrp, "High Score: "..highScore, screenWidth/8 , centerY + 180, "fonts/Barlow-Regular.ttf", 30)
  highScoreText.anchorX = 0
  highScoreText.alpha = 0

  local function addScores (event)
    
    local function showRestart()
      
      restartGrp = display.newGroup()
      restartGrp.anchorChildren = true
      restartGrp.x = centerX
      restartGrp.y = centerY + 325
      restartGrp.alpha = 0

      local restartDisplay = display.newRoundedRect (restartGrp, centerX, centerY - 325, screenWidth - (screenWidth/8), 100, 50)
      restartDisplay.fill = {type="image", filename="images/background.png"}
      restartDisplay.stroke = {1}
      restartDisplay.strokeWidth = 5

      local restartTitle = display.newText (restartGrp, "PLAY AGAIN", centerX, centerY - 325, "fonts/CasinoFlat.ttf", 50)
      
      transition.to (restartGrp, {delay = 500, time = 1000, alpha = 1, transition = easing.inOutSine})
      
      restartGrp:addEventListener ("tap", resetGame)
      
    end
    
    local function newHighScore()

      highScoreGrp = display.newGroup()
      highScoreGrp.anchorChildren = true
      highScoreGrp.x = centerX
      highScoreGrp.y = centerY - screenHeight

      local highScoreDisplay = display.newRoundedRect (highScoreGrp, centerX, centerY - 325, screenWidth - (screenWidth/8), 100, 50)
      highScoreDisplay.fill = {type="image", filename="images/background.png"}
      highScoreDisplay.stroke = {1}
      highScoreDisplay.strokeWidth = 5

      local highScoreTitle = display.newText (highScoreGrp, "NEW HIGH SCORE", centerX, centerY - 325, "fonts/CasinoFlat.ttf", 50)
      
      highScoreText.text = "High Score: "..highScore
      
      local function playHighScoreSfx()
        audio.setVolume ( 0.02, sfxMusic)
        audio.play (hiScoreSfx, sfxMusic)
      end
      
      transition.to (highScoreText, {delay = 200, time = 400, alpha = 1, onComplete = playHighScoreSfx})

      transition.to (highScoreGrp, {delay = 500, time = 3000, y = centerY - 325, transition = easing.outBounce, onComplete = showRestart})
    
  end
    
    local function showHighestBank (event)
      audio.setVolume ( 0.02, backgroundMusic)
      audio.rewind (resultsMusic)
      audio.play (resultsMusic, backgroundMusic)
      local function scoreAdder1 (event)
        highestBankTemp = highestBankTemp + 1
        highestBankText.text = "Highest Bank Amount: "..highestBankTemp
        if highestBankTemp >= highestBank then
          timer.cancel(adderTimer1)
        end
      end
      adderTimer1 = timer.performWithDelay(10, scoreAdder1, -1)
    end
    
    local function showDiceGuessed (event)
      local function scoreAdder2 (event)
        if diceGuessed == 0 then
          timer.cancel(adderTimer2)
          return true
        end
        diceGuessedTemp = diceGuessedTemp + 1
        diceGuessedText.text = "Dice Guessed Correctly: "..diceGuessedTemp
        if diceGuessedTemp >= diceGuessed then
          timer.cancel(adderTimer2)
        end
      end
      adderTimer2 = timer.performWithDelay(100, scoreAdder2, -1)
    end
    
    local function showCorrectLower (event)
      local function scoreAdder3 (event)
        if correctLower == 0 then
          timer.cancel(adderTimer3)
          return true
        end
        correctLowerTemp = correctLowerTemp + 1
        correctLowerText.text = "Correct Lower Guesses: "..correctLowerTemp
        if correctLowerTemp >= correctLower then
          timer.cancel(adderTimer3)
        end
      end
      adderTimer3 = timer.performWithDelay(100, scoreAdder3, -1)
    end
    
    local function showCorrectHigher (event)
      local function scoreAdder4 (event)
        if correctHigher == 0 then
          timer.cancel(adderTimer4)
          return true
        end
        correctHigherTemp = correctHigherTemp + 1
        correctHigherText.text = "Correct Higher Guesses: "..correctHigherTemp
        if correctHigherTemp >= correctHigher then
          timer.cancel(adderTimer4)
        end
      end
      adderTimer4 = timer.performWithDelay(100, scoreAdder4, -1)
    end
    
    local function showCorrectEqual (event)
      local function scoreAdder5 (event)
        if correctEqual == 0 then
          timer.cancel(adderTimer5)
          return true
        end
        correctEqualTemp = correctEqualTemp + 1
        correctEqualText.text = "Correct Equal Guesses: "..correctEqualTemp
        if correctEqualTemp >= correctEqual then
          timer.cancel(adderTimer5)
        end
      end
      adderTimer5 = timer.performWithDelay(100, scoreAdder5, -1)
    end
    
    local function showTotalScore (event)
      local function scoreAdder6 (event)
        totalScoreTemp = totalScoreTemp + 5
        totalScoreText.text = "Total Score: "..totalScoreTemp
        if totalScoreTemp >= totalScore then
          timer.cancel(adderTimer6)
          if totalScore > highScore then
            highScore = totalScore
            newHighScore()
          else
            highScoreText.text = "High Score: "..highScore
            transition.to (highScoreText, {delay = 200, time = 400, alpha = 1})
            showRestart()
          end
        end
      end
      adderTimer6 = timer.performWithDelay(20, scoreAdder6, -1)
    end
    
    transition.to (highestBankText, {delay = 300, time = 1000, alpha = 1, onComplete = showHighestBank})
    transition.to (diceGuessedText, {delay = 1300, time = 1000, alpha = 1, onComplete = showDiceGuessed})
    transition.to (correctLowerText, {delay = 2100, time = 1000, alpha = 1, onComplete = showCorrectLower})
    transition.to (correctHigherText, {delay = 3000, time = 1000, alpha = 1, onComplete = showCorrectHigher})
    transition.to (correctEqualText, {delay = 4000, time = 1000, alpha = 1, onComplete = showCorrectEqual})
    transition.to (totalScoreText, {delay = 6000, time = 1000, alpha = 1, onComplete = showTotalScore})
    
    end

    transition.to (endingGrp, {delay = 2000, time = 2500, y = centerY, onComplete = addScores})

end

local function updateTotal()

  bet = 0
  bankText.text = "BANK: $"..bank
  resetChips()
  bankDifference = bank - oldTotal
  popUp("displayWinLoss")
  diffText()
  
  if bank > 5 and intenseMusic == true then
    local function playNewMusic()
      audio.setVolume( 0.1 , backgroundMusic )
      audio.rewind(gameMusic)
      audio.play (gameMusic, backgroundMusic)
      intenseMusic = false
    end
    audio.fadeOut( {channel = 1, time=900} )
    transition.to (sparkle, {x = 100, time = 1000, onComplete = playNewMusic})
  end
  
  if bank == 5 then
    
    local function playNewMusic()
      audio.setVolume( 0.1 , backgroundMusic )
      audio.rewind(intenseGameMusic)
      audio.play (intenseGameMusic, backgroundMusic)
      intenseMusic = true
    end
    audio.fadeOut( {channel = 1, time=900} )
    transition.to (sparkle, {x = 200, time = 1000, onComplete = playNewMusic})
  end
    
end

local function moveDice()
  
  if bank == 0 then
    audio.fadeOut( {channel = 1, time=1000} )
    endGame()
    return true
  end
  audio.play (swoopSfx, sfxMusic)
  transition.to (diceOne, {transition = easing.inOutElastic, time = 800, delay = 500, x = diceOne.x - 300, onComplete = blinkDice})
  transition.to (diceTwo, {transition = easing.inOutElastic, time = 800, delay = 500, x = centerX - 125, onComplete = swapDice})
end

local function rollNewDice()
    
  local diceRoller2 = randomRollerStart
  local diceHider2 = display.newImageRect ("images/"..diceRoller2..".png", 206, 206)
  local counter2 = 0
  local finished2 = false

  transition.cancel(titleText)
  timer.pause (blinkTimer)
  unknownDice.alpha = 0 

    local function rolling (event)
      diceRoller2 = diceRoller2 + 1
      if diceRoller2 == 7 then
        diceRoller2 = 1
      end
      
      diceHider2.fill = { type="image", filename="images/"..diceRoller2..".png"}

      if diceRoller2 == 1 then
        counter2 = counter2 + 1
      end
      
      if counter2 > 3 and finished2 == false then
        if diceRoller2 == rollTwo then
          diceHider2.alpha = 0
          diceTwo.alpha = 1
          transition.to (sparkle2, { delay = 0, alpha = 1, time = 500, onComplete = updateTotal})
          transition.to (sparkle2, { delay = 500, alpha = 0, time = 1500, onComplete = moveDice})
          display.remove(diceHider2)
          finished2 = true
        end
      end
    end
    
  rollTimer = timer.performWithDelay( 200, rolling, -1 )

  diceHider2.x = centerX + 125
  diceHider2.y = screenTop - diceHider2.height
  audio.play (diceRollSfx, sfxMusic)
  transition.to (diceHider2, {delay = 1000, time = 1000, y = centerY - 300, rotation = 360, transition = easing.outBounce})
  
end

local function rollDice (event)
  
  if currentRoll == true then
    return true
  end
  
  if currentPopUp == true then
    return true
  end
  
  if guess == "None" then
    popUp("noGuess")
    return true
  end
  if bet == 0 then
    popUp("noBet")
    return true
  end
  
  currentRoll = true
  rollButtonClicked.alpha = 1
  
  rollNewDice()
  
  local rightGuess
  
  if rollOne > rollTwo then
    rightGuess = "Lower"
  elseif rollOne < rollTwo then
    rightGuess = "Higher"
  else
    rightGuess = "Equal"
  end
  
  if guess == rightGuess then
    if guess == "Equal" then
      bank = bank + bet*3
      correctEqual = correctEqual + 1
    elseif guess == "Higher" then
      bank = bank + bet*2
      correctHigher = correctHigher + 1
    elseif guess == "Lower" then
      bank = bank + bet*2
      correctLower = correctLower + 1
    end
    if bank > highestBank then
      highestBank = bank
    end
    diceGuessed = diceGuessed + 1
  end
  
  return true
end

local function showTitleScreen()
  
  local titleBackground = display.newImage("images/background.png", centerX, centerY)
  titleBackground.width = screenWidth
  titleBackground.height = screenHeight
  
  local titleLogo = display.newImage("images/titleLogo.png", centerX, centerY - screenHeight/2 - screenHeight/4)
  
  local titleText = display.newText ("- CLICK TO PLAY -", centerX, centerY + 415, "fonts/CasinoFlat.ttf", 42)
  titleText.fill = {0}
  titleText.alpha = 0
  
  local isBlinking = false
  local wasClicked = false
    
  local function clearScreen(event)
    
    if wasClicked == true then
      return true
    end
    
    wasClicked = true
  
    local function erase()
      display.remove(titleBackground)
      display.remove(titleLogo)
      audio.setVolume( 0.1 , backgroundMusic )
      audio.play (gameMusic, backgroundMusic)
      titleScreenGone = true
    end
  
    transition.to(titleBackground,{time=2000, alpha=0, onComplete = erase})
    transition.to(titleLogo,{time=2000, alpha=0, onComplete = diceSetup})
    audio.fadeOut( {channel = 1, time=1000} )
    timer.pause(textBlinkTimer)
    transition.cancel(titleText) 
    transition.to(titleText,{time=2000, alpha=0})
    return true
  end
  
  local fade = display.newRect (centerX, centerY, screenWidth, screenHeight)
  fade.fill = {0}
  
  local function addListener (event)
    titleBackground:addEventListener("tap", clearScreen)
  end
  
  local function blinkText ()
    local function textChange (event)
      if isBlinking == false then
        addListener()
        isBlinking = true
      end
      transition.to (titleText, {transition = easing.OutCubic, alpha = 1, time = 600})
      transition.to (titleText, {transition = easing.OutCubic, alpha = 0, time = 400, delay = 600})
    end
  
    textBlinkTimer = timer.performWithDelay( 1500, textChange, -1)
  end
  
  local function playMusic()
    audio.play (titleScreenMusic, backgroundMusic)
  end
  
  transition.to (fade, {delay = 2000, transition = easing.inSine, time = 1400, alpha = 0, onComplete = playMusic})
  transition.to (titleLogo, {delay = 3400, time = 3000, transition = easing.outElastic, y = centerY, onComplete = blinkText})
  
end


-- main program

local background = display.newImage("images/background.png")
background.width = screenWidth
background.height = screenHeight
background.x = centerX
background.y = centerY

sparkle = display.newEmitter(emitterParams) 
sparkle.x = centerX - 125
sparkle.y = centerY - 300
sparkle.alpha = 0

sparkle2 = display.newEmitter(emitterParams) 
sparkle2.x = centerX + 125
sparkle2.y = centerY - 300
sparkle2.alpha = 0

popUpBox = display.newRoundedRect (centerX, centerY + screenHeight/2 + 100, screenWidth*0.8, 75, 25)
popUpBox.fill = {1}
popUpText = display.newText (errorText, centerX, centerY + screenHeight/2 + 100, "fonts/Barlow-Regular.ttf", 36)
popUpBox.fill = {0}

bankText = display.newText ("BANK: $"..bank, centerX - 220, centerY + 315, "fonts/Barlow-Regular.ttf", 42)
bankText.anchorX = 0,0

bankDiffText = display.newText (""..bank, centerX - 55, centerY + 315, "fonts/Barlow-Regular.ttf", 36)
bankDiffText.alpha = 0

local betPlace = display.newImageRect("images/betPlace.png", 150, 150)
betPlace.x = centerX + 140
betPlace.y = centerY - 5

bet5Button = display.newImageRect ("images/5but.png", 105,105)
bet5Button.x = centerX - 160
bet5Button.y = centerY - 60
bet5Button.value = 5
bet5Button.tap = setBet

bet10Button = display.newImageRect ("images/10but.png", 105,105)
bet10Button.x = centerX - 50
bet10Button.y = centerY - 60
bet10Button.value = 10
bet10Button.tap = setBet

bet15Button = display.newImageRect ("images/15but.png", 105, 105)
bet15Button.x = centerX - 160
bet15Button.y = centerY + 50
bet15Button.value = 15
bet15Button.tap = setBet

bet20Button = display.newImageRect ("images/20but.png", 105, 105)
bet20Button.x = centerX - 50
bet20Button.y = centerY + 50
bet20Button.value = 20
bet20Button.tap = setBet

guessLowButton = display.newImageRect ("images/lower.png", 200, 91)
guessLowButton.x = centerX + 170
guessLowButton.y = centerY + 175
guessLowButton.value = "Lower"
guessLowButton.tap = setGuess

guessEqualButton = display.newImageRect ("images/equal.png", 200, 91)
guessEqualButton.x = centerX
guessEqualButton.y = centerY + 175
guessEqualButton.value = "Equal"
guessEqualButton.tap = setGuess

guessHighButton = display.newImageRect ("images/higher.png", 200, 91)
guessHighButton.x = centerX - 170
guessHighButton.y = centerY + 175
guessHighButton.value = "Higher"
guessHighButton.tap = setGuess

guessLowButtonClicked = display.newImageRect ("images/lowerClicked.png", 200, 91)
guessLowButtonClicked.x = centerX + 170
guessLowButtonClicked.y = centerY + 175
guessLowButtonClicked.alpha = 0

guessEqualButtonClicked = display.newImageRect ("images/equalClicked.png", 200, 91)
guessEqualButtonClicked.x = centerX
guessEqualButtonClicked.y = centerY + 175
guessEqualButtonClicked.alpha = 0

guessHighButtonClicked = display.newImageRect ("images/higherClicked.png", 200, 91)
guessHighButtonClicked.x = centerX - 170
guessHighButtonClicked.y = centerY + 175
guessHighButtonClicked.alpha = 0

rollOne = math.random(1,6)
rollTwo = math.random(1,6)

diceOne = display.newImageRect ("images/"..rollOne..".png", 206, 206)
diceOne.x = centerX - 125
diceOne.y = centerY - 300
diceOne.alpha = 0

diceTwo = display.newImageRect ("images/"..rollTwo..".png", 206, 206)
diceTwo.x = centerX + 125
diceTwo.y = centerY - 300
diceTwo.alpha = 0

rollButton = display.newImageRect ("images/rollDice.png", 200, 91)
rollButton.x = centerX + 130
rollButton.y = centerY + 320

rollButtonClicked = display.newImageRect ("images/rollDiceClicked.png", 200, 91)
rollButtonClicked.x = centerX + 130
rollButtonClicked.y = centerY + 320

showTitleScreen()

-- event listeners

bet5Button:addEventListener ("tap", bet5Button)
bet10Button:addEventListener ("tap", bet10Button)
bet15Button:addEventListener ("tap", bet15Button)
bet20Button:addEventListener ("tap", bet20Button)

guessLowButton:addEventListener ("tap", guessLowButton)
guessEqualButton:addEventListener ("tap", guessEqualButton)
guessHighButton:addEventListener ("tap", guessHighButton)

rollButton:addEventListener ("tap", rollDice)