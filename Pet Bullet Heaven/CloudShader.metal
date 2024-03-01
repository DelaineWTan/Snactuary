#include <metal_stdlib>

using namespace metal;

#include <SceneKit/scn_metal>


float rand(float2 n) {
    return fract(sin(dot(n, float2(12.9898, 78.233))) * 43758.5453);
}

float noise(float p) {
    float fl = floor(p);
    float fc = fract(p);
    return mix(rand(fl), rand(fl + 1.0), fc);
}

float noise(float2 n) {
    const float2 d = float2(0.0, 1.0);
    float2 b = floor(n);
    float2 f = smoothstep(float2(0.0), float2(1.0), fract(n));
    //float a = b.x + d.yx
    return mix(mix(rand(b.x), rand(b.x + d.yx), f.x), mix(rand(b.y + d.xy), rand(b.y + d.yy), f.x), f.y);
}

struct MyNodeBuffer {
    float4x4 modelTransform;
    float4x4 modelViewTransform;
    float4x4 normalTransform;
    float4x4 modelViewProjectionTransform;
};

typedef struct VertexIn {
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float2 texCoords [[ attribute(SCNVertexSemanticTexcoord0) ]];
} MyVertexInput;

struct SimpleVertex
{
    float4 position [[position]];
    float2 texCoords;
};

vertex SimpleVertex cloudVertex(MyVertexInput in [[ stage_in ]],
                             constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                             constant MyNodeBuffer& scn_node [[buffer(1)]])
{
    SimpleVertex vert;
    vert.position = scn_node.modelViewProjectionTransform * float4(in.position, 1.0);
    vert.texCoords = in.texCoords;

    return vert;
}

fragment half4 cloudFragment(SimpleVertex in [[stage_in]],
                          texture2d<float, access::sample> diffuseTexture [[texture(0)]])
{
    //constexpr sampler sampler2d(coord::normalized, filter::linear, address::repeat);
    //float4 color = diffuseTexture.sample(sampler2d, in.texCoords);
    
    float noiseValue = noise(in.texCoords);
    float intensity = noiseValue;
    
    float4 color = float4(intensity, intensity, intensity, 1.0);
    return half4(color);
}
