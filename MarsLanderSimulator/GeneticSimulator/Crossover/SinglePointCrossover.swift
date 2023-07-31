//
//  SinglePointCrossover.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 31..
//

import Foundation

class SinglePointCrossover : MultiPointCrossover {
    init() {
        super.init(crossoverPointCount: 1)
    }
}
