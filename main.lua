require('love.graphics')
require('love.image')

require('util')
require('config')
require('player')

function love.load()
  love.graphics.setMode(config.display.width, config.display.height, false)
  love.graphics.setBackgroundColor(config.bg)

  player = newPlayer(config)
  player:load()
end

function love.update(dt)
  if love.keyboard.isDown("q") then
    love.event.push("quit")
  end
  player:update(dt)
  bullets = player:getBullets()
  for i=1,#bullets do
    bullets[i]:update(dt)
  end
end

function love.mousepressed(x, y, button)
  player:mousepressed(x, y, button)
end

function love.draw()
  player:draw()
  bullets = player:getBullets()
  for i=1,#bullets do
    bullets[i]:draw()
  end
end
