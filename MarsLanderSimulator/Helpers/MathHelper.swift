//
//  MathHelper.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import Foundation

func degreeToRadian(degree: Double) -> Double {
    return degree * Double.pi / 180.0
}

func sinD(angleInDegrees: Double) -> Double {
    return sin(degreeToRadian(degree: angleInDegrees))
}

func cosD(angleInDegrees: Double) -> Double {
    return cos(degreeToRadian(degree: angleInDegrees))
}

extension CGVector {
    func rotateD(angleInDegrees: Double) -> CGVector {
        return CGVector(
            dx: dx * cosD(angleInDegrees: angleInDegrees) - dy * sinD(angleInDegrees: angleInDegrees),
            dy: dx * sinD(angleInDegrees: angleInDegrees) + dy * cosD(angleInDegrees: angleInDegrees)
        )
    }
}

func *(lhs: CGVector, rhs: Double) -> CGVector {
    return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
}

func +(lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

func +(lhs: CGPoint, rhs: CGVector) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
}
