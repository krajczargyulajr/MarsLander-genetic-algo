//
//  GeneticEvaluator.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import Foundation

class GeneticEvaluator {
    var surface : MarsSurface
    
    private var flatSegmentIndex : Int
    private var flatSegmentCenter : CGPoint
    
    init(surface: MarsSurface) {
        self.surface = surface
        
        var flatSegmentCenter : CGPoint = CGPoint()
        self.flatSegmentIndex = surface.findFlatSegment(flatSegmentCenter: &flatSegmentCenter)
        self.flatSegmentCenter = flatSegmentCenter
    }

    func evaluateLastPositions(lander : Lander) -> Double {
        let last = lander.trajectory.last!
        
        let x_diff = abs(surface.surfacePoints[flatSegmentIndex].x - last.position.x)
        let y_diff = abs(surface.surfacePoints[flatSegmentIndex].y - last.position.y)
        
        switch lander.state {
        case .InFlight, .OutOfFuel, .Lost:
            return x_diff + y_diff
        case .Crashed:
            return x_diff
        case .Landed:
            return 0.0
        }
    }
}

extension MarsSurface {
    func findFlatSegment(flatSegmentCenter : inout CGPoint) -> Int
    {
        for j in 0..<surfacePoints.count-1 {
            let surfaceSegment1 = surfacePoints[j]
            let surfaceSegment2 = surfacePoints[j + 1]
            
            if (surfaceSegment1.y == surfaceSegment2.y)
            {
                flatSegmentCenter = CGPoint(x: (surfaceSegment1.x + surfaceSegment2.x) / 2, y: surfaceSegment1.y)
                return j
            }
        }
        flatSegmentCenter = CGPoint(x: 0, y: 0)
        return -1
    }
}
