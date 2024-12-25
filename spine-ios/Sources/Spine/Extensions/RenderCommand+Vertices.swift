import SpineShadersStructs
import Foundation
import simd

struct SpineVertexHigh {
    var position: SIMD2<Float>  // 2D 位置向量
    var color: SIMD4<Float>     // RGBA 颜色向量
    var uv: SIMD2<Float>        // 纹理坐标向量
}

extension RenderCommand {
    func getVertices() -> [SpineVertexHigh] {
        var vertices = [SpineVertexHigh]()

        let indices = indices
        let numVertices = numVertices
        let positions = positions(numVertices: numVertices)
        let uvs = uvs(numVertices: numVertices)
        let colors = colors(numVertices: numVertices)
        vertices.reserveCapacity(indices.count)
        for i in 0..<indices.count {
            let index = Int(indices[i])
            
            let xIndex = 2 * index
            let yIndex = xIndex + 1
            
            // 使用 SIMD2<Float> 来读取和存储位置和 UV 坐标
            let position = SIMD2<Float>(positions[xIndex], positions[yIndex])
            let uv = SIMD2<Float>(uvs[xIndex], uvs[yIndex])

            // 提取颜色并将其转换为 SIMD4<Float>
            let color = extractRGBA(from: colors[index]) // 需要确保这个函数返回 SIMD4<Float>

            let vertex = SpineVertexHigh(
                position: position,
                color: color,
                uv: uv
            )
            vertices.append(vertex)
        }
        
        return vertices
    }
    
    private func extractRGBA(from color: Int32) -> SIMD4<Float> {
        guard color != -1 else {
            return SIMD4<Float>(1.0, 1.0, 1.0, 1.0)
        }
        let alpha = Float((color >> 24) & 0xFF) / 255.0
        let red = Float((color >> 16) & 0xFF) / 255.0
        let green = Float((color >> 8) & 0xFF) / 255.0
        let blue = Float(color & 0xFF) / 255.0
        return SIMD4<Float>(red, green, blue, alpha)
    }
}
