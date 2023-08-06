//
//  GeneticCrossover.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 08. 03..
//

import Foundation

class GeneticCrossover {
    static func get(crossoverType: CrossoverType) -> Crossover {
        switch crossoverType {
        case .Arithmetic:
            return ArithmeticCrossover()
        case .Linear:
            return LinearCrossover()
        case .SinglePoint:
            return SinglePointCrossover()
        case .Uniform:
            fallthrough
        default:
            return UniformCrossover()
        }
    }
}
