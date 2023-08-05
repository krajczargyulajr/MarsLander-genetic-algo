//
//  BlendCrossover.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 31..
//

import Foundation

class ArithmeticCrossover : Crossover {
    func crossover(parent1: Lander, parent2: Lander) -> Lander {
        let child = Lander()
        child.controlInputs = parent1.controlInputs.map { $0.copy() }
        
        let startIndex = Int.random(in: parent1.controlInputs.indices)
        let endIndex = Int.random(in: startIndex...parent1.controlInputs.count-1)
        
        for i in startIndex...endIndex {
            let alpha = Double.random(in: 0...1)
            
            let gene1 = parent1.controlInputs[i]
            let gene2 = parent2.controlInputs[i]
            
            let blendedRotate = alpha * gene1.rotate + (1 - alpha) * gene2.rotate
            let blendedPower = alpha * Double(gene1.power) + (1 - alpha) * Double(gene2.power)
            
            child.controlInputs[i] = LanderControlInput(
                rotate: blendedRotate,
                power: Int(blendedPower)
            )
        }
        
        return child
    }
}
