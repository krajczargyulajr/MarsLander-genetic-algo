//
//  MarsSurface.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 27..
//

import Foundation

class MarsSurface : Codable, Identifiable {
    var id: Int
    
    var surfacePoints : [CGPoint]
    
    var surfaceSegments : [MarsSurfaceSegment]
    
    var flatSegment : MarsSurfaceSegment = MarsSurfaceSegment(startPoint: CGPoint(), endPoint:CGPoint())
    
    init(id: Int, surfacePoints: [CGPoint]) {
        self.id = id
        self.surfacePoints = surfacePoints
        
        surfaceSegments = MarsSurface.setupSegments(surfacePoints: surfacePoints, flatSegment: &self.flatSegment)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let _id = try container.decode(Int.self, forKey: .id)
        let _surfacePoints = try container.decode([CGPoint].self, forKey: .surfacePoints)
        
        self.id = _id
        self.surfacePoints = _surfacePoints
        
        self.surfaceSegments = MarsSurface.setupSegments(surfacePoints: surfacePoints, flatSegment: &self.flatSegment)
    }
    
    static func setupSegments(surfacePoints: [CGPoint], flatSegment: inout MarsSurfaceSegment) -> [MarsSurfaceSegment] {
        var segments = [MarsSurfaceSegment]()
        for i in surfacePoints.indices.dropLast(1) {
            let segment = MarsSurfaceSegment(startPoint: surfacePoints[i], endPoint: surfacePoints[i+1])
            segments.append(segment)
            
            if segment.isFlat {
                flatSegment = segment
            }
        }
        
        return segments
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, surfacePoints
    }
}

class MarsSurfaceSegment : Codable {
    var startPoint : CGPoint
    var endPoint : CGPoint
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    var isFlat : Bool {
        return startPoint.y == endPoint.y
    }
    
    func intersect(p1: CGPoint, p2: CGPoint,intersectionPoint: inout CGPoint) -> Bool {
        let q1 = startPoint;
        let q2 = endPoint;
        
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

            if isInInterval(x0: x, x1: p1.x, x2: p2.x) && isInInterval(x0: y, x1: p1.y, x2: p2.y)
                && isInInterval(x0: x, x1: q1.x, x2: q2.x) && isInInterval(x0: y, x1: q1.y, x2: q2.y)
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
}
