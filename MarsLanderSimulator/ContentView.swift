//
//  ContentView.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 06. 23..
//

import SwiftUI

struct ContentView: View {
    @State var surface : MarsSurface = MarsSurface(Points: [CGPoint]())
    @State var lander : [LanderState] = [LanderState]()
    
    var body: some View {
        VStack {
            Button(action:renderScene) {
                Text("Render")
            }
            Canvas { context, size in
                var surfacePath = Path()
                
                let translatedCoordinates = surface.Points.map { toCanvasCoords(canvasSize: size, point: $0) }
                
                surfacePath.addLines(translatedCoordinates)
                    
                context.stroke(surfacePath, with: .color(.red), style: StrokeStyle(lineWidth: 1))
                
                var landerPath = Path()
                
                let landerPathTranslatedCoordinates = lander.map { toCanvasCoords(canvasSize: size, point: $0.Position ) }
                
                landerPath.addLines(landerPathTranslatedCoordinates)
                
                context.stroke(landerPath, with: .color(.blue), style: StrokeStyle(lineWidth: 1))
            }
        }
    }
    
    func toCanvasCoords(canvasSize : CGSize, point: CGPoint) -> CGPoint {
        let widthRatio = canvasSize.width / 7000
        let heightRatio = canvasSize.height / 3000
        
        return CGPoint(x: point.x * widthRatio, y: canvasSize.height - point.y * heightRatio)
    }
    
    func renderScene() {
        // open file and read
        if let filePath = Bundle.main.path(forResource: "input1", ofType: "txt") {
            let inputContents = try! String(contentsOfFile: filePath)
            let inputRows = inputContents.split(separator: "\n")
            
            var newSurface = MarsSurface(Points: [CGPoint]())
            var newLanderPath = [LanderState]()
            
            if let numberOfSurfacePoints = Int(inputRows[0]) {
                for r in 1...numberOfSurfacePoints {
                    let surfacePoint = inputRows[r]
                    let coordinates = surfacePoint.components(separatedBy: " ").map { Int($0)! }
                    
                    newSurface.Points.append(CGPoint(x: coordinates[0], y: coordinates[1]))
                }
                
                for r in inputRows.suffix(from: numberOfSurfacePoints + 1) {
                    let landerStateComponents = r.components(separatedBy: " ").map { Int($0)! }
                    newLanderPath.append(LanderState(Position: CGPoint(x: landerStateComponents[0], y: landerStateComponents[1])))
                }
            }
            surface = newSurface
            lander = newLanderPath
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
