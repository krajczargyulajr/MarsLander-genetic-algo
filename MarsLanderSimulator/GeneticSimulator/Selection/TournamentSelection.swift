//
//  TournamentSelection.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 08. 03..
//

import Foundation

class TournamentSelection : Selection {
    
    func select(landers: [Lander]) -> Lander {
        var bestIndex = Int(arc4random_uniform(UInt32(landers.count)))
        
        for _ in 0...10 {
            let candidateIndex = Int(arc4random_uniform(UInt32(landers.count)))
            if landers[candidateIndex].normalizedTrajectoryScore > landers[bestIndex].normalizedTrajectoryScore {
                bestIndex = candidateIndex
            }
        }
        
        return landers[bestIndex]
    }
}
