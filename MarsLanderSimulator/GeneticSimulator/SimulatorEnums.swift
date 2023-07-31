//
//  CrossoverType.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 28..
//

import Foundation

enum CrossoverType : String, CaseIterable, Identifiable {
    case SinglePoint, Linear, Blend, SimulatedBinary
    
    var id: String { self.rawValue }
}

enum SelectionType : String, CaseIterable, Identifiable {
    case RouletteWheelNormal, TopPercentRandom
    
    var id: String { self.rawValue }
}
