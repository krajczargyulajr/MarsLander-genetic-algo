//
//  RouletteWheelSelection.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 30..
//

import Foundation

class RouletteWheelSelection : Selection {
    
    func select(landers: [Lander]) -> Lander {
        let r1 = Double.random(in: 0...1)
        
        for i in landers.indices {
            if landers[i].normalizedTrajectoryScore < r1 {
                if i == 0 {
                    return landers[0]
                } else {
                    return landers[i - 1]
                }
            }
        }
        
        print("for loop failed in roulette wheel selection")
        let parent = landers.last { $0.normalizedTrajectoryScore > r1 }!

        return parent
    }
}
