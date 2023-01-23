//
//  Model.swift
//  MetalShader
//
//  Created by Alexander Senin on 23.01.2023.
//

import MetalKit

class Model: Node, Renderable, Texturable {
    
    var vertices: [Vertex] = [Vertex(position: SIMD3<Float>(0, 0.5, 0),
                                     color: SIMD4<Float>(1, 0, 0, 1),
                                     texture: SIMD2<Float>(0, 1)),
                              Vertex(position: SIMD3<Float>(-0.5, -0.5, 0),
                                     color: SIMD4<Float>(0, 1, 0, 1),
                                     texture: SIMD2<Float>(0, 0)),
                              Vertex(position: SIMD3<Float>(0.5, -0.5, 0),
                                     color: SIMD4<Float>(0, 0, 1, 1),
                                     texture: SIMD2<Float>(1, 0))]

    var indices: [UInt16] = [0, 1, 2]
    
    var texture: MTLTexture?
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    var pipelineState: MTLRenderPipelineState!
    var fragmentFunctionName: String = FunctionNames.fragmentShader.rawValue
    var vertexFunctionName: String = FunctionNames.vertexShader.rawValue
    
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<SIMD3<Float>>.stride + MemoryLayout<SIMD4<Float>>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return vertexDescriptor
    }
  
    init(device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
        pipelineState = buildPipelineState(device: device)
    }
    
    init(device: MTLDevice, imageName: String) {
        
        super.init()
        
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = FunctionNames.texturedFragment.rawValue
        }
        
        buildBuffers(device: device)
        pipelineState = buildPipelineState(device: device)
    }
    
    private func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder) {
        
        super.render(commandEncoder: commandEncoder)
        guard let indexBuffer = indexBuffer else { return }

        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.setFragmentTexture(texture, index: 0)
        commandEncoder.drawIndexedPrimitives(type: .triangle,
                                             indexCount: indices.count,
                                             indexType: .uint16, indexBuffer: indexBuffer,
                                             indexBufferOffset: 0)
    }
}
