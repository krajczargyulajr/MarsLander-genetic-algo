//
//  ContentView.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 06. 23..
//

import SwiftUI

struct ContentView: View {
    
    @State var surface : MarsSurface = MarsSurface(surfacePoints: [CGPoint]())
    @State var lander : [LanderGeneration] = [LanderGeneration]()
    
    @State var currentGeneration : Int = 0
    @State var viewForward : Bool = false
    
    @State var playing : Bool = false
    
    let playTimer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack{
                Button(action: play) {
                    Image(systemName: "play.fill")
                }
                Button(action: pause) {
                    Image(systemName: "pause.fill")
                }
                Text("\(String(describing: playing))")
                Group {
                    Button(action: goToFirst) {
                        Image(systemName: "backward.end.fill")
                    }
                    Button(action: goToPrev) {
                        Image(systemName: "backward.frame.fill")
                    }
                    TextField("Current generation:", text: Binding(
                        get: { String(currentGeneration) },
                        set: { Value in currentGeneration = Int(Value) ?? 0 }
                    )).frame(width: 60)
                    Button(action: goToNext) {
                        Image(systemName: "forward.frame.fill")
                    }
                    Button(action: goToLast) {
                        Image(systemName: "forward.end.fill")
                    }
                    
                }.disabled(lander.count == 0)
                Spacer()
                Button(action:loadFromFile) {
                    Text("Render")
                }
            }.padding()
            Canvas { context, size in
                if lander.count > 0 {
                    var surfacePath = Path()
                    
                    let translatedCoordinates = surface.surfacePoints.map { toCanvasCoords(canvasSize: size, point: $0) }
                    
                    surfacePath.addLines(translatedCoordinates)
                    
                    context.stroke(surfacePath, with: .color(.red), style: StrokeStyle(lineWidth: 1))
                    
                    let colors : [Color] = [.blue, .cyan, .green, .orange, .mint]
                    let g = lander[currentGeneration]
                    
                    let landerPathTranslatedCoordinates = g.landers.map { $0.trajectory.map { toCanvasCoords(canvasSize: size, point: $0.position ) } }
                    
                    for p in landerPathTranslatedCoordinates {
                        var landerPath = Path()
                        
                        landerPath.addLines(p)
                        
                        // let opacity = Double(i) / Double(lander.count)
                        context.stroke(landerPath, with: .color(colors[currentGeneration % colors.count]), style: StrokeStyle(lineWidth: 1))
                    }
                }
            }.onReceive(playTimer2) { time in
                guard playing else { return }
                
                if currentGeneration < lander.count - 1 {
                    currentGeneration += 1
                }
                
                if currentGeneration == lander.count - 1 {
                    playing = false
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
        if currentGeneration < lander.count - 1 {
            currentGeneration += 1
        }
    }
    
    func goToLast() {
        currentGeneration = lander.count - 1
    }
    
    func play() {
        playing = true
    }
    
    func pause() {
        playing = false
    }
    
    func toCanvasCoords(canvasSize : CGSize, point: CGPoint) -> CGPoint {
        let widthRatio = canvasSize.width / 7000
        let heightRatio = canvasSize.height / 3000
        
        return CGPoint(x: point.x * widthRatio, y: canvasSize.height - point.y * heightRatio)
    }
    
    func loadFromFile() {
        // open file and read
        if let filePath = Bundle.main.path(forResource: "input1", ofType: "json") {
            let inputContents = try! String(contentsOfFile: filePath)
            
            let decoder = JSONDecoder()
            let simulationOutput = try! decoder.decode(SimulationOutput.self, from: inputContents.data(using: .utf8)!)
            
            surface = simulationOutput.surface
            lander = simulationOutput.generations
            
            /*
            let inputRows = inputContents.split(separator: "\n")
            
            var newSurface = MarsSurface(Points: [CGPoint]())
            var newGenerations = [[Lander]]()
            var newLanderPaths = [Lander]()
            
            if let numberOfSurfacePoints = Int(inputRows[0]) {
                for r in 1...numberOfSurfacePoints {
                    let surfacePoint = inputRows[r]
                    let coordinates = surfacePoint.components(separatedBy: " ").map { Int($0)! }
                    
                    newSurface.Points.append(CGPoint(x: coordinates[0], y: coordinates[1]))
                }
                
                var currentLanderPath : Lander = Lander(Score: 0)
                for r in inputRows.suffix(from: numberOfSurfacePoints + 1) {
                    if r.starts(with: "++") {
                        newGenerations.append(newLanderPaths)
                        newLanderPaths = [Lander]()
                        
                        continue
                    }
                    
                    if r.starts(with: "==") {
                        currentLanderPath.Score = Int( r.split(separator: " ")[1])!
                        newLanderPaths.append(currentLanderPath)
                        currentLanderPath = Lander(Score: 0)
                        
                        continue
                    }
                    
                    let landerStateComponents = r.components(separatedBy: " ").map { Int($0)! }
                    currentLanderPath.Trajectory.append(LanderState(Position: CGPoint(x: landerStateComponents[2], y: landerStateComponents[3])))
                }
            }
            */
            // surface = newSurface
            // lander = newGenerations
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
