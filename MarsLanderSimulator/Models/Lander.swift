//
//  Lander.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 27..
//

import Foundation

class LanderGeneration : Codable {
    public var number : Int = 0
    
    public var landers : [Lander] = [Lander]()
    
    public var valid : Bool = true
}

class Lander : Codable {
    
    var id : String = UUID().uuidString
    
    public var controlInputs : [LanderControlInput] = [LanderControlInput]()
    
    public var trajectory : [LanderPosition] = [LanderPosition]()
    
    public var distanceFromTarget : Double = 0.0
    public var trajectoryScore : Double = 1.0
    
    public var normalizedTrajectoryScore : Double = 0.0
    
    public var state : LanderState = LanderState.InFlight
    
    func trajectoryInCanvasCoordinates(canvasSize : CGSize) -> [CGPoint] {
        let widthRatio = canvasSize.width / 7000
        let heightRatio = canvasSize.height / 3000
        
        return trajectory.map { CGPoint(x: $0.position.x * widthRatio, y: canvasSize.height - $0.position.y * heightRatio) }
    }
}

class LanderPosition : Codable {
    public var position : CGPoint
    
    public var velocity : CGVector
    
    public var fuel : Int
    
    public var rotate : Double
    public var power : Int
    
    init(position: CGPoint, velocity: CGVector, fuel: Int, rotate: Double, power: Int) {
        self.position = position
        self.velocity = velocity
        self.fuel = fuel
        self.rotate = rotate
        self.power = power
    }
}

enum LanderState : Codable {
    case InFlight, Landed, Crashed, OutOfFuel, Lost
}

class LanderControlInput : Codable {
    public var rotate : Double
    
    public var power : Int
    
    init(rotate: Double, power: Int) {
        self.rotate = rotate
        self.power = power
    }
}
