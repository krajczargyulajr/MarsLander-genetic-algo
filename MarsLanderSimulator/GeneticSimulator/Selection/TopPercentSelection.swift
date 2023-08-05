//
//  TopPercentSelection.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 30..
//

import Foundation

class TopPercentSelection : Selection {
    
    var topPercentToSelect : Int = 50
    
    func select(landers: [Lander]) -> Lander {
        // use only the top 50%
        let selectionPool = landers.count * topPercentToSelect / 100

        let r1 = Int.random(in: 0...selectionPool)

        let parent = landers[r1]
        return parent
    }
}
