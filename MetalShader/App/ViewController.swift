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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView.device = MTLCreateSystemDefaultDevice()
        
        guard let device = metalView.device else {
            fatalError("Device not created. Run on a physical device")
        }
        
        metalView.clearColor = Colors.black
    }
}
