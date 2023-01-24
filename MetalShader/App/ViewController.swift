//
//  ViewController.swift
//  MetalShader
//
//  Created by Alexander Senin on 23.01.2023.
//

import MetalKit

enum Colors {
    static let black = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let beige = MTLClearColor(red: 0.82, green: 0.69, blue: 0.52, alpha: 1)
}

class ViewController: UIViewController {

    var metalView: MTKView {
        return view as! MTKView
    }
    
    var renderer: Renderer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        metalView.device = MTLCreateSystemDefaultDevice()
        
        guard let device = metalView.device else {
            fatalError("Device not created. Run on a physical device")
        }
        
        renderer = Renderer(device: device)
        renderer?.scene = MainScene(device: device, size: view.bounds.size)
        
        metalView.clearColor = Colors.beige
        metalView.depthStencilPixelFormat = .depth32Float
        metalView.delegate = renderer
    }
}
