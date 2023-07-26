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

func intersect(p1: CGPoint, p2: CGPoint, q1: CGPoint, q2: CGPoint, intersectionPoint: inout CGPoint) -> Bool {
    let A1 = p2.y - p1.y
    let B1 = p1.x - p2.x
    let C1 = A1 * p1.x + B1 * p1.y

    let A2 = q2.y - q1.y
    let B2 = q1.x - q2.x
    let C2 = A2 * q1.x + B2 * q1.y

    let determinant = A1 * B2 - A2 * B1
    if determinant != 0 {
        let x = (B2 * C1 - B1 * C2) / determinant
        let y = (A1 * C2 - A2 * C1) / determinant

        if x >= min(p1.x, p2.x) && x <= max(p1.x, p2.x) && y >= min(p1.y, p2.y) && y <= max(p1.y, p2.y)
            && x >= min(q1.x, q2.x) && x <= max(q1.x, q2.x) && y >= min(q1.y, q2.y) && y <= max(q1.y, q2.y)
        {
            // correct
            intersectionPoint = CGPoint(x: x, y: y)
            return true
        }
    }

    // parallel
    intersectionPoint = CGPoint(x: 0, y: 0)
    return false
}
