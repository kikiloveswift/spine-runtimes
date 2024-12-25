#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

typedef enum SpineVertexInputIndex {
    SpineVertexInputIndexVertices     = 0,
    SpineVertexInputIndexTransform    = 1,
    SpineVertexInputIndexViewportSize = 2,
} SpineVertexInputIndex;

typedef enum SpineTextureIndex {
    SpineTextureIndexBaseColor = 0,
} SpineTextureIndex;

typedef struct {
    simd_float2 position;
    simd_float4 color;
    simd_float2 uv;
} SpineVertex;

typedef struct {
    vector_float2 translation;
    vector_float2 scale;
    vector_float2 offset;
} SpineTransform;

struct RasterizerData {
    float4 position [[position]];
    half4 color;
    half2 textureCoordinate;
};

vertex RasterizerData
vertexShaderLow(uint vertexID [[vertex_id]],
             constant SpineVertex *vertices [[buffer(SpineVertexInputIndexVertices)]],
             constant SpineTransform *transform [[buffer(SpineVertexInputIndexTransform)]],
             constant vector_uint2 *viewportSizePointer [[buffer(SpineVertexInputIndexViewportSize)]])
{
    RasterizerData out;

    float2 pixelSpacePosition = vertices[vertexID].position.xy;

    vector_float2 viewportSize = vector_float2(*viewportSizePointer);

    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);

    out.position.xy = pixelSpacePosition;
    out.position.xy *= transform->scale;
    out.position.xy += transform->translation * transform->scale + transform->offset;
    out.position.xy /= viewportSize / 2;
    out.position.y *= -1;

    out.color = half4(vertices[vertexID].color);

    out.textureCoordinate = half2(vertices[vertexID].uv);

    return out;
}

fragment half4
fragmentShaderLow(RasterizerData in [[stage_in]],
               texture2d<half> colorTexture [[ texture(SpineTextureIndexBaseColor) ]])
{
    constexpr sampler textureSampler (mag_filter::nearest,
                                      min_filter::nearest);

    const half4 colorSample = colorTexture.sample(textureSampler, float2(in.textureCoordinate));

    return colorSample * in.color;
}

