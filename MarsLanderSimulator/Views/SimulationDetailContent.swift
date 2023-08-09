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
    
    @State var populationSize : Int = 100
    @State var stepCount : Int = 160
    @State var generationsCount : Int = 60
    
    @State var crossoverType : CrossoverType = CrossoverType.Arithmetic
    @State var selectionType : SelectionType = SelectionType.Tournament
    
    @State var mutationProbability : Int = 3
    
    var body: some View {
        VStack(alignment: .leading) {
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
                    Picker("Selection type", selection: $selectionType) {
                        ForEach(SelectionType.allCases) { st in
                            Text(st.rawValue.capitalized)
                                .tag(st)
                        }
                    }
                    Picker("Crossover type", selection: $crossoverType) {
                        ForEach(CrossoverType.allCases) { ct in
                            Text(ct.rawValue.capitalized)
                                .tag(ct)
                        }
                    }
                    Text("Mutation probability:")
                    TextField("mutation-probability", text: Binding(get: { String(mutationProbability)}, set: {Value in mutationProbability = Int(Value) ?? 0 }))
                }
                Spacer()
            }.padding()
            Divider().frame(height: 1).padding(.horizontal).background(Color.gray)
            Text("\(simulation.title)").multilineTextAlignment(.leading).font(Font.system(size: 21, weight: .bold)).padding()
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
                
                let initialPositionCoordinates = toCanvasCoords(canvasSize: size, point: simulation.initialPosition.position)
                
                var initialPositionPath = Path()
                initialPositionPath.addEllipse(in: CGRect(x: initialPositionCoordinates.x - 3, y: initialPositionCoordinates.y - 3, width: 6, height: 6))
                context.fill(initialPositionPath, with: .color(.cyan))
                
                if simulationResults.count > 0 {
                    let g = simulationResults[currentGeneration]
                    
                    for lander in g.landers {
                        var landerPath = Path()
                        
                        landerPath.addLines(lander.trajectoryInCanvasCoordinates(canvasSize: size))
                        
                        // inflight: white
                        // crashed: red
                        // landed: green
                        let color : Color
                        var opacity : Double = lander.normalizedTrajectoryScore.isNaN ? 0.5 : lander.normalizedTrajectoryScore
                        switch lander.state {
                        case LanderState.Crashed:
                            color = .red
                        case LanderState.Landed:
                            color = .green
                            opacity = 1.0
                        default:
                            color = .white
                        }
                        
                        // let opacity = Double(i) / Double(lander.count)
                        context.stroke(landerPath, with: .color(color.opacity(opacity)), style: StrokeStyle(lineWidth: 1))
                        
                        var trajectoryPoints = Path()
                        for coords in lander.trajectoryInCanvasCoordinates(canvasSize: size) {
                            trajectoryPoints.addEllipse(in: CGRect(x: coords.x - 1, y: coords.y - 1, width: 2, height: 2))
                        }

                        context.fill(trajectoryPoints, with: .color(color.opacity(opacity)) )
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
        for _ in 0...4 {
            let random = arc4random_uniform(2)
            print(random)
        }
        
        currentGeneration = 0
        simulationResults = solveWithGeneticAlgorithm(
            surface: simulation.surface,
            initialPosition: simulation.initialPosition,
            stepCount: stepCount,
            generationsCount: generationsCount,
            populationSize: populationSize,
            crossover: crossoverType,
            selection: selectionType,
            mutationProbability: mutationProbability
        )
        
        return
    }
}

struct SimulationDetailContent_Previews: PreviewProvider {
    static var previews: some View {
        SimulationDetailContent(simulation: surfaces[0])
    }
}
