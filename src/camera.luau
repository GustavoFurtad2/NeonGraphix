local Camera = {Cameras = {}}

local cos, sin = {}, {}

for i = 1, 360 do

    cos[i], sin[i] = math.cos(i / 180 * math.pi), math.sin(i / 180 * math.pi)
end

function Camera.createCamera(player : instance, position : Vector3, angle : number, moveSpeed : number, elevationSpeed : number, rotationSpeed : number) : table

    if typeof(position) ~= "Vector3" then

        error("In the position parameter of the Camera createCamera you must use a Vector3!")
    
    elseif typeof(angle) ~= "number" then

        error("In the angle parameter of the Camera createCamera you must use a number!")
    end

    table.insert(Camera.Cameras, {
        player = player,
        position = Vector3.new(position.X, position.Y, position.Z),
        angle = angle,
        moveSpeed = moveSpeed,
        elevationSpeed = elevationSpeed,
        rotationSpeed = rotationSpeed
    })

    return #Camera.Cameras
end

function Camera.getCamera(ID : number)

    return Camera.Cameras[ID]
end

return Camera