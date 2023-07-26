//
//  SimulationDetail.swift
//  MarsLanderSimulator
//
//  Created by Gyula Krajczar on 2023. 07. 26..
//

import SwiftUI

struct SimulationDetail: View {
    var dataModel : [MarsSurface]
    var selectedSurfaceId : Int = -1
    
    var body: some View {
        ZStack {
            if selectedSurfaceId <= 0 {
                Text("Please select one of the surfaces!")
            } else {
                SimulationDetailContent(surface: dataModel.first(where: { $0.id == selectedSurfaceId})!)
            }
        }
    }
}

struct SimulationDetail_Previews: PreviewProvider {
    static var previews: some View {
        SimulationDetail(dataModel: surfaces, selectedSurfaceId: 0)
    }
}
