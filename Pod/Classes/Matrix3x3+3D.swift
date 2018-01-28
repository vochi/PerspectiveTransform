//
//  CATransform3D+float3x3.swift
//  Pods
//
//  Created by Paul Zabelin on 2/21/16.
//
//

import QuartzCore
import simd

extension Matrix3x3Type {
    static let multiplier: Vector3Type = Vector3Type(1, 1, 0)

    static let addColumn : Matrix4x3Type =  {
        var m = Matrix4x3Type(diagonal:multiplier)
        m[3, 2] = 1
        return m
    }()

    static let addRow : Matrix3x4Type =  {
        var m = Matrix3x4Type(diagonal:multiplier)
        m[2, 3] = 1
        return m
    }()

    func to3d() -> Matrix4x4Type {
        var stretch = Matrix3x3Type.addRow * self * Matrix3x3Type.addColumn
        stretch[2, 2] = 1
        return stretch
    }

    func zNormalized() -> Matrix3x3Type {
        return zNormalizedUnsafe()
    }

    func homogeneousInverse() -> Matrix3x3Type {
        return inverse.zNormalizedSafe()
    }

    private func zNormalizedUnsafe() -> Matrix3x3Type {
        return (ScalarType(1) / normalizationFactor()) * self
    }

    private func normalizationFactor() -> ScalarType {
        return self[2,2]
    }

    private func zNormalizedSafe() -> Matrix3x3Type {
        return normalizationFactor() == 0 ? self : zNormalizedUnsafe()
    }

    func adjugate()-> Matrix3x3Type {
        let c1 = self[0]
        let c2 = self[1]
        let c3 = self[2]
        return Matrix3x3Type([cross(c2, c3), cross(c3, c1), cross(c1, c2)]).transpose
    }
}
