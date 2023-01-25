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
    
    var device: MTLDevice {
        let device = MTLCreateSystemDefaultDevice()
        return device!
    }
    
    lazy var renderer = Renderer(device: device)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRenderer()
        configureView()
    }
    
    private func configureRenderer() {
        renderer.scene = MainScene(device: device, size: view.bounds.size)
    }
    
    private func configureView() {
        metalView.device = device
        metalView.delegate = renderer
        metalView.depthStencilPixelFormat = .depth32Float
        metalView.clearColor = Colors.beige
    }
}
