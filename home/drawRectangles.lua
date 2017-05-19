--"Imports" (ik they are variables)
local component = require ("component")
local sides = require("sides")
local event = require("event")
local term = require("term")
local gpu = component.gpu

local myColors = require("myColors")
--local rect = require("rect")
-- local shapes = require("shapes")
-- local rect = shapes.rect

--Variable definition
resX, resY = gpu.getResolution()
curID = 0
dropped = true
rect = {}

--Functions

function newRect(id, color, x, y)
  rect[id] = {["color"] = color, ["originX"] = x, ["originY"] = y, ["width"] = 1, ["height"] = 1, ["x"]=x, ["y"]=y}
end

function setBoundsRect(id, x, y, width, height)
  rect[id].x = x
  rect[id].y = y
  rect[id].width = width
  rect[id].height = height
end

function resizeRect(id, newX, newY)
  r = rect[id]
  if (newX >= r.originX and newY >= r.originY) then --1st Quadrant
    r.x = r.originX
    r.y = r.originY
    r.width = newX - r.originX + 1
    r.height = newY - r.originY + 1

  elseif (newX < r.originX and newY >= r.originY) then --2nd Quadrant
    r.x = newX
    r.y = r.originY
    r.width = r.originX - newX + 1
    r.height = newY - r.originY + 1

  elseif (newX >= r.originX and newY < r.originY) then --3rd Quandrant
    r.x = r.originX
    r.y = newY
    r.width = newX - r.originX + 1
    r.height = r.originY - newY + 1

  elseif (newX < r.originX and newY < r.originY) then --4th Quadrant
    r.x = newX
    r.y = newY
    r.width = r.originX - newX + 1
    r.height = r.originY - newY + 1
  end
end

function reDrawRect()
  term.clear()
  for i=0, (#rect or 0) do
    gpu.setBackground(rect[i].color)
    gpu.fill(rect[i].x, rect[i].y, rect[i].width, rect[i].height, " ")
  end
end

function summaryRect()
  for i=0, #rect do
    r = rect[i]
    print("ID: ".. i .."\tX: ".. r.x .."\tY:".. r.y .."\tW: ".. r.width .."\tH:".. r.height)
  end
end


function quit()
  gpu.setForeground(myColors.white)
  gpu.setBackground(0x000000)
  print("Soft Interrupt, Closing")
  summaryRect()
  os.exit()
end

--Execution (loop)
term.clear()
while true do
  id, _, x, y = event.pullMultiple("touch", "click", "drag", "drop", "interrupted")
  if id == "interrupted" then
    quit()
  elseif id == "touch" then
    if dropped then dropped = false else curID = curID +1 end

    newRect(curID, myColors.red, x, y)
    reDrawRect()
  elseif id == "drag" then
    resizeRect(curID, x, y)
    reDrawRect()
  elseif id == "drop" then
    dropped = true
    curID = curID + 1
  end
  gpu.setBackground(myColors.gray)
  gpu.setForeground(myColors.white)
  gpu.set(1, resY,"                        ")
  gpu.set(1, resY, id.."    x:".. x .."    y:".. y)
  gpu.setBackground(0x000000)
end
