//
//  SimulationCard.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import SwiftUI

struct SimulationCard: View {
    var simulation : Simulation
    
    var body: some View {
        HStack {
            Text("#\(simulation.id)")
            VStack(alignment: .leading) {
                Text("\(simulation.title)").multilineTextAlignment(TextAlignment.leading)
                Canvas { context, size in
                    var surfacePath = Path()
                    
                    let translatedCoordinates = simulation.surface.surfacePoints.map { toCanvasCoords(canvasSize: size, point: $0) }
                    
                    surfacePath.addLines(translatedCoordinates)
                    
                    context.stroke(surfacePath, with: .color(.red), style: StrokeStyle(lineWidth: 1))
                }.frame(idealWidth: 50, idealHeight: 25)
            }
        }
    }
}

struct SimulationCard_Previews: PreviewProvider {
    static var previews: some View {
        SimulationCard(simulation: surfaces[0])
    }
}
