//
//  CrossoverType.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 28..
//

import Foundation

enum CrossoverType : String, CaseIterable, Identifiable {
    case Uniform, SinglePoint, Linear, Arithmetic 
    
    var id: String { self.rawValue }
}

enum SelectionType : String, CaseIterable, Identifiable {
    case TopPercentRandom, RouletteWheelNormal, Tournament
    
    var id: String { self.rawValue }
}
