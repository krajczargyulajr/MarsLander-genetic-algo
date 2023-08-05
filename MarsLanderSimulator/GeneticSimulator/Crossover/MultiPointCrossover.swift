//
//  MultiPointCrossover.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 31..
//

import Foundation

class MultiPointCrossover : Crossover {
    let crossoverPointCount : Int
    
    init(crossoverPointCount: Int) {
        self.crossoverPointCount = crossoverPointCount
    }
    
    func crossover(parent1: Lander, parent2: Lander) -> Lander {
        let child1 = Lander()
        
        child1.controlInputs = parent1.controlInputs.map { LanderControlInput(rotate: $0.rotate, power: $0.power) }
        
        for _ in 0..<crossoverPointCount {
            let crossoverPoint = Int.random(in: child1.controlInputs.indices)
            
            for i in crossoverPoint..<child1.controlInputs.count {
                let parent2CI = parent2.controlInputs[i]
                
                child1.controlInputs[i] = LanderControlInput(rotate: parent2CI.rotate, power: parent2CI.power)
            }
        }
        
        return child1
    }
}
