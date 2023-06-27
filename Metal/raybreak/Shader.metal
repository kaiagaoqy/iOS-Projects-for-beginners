//
//  Shader.metal
//  raybreak
//
//  Created by Kaia Gao on 6/26/23.
//

#include <metal_stdlib>
using namespace metal;

//MARK: Vertex Function
// Return float
// vertexID: the vertex being processed by GPU
vertex float4 vertex_shader(const device packed_float3 *vertices [[buffer(0)]],
                            uint vertexId[[ vertex_id]]){
    return float4(vertices[vertexId],1);
}

// GPU will then assemble vertices into triangle primitives and rasterize triangles into fragments

//MARK: Fragment Function -> Fill in Color
fragment half4 fragment_shader(){
    return half4(1,0,0,1); // RGBA
}
