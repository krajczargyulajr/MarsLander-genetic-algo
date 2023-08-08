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
    
    for i in 0..<generationsCount {
        
        let prevGeneration = generation
        
        generation = LanderGeneration()
        generation.number = i
        
        if i == 0 {
            generation.landers = populationService.generateInitialPopulation(initialPosition: initialPosition)
        } else {
            generation.landers = populationService.generateNextPopulation(prevLanders: prevGeneration.landers)
        }
        
        landerGenerations.append(generation)
        
        if simulator.simulateAll(landers: generation.landers) {
            generation.landers = generation.landers.filter { $0.state == LanderState.Landed }
            break
        }
        
        evaluator.evaluateAll(landers: generation.landers)
    }
    
    return landerGenerations
}
