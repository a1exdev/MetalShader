//
//  Scene.swift
//  MetalShader
//
//  Created by Alexander Senin on 23.01.2023.
//

import MetalKit

class Scene: Node {
    
    var device: MTLDevice
    var size: CGSize
    var camera = Camera()
    var sceneConstants = SceneConstants()
  
    init(device: MTLDevice, size: CGSize) {
        
        self.device = device
        self.size = size
        
        super.init()
        
        camera.aspect = Float(size.width / size.height)
        camera.position.x -= 16.8
        camera.position.y -= 7
        camera.position.z -= 16
        
        add(childNode: camera)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder) {
        sceneConstants.projectionMatrix = camera.projectionMatrix
        commandEncoder.setVertexBytes(&sceneConstants,
                                      length: MemoryLayout<SceneConstants>.stride,
                                      index: 2)
        for child in children {
            child.render(commandEncoder: commandEncoder,
                         parentModelViewMatrix: camera.viewMatrix)
        }
    }
}
