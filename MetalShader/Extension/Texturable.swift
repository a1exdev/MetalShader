//
//  Texturable.swift
//  MetalShader
//
//  Created by Alexander Senin on 23.01.2023.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable {
    
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        
        let textureLoader = MTKTextureLoader(device: device)
        var texture: MTLTexture? = nil
        
        let textureLoaderOptions: [MTKTextureLoader.Option : Any]
        let origin = NSString(string: MTKTextureLoader.Origin.bottomLeft.rawValue)
        textureLoaderOptions = [MTKTextureLoader.Option.origin : origin]
        
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                texture = try textureLoader.newTexture(URL: textureURL, options: textureLoaderOptions)
            } catch let error as NSError {
                fatalError("error: \(error.localizedDescription)")
            }
        }
        return texture
    }
}
