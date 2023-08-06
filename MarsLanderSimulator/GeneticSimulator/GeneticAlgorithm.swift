//
//  GeneticAlgorithm.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import Foundation

func solveWithGeneticAlgorithm(
    surface: MarsSurface,
    initialPosition: LanderPosition,
    stepCount : Int,
    generationsCount: Int,
    populationSize: Int,
    crossover: CrossoverType,
    selection: SelectionType
) -> [LanderGeneration] {
    var landerGenerations = [LanderGeneration]()
    
    let simulator = GeneticSimulator(surface: surface, initialPosition: initialPosition)
    let populationService = GeneticPopulation(populationSize: populationSize, steps: stepCount, geneMutationProbability: 0.03, crossover: crossover, selection: selection)
    let evaluator = GeneticEvaluator(surface: surface)
    
    var generation = LanderGeneration()
    generation.number = 0
    generation.landers = populationService.generateInitialPopulation(initialPosition: initialPosition)
    
    for _ in 0..<generationsCount {
        
        simulator.simulateAll(landers: generation.landers)
        
        landerGenerations.append(generation)
        
        if generation.landers.contains(where: { $0.state == LanderState.Landed}) {
            generation.landers = generation.landers.filter { $0.state == LanderState.Landed }
            break
        }
        
        evaluator.evaluateAll(landers: generation.landers)
        
        // try next generation 10 times
        var canContinue = false
        for _ in 0...9 {
            let nextGeneration = populationService.generateNextGeneration(generation: generation)
            
            if nextGeneration.valid {
                canContinue = true
                generation = nextGeneration
                break
            }
        }
        
        if !canContinue {
            print("Could not generate valid next generation")
            break
        }
    }
    
    return landerGenerations
}
