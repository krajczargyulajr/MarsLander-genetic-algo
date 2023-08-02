//
//  UniformCrossover.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 08. 02..
//

import Foundation

class UniformCrossover : Crossover {
    func crossover(parent1: Lander, parent2: Lander) -> [Lander] {
        let child1 = Lander()
        let child2 = Lander()
        
        for i in parent1.controlInputs.indices {
            let parentGene1 = parent1.controlInputs[i]
            let parentGene2 = parent2.controlInputs[i]
            
            let toss = Int.random(in: 0...1)
            
            if toss == 1 {
                child1.controlInputs.append(parentGene2.copy())
                child2.controlInputs.append(parentGene1.copy())
            } else {
                child1.controlInputs.append(parentGene1.copy())
                child2.controlInputs.append(parentGene2.copy())
            }
        }
        
        return [child1, child2]
    }
    
    
}
