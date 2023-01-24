//
//  Camera.swift
//  MetalShader
//
//  Created by Alexander Senin on 24.01.2023.
//

import MetalKit

class Camera: Node {
    
    var fovDegrees: Float = 65
    var fovRadians: Float {
        return radians(fromDegrees: fovDegrees)
    }
    
    var aspect: Float = 1
    var nearZ: Float = 0.1
    var farZ: Float = 100
    
    var viewMatrix: matrix_float4x4 {
        return modelMatrix
    }
    
    var projectionMatrix: matrix_float4x4 {
        return matrix_float4x4(projectionFov: fovRadians,
                               aspect: aspect,
                               nearZ: nearZ,
                               farZ: farZ)
    }
}
