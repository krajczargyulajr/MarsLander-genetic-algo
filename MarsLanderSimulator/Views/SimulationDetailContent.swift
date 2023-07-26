//
//  SimulationDetailContent.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import SwiftUI

struct SimulationDetailContent: View {
    var surface : MarsSurface
    
    @State var simulationResults : [LanderGeneration] = []
    
    @State var currentGeneration : Int = 0
    @State var viewForward : Bool = false
    
    @State var playing : Bool = false
    
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    Button(action: goToFirst) {
                        Image(systemName: "backward.end.fill")
                    }
                    Button(action: goToPrev) {
                        Image(systemName: "backward.frame.fill")
                    }
                    Button(action: play) {
                        Image(systemName: "play.fill")
                    }
                    Button(action: pause) {
                        Image(systemName: "pause.fill")
                    }
                    Button(action: goToNext) {
                        Image(systemName: "forward.frame.fill")
                    }
                    Button(action: goToLast) {
                        Image(systemName: "forward.end.fill")
                    }
                    TextField("Current generation:", text: Binding(
                        get: { String(currentGeneration) },
                        set: { Value in currentGeneration = Int(Value) ?? 0 }
                    )).frame(width: 60)
                }.disabled(simulationResults.isEmpty)
                Spacer()
                Button(action:runSim) {
                    Text("Run Sim")
                }
            }.padding()
            Canvas { context, size in
                var surfacePath = Path()
                
                let translatedCoordinates = surface.surfacePoints.map { toCanvasCoords(canvasSize: size, point: $0) }
                
                surfacePath.addLines(translatedCoordinates)
                
                context.stroke(surfacePath, with: .color(.red), style: StrokeStyle(lineWidth: 1))
                
                if simulationResults.count > 0 {
                    let colors : [Color] = [.blue, .cyan, .green, .orange, .mint]
                    let g = simulationResults[currentGeneration]
                    
                    let landerPathTranslatedCoordinates = g.landers.map { $0.trajectory.map { toCanvasCoords(canvasSize: size, point: $0.position ) } }
                    
                    for p in landerPathTranslatedCoordinates {
                        var landerPath = Path()
                        
                        landerPath.addLines(p)
                        
                        // let opacity = Double(i) / Double(lander.count)
                        context.stroke(landerPath, with: .color(colors[currentGeneration % colors.count]), style: StrokeStyle(lineWidth: 1))
                    }
                }
            }
        }
    }
    
    func goToFirst() {
        currentGeneration = 0
    }
    
    func goToPrev() {
        currentGeneration -= 1
        
        if currentGeneration < 0 {
            currentGeneration = 0
        }
    }
    
    func goToNext() {
        if currentGeneration < simulationResults.count - 1 {
            currentGeneration += 1
        }
    }
    
    func goToLast() {
        currentGeneration = simulationResults.count - 1
    }
    
    func play() {
        playing = true
    }
    
    func pause() {
        playing = false
    }
    
    func runSim() {
        
        simulationResults = solveWithGeneticAlgorithm(surface: surface, initialPosition: LanderPosition(position: CGPoint(x: 2500, y: 2700), velocity: CGVector(dx: 0, dy: 0), fuel: 550, rotate: 0, power: 0))
        
        return
    }
}

struct SimulationDetailContent_Previews: PreviewProvider {
    static var previews: some View {
        SimulationDetailContent(surface: surfaces[0])
    }
}
