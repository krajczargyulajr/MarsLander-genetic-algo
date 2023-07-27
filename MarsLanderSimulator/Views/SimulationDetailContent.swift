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
    
    @State var populationSize : Int = 40
    @State var stepCount : Int = 40
    @State var generationsCount : Int = 40
    
    var body: some View {
        VStack {
            HStack {
                Button(action:runSim) {
                    Text("Run Sim")
                }
                Group {
                    Text("Population:")
                    TextField("population-size", text: Binding(get: { String(populationSize) }, set: {Value in populationSize = Int(Value) ?? 40}))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 50)
                    Text("Steps:")
                    TextField("step-count", text: Binding(get: { String(stepCount) }, set: {Value in stepCount = Int(Value) ?? 40}))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 50)
                    Text("Generations:")
                    TextField("generation-count", text: Binding(get: {String(generationsCount)}, set: {Value in generationsCount = Int(Value) ?? 20}))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 50)
                }
                Spacer()
            }.padding()
            Divider().frame(height: 1).padding(.horizontal).background(Color.gray)
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
                
            }.padding()
            Canvas { context, size in
                var surfacePath = Path()
                
                let translatedCoordinates = surface.surfacePoints.map { toCanvasCoords(canvasSize: size, point: $0) }
                
                surfacePath.addLines(translatedCoordinates)
                
                context.stroke(surfacePath, with: .color(.red), style: StrokeStyle(lineWidth: 1))
                
                if simulationResults.count > 0 {
                    let g = simulationResults[currentGeneration]
                    
                    for lander in g.landers {
                        var landerPath = Path()
                        
                        landerPath.addLines(lander.trajectoryInCanvasCoordinates(canvasSize: size))
                        
                        // inflight: white
                        // crashed: red
                        // landed: green
                        let color : Color
                        switch lander.state {
                        case LanderState.Crashed:
                            color = .red
                        case LanderState.Landed:
                            color = .green
                        default:
                            color = .white
                        }
                        
                        // let opacity = Double(i) / Double(lander.count)
                        context.stroke(landerPath, with: .color(color), style: StrokeStyle(lineWidth: 1))
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
        
        simulationResults = solveWithGeneticAlgorithm(
            surface: surface,
            initialPosition: LanderPosition(position: CGPoint(x: 2500, y: 2700), velocity: CGVector(dx: 0, dy: 0), fuel: 550, rotate: 0, power: 0),
            stepCount: stepCount,
            generationsCount: generationsCount
        )
        
        return
    }
}

struct SimulationDetailContent_Previews: PreviewProvider {
    static var previews: some View {
        SimulationDetailContent(surface: surfaces[0])
    }
}
