#include <metal_stdlib>

using namespace metal;

#include <SceneKit/scn_metal>


float rand(float2 n) {
    return fract(sin(dot(n, float2(12.9898, 78.233))) * 43758.5453);
}

//float noise(float p) {
//    float fl = floor(p);
//    float fc = fract(p);
//    return mix(rand(fl), rand(fl + 1.0), fc);
//}
//
//float noise(float2 n) {
//    const float2 d = float2(0.0, 1.0);
//    float2 b = floor(n);
//    float2 f = smoothstep(float2(0.0), float2(1.0), fract(n));
//    //float a = b.x + d.yx
//    return mix(mix(rand(b.x), rand(b.x + d.yx), f.x), mix(rand(b.y + d.xy), rand(b.y + d.yy), f.x), f.y);
//}

float noise(float2 p, float freq) {
    //p.x +=  * 0.1; // Adjust the time scaling factor as needed
    float screenWidth = .7;
    float unit = screenWidth / freq;
    float2 ij = floor(p / unit);
    float2 xy = (p / unit) - (ij * unit);
    //xy = 3.*xy*xy-2.*xy*xy*xy;
    xy = 0.5 * (1.0 - cos(float(3.14159265358979323846264338327950288) * xy));
    float a = rand(ij);
    float b = rand(ij + float2(1.0, 0.0));
    float c = rand(ij + float2(0.0, 1.0));
    float d = rand(ij + float2(1.0, 1.0));
    float x1 = mix(a, b, xy.x);
    float x2 = mix(c, d, xy.x);
    return mix(x1, x2, xy.y);
}

// "Referenced" perlin noise from here https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83
float pNoise(float2 p, int res) {
    float persistance = 0.5;
    float n = 0.0;
    float normK = 0.0;
    float f = 4.0;
    float amp = 1.0;
    int iCount = 0;
    for (int i = 0; i < 50; i++) {
        n += amp * noise(p, f);
        f *= 2.0;
        normK += amp;
        amp *= persistance;
        if (iCount == res) break;
        iCount++;
    }
    float nf = n / normK;
    return nf * nf * nf * nf;
}

struct MyNodeBuffer {
    float4x4 modelTransform;
    float4x4 modelViewTransform;
    float4x4 normalTransform;
    float4x4 modelViewProjectionTransform;
};

struct SimpleVertex
{
    float4 position [[position]];
    float3 normal;
    float2 texCoords;
};


typedef struct VertexIn {
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float3 normal [[ attribute(SCNVertexSemanticNormal)]];
    float2 texCoords [[ attribute(SCNVertexSemanticTexcoord0) ]];
} MyVertexInput;

vertex SimpleVertex cloudVertex(MyVertexInput in [[ stage_in ]],
                                constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                                constant MyNodeBuffer& scn_node [[buffer(1)]],
                                texture2d<float, access::sample> noiseTexture [[ texture(1) ]])
{
    SimpleVertex vert;

    // Get the texture coordinates
//    float2 texCoords = in.texCoords;
//    
//    // Sample the noise texture at the current texture coordinates
//    float noiseValue = pNoise(in.texCoords, 4);
//    
//    
//    // Define the displacement direction based on the normal vector and noise value
//    float3 displacementDirection = in.normal * noiseValue * 10;
//    
//    // Displace the vertex position along the displacement direction
//    vert.position = scn_node.modelViewProjectionTransform * float4(in.position + displacementDirection, 1.0);
//    
//    // Pass through texture coordinates
//    vert.texCoords = texCoords;
    
    /// ONE PIECE
    // Pass through vertex position
    vert.position = scn_node.modelViewProjectionTransform * float4(in.position, 1.0);
    vert.texCoords = in.texCoords;
    
    return vert;
}


fragment half4 cloudFragment(SimpleVertex in [[stage_in]],
                          texture2d<float, access::sample> diffuseTexture [[texture(0)]])
{
    constexpr sampler sampler2d(coord::normalized, filter::linear, address::repeat);
    float4 color = diffuseTexture.sample(sampler2d, in.texCoords);
    
//    float noiseValue = pNoise(in.texCoords, 4);
//    float intensity = noiseValue;
//    
//    float4 color = float4(intensity, intensity, intensity, 1.0);
    
    color.a = 0.5;
    return half4(color);
    
}
