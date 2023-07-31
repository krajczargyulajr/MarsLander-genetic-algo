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
    
    func crossover(parent1: Lander, parent2: Lander) -> [Lander] {
        let child1 = Lander()
        let child2 = Lander()
        
        child1.controlInputs = parent1.controlInputs.map { LanderControlInput(rotate: $0.rotate, power: $0.power) }
        child2.controlInputs = parent2.controlInputs.map { LanderControlInput(rotate: $0.rotate, power: $0.power) }
        
        for _ in 0..<crossoverPointCount {
            let crossoverPoint = Int.random(in: child1.controlInputs.indices)
            
            for i in crossoverPoint..<child1.controlInputs.count {
                let parent1CI = parent1.controlInputs[i]
                let parent2CI = parent2.controlInputs[i]
                
                child1.controlInputs[i] = LanderControlInput(rotate: parent2CI.rotate, power: parent2CI.power)
                child2.controlInputs[i] = LanderControlInput(rotate: parent1CI.rotate, power: parent1CI.power)
            }
        }
        
        return [child1, child2]
    }
}
