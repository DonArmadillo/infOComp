local API = {}
local rect = {} --Rectangles Will be stored in this table

local component = require ("component")
local sides = require("sides")
local event = require("event")
local term = require("term")
local gpu = component.gpu

local myColors = require("myColors")

function API.clearTable()
  rect = {}
  term.clear()
end

function API.setOrigins(id, x, y)
  rect[id].color = colors.white
  rect[id].originX = x
  rect[id].originY = y
end

function API.setBounds(id, x, y, width, height)
  rect[id].x = x
  rect[id].y = y
  rect[id].width = width
  rect[id].height = height
  rect[id].originX = nil
  rect[id].originY = nil
end

function API.resize(id, newX, newY)
  re = rect[id]
  if (newX >= re.originX and newY >= re.originY) then --1st Quadrant
    re.x = re.originX
    re.y = re.originY
    re.width = newX - re.originX + 1
    re.height = newY - re.originY + 1

  elseif (newX < re.originX and newY >= re.originY) then --2nd Quadrant
    re.x = newX
    re.y = re.originY
    re.width = re.originX - newX + 1
    re.height = newY - re.originY + 1

  elseif (newX >= re.originX and newY < re.originY) then --3rd Quandrant
    re.x = re.originX
    re.y = newY
    re.width = newX - re.originX + 1
    re.height = re.originY - newY + 1

  elseif (newX < re.originX and newY < re.originY) then --4th Quadrant
    re.x = newX
    re.y = newY
    re.width = re.originX - newX + 1
    re.height = re.originY - newY + 1
  end
  rect[id] = re
  re = nil
end

function API.draw()
  term.clear()
  for i=0, (#rect or 0) do
    gpu.setBackground(rect[i].color)
    gpu.fill(rect[i].x, rect[i].y, rect[i].width, rect[i].height, " ")
  end
end

function API.inform()
  for i=0, #rect do print(table.unpack(rect[i])) end
end

return API
