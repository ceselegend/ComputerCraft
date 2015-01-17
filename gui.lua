wyvernsPeripherals = {}
wyvernsCtrl = {}
wyvernsState = {}
checkboxScale = 5

function pulse(side, delay)
	if delay == nil then delay = 1 end
	redstone.setOutput(side, true)
	sleep(delay)
	redstone.setOutput(side, false)
end

function wget(url, dir)
	local page=http.get(url)
	if not page then return false end
	local cFile = page.readAll()
	page.close()

	local fHandle = fs.open(dir, "w")
	if fHandle == nil then return false end
	local ret = fHandle.write(cFile)
	if ret == nil then return false end
	ret = fHandle.close()
end

function mprint(data)
	local m=loadPeripheral("monitor")
	local x,y = m.getCursorPos()
	m.write(data)
	local sizeX, sizeY = m.getSize()
	if y<sizeY then m.setCursorPos(1, y+1) end
	if y>=sizeY then m.scroll(1) m.setCursorPos(1, sizeY) end
end

function printFunctions(side)
	local methods = peripheral.getMethods(side)
	for i,v in pairs(methods) do
		print(peripheral.getType(side).."."..v.."()")
	end
end

-- ##Buttons part##

--  #Local functions#
--  Registering
local function registerCtrlButton(id, text, left, top, width, height, edges)
	wyvernsCtrl[id]={[1]="Button",[2]=text,[3]=left,[4]=top,[5]=width,[6]=height,[7]=edges}
end
local function registerCtrlToggle(id, text, left, top, width, height, edges, state)
	wyvernsCtrl[id]={[1]="Toggle",[2]=text,[3]=left,[4]=top,[5]=width,[6]=height,[7]=edges,[8]=state}
end
local function registerCtrlCheckbox(id, left, top)
	wyvernsCtrl[id]={[1]="Checkbox",[3]=left, [4]=top, [5]=checkboxScale, [6]=checkboxScale}
end
local function registerCtrlLabel(id, text, left, top, width, height, textColor, bgColor)
	wyvernsCtrl[id]={[1]="Label",[2]=text,[3]=left,[4]=top,[5]=width,[6]=height,[7]=textColor,[8]=bgColor}
end

local function loadCtrl(id, shift)
	if shift == nil then shift = 1 end -- The function won't return any parameter below the shift, this allow me to add global parameters whenever I want
	if type(wyvernsCtrl[id]) ~= "table" then print("Error: invalid id ("..id..").") end
	return wyvernsCtrl[id][1+shift], wyvernsCtrl[id][2+shift], wyvernsCtrl[id][3+shift], wyvernsCtrl[id][4+shift], wyvernsCtrl[id][5+shift], wyvernsCtrl[id][6+shift], wyvernsCtrl[id][7+shift], wyvernsCtrl[id][8+shift], wyvernsCtrl[id][9+shift]
end

local function getBackgroundColor()
	return backgroundColor
end

--   Drawing
local function drawEdges(left, top, width, height)
	for i=0, height do -- Draw the left edge
		drawPixel(left, top+i, "white")
	end
	for i=0, height do -- Draw the right edge
		drawPixel(left+width, top+i, "gray")
	end
	for i=0, width-1 do -- Draw the top edge
		drawPixel(left+i, top, "white")
	end
	for i=0, width do -- Draw the bottom edge
		drawPixel(left+i, top+height, "gray")
	end
end

local function drawInvertedEdges(left, top, width, height)
	for i=0, height do -- Draw the left edge
		drawPixel(left, top+i, "gray")
	end
	for i=0, height do -- Draw the right edge
		drawPixel(left+width, top+i, "white")
	end
	for i=0, width-1 do -- Draw the top edge
		drawPixel(left+i, top, "gray")
	end
	for i=0, width do -- Draw the bottom edge
		drawPixel(left+i, top+height, "white")
	end
end

-- ##Public functions##
function registerPeripheral(side)
	wyvernsPeripherals[peripheral.getType(side)] = peripheral.wrap(side)
end

function loadPeripheral(peripheralType)
	return wyvernsPeripherals[peripheralType]
end

function setBackgroundColor(color)
	local m=loadPeripheral("monitor")
	m.setBackgroundColor(colors[color])
	local x,y=m.getSize()
	for i=1,y do
		for v=1,x do
			m.setCursorPos(v,i)
			m.write(" ")
		end
	end
	backgroundColor = color
end

function changeResolution(newResolution)
	local m=loadPeripheral("monitor")
	if newResolution > 5 then
		newResolution = 5
		print("Resolution can't be greater than 5. Automatically set to max.")
	elseif newResolution < 0.5 then
		newResolution = 0.5
		print("Resolution can't be lower than 5. Automatically set to min.")
	end
	m.setTextScale(newResolution)
