//
//  SimulationDetailContent.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import SwiftUI

struct SimulationDetailContent: View {
    var simulation : Simulation
    
    @State var simulationResults : [LanderGeneration] = []
    
    @State var currentGeneration : Int = 0
    @State var viewForward : Bool = false
    
    @State var playing : Bool = false
    
    @State var populationSize : Int = 60
    @State var stepCount : Int = 60
    @State var generationsCount : Int = 60
    
    @State var crossoverType : CrossoverType = CrossoverType.Uniform
    @State var selectionType : SelectionType = SelectionType.TopPercentRandom
    
    var body: some View {
        VStack {
            HStack {
                Button(action:runSim) {
                    Text("Run Sim")
                }
                Group {
                    Text("Population:")
                    TextField("population-size", text: Binding(get: { String(populationSize) }, set: {Value in populationSize = Int(Value) ?? 60}))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 50)
                    Text("Steps:")
                    TextField("step-count", text: Binding(get: { String(stepCount) }, set: {Value in stepCount = Int(Value) ?? 60}))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 50)
                    Text("Generations:")
                    TextField("generation-count", text: Binding(get: {String(generationsCount)}, set: {Value in generationsCount = Int(Value) ?? 60}))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: 50)
                    Picker("Crossover type", selection: $crossoverType) {
                        ForEach(CrossoverType.allCases) { ct in
                            Text(ct.rawValue.capitalized)
                                .tag(ct)
                        }
                    }
                    Picker("Selection type", selection: $selectionType) {
                        ForEach(SelectionType.allCases) { st in
                            Text(st.rawValue.capitalized)
                                .tag(st)
                        }
                    }
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
                
                let translatedCoordinates = simulation.surface.surfacePoints.map { toCanvasCoords(canvasSize: size, point: $0) }
                
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
                        context.stroke(landerPath, with: .color(color.opacity(lander.normalizedTrajectoryScore)), style: StrokeStyle(lineWidth: 1))
                        
                        var trajectoryPoints = Path()
                        for coords in lander.trajectoryInCanvasCoordinates(canvasSize: size) {
                            trajectoryPoints.addEllipse(in: CGRect(x: coords.x - 1, y: coords.y - 1, width: 2, height: 2))
                        }

                        context.fill(trajectoryPoints, with: .color(color.opacity(lander.normalizedTrajectoryScore)) )
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
            surface: simulation.surface,
            initialPosition: simulation.initialPosition,
            stepCount: stepCount,
            generationsCount: generationsCount,
            populationSize: populationSize,
            crossover: crossoverType,
            selection: selectionType
        )
        
        return
    }
}

struct SimulationDetailContent_Previews: PreviewProvider {
    static var previews: some View {
        SimulationDetailContent(simulation: surfaces[0])
    }
}
