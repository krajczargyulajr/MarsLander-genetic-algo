//
//  GeneticAlgorithm.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import Foundation

func solveWithGeneticAlgorithm(surface: MarsSurface, initialPosition: LanderPosition) -> [LanderGeneration] {
    var landerGenerations = [LanderGeneration]()
    
    let populationService = PopulationService(populationSize: 40, steps: 40, geneMutationProbability: 0.1)
    
    var generation = populationService.generateInitialPopulation()
    
    for _ in 0...20 {
        generation.simulateAll(surface: surface, initialPosition: initialPosition)
        
        landerGenerations.append(generation)
        
        let nextGeneration = populationService.crossover(generation: generation)
        generation = nextGeneration
    }
    
    return landerGenerations
}

extension LanderGeneration {
    func simulateAll(surface: MarsSurface, initialPosition: LanderPosition) {
        let simulator = GeneticSimulator(surface: surface)
        var newLanders = [Lander]()
        for var lander in landers {
            simulator.simulateLanderMovement(lander: &lander, initialPosition: initialPosition)
            
            newLanders.append(lander)
        }
        
        landers = newLanders
    }
}
