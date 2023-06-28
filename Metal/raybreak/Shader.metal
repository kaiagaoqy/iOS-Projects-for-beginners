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


//MARK: Vertex Function
// Return float
// vertexID: the vertex being processed by GPU
vertex float4 vertex_shader(const device packed_float3 *vertices [[buffer(0)]],
                            constant Constants &constants [[buffer(1)]],//data is in constant space(not device space), Type of property is Constants, the name of variable is constants
                            uint vertexId[[ vertex_id]]){ // Get Vertex value use the vertextID
    float4 position = float4(vertices[vertexId],1);
    position.x += constants.animateBy;
    return position;
//    return float4(vertices[vertexId],1);
}

// GPU will then assemble vertices into triangle primitives and rasterize triangles into fragments

//MARK: Fragment Function -> Fill in Color
fragment half4 fragment_shader(){
    return half4(1,1,0,1); // RGBA
}
