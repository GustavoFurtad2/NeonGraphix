# NeonGraphix

A Graphics Lib for Roblox

# Import library

```lua
local NeonGraphix = require(game.ReplicatedStorage.NeonGraphix.neonGraphix)
```

# Documentation

<h2>Render Class</h2>

<table>
<td>
<h3>NeonGraphix.Renderer.new</h3>

method to create a new renderer, returns a new render object.
| Parameter | Data Type |
| --------- | --------- |
| Width     | Number    |
| Height    | Number    |

usage example:
```lua
local render = NeonGraphix.Renderer.new(320, 248)                   
```
</td>
</table>
<table>
<td>
<h3>NeonGraphix.Renderer.init</h3>

starts the renderer for a player
| Parameter | Data Type      |
| --------- | -------------- |
| Player    | Player Object  |

usage example:
```lua
render:init(game.Players.LocalPlayer)                               
```
</td>
</table>
<table>
<td>
<h3>NeonGraphix.Renderer.clear</h3>

clears the render buffer.

usage example:
```lua
render:clear()                                                      
```
</td>
</table>
<table>
<td>
<h3>NeonGraphix.Renderer.update</h3>

updates rendering, reusing objects in the buffer<BR> to optimize performance.

usage example:
```lua
render:update()                                                     
```
</td>
</table>
<table>
<td>
<h3>NeonGraphix.Renderer.setBackgroundColor</h3>

set the render background color.
| Parameter | Data Type       |
| --------- | --------------- |
| Color     | Color3 Object    |

usage example:
```lua
render:setBackgroundColor(Color3.new(0, 0, 1))                      
```
</td>
</table>
<table>
<td>
<h3>NeonGraphix.Renderer.setResolution</h3>

set the render resolution.
| Parameter | Data Type |
| --------- | --------- |
| Width     | Number    |
| Height    | Number    |

usage example:
```lua
render:setResolution(320, 448)                                      
```
</td>
</table>
<table>
<td>
<h3>NeonGraphix.Renderer.getResolution</h3>

get render resolution.

returns two values: width and height.

usage example:
```lua
render:getResolution()                                              
```
</td>
</table>
<table>
<td>
<h3>NeonGraphix.Renderer.getGui</h3>

get render gui.

returns render gui.

usage example:
```lua
render:getGui()                                                     
```
</td>
</table>
<table>
<td>
<h3>NeonGraphix.Renderer.drawPixel</h3>

draw a pixel.
| Parameter | Data Type     |
| --------- | ------------- |
| X         | Number        |
| Y         | Number        |
| Color     | Color Object  |

usage example:
```lua
render:drawPixel(10, 10, Color3.new(1, 0, 0))                       
```
</td>
</table>
<table>
<td>
<h3>NeonGraphix.Renderer.drawLine</h3>

draw a line.
| Parameter  | Data Type     |
| ---------- | ------------- |
| X1         | Number        |
| Y1         | Number        |
| X2         | Number        |
| Y2         | Number        |
| Thickness  | Number        |
| Color      | Color Object  |

usage example:
```lua
render:drawLine(1, 1, 10, 10, 1, Color3.new(1, 0, 0))               
```
</td>
</table>
<table>
<td>
<h3>NeonGraphix.Renderer.drawRectangle</h3>

draw a rectangle.
| Parameter  | Data Type     |
| ---------- | ------------- |
| X          | Number        |
| Y          | Number        |
| width      | Number        |
| height     | Number        |
| Color      | Color Object  |

usage example:
```lua
render:drawRectangle(1, 1, 10, 10, Color3.new(1, 0, 0))             
```
</td>
</table>
<table>
<td>
<h3>NeonGraphix.Renderer.drawCircle</h3>

draw a circle.
| Parameter  | Data Type     |
| ---------- | ------------- |
| X          | Number        |
| Y          | Number        |
| Radius     | Number        |
| Fill       | Number        |
| Color      | Color Object  |

note: if fill is true the circle will be filled

usage example:
```lua
render:drawCircle(20, 20, 10, false, Color3.new(1, 0, 0))           
```
</td>
</table>