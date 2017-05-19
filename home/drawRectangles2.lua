--"Imports" (ik they are variables)
local component = require ("component")
local sides = require("sides")
local event = require("event")
local term = require("term")
local gpu = component.gpu

local myColors = require("myColors")
-- local rectangle = require("rectangle")

local button = require("buttonAPI")


-- for k,v in pairs(button) do print(k,v) end

--Variable definition
resX, resY = gpu.getResolution()
STID = 0 --SelectedThingID
totalThings = 0

function quit()
  gpu.setForeground(myColors.white)
  gpu.setBackground(0x000000)
  print("Soft Interrupt, Closing")
  os.exit()
end

button.setTable("test", quit, 1,1,1,1)

--Execution (loop)
term.clear()
while true do
  id, _, x, y = event.pullMultiple("touch", "click", "drag", "drop", "interrupted")
  if id == "interrupted" then
    quit()
  elseif id == "touch" then
    if dropped==false then STID = totalThings + 1 else dropped = false end

    rectangle.setOrigins(STID, x, y)
    rect[STID].color = myColors.green
    totalThings = totalThings + 1
    rectangle.draw()

  elseif id == "drag" then
    rectangle.resize(STID, x, y)
    rectangle.draw()

  elseif id == "drop" then
    dropped = true
    STID = totalThings + 1
  end
  gpu.setBackground(myColors.gray)
  gpu.setForeground(myColors.white)
  gpu.set(1, resY,"                        ")
  gpu.set(1, resY, id.."    x:".. x .."    y:".. y)
  gpu.setBackground(0x000000)
end
