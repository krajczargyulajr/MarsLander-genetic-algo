//
//  PopulationService.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import Foundation

class PopulationService {
    var populationSize : Int
    var steps : Int
    
    var geneMutationProbability : Double
    
    init(populationSize: Int, steps: Int, geneMutationProbability: Double) {
        self.populationSize = populationSize
        self.steps = steps
        self.geneMutationProbability = geneMutationProbability
    }
    
    func generateInitialPopulation() -> LanderGeneration {
        let generation = LanderGeneration()
        
        for _ in 0..<populationSize {
            generation.landers.append(generateLander())
        }
        
        return generation
    }
    
    func generateLander() -> Lander {
        var lander = Lander()
        
        var prev = LanderControlInput(rotate: 0.0, power: 0)
        
        for _ in 0...steps {
            let powerDelta = Int.random(in: -1...1)
            let rotateDelta = Double.random(in: -15...15)
            let current = LanderControlInput(
                rotate: calculateValidRotation(current: prev.rotate, requested: prev.rotate + rotateDelta),
                power: calculateValidPower(current: prev.power, requested: prev.power + powerDelta)
            )
            
            print("r:\(current.rotate) p:\(current.power)")
            lander.controlInputs.append(current)
            
            prev = current
        }
        print("==")
        return lander
    }
    
    func crossover(generation: LanderGeneration) -> LanderGeneration {
        let prevGeneration = generation.landers.sorted { $0.trajectoryScore < $1.trajectoryScore }
        let nextGeneration = LanderGeneration()
        
        calculateRouletteWheelNormals(landers: prevGeneration)
        
        while nextGeneration.landers.count < populationSize {
            let r1 = Double.random(in: 0...1)
            let r2 = Double.random(in: 0...1)
            
            let parent1 = prevGeneration.last { $0.trajectoryScore > r1 }!
            let parent2 = prevGeneration.last { $0.trajectoryScore > r2 }!
            
            nextGeneration.landers.append(contentsOf: crossover(parent1: parent1, parent2: parent2))
        }
        
        return nextGeneration
    }
    
    func crossover(parent1: Lander, parent2: Lander) -> [Lander] {
        let cutGene = Int.random(in: 0...parent1.controlInputs.count)
        
        var child1 = Lander()
        child1.controlInputs.append(contentsOf: parent1.controlInputs.dropLast(parent1.controlInputs.count - cutGene))
        child1.controlInputs.append(contentsOf: parent2.controlInputs.dropFirst(cutGene))
        
        var child2 = Lander()
        child2.controlInputs.append(contentsOf: parent2.controlInputs.dropLast(parent2.controlInputs.count - cutGene))
        child2.controlInputs.append(contentsOf: parent1.controlInputs.dropFirst(cutGene))
        
        mutate(lander: &child1)
        mutate(lander: &child2)
        
        return [child1, child2]
    }
    
    func mutate(lander: inout Lander) {
        for var controlInput in lander.controlInputs {
            if Double.random(in: 0...1) > geneMutationProbability {
                controlInput.power = calculateValidPower(current: controlInput.power, requested:Int.random(in: 0...4))
                controlInput.rotate = calculateValidRotation(current: controlInput.rotate, requested: Double.random(in: -15...15))
            }
        }
    }
}

func calculateRouletteWheelNormals(landers: [Lander]) {
    let sum = landers.sum(\.trajectoryScore)
    
    var bestToWorst = landers.sorted { $0.trajectoryScore < $1.trajectoryScore }
    
    for l in 0..<bestToWorst.count {
        var lander = bestToWorst[l]
        let normal = lander.trajectoryScore / sum
        
        for i in 0..<l {
            bestToWorst[i].trajectoryScore += normal
        }
        
        lander.trajectoryScore = normal
    }
}

extension Sequence  {
    func sum<T: AdditiveArithmetic>(_ predicate: (Element) -> T) -> T { reduce(.zero) { $0 + predicate($1) } }
}
