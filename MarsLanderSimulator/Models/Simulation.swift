//
//  Simulation.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 27..
//

import Foundation


struct Simulation : Codable {
    public var surface : MarsSurface
    public var initialPosition : LanderPosition
    public var output : SimulationOutput
}

struct SimulationOutput : Codable {
    public var surface : MarsSurface
    
    public var generations : [LanderGeneration]
}
