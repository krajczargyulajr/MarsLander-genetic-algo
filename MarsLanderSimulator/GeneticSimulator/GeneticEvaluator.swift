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
    
    func evaluateLastPositions(lander: Lander) -> Double {
        let last = lander.trajectory.last!
        let landingZone = surface.flatSegment
        
        var score : Double = 0.0
        
        if lander.state == LanderState.Crashed && last.position.x >= landingZone.startPoint.x && last.position.x <= landingZone.endPoint.x {
            score = (abs(last.velocity.dx) / 250 + abs(last.velocity.dy) / 250)
        } else {
            let targetPoint = landingZone.midpoint()
            
            let x_diff = abs(targetPoint.x - last.position.x)
            let y_diff = abs(targetPoint.y - last.position.y)
            
            let distanceToTargetPenalty = sqrt(pow(x_diff, 2) + pow(y_diff, 2)) / 100.0
            let velocityPenalty = sqrt(pow(last.velocity.dx, 2) + pow(last.velocity.dy, 2)) / 175.0
            
            score = (distanceToTargetPenalty + velocityPenalty)
        }
        
        return score
    }
    
    func evaluateLastPositions2(lander : Lander) -> Double {
        let last = lander.trajectory.last!
        
        // check if landing point has line of sight to last position
        var segmentIntersectCount : Int = 0
        for surfaceSegment in surface.surfaceSegments {
            var intersectionPoint : CGPoint = CGPoint()
            if surfaceSegment.intersect(p1: last.position, p2: surface.flatSegment.midpoint(), intersectionPoint: &intersectionPoint) {
                segmentIntersectCount += 1
                break
            }
        }
        
        let lineOfSightPenalty : Double = segmentIntersectCount > 1 ? 20000.0 : 0.0
        
        let x = last.position.x
        
        var x_diff : Double = 0.0
        if x < surface.flatSegment.startPoint.x {
            x_diff = abs(surface.flatSegment.startPoint.x - x)
        }
        else if x > surface.flatSegment.endPoint.x {
            x_diff = abs(surface.flatSegment.endPoint.x - x)
        }
        
        let y_diff = abs(surface.flatSegment.startPoint.y - last.position.y)
//
//        let hSpeedDiff : Double = 20.0 - abs(last.velocity.dx)
//        let vSpeedDiff : Double = 40.0 - abs(last.velocity.dy)
//        let rotateDiff : Double = abs(last.rotate)
//
        var prop_diff : Double = 0.0
        // if x_diff == 0.0 && y_diff == 0.0 {
            // prev.rotate == 0 && prev.velocity.dy <= 40 && prev.velocity.dx <= 20
            prop_diff += abs(15.0 - abs(last.rotate))
            prop_diff += abs(40.0 - abs(last.velocity.dy))
            prop_diff += abs(20.0 - abs(last.velocity.dx))
        // }
        
        switch lander.state {
        case .Landed:
            return 1.0
        default:
            return sqrt(pow(x_diff, 2) + pow(y_diff, 2)) + prop_diff + lineOfSightPenalty
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
