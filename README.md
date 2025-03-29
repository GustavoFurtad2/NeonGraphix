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
<h3>NeonGraphix.Renderer2D.new</h3>

method to create a new renderer, returns a new render object.
| Parameter | Data Type            |
| --------- | -------------------- |
| Resolution Width     | Number    |
| Resolution Height    | Number    |
| Window X             | Number    |
| Window Y             | Number    |
| Window Width         | Number    |
| Window Height        | Number    |

usage example:
```lua
local render = NeonGraphix.Renderer2D.new(320, 248, 0, 0, 1, 1)     
 ```
note: the window size is scaled, i.e. 1 is the same as 100%

</td>
</table>
<table>
<td>
<h3>:init</h3>

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
<h3>:clear</h3>

clears the render buffer.

| Parameter           | Data Type |
| ------------------- | --------- |
| BackgroundColor     | Number    |

usage example:
```lua
render:clear(Color3.new(0, 0, 0))                                   
```
</td>
</table>
<table>
<td>
<h3>:update</h3>

updates rendering, reusing objects in the buffer<BR> to optimize performance.

usage example:
```lua
render:update()                                                     
```
</td>
</table>
<table>
<td>
<h3>:setResolution</h3>

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
<h3>:getResolution</h3>

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
<h3>:getGui</h3>

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
<h3>:drawPixel</h3>

draw a pixel.
| Parameter | Data Type     |
| --------- | ------------- |
| X         | Number        |
| Y         | Number        |
| Color     | Color3 Object |

usage example:
```lua
render:drawPixel(10, 10, Color3.new(1, 0, 0))                       
```
</td>
</table>
<table>
<td>
<h3>:drawLine</h3>

draw a line.
| Parameter  | Data Type     |
| ---------- | ------------- |
| X1         | Number        |
| Y1         | Number        |
| X2         | Number        |
| Y2         | Number        |
| Thickness  | Number        |
| Color      | Color3 Object |

usage example:
```lua
render:drawLine(1, 1, 10, 10, 1, Color3.new(1, 0, 0))               
```
</td>
</table>
<table>
<td>
<h3>:drawRectangle</h3>

draw a rectangle.
| Parameter  | Data Type     |
| ---------- | ------------- |
| X          | Number        |
| Y          | Number        |
| width      | Number        |
| height     | Number        |
| Color      | Color3 Object |

usage example:
```lua
render:drawRectangle(1, 1, 10, 10, Color3.new(1, 0, 0))             
```
</td>
</table>
<table>
<td>
<h3>:drawCircle</h3>

draw a circle.
| Parameter  | Data Type     |
| ---------- | ------------- |
| X          | Number        |
| Y          | Number        |
| Radius     | Number        |
| Fill       | Number        |
| Color      | Color3 Object |

note: if fill is true the circle will be filled

usage example:
```lua
render:drawCircle(20, 20, 10, false, Color3.new(1, 0, 0))           
```
</td>
</table>
<table>
<td>
<h3>:drawTriangle</h3>

draw a triangle.
| Parameter  | Data Type     |
| ---------- | ------------- |
| X1         | Number        |
| Y1         | Number        |
| X2         | Number        |
| Y2         | Number        |
| X3         | Number        |
| Y3         | Number        |
| Thickness  | Number        |
| Color      | Color3 Object |

usage example:
```lua
render:drawTriangle(20, 10, 30, 20, 10, 20, 1, Color3.new(1, 1, 0)) 
```
</td>
</table>