//
//  SimulationCard.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import SwiftUI

struct SimulationCard: View {
    var surface : MarsSurface
    
    var body: some View {
        HStack {
            Text("#\(surface.id)")
            Canvas { context, size in
                var surfacePath = Path()
                
                let translatedCoordinates = surface.surfacePoints.map { toCanvasCoords(canvasSize: size, point: $0) }
                
                surfacePath.addLines(translatedCoordinates)
                
                context.stroke(surfacePath, with: .color(.red), style: StrokeStyle(lineWidth: 1))
            }
        }
    }
}

struct SimulationCard_Previews: PreviewProvider {
    static var previews: some View {
        SimulationCard(surface: surfaces[0])
    }
}
