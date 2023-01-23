//
//  Node.swift
//  MetalShader
//
//  Created by Alexander Senin on 23.01.2023.
//

import MetalKit

class Node {
    
    var name = ""
    var children: [Node] = []
  
    func add(childNode: Node) {
        children.append(childNode)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder) {
        for child in children {
            child.render(commandEncoder: commandEncoder)
        }
    }
}
