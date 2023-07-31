//
//  CrossoverProtocol.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 31..
//

import Foundation

protocol Crossover {
    func crossover(parent1: Lander, parent2: Lander) -> [Lander]
}
