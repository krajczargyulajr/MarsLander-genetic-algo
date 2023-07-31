//
//  RouletteWheelSelection.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 30..
//

import Foundation

class RouletteWheelSelection : Selection {
    var populationSize : Int
    
    init(populationSize: Int) {
        self.populationSize = populationSize
    }
    
    func select(generation: LanderGeneration) -> [(Lander, Lander)] {        
        let landersBestToWorst = generation.landers.sorted { $0.normalizedTrajectoryScore > $1.normalizedTrajectoryScore }
        
        var parentSelection = [(Lander, Lander)]()
        
        // each set of parents is expected to produce 2 offsprings
        while parentSelection.count < populationSize / 2 {
            let r1 = Double.random(in: 0...1)
            let r2 = Double.random(in: 0...1)
            
            let parent1 = landersBestToWorst.last { $0.normalizedTrajectoryScore > r1 }!
            let parent2 = landersBestToWorst.last { $0.normalizedTrajectoryScore > r2 }!
            
            if parent1.id != parent2.id {
                parentSelection.append((parent1, parent2))
            }
        }
        
        return parentSelection
    }
}
