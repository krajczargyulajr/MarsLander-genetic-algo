//
//  MarsSurface.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 05..
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

struct MarsSurface : Codable, Identifiable {
    var id: Int
    
    public var surfacePoints : [CGPoint]
}

class LanderGeneration : Codable {    
    public var landers : [Lander] = [Lander]()
}

struct Lander : Codable {
    
    public var controlInputs : [LanderControlInput] = [LanderControlInput]()
    
    public var trajectory : [LanderPosition] = [LanderPosition]()
    
    public var trajectoryScore : Double = 0.0
    
    public var state : LanderState = LanderState.InFlight
}

struct LanderPosition : Codable {
    public var position : CGPoint
    
    public var velocity : CGVector
    
    public var fuel : Int
    
    public var rotate : Double
    public var power : Int
}

enum LanderState : Codable {
    case InFlight, Landed, Crashed, OutOfFuel, Lost
}

struct LanderControlInput : Codable {
    public var rotate : Double
    
    public var power : Int
}
