function getAngleBetweenPoints(x1, y1, x2, y2)
  return math.atan2(y2 - y1, x2 - x1)
end

function getPointOnCircle(rad, r, cx, cy)
  local nx, ny
  nx = cx + r * math.cos(rad)
  ny = cy + r * math.sin(rad)
  return nx, ny
end

function each(tbl, func)
  for i=1,#tbl do
    func(tbl)
  end
end

function distance(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
