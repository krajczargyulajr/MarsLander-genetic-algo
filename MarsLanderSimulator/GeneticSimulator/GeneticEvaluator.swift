//
//  GeneticEvaluator.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import Foundation

class GeneticEvaluator {
    var surface : MarsSurface
    
    init(surface: MarsSurface) {
        self.surface = surface
    }

    func evaluateAll(landers: [Lander]) {
        for lander in landers {
            let distance = evaluateLastPositions(lander: lander)
            
            if distance == 0 {
                print("Zero distance")
            }
            
            lander.distanceFromTarget = distance
        }
        
        calculateTrajectoryScores(landers: landers)
        normalizeTrajectoryScores(landers: landers)
    }
    
    func evaluateLastPositions(lander : Lander) -> Double {
        let last = lander.trajectory.last!
        
        let x = last.position.x
        
        var x_diff : Double = 0.0
        if x < surface.flatSegment.startPoint.x {
            x_diff = abs(surface.flatSegment.startPoint.x - x)
        }
        else if x > surface.flatSegment.endPoint.x {
            x_diff = abs(surface.flatSegment.endPoint.x - x)
        }
        
        let y_diff = abs(surface.flatSegment.startPoint.y - last.position.y)
        
        var prop_diff : Double = 0.0
        if x_diff == 0.0 && y_diff == 0.0 {
            // prev.rotate == 0 && prev.velocity.dy <= 40 && prev.velocity.dx <= 20
            prop_diff += abs(last.rotate)
            prop_diff += 40 - last.velocity.dy
            prop_diff += 20 - last.velocity.dx
        }
        
        switch lander.state {
        case .Landed:
            return 1.0
        default:
            return sqrt(pow(x_diff, 2) + pow(y_diff, 2)) + prop_diff
        }
    }
    
    func calculateTrajectoryScores(landers: [Lander]) {
        let maxDistance = landers.max { a,b in a.distanceFromTarget < b.distanceFromTarget }!.distanceFromTarget
        
        for lander in landers {
            lander.trajectoryScore = maxDistance - lander.distanceFromTarget
        }
    }
    
    func normalizeTrajectoryScores(landers: [Lander]) {
        let minx = landers.min { a, b in a.trajectoryScore < b.trajectoryScore }!.trajectoryScore
        let maxx = landers.max { a, b in a.trajectoryScore < b.trajectoryScore }!.trajectoryScore
        
        let denominator = maxx - minx
        
        if denominator == 0 {
            for lander in landers {
                lander.normalizedTrajectoryScore = 1.0
            }
        }
        
        for lander in landers {
            let normal = (lander.trajectoryScore - minx) / (maxx - minx)
            
            lander.normalizedTrajectoryScore = normal
        }
    }

}
