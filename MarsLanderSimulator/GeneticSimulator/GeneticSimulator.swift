//
//  GeneticSimulator.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import Foundation

let gravity = CGVector(dx: 0, dy: -3.711)

class GeneticSimulator {
    private var evaluator : GeneticEvaluator
    
    var surface : MarsSurface
    var initialPosition : LanderPosition
    
    init(surface: MarsSurface, initialPosition: LanderPosition) {
        self.surface = surface
        self.initialPosition = initialPosition
        
        evaluator = GeneticEvaluator(surface: surface)
    }
    
    func simulateAll(landers: [Lander]) -> Bool {
        for lander in landers {
            if simulateTrajectory(lander: lander, initialPosition: initialPosition) == LanderState.Landed {
                return true
            }
        }
        
        return false
    }
    
    func simulateTrajectory(lander: Lander, initialPosition: LanderPosition) -> LanderState {
        lander.trajectory = []
        lander.trajectory.append(initialPosition)
        
        var currentPosition = initialPosition
        
        for controlInput in lander.controlInputs {
            let nextPosition = simulateStep(currentPosition: currentPosition, controlInput: controlInput)
            
            var intersectionPoint : CGPoint = CGPoint()
            lander.state = getLanderState(prev: currentPosition, next: nextPosition, intersectionPoint: &intersectionPoint)

            if lander.state == LanderState.Crashed || lander.state == LanderState.Landed {
                nextPosition.position = intersectionPoint
            }

            lander.trajectory.append(nextPosition)
            
            if lander.state != LanderState.InFlight {
                break
            }
            
            currentPosition = nextPosition
        }
        
        return lander.state
    }
    
    func simulateStep(currentPosition: LanderPosition, controlInput: LanderControlInput) -> LanderPosition {
        let velocity = currentPosition.velocity
        
        let endRotation = calculateValidRotation(current: currentPosition.rotate, requested: currentPosition.rotate + controlInput.rotate)
        let endPower = calculateValidPower(current: currentPosition.power, requested: currentPosition.power + controlInput.power)
        
        let endThrust = (CGVector(dx: 0, dy: 1) * Double(endPower)).rotateD(angleInDegrees: endRotation)
        
        let acceleration = endThrust + gravity
        
        let endVelocity = velocity + acceleration
        
        let endPosition = currentPosition.position + velocity + acceleration * 0.5
        
        return LanderPosition(
            position: endPosition,
            velocity: endVelocity,
            fuel: currentPosition.fuel - endPower,
            rotate: endRotation,
            power: endPower
        )
    }
    
    func getLanderState(prev: LanderPosition, next: LanderPosition, intersectionPoint: inout CGPoint) -> LanderState {
        if next.fuel < 0 {
            return LanderState.OutOfFuel
        }
        
        for segment in surface.surfaceSegments {
            
            if segment.intersect(p1: prev.position, p2: next.position, intersectionPoint: &intersectionPoint) {
                if segment.isFlat && abs(prev.rotate) <= 15 && abs(prev.velocity.dy) <= 40 && abs(prev.velocity.dx) <= 20 {
                    return LanderState.Landed
                }
                
                return LanderState.Crashed
            }
        }
        
        if next.position.x > surface.surfacePoints.last!.x || next.position.x < surface.surfacePoints.first!.x {
            return LanderState.Lost
        }
        
        return LanderState.InFlight
    }
}

func calculateValidPower(current: Int, requested: Int) -> Int {
    var endPower = current
    if requested > current && current < 4 {
        endPower = current + 1
    }
    else if requested < current && current > 0 {
        endPower = current - 1
    }
    
    return endPower
}

func calculateValidRotation(current: Double, requested: Double) -> Double {
    let rotateUpperLimit = current + 15.0 >= 90.0 ? 90.0 : current + 15.0
    let rotateLowerLimit = current - 15.0 <= -90.0 ? -90.0 : current - 15.0
    
    return requested > rotateUpperLimit ? rotateUpperLimit : (requested < rotateLowerLimit ? rotateLowerLimit : requested)
}
