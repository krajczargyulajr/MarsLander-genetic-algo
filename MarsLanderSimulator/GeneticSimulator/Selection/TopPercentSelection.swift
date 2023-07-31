//
//  TopPercentSelection.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 30..
//

import Foundation

class TopPercentSelection : Selection {
    var populationSize : Int
    var topPercentToSelect : Int
    
    init(populationSize: Int, topPercentToSelect: Int) {
        self.populationSize = populationSize
        self.topPercentToSelect = topPercentToSelect
    }
    
    func select(generation: LanderGeneration) -> [(Lander, Lander)] {
        
        var parentSelection = [(Lander, Lander)]()
        
        let landersBestToWorst = generation.landers.sorted { $0.normalizedTrajectoryScore > $1.normalizedTrajectoryScore }
        
        // use only the top 50%
        let selectionPoolCount = landersBestToWorst.count * topPercentToSelect / 100
        let selectionPool = Array(landersBestToWorst.dropLast(selectionPoolCount))

        // each set of parents is expected to produce two offsprings
        while parentSelection.count < populationSize / 2 {
            let r1 = Int.random(in: selectionPool.indices)
            let r2 = Int.random(in: selectionPool.indices)

            if r1 != r2 {
                let parent1 = selectionPool[r1]
                let parent2 = selectionPool[r2]

                parentSelection.append((parent1, parent2))
            }
        }
        
        return parentSelection
    }
}
