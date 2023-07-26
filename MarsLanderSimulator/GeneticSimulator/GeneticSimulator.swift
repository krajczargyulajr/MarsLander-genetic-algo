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
    
    init(surface: MarsSurface) {
        evaluator = GeneticEvaluator(surface: surface)
    }
    
    func simulateLanderMovement(lander: inout Lander, initialPosition: LanderPosition) {
        lander.trajectory.append(initialPosition)
        
        var currentPosition = initialPosition
        
        for controlInput in lander.controlInputs {
            let nextPosition = simulateStep(currentPosition: currentPosition, controlInput: controlInput)
            
            lander.trajectory.append(nextPosition)
            
            lander.state = evaluator.getLanderState(prev: currentPosition, next: nextPosition)
            
            if lander.state != LanderState.InFlight {
                break
            }
            
            currentPosition = nextPosition
        }
        
        lander.trajectoryScore = evaluator.evaluateLastPositions(lander: lander)
    }
    
    func simulateStep(currentPosition: LanderPosition, controlInput: LanderControlInput) -> LanderPosition {
        let velocity = currentPosition.velocity
        
        let endRotation = calculateValidRotation(current: currentPosition.rotate, requested: controlInput.rotate)
        let endPower = calculateValidPower(current: currentPosition.power, requested: controlInput.power)
        
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
