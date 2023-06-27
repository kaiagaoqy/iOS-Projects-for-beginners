//
//  ViewController.swift
//  raybreak
//
//  Created by Kaia Gao on 6/26/23.
//

import UIKit
import MetalKit // Access to MetalKit Framework to deal with graphs using GPU


enum Colors{
    static let wenderlinchGreen = MTLClearColor(red: 0.0, green: 0.4, blue: 0.21, alpha: 1.0)
}
class ViewController: UIViewController {
    // Creat a view variable to access the view clarified in Main Storyboard
    var metalView: MTKView{ // Type annotation--> var variableName: <data type> = <optional initial value>
        return view as! MTKView // Computed Property: Run the closure everytime access the property
    }
    var renderer:Renderer!
    var device: MTLDevice!
    
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // VC is a delegate to MTKView
        //        metalView.delegate = self
        
        // Only one device and command queue per application
        metalView.device = MTLCreateSystemDefaultDevice()
        device = metalView.device //The device object the view uses to create its Metal objects.
        metalView.clearColor = Colors.wenderlinchGreen
        
        // Configure the renderer to draw to the view
        renderer = Renderer(device: device)
        renderer.draw(in: metalView)
        
        
    }
    
}
