//
//  MarsLanderSimulatorApp.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 06. 23..
//

import SwiftUI

@main
struct MarsLanderSimulatorApp: App {
    var dataModel : [MarsSurface] = surfaces
    
    var body: some Scene {
        Window("MarsLander Simulator", id: "main") {
            SimulationList(dataModel: dataModel, selectedSurfaceId: 0)
        }
    }
}
