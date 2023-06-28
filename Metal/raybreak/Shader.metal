//
//  Shader.metal
//  raybreak
//
//  Created by Kaia Gao on 6/26/23.
//

#include <metal_stdlib>
using namespace metal;

struct Constants{
    float animateBy;
};

struct VertexIn{
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut{
    float4 position [[position]];
    float4 color;
};

//MARK: Vertex Function -- to position vertices in 3D space
// Use an array of float in buffer 0, then calculate the new positions of the vertex
// Return float to "primitive assembler" stage
// vertexID: the vertex being processed by GPU
vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]]){
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    return vertexOut;
}

// GPU will then assemble vertices into triangle primitives and rasterize triangles into fragments

//MARK: Fragment Function -> Fill in Color
fragment half4 fragment_shader(const VertexOut vertexIn [[stage_in]]){ // Generate Per fragment
    return half4(vertexIn.color); // RGBA
}
