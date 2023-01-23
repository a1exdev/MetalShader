//
//  Renderer.swift
//  MetalShader
//
//  Created by Alexander Senin on 23.01.2023.
//

import MetalKit

class Renderer: NSObject {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    
    var scene: Scene?
    
    var samplerState: MTLSamplerState?
    var depthStencilState: MTLDepthStencilState?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()!
        super.init()
        buildSamplerState()
    }
    
    private func buildSamplerState() {
        let descriptor = MTLSamplerDescriptor()
        descriptor.minFilter = .linear
        descriptor.magFilter = .linear
        samplerState = device.makeSamplerState(descriptor: descriptor)
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
  
    func draw(in view: MTKView) {
        
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        commandEncoder?.setFragmentSamplerState(samplerState, index: 0)
        
        scene?.render(commandEncoder: commandEncoder!)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
