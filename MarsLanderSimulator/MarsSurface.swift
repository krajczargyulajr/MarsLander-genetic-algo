//
//  MarsSurface.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 05..
//

import Foundation

struct SimulationOutput : Codable {
    public var surface : MarsSurface
    
    public var generations : [LanderGeneration]
}

struct MarsSurface : Codable {
    public var surfacePoints : [CGPoint]
}

struct LanderGeneration : Codable {    
    public var landers : [Lander] = [Lander]()
}

struct Lander : Codable {
    
    public var controlInputs : [LanderControlInput] = [LanderControlInput]()
    
    public var trajectory : [LanderState] = [LanderState]()
}

struct LanderState : Codable {
    public var position : CGPoint
}

struct LanderControlInput : Codable {
    public var rotate : Double
    
    public var power : Int
}
