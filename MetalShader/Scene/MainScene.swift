//
//  MainScene.swift
//  MetalShader
//
//  Created by Alexander Senin on 23.01.2023.
//

import MetalKit

class MainScene: Scene {
    
    let model: Model
    
    override init(device: MTLDevice, size: CGSize) {
        
        model = Model(device: device, modelName: "model")
        
        super.init(device: device, size: size)
        add(childNode: model)
      
        model.rotation.x -= 0.45
        model.rotation.y -= 0.367
        model.rotation.z -= 0.08
    }
}
