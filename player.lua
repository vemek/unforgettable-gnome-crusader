require('util')
function newBullet(angle, x, y)
  local bullet = {
    x = x,
    y = y,
    dx = 0,
    dy = 0,
  }

  function bullet:load()
    local velocity = 4
    self.dx = velocity * math.cos(angle)
    self.dy = velocity * math.sin(angle)
  end

  function bullet:update(dt)
    self.x = self.x + self.dx
    self.y = self.y + self.dy
  end

  function bullet:draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, 3, 3)
  end

  return bullet
end

function newPlayer(config)
  local player = {
    tick = 0,
    config = config,
    radius = 20,
    x = 0,
    y = 0,
    shieldAngle = math.pi,
    shieldSize = 0.3,
    bullets = {}
  }

  function player:load()
    self.x = love.graphics.getWidth()/2
    self.y = love.graphics.getHeight()/2
  end

  function player:update(dt)
    self.tick = self.tick + 1
    if love.keyboard.isDown(self.config.keymap.LEFT) then
      self.shieldAngle = (self.shieldAngle - self.config.velocity) % (2 * math.pi)
    end
    if love.keyboard.isDown(self.config.keymap.RIGHT) then
      self.shieldAngle = (self.shieldAngle + self.config.velocity) % (2 * math.pi)
    end

    -- clean bullets
    if self.tick == 99 then
      for i=1,#self.bullets do
        if distance(self.x, self.y, self.bullets[i].x, self.bullets[i].y) > 70 then
          table.remove(self.bullets, i)
        end
      end
    end

    self.tick = self.tick % 100
  end

  function player:mousepressed(x, y, button)
    if #self.bullets < self.config.max_bullets then
      angle = getAngleBetweenPoints(self.x, self.y, x, y)
      bx, by = getPointOnCircle(angle, self.radius + 30, self.x, self.y)
      b = newBullet(angle, bx, by)
      b:load()
      table.insert(self.bullets, b)
    end
  end

  function player:getBullets()
    return self.bullets
  end

  function player:drawTurret()
    -- set up styles and colours
    love.graphics.setColor(255, 0, 0)
    love.graphics.setLine(2, "smooth")
    local angle, x1, y1, x2, y2, x3, y3
    local mx, my = love.mouse.getPosition()
    angle = getAngleBetweenPoints(self.x, self.y, mx, my)
    x1, y1 = getPointOnCircle(angle, self.radius + 30, self.x, self.y)
    x2, y2 = getPointOnCircle(angle - 0.11, self.radius + 20, self.x, self.y)
    x3, y3 = getPointOnCircle(angle + 0.11, self.radius + 20, self.x, self.y)
    love.graphics.triangle("fill", x1, y1, x2, y2, x3, y3)
  end

  function player:drawShield()
    -- set up styles and colours
    love.graphics.setColor(0, 255, 0)
    love.graphics.setLine(2, "smooth")
    love.graphics.arc("fill", self.x, self.y, self.radius + 35, self.shieldAngle, self.shieldAngle + self.shieldSize, 10)
    love.graphics.setColor(self.config.bg)
    love.graphics.circle("fill", self.x, self.y, self.radius + 32, 50)
  end

  function player:draw()
    -- shield graphics
    self:drawShield()
    
    -- turret graphics
    self:drawTurret()

    -- base graphics
    love.graphics.setColor(255, 255, 0)
    love.graphics.setLine(2, "smooth")
    love.graphics.circle("line", self.x, self.y, self.radius, 50)

  end

  return player
end
