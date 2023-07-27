//
//  MarsSurface.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 27..
//

import Foundation

struct MarsSurface : Codable, Identifiable {
    var id: Int
    
    var surfacePoints : [CGPoint]
    
    var surfaceSegments : [MarsSurfaceSegment]
    
    init(id: Int, surfacePoints: [CGPoint]) {
        self.id = id
        self.surfacePoints = surfacePoints
        
        var segments = [MarsSurfaceSegment]()
        for i in surfacePoints.indices.dropLast(1) {
            segments.append(MarsSurfaceSegment(startPoint: surfacePoints[i], endPoint: surfacePoints[i+1]))
        }
        surfaceSegments = segments
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let _id = try container.decode(Int.self, forKey: .id)
        let _surfacePoints = try container.decode([CGPoint].self, forKey: .surfacePoints)
        
        self.init(id: _id, surfacePoints: _surfacePoints)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, surfacePoints
    }
}

struct MarsSurfaceSegment : Codable {
    var startPoint : CGPoint
    var endPoint : CGPoint
    
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
}
