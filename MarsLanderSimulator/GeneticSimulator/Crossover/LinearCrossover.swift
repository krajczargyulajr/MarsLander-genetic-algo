//
//  LinearCrossover.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 31..
//

import Foundation

class LinearCrossover : Crossover {
    func crossover(parent1: Lander, parent2: Lander) -> Lander {
        let offspring = Lander()
        
        let alpha = [0.5, 1.5, -0.5]
        let beta = [0.5, -0.5, 1.5]
        
        let crossoverGeneIndex = Int.random(in: 0..<parent1.controlInputs.count)
        
        let crossoverGeneValue1Rotate = parent1.controlInputs[crossoverGeneIndex].rotate
        let crossoverGeneValue2Rotate = parent2.controlInputs[crossoverGeneIndex].rotate
        
        let o1kr = alpha[0] * crossoverGeneValue1Rotate + beta[0] * crossoverGeneValue2Rotate
        let o2kr = alpha[1] * crossoverGeneValue1Rotate + beta[1] * crossoverGeneValue2Rotate
        let o3kr = alpha[2] * crossoverGeneValue1Rotate + beta[2] * crossoverGeneValue2Rotate
        
        let crossoverGeneValue1Power = parent1.controlInputs[crossoverGeneIndex].power
        let crossoverGeneValue2Power = parent2.controlInputs[crossoverGeneIndex].power
        
        let o1kp = alpha[0] * Double(crossoverGeneValue1Power) + beta[0] * Double(crossoverGeneValue2Power)
        let o2kp = alpha[1] * Double(crossoverGeneValue1Power) + beta[1] * Double(crossoverGeneValue2Power)
        let o3kp = alpha[2] * Double(crossoverGeneValue1Power) + beta[2] * Double(crossoverGeneValue2Power)
        
        return offspring
    }
}
