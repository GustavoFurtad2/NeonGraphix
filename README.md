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
| Resolution      | Vector2    |
| Window Position | Vector2    |
| Window Size     | Vector2    |

usage example:
```lua
local render = NeonGraphix.Renderer2D.new(
 Vector2.new(320, 248),
 Vector2.new(0, 0),
 Vector2.new(1, 1)
)                                                                   
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
| Resolution| Vector2    |

usage example:
```lua
render:setResolution(Vector2.new(328, 248))                         
```
</td>
</table>
<table>
<td>
<h3>:getResolution</h3>

get render resolution.

returns a vector with the render resolution.

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
| Position  | Vector2       |
| Color     | Color3 Object |

usage example:
```lua
render:drawPixel(Vector2.new(10, 10), Color3.new(1, 0, 0))          
```
</td>
</table>
<table>
<td>
<h3>:drawLine</h3>

draw a line.
| Parameter  | Data Type     |
| ---------- | ------------- |
| Position 1 | Vector2       |
| Position 2 | Vector2       |
| Thickness  | Number        |
| Color      | Color3 Object |

usage example:
```lua
render:drawLine(
  Vector2.new(1, 1)
  Vector2.new(320, 248),
  1, Color3.new(1, 0, 0)
)                                                                   
```
</td>
</table>
<table>
<td>
<h3>:drawRectangle</h3>

draw a rectangle.
| Parameter  | Data Type     |
| ---------- | ------------- |
| Position   | Vector2       |
| Size       | Vector2       |
| Color      | Color3 Object |

usage example:
```lua
render:drawRectangle(
  Vector2.new(10, 10),
  Vector2.new(10, 10),
  Color3.new(1, 0, 0)
)                                                                   
```
</td>
</table>
<table>
<td>
<h3>:drawCircle</h3>

draw a circle.
| Parameter  | Data Type     |
| ---------- | ------------- |
| Position   | Vector2       |
| Size       | Vector2       |
| Radius     | Number        |
| Fill       | Number        |
| Color      | Color3 Object |

note: if fill is true the circle will be filled

usage example:
```lua
render:drawCircle(
  Vector2.new(20, 20),
  10, false,
  Color3.new(1, 0, 0)
)                                                                   
```
</td>
</table>
<table>
<td>
<h3>:drawTriangle</h3>

draw a triangle.
| Parameter  | Data Type     |
| ---------- | ------------- |
| Position 1 | Vector2       |
| Position 2 | Vector2       |
| Position 3 | Vector2       |
| Color      | Color3 Object |

usage example:
```lua
render:drawTriangle(
  Vector2.new(20, 10),
  Vector2.new(30, 20),
  Vector2.new(10, 20),
  1, Color3.new(1, 1, 0)
)                                                                   
```
</td>
</table>