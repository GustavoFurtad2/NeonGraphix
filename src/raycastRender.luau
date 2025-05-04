local Render2D = require(script.Parent.render2D)

local RaycastRender = {Renderers = {}}

local cos, sin = {}, {}

for i = 0, 360 do

    cos[i], sin[i] = math.cos(i / 180 * math.pi), math.sin(i / 180 * math.pi)
end

type plane = {

    top: {number},
    bottom: {number}
}

type wall = {

    a: Vector2,
    b: Vector2,

    portalTopHeight: number,
    portalBottomHeight: number,

    isPortal: boolean
}

type sector = {

    id: number,

    walls: {wall},
    height: number,

    elevation: number,
    distance: number,

    color: Color3,
}

function RaycastRender.createSector(height : number, elevation : number, color : Color3)

    if typeof(height) ~= "number" then

        error("In the height parameter of the RaycastRender createSector you must use a number!")

    elseif typeof(elevation) ~= "number" then

        error("In the elevaation parameter of the RaycastRender createSector you must use a number!")
    elseif typeof(color) ~= "Color3" then

        error("In the color parameter of the RaycastRender createSector you must use a Color!")
    end

    local sector : sector = {

        id = 0,

        walls = {},
        height = height,
        elevation = elevation,
        color = color,
    }

    return sector
end

function RaycastRender.addWallToSector(sector : sector, wall : wall)
    
    if typeof(sector) ~= "table" then

        error("In the sector parameter of the RaycastRender addWallToSector you must use a sector!")

    elseif typeof(wall) ~= "table" then

        error("In the wall parameter of the RaycastRender addWallToSector you must use a wall!")
    end

    table.insert(sector.walls, wall)
end

function RaycastRender.addSectorToQueue(sectorsQueue : table, sector : sector)
   
    if typeof(sectorsQueue) ~= "table" then

        error("In the sectorsQueue parameter of the RaycastRender addSectorToQueue you must use a table!")

    elseif typeof(sector) ~= "table" then

        error("In the sector parameter of the RaycastRender addSectorToQueue you must use a sector!")
    end

    table.insert(sectorsQueue, sector)
end

function RaycastRender.createWall(a : Vector2, b : Vector2)

    if typeof(a) ~= "Vector2" then

        error("In the a parameter of the RaycastRender createWall you must use a Vector2!")

    elseif typeof(b) ~= "Vector2" then

        error("In the b parameter of the RaycastRender createWall you must use a Vector2!")
    end

    local wall : wall = {

        a = Vector2.new(a.X, a.Y),
        b = Vector2.new(b.X, b.Y),
    }

    return wall
end

function RaycastRender.renderSectors(ID : number, sectorsQueue : table, lodScale : number)

    if typeof(ID) ~= "number" then

        error("In the ID parameter of the RaycastRender renderSectors you must use a number!")

    elseif typeof(sectorsQueue) ~= "table" then

        error("In the sectorsQueue parameter of the RaycastRender renderSectors you must use a table")
    
    elseif typeof(lodScale) ~= "number" then

        error("In the lodScale parameter of the RaycastRender renderSectors you must use a number!")
    end
    
    local currentRenderer = RaycastRender.Renderers[ID]
    local resolution = Render2D.getResolution(currentRenderer.render2DID)
    local camera = currentRenderer.camera

    local halfWidth, halfHeight = resolution.X * 0.5, resolution.Y * 0.5
    local fov = 300
    local wallColor = Color3.new(1, 1, 0)

    local sinAngle = sin[camera.angle]
    local cosAngle = cos[camera.angle]

    local camX, camY, camZ = camera.position.X, camera.position.Y, camera.position.Z

    for _, sector in next, sectorsQueue do

        for _, wall in next, sector.walls do

            local dx1, dy1 = wall.a.X - camX, wall.a.Y - camY
            local dx2, dy2 = wall.b.X - camX, wall.b.Y - camY

            local wx1 = dx1 * sinAngle - dy1 * cosAngle
            local wz1 = dx1 * cosAngle + dy1 * sinAngle
            local wx2 = dx2 * sinAngle - dy2 * cosAngle
            local wz2 = dx2 * cosAngle + dy2 * sinAngle

            if wz1 < 0 and wz2 < 0 then break end

            wz1 = math.max(wz1, 0.1)
            wz2 = math.max(wz2, 0.1)

            local invWZ1, invWZ2 = 1 / wz1, 1 / wz2
            local sx1 = wx1 * fov * invWZ1 + halfWidth
            local sx2 = wx2 * fov * invWZ2 + halfWidth

            local elevation1 = sector.elevation * fov * invWZ1
            local elevation2 = sector.elevation * fov * invWZ2

            local sy1 = (resolution.Y + camZ) * invWZ1 - elevation1 + halfHeight
            local sy2 = (resolution.Y + camZ) * invWZ2 - elevation2 + halfHeight

            local wallHeight1 = sector.height * fov * invWZ1
            local wallHeight2 = sector.height * fov * invWZ2

            if sx2 < sx1 then
                sx1, sx2 = sx2, sx1
                sy1, sy2 = sy2, sy1
                wallHeight1, wallHeight2 = wallHeight2, wallHeight1
            end

            local xStart = math.floor(sx1)
            local xEnd = math.ceil(sx2)

            local distance = math.min(wz1, wz2)
            local lodFactor = math.max(1, math.floor(distance / lodScale))

            local wallWidth = math.abs(sx2 - sx1)
            local step = math.max(1, math.floor(wallWidth / (lodFactor * 20)))

            for x = xStart, xEnd, step do

                local t = (x - sx1) / (sx2 - sx1)

                local yTop = ((sy1 - wallHeight1) * (1 - t)) + ((sy2 - wallHeight2) * t)
                local yBottom = (sy1 * (1 - t)) + (sy2 * t)
                local height = yBottom - yTop

                Render2D.drawRectangle(currentRenderer.render2DID, Vector2.new(x, yTop), Vector2.new(step, height), sector.color)
            end
        end
    end
end

function RaycastRender.createRenderer(player : Instance, camera : table, resolution : Vector2, windowPosition : Vector2, windowSize : Vector2) : number

    if typeof(player) ~= "Instance" then

        error("In the player parameter of the RaycasterRender createRenderer you must use a player instance!")

    elseif typeof(camera) ~= "table" then
    
        error("In the camera parameter of the RaycasterRender createRenderer you must use a camera!")

    elseif typeof(resolution) ~= "Vector2" then

        error("In the resolution parameter of the RaycasterRender createRenderer you must use a Vector2!")
    
    elseif typeof(windowPosition) ~= "Vector2" then

        error("In the windowPosition parameter of the RaycasterRender createRenderer  you must use a Vector2!")
        
    elseif typeof(resolution) ~= "Vector2" then

        error("In the windowSize parameter of the RaycasterRender createRenderer  you must use a Vector2!")
    end

    table.insert(RaycastRender.Renderers, {

        render2DID = Render2D.createRenderer(resolution, windowPosition, windowSize),

        camera = camera,

        planes = {},
        walls = {},

        camera = camera
    })

    Render2D.init(#RaycastRender.Renderers, player)

    return #RaycastRender.Renderers
end

function RaycastRender.clear(ID : number, color : Color3)

    Render2D.clear(RaycastRender.Renderers[ID].render2DID, color)
end

function RaycastRender.update(ID : number)

    local renderer = RaycastRender.Renderers[ID]

    Render2D.update(renderer.render2DID)
end



return RaycastRender