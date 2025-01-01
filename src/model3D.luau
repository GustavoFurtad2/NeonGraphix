local Model3D = {}
Model3D.__index = Model3D

function Model3D.new(modelType)
    
    local model3D = {modelType = modelType}

    if modelType == "obj" then

    end

    return model3D
end

return Model3D