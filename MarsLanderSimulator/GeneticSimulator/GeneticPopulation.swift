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
    
    var geneMutationProbability : Double
    
    var crossover : CrossoverType
    var selection : SelectionType
    
    var topTenPercentCount : Int
    
    init(populationSize: Int, steps: Int, geneMutationProbability: Double, crossover: CrossoverType, selection: SelectionType) {
        self.populationSize = populationSize
        self.steps = steps
        self.geneMutationProbability = geneMutationProbability
        self.crossover = crossover
        self.selection = selection
        
        self.topTenPercentCount = populationSize / 10
    }
    
    func generateInitialPopulation() -> [Lander] {
        var landers = [Lander]()
        
        for _ in 0..<populationSize {
            landers.append(generateLander())
        }
        
        return landers
    }
    
    func generateLander() -> Lander {
        let lander = Lander()
        
        var prev = LanderControlInput(rotate: 0.0, power: 0)
        
        for _ in 0..<steps {
            let powerDelta = Int.random(in: -1...1)
            let rotateDelta = Double.random(in: -30...30)
            let current = LanderControlInput(
                rotate: calculateValidRotation(current: prev.rotate, requested: prev.rotate + rotateDelta),
                power: calculateValidPower(current: prev.power, requested: prev.power + powerDelta)
            )
            
            lander.controlInputs.append(current)
            
            prev = current
        }
        
        return lander
    }
    
    func crossover(generation: LanderGeneration) -> LanderGeneration {
        let nextGeneration = LanderGeneration()
        nextGeneration.number = generation.number + 1
        
        var selection : Selection
        switch self.selection {
        case .RouletteWheelNormal:
            selection = RouletteWheelSelection(populationSize: populationSize)
        case .TopPercentRandom:
            fallthrough
        default:
            selection = TopPercentSelection(populationSize: populationSize, topPercentToSelect: 10)
        }
        
        let selectedParents = selection.select(generation: generation)
        
        var crossover : Crossover
        switch self.crossover {
        case .SinglePoint:
            crossover = SinglePointCrossover()
        case .Linear:
            crossover = LinearCrossover()
        case .Blend:
            fallthrough
        default:
            crossover = BlendCrossover()
        }
        
        for parent in selectedParents {
            nextGeneration.landers.append(contentsOf: crossover.crossover(parent1: parent.0, parent2: parent.1))
        }
        
        return nextGeneration
    }
    
    func mutate(lander: Lander) {
        for controlInput in lander.controlInputs {
            if Double.random(in: 0...1) > geneMutationProbability {
                controlInput.power = calculateValidPower(current: controlInput.power, requested: controlInput.power + Int.random(in: -1...1))
                controlInput.rotate = calculateValidRotation(current: controlInput.rotate, requested: controlInput.rotate + Double.random(in: -30...30))
            }
        }
    }
}

extension Sequence  {
    func sum<T: AdditiveArithmetic>(_ predicate: (Element) -> T) -> T { reduce(.zero) { $0 + predicate($1) } }
}
