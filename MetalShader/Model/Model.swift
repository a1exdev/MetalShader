//
//  Model.swift
//  MetalShader
//
//  Created by Alexander Senin on 23.01.2023.
//

import MetalKit

class Model: Node, Texturable {
    
    var fragmentFunctionName: String = FunctionNames.fragmentShader.rawValue
    var vertexFunctionName: String = FunctionNames.vertexShader.rawValue
    
    var modelConstants = ModelConstants()
    
    var meshes: [AnyObject]?
    
    var texture: MTLTexture?
    
    var pipelineState: MTLRenderPipelineState!
  
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<Float>.stride * 3
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<Float>.stride * 7
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].offset = MemoryLayout<Float>.stride * 9
        vertexDescriptor.attributes[3].bufferIndex = 0

        vertexDescriptor.layouts[0].stride = MemoryLayout<Float>.stride * 12
        
        return vertexDescriptor
    }
  
    init(device: MTLDevice, modelName: String) {
        
        super.init()
        
        name = modelName
        loadModel(device: device, modelName: modelName)
        
        let imageName = modelName + ".jpg"
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
        } else {
            print("Texture named \(modelName).jpg doesn't exist.")
        }
        
        fragmentFunctionName = FunctionNames.texturedFragment.rawValue
        pipelineState = buildPipelineState(device: device)
    }
    
    func loadModel(device: MTLDevice, modelName: String) {
        
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else {
            fatalError("Asset \(modelName) doesn't exist.")
        }
        let descriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        
        let attributePosition = descriptor.attributes[0] as! MDLVertexAttribute
        attributePosition.name = MDLVertexAttributePosition
        descriptor.attributes[0] = attributePosition
        
        let attributeColor = descriptor.attributes[1] as! MDLVertexAttribute
        attributeColor.name = MDLVertexAttributeColor
        descriptor.attributes[1] = attributeColor
        
        let attributeTexture = descriptor.attributes[2] as! MDLVertexAttribute
        attributeTexture.name = MDLVertexAttributeTextureCoordinate
        descriptor.attributes[2] = attributeTexture
        
        let attributeNormal = descriptor.attributes[3] as! MDLVertexAttribute
        attributeNormal.name = MDLVertexAttributeNormal
        descriptor.attributes[3] = attributeNormal
        
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL,
                             vertexDescriptor: descriptor,
                             bufferAllocator: bufferAllocator)
        
        do {
            meshes = try MTKMesh.newMeshes(asset: asset, device: device).metalKitMeshes
        } catch let error as NSError {
            fatalError("error: \(error.localizedDescription)")
        }
    }
}

extension Model: Renderable {
      
    func doRender(commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        
        modelConstants.modelViewMatrix = modelViewMatrix
        commandEncoder.setVertexBytes(&modelConstants,
                                      length: MemoryLayout<ModelConstants>.stride,
                                      index: 1)
        
        if texture != nil {
            commandEncoder.setFragmentTexture(texture, index: 0)
        }
        commandEncoder.setRenderPipelineState(pipelineState)
        
        guard let meshes = meshes as? [MTKMesh], meshes.count > 0 else { return }
        for mesh in meshes {
            let vertexBuffer = mesh.vertexBuffers[0]
            commandEncoder.setVertexBuffer(vertexBuffer.buffer,
                                           offset: vertexBuffer.offset,
                                           index: 0)
            for submesh in mesh.submeshes {
                commandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                     indexCount: submesh.indexCount,
                                                     indexType: submesh.indexType,
                                                     indexBuffer: submesh.indexBuffer.buffer,
                                                     indexBufferOffset: submesh.indexBuffer.offset)
            }
        }
    }
}
