#ifndef SpineShadersStructs_h
#define SpineShadersStructs_h

#include <simd/simd.h>

typedef enum SpineVertexInputIndex {
    SpineVertexInputIndexVertices     = 0,
    SpineVertexInputIndexTransform    = 1,
    SpineVertexInputIndexViewportSize = 2,
} SpineVertexInputIndex;

typedef enum SpineTextureIndex {
    SpineTextureIndexBaseColor = 0,
} SpineTextureIndex;

typedef struct {
    simd_float2 position;  // 使用两个 float 的数组来模拟 SIMD2<Float>
    simd_float4 color;     // 使用四个 float 的数组来模拟 SIMD4<Float>
    simd_float2 uv;        // 使用两个 float 的数组来模拟 SIMD2<Float>
} SpineVertex;

typedef struct {
    vector_float2 translation;
    vector_float2 scale;
    vector_float2 offset;
} SpineTransform;

#endif /* SpineShadersStructs_h */
