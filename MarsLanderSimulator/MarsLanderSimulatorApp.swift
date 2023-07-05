//
//  MarsLanderSimulatorApp.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 06. 23..
//

import SwiftUI

@main
struct MarsLanderSimulatorApp: App {
    @State private var searchText = ""
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
    }
}
