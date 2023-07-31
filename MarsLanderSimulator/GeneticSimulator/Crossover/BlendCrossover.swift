//
//  BlendCrossover.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 31..
//

import Foundation

class BlendCrossover : Crossover {
    func crossover(parent1: Lander, parent2: Lander) -> [Lander] {
        let offspring1 = blendLanders(parent1: parent1, parent2: parent2)
        let offspring2 = blendLanders(parent1: parent2, parent2: parent1)
        
        return [offspring1, offspring2]
    }
    
    func blendLanders(parent1: Lander, parent2: Lander) -> Lander {
        let child = Lander()
        
        for i in parent1.controlInputs.indices {
            let blendingRandom = Double.random(in: 0...1)
            
            let gene1 = parent1.controlInputs[i]
            let gene2 = parent2.controlInputs[i]
            
            let blendedRotate = blendingRandom * gene1.rotate + (1 - blendingRandom) * gene2.rotate
            let newPower1 = blendingRandom * Double(gene1.power)
            let newPower2 = (1 - blendingRandom) * Double(gene2.power)
            let blendedPower = round(newPower1 + newPower2)
            
            child.controlInputs.append(LanderControlInput(
                rotate: blendedRotate,
                power: Int(blendedPower)
            ))
        }
        
        return child
    }
}
