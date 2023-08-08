//
//  PopulationService.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import Foundation

class GeneticPopulation {
    var populationSize : Int
    var steps : Int
    
    var crossoverProbability : Double = 0.8
    var geneMutationProbability : Int
    
    var crossover : Crossover
    var selection : Selection
    
    var topTenPercentCount : Int
    
    init(populationSize: Int, steps: Int, geneMutationProbability: Int, crossover: CrossoverType, selection: SelectionType) {
        self.populationSize = populationSize
        self.steps = steps
        
        self.geneMutationProbability = geneMutationProbability
        
        self.crossover = GeneticCrossover.get(crossoverType: crossover)
        self.selection = GeneticSelection.get(selectionType: selection)
        
        self.topTenPercentCount = populationSize / 10
    }
    
    func generateInitialPopulation(initialPosition: LanderPosition) -> [Lander] {
        var landers = [Lander]()
        
        for _ in 0..<populationSize {
            landers.append(generateLander(initialPosition: initialPosition))
        }
        
        return landers
    }
    
    func generateLander(initialPosition: LanderPosition) -> Lander {
        let lander = Lander()
        
        for _ in 0..<steps {
            let powerDelta = Int(arc4random_uniform(3)) - 1 // (in: -1...1)
            let rotateDelta = Double(Int(arc4random_uniform(31)) - 15)
            let current = LanderControlInput(
                rotate: rotateDelta,
                power: powerDelta
            )
            
            lander.controlInputs.append(current)
        }
        
        return lander
    }
    
    func generateNextGeneration(generation: LanderGeneration) -> LanderGeneration {
        var landers = [Lander]()
        
        let prevLandersBestToWorst = generation.landers.sorted { $0.normalizedTrajectoryScore > $1.normalizedTrajectoryScore }

        while landers.count < populationSize {
        
            let parent1 = selection.select(landers: prevLandersBestToWorst)
            let parent2 = selection.select(landers: prevLandersBestToWorst)
            
            
            let child = crossover.crossover(parent1: parent1, parent2: parent2)
            let originalChild = Lander()
            originalChild.controlInputs = child.controlInputs.map { $0.copy() }
            
            mutate(lander: child)
            
            landers.append(child)
        }
        
        let nextGeneration = LanderGeneration()
        nextGeneration.number = generation.number + 1
        nextGeneration.landers = landers
        
        return nextGeneration
    }
    
    func mutate(lander: Lander) {
        for controlInput in lander.controlInputs {
            if arc4random_uniform(101) < geneMutationProbability {
                controlInput.power = Int(arc4random_uniform(5))
                controlInput.rotate = Double(Int(arc4random_uniform(181)) - 90)
            }
        }
    }
}

extension Sequence  {
    func sum<T: AdditiveArithmetic>(_ predicate: (Element) -> T) -> T { reduce(.zero) { $0 + predicate($1) } }
}
