//
//  GeneticSelection.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 08. 03..
//

import Foundation

class GeneticSelection {
    static func get(selectionType: SelectionType) -> Selection {
        switch selectionType {
        case .RouletteWheelNormal:
            return RouletteWheelSelection()
        case .TopPercentRandom:
            return TopPercentSelection()
        case .Tournament:
            fallthrough
        default:
            return TournamentSelection()
        }
    }
}
