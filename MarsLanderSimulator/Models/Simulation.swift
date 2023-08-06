//
//  Simulation.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 27..
//

import Foundation


class Simulation : Codable, Identifiable {
    public var id : Int
    
    public var surface : MarsSurface
    public var initialPosition : LanderPosition
    
    public var outputs : [SimulationOutput] = []
    
    private enum CodingKeys: String, CodingKey {
        case id, surface, initialPosition
    }
}

class SimulationOutput : Codable {
    public var surface : MarsSurface
    
    public var generations : [LanderGeneration]
}
