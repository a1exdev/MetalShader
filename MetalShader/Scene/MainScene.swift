//
//  MainScene.swift
//  MetalShader
//
//  Created by Alexander Senin on 23.01.2023.
//

import MetalKit

class MainScene: Scene {
    
    var model: Model
    
    override init(device: MTLDevice, size: CGSize) {
        
        model = Model(device: device, imageName: "apple park.jpg")
        
        super.init(device: device, size: size)
        
        add(childNode: model)
    }
}
