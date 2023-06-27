//
//  Renderer.swift
//  raybreak
//
//  Created by Kaia Gao on 6/27/23.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    
    
    //MARK: - Properties -
    var vertices: [Float] = [
        0, 1, 0,
        -1, -1, 0,
        1, -1, 0
    ]
    
    
    //MARK: - Init -
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()!
        super.init()
        buildModel()
        buildPipeLineState()
    }
    
    
    //MARK: - Methods -
    // Create a metal buffer to hold properties (vertices from array)
    private func buildModel() {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Float>.size, // each entry is float 
                                         options: [])
    }
    
    private func buildPipeLineState() {
        let library = device.makeDefaultLibrary() // All shader functions will be stored in a library
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        // Descriptor has reference to shader functions for the specific object
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            NSLog("""
        Something happened:
        \(error)
        
        \(error.localizedDescription)
        """)
        }
    }
    
}


extension Renderer: MTKViewDelegate {
    // Called when drawable size change, like rotating the device
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, // an object used every frame
              let pipelineState = pipelineState, // unwrap pipeline state
              let descriptor = view.currentRenderPassDescriptor else {
            return
        }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            NSLog("Could not instantiate Metal command buffer.")
            return
        }
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            NSLog("Could not instantiate Metal command encoder.")
            return
        }
        
        commandEncoder.setRenderPipelineState(pipelineState) // Set the pipeline state for command encoder
        commandEncoder.setVertexBuffer(vertexBuffer,
                                        offset: 0, // where the data begin
                                        index: 0) // set vertex buffer at index 0
        commandEncoder.drawPrimitives(type: .triangle, //render an instance of primitives using contiguous vertices
                                       vertexStart: 0,
                                       vertexCount: vertices.count)
        commandEncoder.endEncoding()
        commandBuffer.present(drawable) // Register a drawable presentation
        commandBuffer.commit() // It will not draw the instance until 'commit' the command buffer to GPU for execution
    }
}
