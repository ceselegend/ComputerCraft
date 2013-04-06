ComputerCraft
=============

Functions

=============================================================
- registerPeripheral(side)
Returns: Nothing

It's the first thing you'll have to do. 
Register a monitor and everything you're gonna create will be shown on it.

Example:
registerPeripheral("bottom")
-> nil

=============================================================
- loadPeripheral(peripheralType)
Returns: The last registered peripheral of the indicated type

Example: 
loadPeripheral("monitor")
-> Table

=============================================================
- setBackgroundColor(color)
Returns: Nothing

Changes the background color of the last registered monitor.
Example:
setBackgroundColor("orange")
-> nil

=============================================================
- drawPixel(x,y,color)
Returns: Nothing

Draw a pixel on the last registered monitor.
Example:
for i=1,5 do
  drawPixel(i,1,"white")
end
-- It drew a line
-> nil

=============================================================
- guiCtrlGetType(id)
Returns: The type of the corresponding control (ex: "Button")

Example:
if guiCtrlGetType(id) == "Toggle" then
  print("It's a toggle !")
end

=============================================================
- guiCtrlSetState(id, state)
Returns: The new state of the control or nil

Example:
if guiCtrlGetState(id) == true then
  guiCtrlSetState(id, false)
end

=============================================================
- guiCtrlGetState(id)
Returns: The current state of the control or nil

Example:
if guiCtrlGetState(id) == true then
  guiCtrlSetState(id, false)
end

=============================================================
- guiGetMsg()
Returns: 
if a control is touched on the last registered monitor: id, text 
if the background was touched: -1, x, y

Example:
registerPeripheral("bottom")
btn1 = guiCreateButton("Button 1", 1, 1, 10, 5, "white", true)
while true do
  id, var1, var2 = guiGetMsg()
  if id == btn1 then
    print(var1.." was just pressed")
  elseif id == -1 then
    print("The background was just touched")
  end
end

=============================================================
- guiCreateButton(text, left, top, width, height, [color=lightGray], [outlines=true])
Returns: The ID of the new control

Example:
registerPeripheral("bottom")
btn1 = guiCreateButton("Button 1", 1, 1, 10, 5, "white", true)
while true do
  id, var1, var2 = guiGetMsg()
  if id == btn1 then
    print(var1.." was just pressed")
  end
end

=============================================================
- guiCreateToggle(text, left, top, width, height, [color="lightGray"], [outlines=true], [state=false])
Returns: The ID of the new control

Example:
registerPeripheral("bottom")
toggle = guiCreateButton("The door", 1, 1, 10, 5, "white", true)
while true do
  id, var1, var2 = guiGetMsg()
  if id == toggle then
    redstone.setOutput("left", guiCtrlGetState(toggle))
  end
end

=============================================================
- guiCreateCheckbox(left, top, [state=false])
Returns: The ID of the new control

Example:
registerPeripheral("bottom")
chkbx = guiCreateCheckbox(1,1)
while true do
  id, var1, var2 = guiGetMsg()
  if id == chkbox then
    redstone.setOutput("left", guiCtrlGetState(chkbox))
  end
end

=============================================================
- guiCreateLabel(text, left, top, [width=string.len(text)], [height=1], [textColor="black"], [backgroundColor=nil])
Returns: The ID of the new control

If no background color is given, the backgroundcolor of the monitor will be chosen
A label acts like a button. Its ID will be returned by guiGetMsg() if pressed.

registerPeripheral("bottom")
label = guiCreateLabel("Do not touch", 1 , 1)
while true do
  id, var1, var2 = guiGetMsg()
  if id == label then
    print("You touched the label !")
  end
end
