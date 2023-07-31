//
//  SelectionProtocol.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 31..
//

import Foundation

protocol Selection {
    func select(generation: LanderGeneration) -> [(Lander, Lander)]
}
