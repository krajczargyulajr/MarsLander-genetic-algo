//
//  TournamentSelection.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 08. 03..
//

import Foundation

class TournamentSelection : Selection {
    
    func select(landers: [Lander]) -> Lander {
        var bestIndex = Int.random(in: landers.indices)
        
        for _ in 0...10 {
            let candidateIndex = Int.random(in: landers.indices)
            if landers[candidateIndex].normalizedTrajectoryScore > landers[bestIndex].normalizedTrajectoryScore {
                bestIndex = candidateIndex
            }
        }
        
        return landers[bestIndex]
    }
}
