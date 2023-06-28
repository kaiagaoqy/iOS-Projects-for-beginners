//
//  Renderer.swift
//  raybreak
//
//  Created by Kaia Gao on 6/27/23.
//

import Foundation
import MetalKit

class Renderer:NSObject{
    //MARK: Pipeline only initialize once
    let device: MTLDevice!
    let commandQueue: MTLCommandQueue
    var pipelineState: MTLRenderPipelineState?
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    //MARK: Init
    init(device: MTLDevice!) {
        self.device = device
        commandQueue = device.makeCommandQueue()! // no difference with or without 'self'
        super.init()
        buildModel()
        buildPipeLineState() 
    }
    
    //MARK: Properties
    // With index drawing, we need only unique vertices
    var vertices:[Vertex] = [ //Here we use customized type to store features of vertex
        Vertex(position: SIMD3(-1,1,0), // v0
               color: SIMD4(1,0,0,1)),
        Vertex(position: SIMD3(-1,-1,0), // v1
               color: SIMD4(0,1,0,1)),
        Vertex(position: SIMD3(1,-1,0), // v2
               color: SIMD4(0,0,1,1)),
        Vertex(position: SIMD3(1,1,0), // v3
               color: SIMD4(1,0,1,1))
    ]
    
    var indices:[UInt16] = [
        0,1,2,
        2,3,0
    ]
    
    struct Constants{ //Struct is a simple Class
        var animateBy:Float = 0.0;
    }
    
    var constants = Constants()
    var time:Float = 0.0
    
    //MARK: Initialize Buffers
    private func buildModel(){
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Vertex>.size, // each entry is float
                                         options: [])
        indexBuffer = device.makeBuffer(bytes:indices,
                                        length:indices.count * MemoryLayout<UInt16>.size,
                                        options: [])
    }
    
    //MARK: PipelineState to tell GPU use which shader functions
    private func buildPipeLineState() {
        let library = device.makeDefaultLibrary() // All shader functions will be stored in a library
        let vertexFunction = library?.makeFunction(name: "vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "fragment_shader")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        // Descriptor has reference to shader functions for the specific object
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        //MARK: Vertex Descriptor to allign data structure in metal and GPU
        let vertexDescriptor = MTLVertexDescriptor()
        
        // [...[position,color],...]
        // Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0 //both start from 0
        // Color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride // after the position
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        pipelineDescriptor.vertexDescriptor = vertexDescriptor // Assign to pipelinedescriptor
        
        // Create PipelineState from Pipeline Descriptor
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
    // Called every frame to render graphics on screen
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, // an object used every frame
              let pipelineState = pipelineState, // unwrap pipeline state
              let indexBuffer = indexBuffer,
              let descriptor = view.currentRenderPassDescriptor else {
            return
        }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            NSLog("Could not instantiate Metal command buffer.")
            return
        }
        
        //MARK: Add Animation
        time += 1/Float(view.preferredFramesPerSecond)//default = 60 fps
        let animateBy = abs(sin(time)/2+0.5)
        constants.animateBy = animateBy
//        print(animateBy)
        
        
        //MARK: Set up Command Encoder and Store info from Buffer(Models) and PipelineState (Shader funcs)
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            NSLog("Could not instantiate Metal command encoder.")
            return
        }
        
        commandEncoder.setRenderPipelineState(pipelineState) // Set the pipeline state for command encoder
        commandEncoder.setVertexBuffer(vertexBuffer,
                                        offset: 0, // where the data begin
                                        index: 0) // set vertex buffer at index 0
        
        commandEncoder.setVertexBytes(&constants, //Set up a new encoder with new data but bind to vertex Buffer
                                      length: MemoryLayout<Constants>.stride,
                                      index: 1)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle, // Type of primitives
                                             indexCount: indices.count,
                                             indexType: .uint16, 
                                             indexBuffer: indexBuffer, // Retrieve data from indexBuffer
                                             indexBufferOffset: 0) // Start reading indices from 0
        commandEncoder.endEncoding()
        commandBuffer.present(drawable) // Register a drawable presentation
        commandBuffer.commit() // It will not draw the instance until 'commit' the command buffer to GPU for execution
    }
}