end

function drawPixel(x,y,color)
	local m=loadPeripheral("monitor")
	m.setCursorPos(x,y)
	m.setBackgroundColor(colors[color])
	m.write(" ")
	m.setBackgroundColor(colors.white)
end

function guiCtrlGetType(id)
	local cType = loadCtrl(id, 0)
	return cType
end

function guiCtrlGetState(id)
	local cType = loadCtrl(id, 0)
	if cType == "Toggle" or cType == "Checkbox" then 
		return wyvernsState[id]
	end
end

function guiCtrlSetState(id, state)
	local m=loadPeripheral("monitor")
	local left, top, width, height = loadCtrl(id, 2)
	
	if state == true then
		color = "lime"
		wyvernsState[id] = true
	else
		color = "red"
		wyvernsState[id] = false
	end
	
	if guiCtrlGetType(id) == "Toggle" then
		for i=1, width-3 do
			drawPixel(left+1+i, top+1+height/2, color)
		end
	elseif guiCtrlGetType(id) == "Checkbox" then
		for v=1, height-1 do
			for i=1, width-1 do
				drawPixel(left+i, top+v, color)
			end
		end
		-- if state == true then drawInvertedEdges(left, top, width, height) end
		-- if state == false then drawEdges(left, top, width, height) end
		drawEdges(left, top, width, height)
	end
end

function guiCreateButton(text, left, top, width, height, color, edges)
	if edges == nil then edges = true end
	if color == nil then color = "lightGray" end
	local m=loadPeripheral("monitor")
	for v=0, height do
		for i=0, width do
			drawPixel(left+i, top+v, color)
		end
	end
	if edges == true then drawEdges(left, top, width, height) end
	m.setCursorPos(left+1-(string.len(text)/2)+width/2, top+height/2)
	m.setTextColor(colors.black)
	m.setBackgroundColor(colors[color])
	m.write(text)
	registerCtrlButton(#wyvernsCtrl+1, text, left, top, width, height)
	return #wyvernsCtrl -- Return the ID of the button
end

function guiCreateToggle(text, left, top, width, height, color, edges, state)
	if edges == nil then edges = true end
	if color == nil then color = "lightGray" end
	if state == nil then state = false end
	local m=loadPeripheral("monitor")
	for v=0, height do
		for i=0, width do
			drawPixel(left+i, top+v, color)
		end
	end
	if edges == true then drawEdges(left, top, width, height) end
	m.setCursorPos(left+1-(string.len(text)/2)+width/2, top+height/2)
	m.setTextColor(colors.black)
	m.setBackgroundColor(colors[color])
	m.write(text)
	registerCtrlToggle(#wyvernsCtrl+1, text, left, top, width, height, state) 
	guiCtrlSetState(#wyvernsCtrl, state) -- As I just added it to the registry there's no +1 anymore
	return #wyvernsCtrl -- Return the ID of the button
end

function guiCreateCheckbox(left, top, state)
	if state == nil then state = false end
	if state == true then color = "lime" end
	if state == false then color = "red" end
	local m=loadPeripheral("monitor")
	--[[
	for v=0, checkboxScale do
		for i=0, checkboxScale do
			drawPixel(left+i, top+v, color)
		end
	end
	]]
	registerCtrlCheckbox(#wyvernsCtrl+1, left, top)
	guiCtrlSetState(#wyvernsCtrl, state)
	return #wyvernsCtrl
end

function guiCreateLabel(text, left, top, width, height, textColor, bgColor)
	if width == nil then width = string.len(text) end
	if height == nil then height = 1 end
	if textColor == nil then textColor = "black" end
	if bgColor == nil then bgColor = getBackgroundColor() end
	local m=loadPeripheral("monitor")
	
	m.setCursorPos(left, top)
	m.setTextColor(colors[textColor])
	m.setBackgroundColor(colors[bgColor])
	m.write(text)
	
	registerCtrlLabel(#wyvernsCtrl+1, text, left, top, width, height, textColor, bgColor)
	return #wyvernsCtrl
end
	

function guiGetMsg()
	local _,side,x,y = os.pullEvent("monitor_touch")
	for i=1, #wyvernsCtrl do
		local name, left, top, width, height = loadCtrl(i)
		if x <= left+width and x >= left then
			if y <= top+height and y >= top then
				-- He clicked on a button
				if guiCtrlGetType(i) == "Toggle" or guiCtrlGetType(i) == "Checkbox" then
					if guiCtrlGetState(i) == false then 
						guiCtrlSetState(i, true)
					else
						guiCtrlSetState(i, false)
					end
				end
				return i, name, 0
			end
		end
	end
	return -1, x, y
end
